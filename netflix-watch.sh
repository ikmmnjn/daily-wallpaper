#!/bin/bash

# 넷플릭스 영상 URL (전체화면 자동 열기 + 잠자기 방지)
NETFLIX_URL="${1:-https://www.netflix.com}"

echo "넷플릭스 열기: $NETFLIX_URL"
echo "잠자기 방지 시작 (종료하려면 Ctrl+C)"

# 브라우저에서 넷플릭스 열기
open "$NETFLIX_URL"

# 디스플레이 잠자기 방지 (브라우저 닫을 때까지)
caffeinate -d -i &
CAFFEINATE_PID=$!

echo "잠자기 방지 PID: $CAFFEINATE_PID"
echo "영화 다 보고 나서 이 터미널에서 Ctrl+C 를 누르면 잠자기 방지가 해제됩니다."

# Ctrl+C 또는 종료 시 caffeinate 정리
trap "kill $CAFFEINATE_PID 2>/dev/null; echo '잠자기 방지 해제됨'; exit 0" INT TERM

# 대기
wait $CAFFEINATE_PID
