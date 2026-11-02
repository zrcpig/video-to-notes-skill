---
name: video-notes
description: Use when summarizing online videos or local media files into structured reading notes with transcripts.
license: MIT
---

# Video Notes

Transform video content into structured reading notes with full transcripts. Supports Bilibili, YouTube, and local video/audio files.

## Features

- Download videos from major platforms (Bilibili, YouTube, etc.)
- Extract audio tracks losslessly
- Transcribe with Fun-ASR-Nano (LLM-powered, high accuracy for Chinese/English)
- Generate logically segmented transcripts
- Produce pyramid-structured summaries

## Prerequisites

```bash
# Install uv (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install ffmpeg
# macOS:   brew install ffmpeg
# Windows: winget install ffmpeg
# Linux:   sudo apt install ffmpeg

# Install tools in isolated environments
uv tool install yt-dlp
uv tool install funasr --with torch --with torchaudio
```

## Usage

### Basic Workflow

```bash
# Set up task directory
TASK_DIR=~/video-notes/$(date +%y%m%d)-topic
mkdir -p "$TASK_DIR" && cd "$TASK_DIR"

# 1. Download video
yt-dlp -f "bv*+ba" --merge-output-format mp4 -o "video.%(ext)s" "VIDEO_URL"

# 2. Extract audio (lossless stream copy)
ffmpeg -i video.mp4 -vn -c:a copy audio.m4a

# 3. Transcribe (Fun-ASR-Nano, ~0.2-0.4 RTF)
funasr audio.m4a -m fun-asr-nano -l zh -f srt -o .

# 4. Process transcript
mv audio.srt transcript.srt
```

### For Login-Protected Content

Some videos require account authentication. Use browser cookies:

```bash
yt-dlp --cookies-from-browser chrome -f "bv*+ba" --merge-output-format mp4 -o "video.%(ext)s" "VIDEO_URL"
```

This accesses content within your account permissions. Do not use for unauthorized access.

### Multi-Part Videos

```bash
# Download specific part
yt-dlp "VIDEO_URL?p=2"

# Or download all parts
yt-dlp -f "bv*+ba" --merge-output-format mp4 -o "video.%(ext)s" "VIDEO_URL"
```

## Output Files

| File | Description |
|------|-------------|
| `video.mp4` | Original video archive |
| `audio.m4a` | Original audio track |
| `transcript.srt` | Raw transcript with timestamps |
| `transcript.txt` | Logically segmented readable text |
| `note.md` | Structured summary (generated with AI assistance) |

## Transcript Processing

The raw SRT output is a single block. Process it into readable segments:

1. Extract plain text (remove sequence numbers and timestamp lines)
2. Segment by topic shifts with descriptive headers
3. Preserve original text exactly (including ASR errors) — edits only in headers/structure

## Note Generation

Use an AI assistant to generate structured notes following the Pyramid Principle:

1. **Structure mapping**: Identify the video's skeleton and relationships between parts
2. **Redundancy removal**: Compress oral fillers while preserving substantive information
3. **Logical reorganization**: Conclusion-first, with each section opening a clear claim followed by supporting evidence

## Compliance Notice

- Respect platform Terms of Service. Only download content you have the right to access.
- This tool is intended for personal learning, research, and archival purposes.
- Do not redistribute downloaded content without permission.
- The Fun-ASR model is licensed under MIT. Model weights are downloaded from ModelScope/HuggingFace on first run.

## Technical Details

- **ASR Engine**: Fun-ASR-Nano (SenseVoice encoder + Qwen3 LLM decoder)
- **Chinese CER**: ~8% (vs ~20% for Whisper large-v3)
- **Speed**: 0.2-0.4x real-time factor on modern CPU
- **Platform**: Cross-platform (macOS, Windows, Linux)

## License

MIT License. See LICENSE file for details.

Tool licenses: yt-dlp (Unlicense), FunASR (MIT), ffmpeg (LGPL/GPL).
