#!/bin/bash

# LaunchDaemon plist 생성 (root로 실행되어 pmset 사용 가능)
cat > /Library/LaunchDaemons/com.daily-wallpaper-wake.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.daily-wallpaper-wake</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/home/.daily-wallpaper/wake-and-wallpaper.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <array>
        <dict><key>Hour</key><integer>9</integer><key>Minute</key><integer>0</integer></dict>
        <dict><key>Hour</key><integer>9</integer><key>Minute</key><integer>10</integer></dict>
        <dict><key>Hour</key><integer>9</integer><key>Minute</key><integer>20</integer></dict>
        <dict><key>Hour</key><integer>9</integer><key>Minute</key><integer>30</integer></dict>
        <dict><key>Hour</key><integer>9</integer><key>Minute</key><integer>40</integer></dict>
        <dict><key>Hour</key><integer>9</integer><key>Minute</key><integer>50</integer></dict>
        <dict><key>Hour</key><integer>10</integer><key>Minute</key><integer>0</integer></dict>
        <dict><key>Hour</key><integer>10</integer><key>Minute</key><integer>10</integer></dict>
        <dict><key>Hour</key><integer>10</integer><key>Minute</key><integer>20</integer></dict>
        <dict><key>Hour</key><integer>10</integer><key>Minute</key><integer>30</integer></dict>
        <dict><key>Hour</key><integer>10</integer><key>Minute</key><integer>40</integer></dict>
        <dict><key>Hour</key><integer>10</integer><key>Minute</key><integer>50</integer></dict>
        <dict><key>Hour</key><integer>11</integer><key>Minute</key><integer>0</integer></dict>
        <dict><key>Hour</key><integer>11</integer><key>Minute</key><integer>10</integer></dict>
        <dict><key>Hour</key><integer>11</integer><key>Minute</key><integer>20</integer></dict>
        <dict><key>Hour</key><integer>11</integer><key>Minute</key><integer>30</integer></dict>
        <dict><key>Hour</key><integer>11</integer><key>Minute</key><integer>40</integer></dict>
        <dict><key>Hour</key><integer>11</integer><key>Minute</key><integer>50</integer></dict>
        <dict><key>Hour</key><integer>12</integer><key>Minute</key><integer>0</integer></dict>
        <dict><key>Hour</key><integer>12</integer><key>Minute</key><integer>10</integer></dict>
        <dict><key>Hour</key><integer>12</integer><key>Minute</key><integer>20</integer></dict>
        <dict><key>Hour</key><integer>12</integer><key>Minute</key><integer>30</integer></dict>
        <dict><key>Hour</key><integer>12</integer><key>Minute</key><integer>40</integer></dict>
        <dict><key>Hour</key><integer>12</integer><key>Minute</key><integer>50</integer></dict>
        <dict><key>Hour</key><integer>13</integer><key>Minute</key><integer>0</integer></dict>
        <dict><key>Hour</key><integer>13</integer><key>Minute</key><integer>10</integer></dict>
        <dict><key>Hour</key><integer>13</integer><key>Minute</key><integer>20</integer></dict>
        <dict><key>Hour</key><integer>13</integer><key>Minute</key><integer>30</integer></dict>
        <dict><key>Hour</key><integer>13</integer><key>Minute</key><integer>40</integer></dict>
        <dict><key>Hour</key><integer>13</integer><key>Minute</key><integer>50</integer></dict>
        <dict><key>Hour</key><integer>14</integer><key>Minute</key><integer>0</integer></dict>
        <dict><key>Hour</key><integer>14</integer><key>Minute</key><integer>10</integer></dict>
        <dict><key>Hour</key><integer>14</integer><key>Minute</key><integer>20</integer></dict>
        <dict><key>Hour</key><integer>14</integer><key>Minute</key><integer>30</integer></dict>
        <dict><key>Hour</key><integer>14</integer><key>Minute</key><integer>40</integer></dict>
        <dict><key>Hour</key><integer>14</integer><key>Minute</key><integer>50</integer></dict>
        <dict><key>Hour</key><integer>15</integer><key>Minute</key><integer>0</integer></dict>
        <dict><key>Hour</key><integer>15</integer><key>Minute</key><integer>10</integer></dict>
        <dict><key>Hour</key><integer>15</integer><key>Minute</key><integer>20</integer></dict>
        <dict><key>Hour</key><integer>15</integer><key>Minute</key><integer>30</integer></dict>
        <dict><key>Hour</key><integer>15</integer><key>Minute</key><integer>40</integer></dict>
        <dict><key>Hour</key><integer>15</integer><key>Minute</key><integer>50</integer></dict>
        <dict><key>Hour</key><integer>16</integer><key>Minute</key><integer>0</integer></dict>
        <dict><key>Hour</key><integer>16</integer><key>Minute</key><integer>10</integer></dict>
        <dict><key>Hour</key><integer>16</integer><key>Minute</key><integer>20</integer></dict>
        <dict><key>Hour</key><integer>16</integer><key>Minute</key><integer>30</integer></dict>
        <dict><key>Hour</key><integer>16</integer><key>Minute</key><integer>40</integer></dict>
        <dict><key>Hour</key><integer>16</integer><key>Minute</key><integer>50</integer></dict>
        <dict><key>Hour</key><integer>17</integer><key>Minute</key><integer>0</integer></dict>
        <dict><key>Hour</key><integer>17</integer><key>Minute</key><integer>10</integer></dict>
        <dict><key>Hour</key><integer>17</integer><key>Minute</key><integer>20</integer></dict>
        <dict><key>Hour</key><integer>17</integer><key>Minute</key><integer>30</integer></dict>
        <dict><key>Hour</key><integer>17</integer><key>Minute</key><integer>40</integer></dict>
        <dict><key>Hour</key><integer>17</integer><key>Minute</key><integer>50</integer></dict>
        <dict><key>Hour</key><integer>18</integer><key>Minute</key><integer>0</integer></dict>
    </array>
    <key>StandardOutPath</key>
    <string>/Users/home/.daily-wallpaper/wake.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/home/.daily-wallpaper/wake.log</string>
</dict>
</plist>
EOF

# 실제 작업 스크립트 생성
cat > /Users/home/.daily-wallpaper/wake-and-wallpaper.sh << 'EOF'
#!/bin/bash
# Mac을 잠깐 깨워서 배경화면 스크립트 실행
su - home -c "bash /Users/home/.daily-wallpaper/wallpaper.sh"
EOF

chmod +x /Users/home/.daily-wallpaper/wake-and-wallpaper.sh

# LaunchDaemon 등록
launchctl unload /Library/LaunchDaemons/com.daily-wallpaper-wake.plist 2>/dev/null
launchctl load /Library/LaunchDaemons/com.daily-wallpaper-wake.plist

echo "완료: 매일 9시~18시 매시 정각에 자동 실행됩니다."
