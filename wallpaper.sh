#!/bin/bash

BING_API="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=ko-KR"
SAVE_DIR="/Users/home/Documents/daily-wallpaer/images"
DATE=$(date +%Y-%m-%d)
SAVE_PATH="$SAVE_DIR/$DATE.jpg"
LOG="/Users/home/Documents/daily-wallpaer/wallpaper.log"

mkdir -p "$SAVE_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

log "Starting wallpaper update"

IMAGE_PATH=$(curl -sf "$BING_API" | python3 -c "import json,sys; print(json.load(sys.stdin)['images'][0]['url'])" 2>/dev/null)

if [ -z "$IMAGE_PATH" ]; then
    log "ERROR: Failed to fetch Bing API"
    exit 1
fi

IMAGE_URL="https://www.bing.com${IMAGE_PATH%&*}"

curl -sf -o "$SAVE_PATH" "$IMAGE_URL"

if [ ! -f "$SAVE_PATH" ]; then
    log "ERROR: Failed to download image from $IMAGE_URL"
    exit 1
fi

osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$SAVE_PATH\""

log "SUCCESS: Wallpaper set to $SAVE_PATH"
