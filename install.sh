#!/bin/bash

set -e

INSTALL_DIR="$HOME/.daily-wallpaper"
LAUNCH_AGENTS="$HOME/Library/LaunchAgents"

echo "🖼️  Daily Wallpaper 설치 시작..."

# desktoppr 설치 확인 (macOS 26+ 필요)
if ! command -v desktoppr &>/dev/null; then
    echo "⚠️  desktoppr가 없습니다. Homebrew로 설치합니다..."
    if ! command -v brew &>/dev/null && [ -x /opt/homebrew/bin/brew ]; then
        export PATH="/opt/homebrew/bin:$PATH"
    fi
    brew install desktoppr || { echo "❌ desktoppr 설치 실패. 먼저 Homebrew를 설치해주세요."; exit 1; }
fi
DESKTOPPR=$(command -v desktoppr)
echo "✅ desktoppr: $DESKTOPPR"

# 디렉토리 생성
mkdir -p "$INSTALL_DIR/images"
mkdir -p "$LAUNCH_AGENTS"

# wallpaper.sh 생성
cat > "$INSTALL_DIR/wallpaper.sh" << 'EOF'
#!/bin/bash

BING_API="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=ko-KR"
SAVE_DIR="$HOME/.daily-wallpaper/images"
DATE=$(date +%Y-%m-%d)
SAVE_PATH="$SAVE_DIR/$DATE.jpg"
LOG="$HOME/.daily-wallpaper/wallpaper.log"
LAST_SET="$HOME/.daily-wallpaper/.last_set"

mkdir -p "$SAVE_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

if [ -f "$LAST_SET" ] && [ "$(cat $LAST_SET)" = "$DATE" ]; then
    log "Already applied today, skipping"
    exit 0
fi

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

for i in 1 2 3; do
    /usr/local/bin/desktoppr "$SAVE_PATH" 2>/dev/null
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
EOF

chmod +x "$INSTALL_DIR/wallpaper.sh"
echo "✅ wallpaper.sh 생성 완료"

# 7시 실행 plist
cat > "$LAUNCH_AGENTS/com.daily-wallpaper.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.daily-wallpaper</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$INSTALL_DIR/wallpaper.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>7</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>RunAtLoad</key>
    <false/>
    <key>StandardOutPath</key>
    <string>$INSTALL_DIR/launchd.log</string>
    <key>StandardErrorPath</key>
    <string>$INSTALL_DIR/launchd.log</string>
</dict>
</plist>
EOF

# 로그인 시 실행 plist
cat > "$LAUNCH_AGENTS/com.daily-wallpaper-login.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.daily-wallpaper-login</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$INSTALL_DIR/wallpaper.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$INSTALL_DIR/launchd.log</string>
    <key>StandardErrorPath</key>
    <string>$INSTALL_DIR/launchd.log</string>
</dict>
</plist>
EOF

echo "✅ plist 생성 완료"

# launchd 등록
launchctl unload "$LAUNCH_AGENTS/com.daily-wallpaper.plist" 2>/dev/null
launchctl unload "$LAUNCH_AGENTS/com.daily-wallpaper-login.plist" 2>/dev/null
launchctl load "$LAUNCH_AGENTS/com.daily-wallpaper.plist"
launchctl load "$LAUNCH_AGENTS/com.daily-wallpaper-login.plist"
echo "✅ launchd 등록 완료"

# 지금 바로 실행
echo "🔄 지금 바로 배경화면 변경 중..."
bash "$INSTALL_DIR/wallpaper.sh"

echo ""
echo "🎉 설치 완료! 매일 오전 7시 + 로그인 시 자동으로 배경화면이 바뀝니다."
