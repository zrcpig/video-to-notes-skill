#!/bin/bash
set -e

URL="$1"
TOPIC="${2:-未命名}"
TASK_DIR=~/video-notes/$(date +%y%m%d)-"$TOPIC"
mkdir -p "$TASK_DIR" && cd "$TASK_DIR"

echo "=== 下载视频 ==="
yt-dlp --cookies-from-browser chrome -f "bv*+ba" --merge-output-format mp4 -o "video.%(ext)s" "$URL"

echo "=== 提取音频 ==="
ffmpeg -y -i video.mp4 -vn -c:a copy audio.m4a

echo "=== 语音识别（Fun-ASR-Nano）==="
funasr audio.m4a -m fun-asr-nano -l zh -f srt -o .
mv audio.srt transcript.srt

echo "=== 完成 ==="
echo "产物在: $TASK_DIR"
ls -lh
