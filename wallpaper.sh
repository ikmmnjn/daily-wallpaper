#!/bin/bash

BING_API="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=ko-KR"
SAVE_DIR="$HOME/.daily-wallpaper/images"
LOG="$HOME/.daily-wallpaper/wallpaper.log"
LAST_SET="$HOME/.daily-wallpaper/.last_set"
SLACK_WEBHOOK="$(cat "$HOME/.daily-wallpaper/.slack_webhook" 2>/dev/null)"

mkdir -p "$SAVE_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

# Bing API 호출
BING_RESPONSE=$(curl -sf "$BING_API")
if [ -z "$BING_RESPONSE" ]; then
    log "ERROR: Failed to fetch Bing API"
    exit 1
fi

# 최신 사진 ID 확인
IMAGE_ID=$(echo "$BING_RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin)['images'][0]['hsh'])" 2>/dev/null)

# 이미 같은 사진이면 스킵
if [ -f "$LAST_SET" ] && [ "$(cat $LAST_SET)" = "$IMAGE_ID" ]; then
    log "Already showing latest wallpaper, skipping"
    exit 0
fi

# 이미지 다운로드
IMAGE_URL=$(echo "$BING_RESPONSE" | python3 -c "import json,sys; u=json.load(sys.stdin)['images'][0]['url'].split('&')[0]; print('https://www.bing.com'+u)" 2>/dev/null)
SAVE_PATH="$SAVE_DIR/$IMAGE_ID.jpg"

if [ ! -f "$SAVE_PATH" ]; then
    log "Downloading new wallpaper ($IMAGE_ID)"
    curl -sf -o "$SAVE_PATH" "$IMAGE_URL"

    if [ ! -f "$SAVE_PATH" ]; then
        log "ERROR: Failed to download image"
        exit 1
    fi

    log "Downloaded: $SAVE_PATH"
fi

# 배경화면 적용 (최대 3번 재시도)
killall WallpaperAgent 2>/dev/null; sleep 2
for i in 1 2 3; do
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$SAVE_PATH\""
    if [ $? -eq 0 ]; then
        echo "$IMAGE_ID" > "$LAST_SET"
        log "SUCCESS: Wallpaper set to $SAVE_PATH"
        if [ -n "$SLACK_WEBHOOK" ]; then
            curl -sf -X POST -H 'Content-type: application/json' \
                --data "{\"text\":\"배경화면 바뀌었어요 🖼 $(date '+%Y-%m-%d %H:%M')\"}" \
                "$SLACK_WEBHOOK" > /dev/null
        fi
        exit 0
    fi
    log "Attempt $i failed, retrying in 10s..."
    sleep 10
done

log "ERROR: Could not set wallpaper (screen may be locked)"
exit 1
