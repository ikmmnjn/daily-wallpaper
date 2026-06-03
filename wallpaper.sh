#!/bin/bash

BING_API="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=ko-KR"
SAVE_DIR="$HOME/.daily-wallpaper/images"
DATE=$(date +%Y-%m-%d)
TODAY=$(date +%Y%m%d)
SAVE_PATH="$SAVE_DIR/$DATE.jpg"
LOG="$HOME/.daily-wallpaper/wallpaper.log"
LAST_SET="$HOME/.daily-wallpaper/.last_set"
SLACK_WEBHOOK="$(cat "$HOME/.daily-wallpaper/.slack_webhook" 2>/dev/null)"

mkdir -p "$SAVE_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

# 오늘 이미 적용 완료됐으면 스킵
if [ -f "$LAST_SET" ] && [ "$(cat $LAST_SET)" = "$DATE" ]; then
    exit 0
fi

# Bing API 호출
BING_RESPONSE=$(curl -sf "$BING_API")
if [ -z "$BING_RESPONSE" ]; then
    log "ERROR: Failed to fetch Bing API"
    exit 1
fi

# Bing이 오늘 사진으로 업데이트됐는지 확인
START_DATE=$(echo "$BING_RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin)['images'][0]['startdate'])" 2>/dev/null)

if [ "$START_DATE" != "$TODAY" ]; then
    log "Bing not updated yet (startdate: $START_DATE), will retry"
    exit 0
fi

# 이미지 다운로드
IMAGE_PATH=$(echo "$BING_RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin)['images'][0]['url'])" 2>/dev/null)
IMAGE_URL="https://www.bing.com${IMAGE_PATH%&*}"
curl -sf -o "$SAVE_PATH" "$IMAGE_URL"

if [ ! -f "$SAVE_PATH" ]; then
    log "ERROR: Failed to download image"
    exit 1
fi

log "Downloaded: $SAVE_PATH"

# 배경화면 적용 (최대 3번 재시도)
for i in 1 2 3; do
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$SAVE_PATH\"" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "$DATE" > "$LAST_SET"
        log "SUCCESS: Wallpaper set to $SAVE_PATH"
        curl -sf -X POST -H 'Content-type: application/json' \
            --data "{\"text\":\"배경화면 바뀌었어요 🖼 ($DATE) - $(date '+%H:%M')\"}" \
            "$SLACK_WEBHOOK" > /dev/null
        exit 0
    fi
    log "Attempt $i failed, retrying in 10s..."
    sleep 10
done

log "ERROR: Could not set wallpaper (screen may be locked)"
exit 1
