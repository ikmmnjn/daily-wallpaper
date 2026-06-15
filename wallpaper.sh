#!/bin/bash

SAVE_DIR="$HOME/.daily-wallpaper/images"
LOG="$HOME/.daily-wallpaper/wallpaper.log"
LAST_SET="$HOME/.daily-wallpaper/.last_set"

mkdir -p "$SAVE_DIR"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"; }

# Bing에서 오늘 이미지 정보 가져오기
RESPONSE=$(curl -sf "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=ko-KR")
[ -z "$RESPONSE" ] && log "ERROR: Bing API 실패" && exit 1

IMAGE_ID=$(echo "$RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin)['images'][0]['hsh'])")
IMAGE_URL=$(echo "$RESPONSE" | python3 -c "import json,sys; u=json.load(sys.stdin)['images'][0]['url'].split('&')[0]; print('https://www.bing.com'+u)")
SAVE_PATH="$SAVE_DIR/$IMAGE_ID.jpg"

# 이미 오늘 이미지면 스킵
[ -f "$LAST_SET" ] && [ "$(cat "$LAST_SET")" = "$IMAGE_ID" ] && log "이미 최신 배경화면" && exit 0

# 다운로드
if [ ! -f "$SAVE_PATH" ]; then
    curl -sf -o "$SAVE_PATH" "$IMAGE_URL"
    [ ! -f "$SAVE_PATH" ] && log "ERROR: 다운로드 실패" && exit 1
fi

# 배경화면 적용
killall WallpaperAgent 2>/dev/null
sleep 3
desktoppr "$SAVE_PATH"

# 적용 확인
sleep 2
CURRENT=$(osascript -e 'tell app "System Events" to get picture of desktop 1' 2>/dev/null)
if [ "$CURRENT" = "$SAVE_PATH" ]; then
    echo "$IMAGE_ID" > "$LAST_SET"
    log "SUCCESS: $SAVE_PATH"
else
    log "ERROR: 적용 실패 (현재: $CURRENT)"
    exit 1
fi
