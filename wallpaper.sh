#!/bin/bash

BING_API="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=ko-KR"
SAVE_DIR="/Users/home/.daily-wallpaper/images"
DATE=$(date +%Y-%m-%d)
SAVE_PATH="$SAVE_DIR/$DATE.jpg"
LOG="/Users/home/.daily-wallpaper/wallpaper.log"
LAST_SET="/Users/home/.daily-wallpaper/.last_set"

mkdir -p "$SAVE_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

# 오늘 이미 적용 완료됐으면 스킵
if [ -f "$LAST_SET" ] && [ "$(cat $LAST_SET)" = "$DATE" ]; then
    log "Already applied today, skipping"
    exit 0
fi

# 이미지 다운로드 (오늘 것 없을 때만)
if [ ! -f "$SAVE_PATH" ]; then
    log "Downloading today's wallpaper"

    IMAGE_PATH=$(curl -sf "$BING_API" | python3 -c "import json,sys; print(json.load(sys.stdin)['images'][0]['url'])" 2>/dev/null)

    if [ -z "$IMAGE_PATH" ]; then
        log "ERROR: Failed to fetch Bing API"
        exit 1
    fi

    IMAGE_URL="https://www.bing.com${IMAGE_PATH%&*}"
    curl -sf -o "$SAVE_PATH" "$IMAGE_URL"

    if [ ! -f "$SAVE_PATH" ]; then
        log "ERROR: Failed to download image"
        exit 1
    fi

    log "Downloaded: $SAVE_PATH"
fi

# 배경화면 적용 (최대 3번 재시도)
for i in 1 2 3; do
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$SAVE_PATH\"" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "$DATE" > "$LAST_SET"
        log "SUCCESS: Wallpaper set to $SAVE_PATH"
        exit 0
    fi
    log "Attempt $i failed, retrying in 10s..."
    sleep 10
done

log "ERROR: Could not set wallpaper (screen may be locked)"
exit 1
