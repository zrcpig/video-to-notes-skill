# 视频笔记技能

把 B 站/YouTube 视频转成结构化阅读笔记，带完整原文留档。

## 效果

输入一个视频链接，输出：
- 视频文件留档
- 无损音轨
- 转写原文（按逻辑话题分段）
- 结构化笔记（金字塔原理，需 AI 助手整理）

## 快速开始

```bash
# 1. 装依赖
curl -LsSf https://astral.sh/uv/install.sh | sh
brew install ffmpeg  # Windows: winget install ffmpeg
uv tool install yt-dlp
uv tool install funasr --with torch --with torchaudio

# 2. 跑工作流
./video-notes.sh "https://www.bilibili.com/video/BVxxxx" "主题名"

# 3. 产物在 ~/video-notes/YYMMDD-主题名/
```

## 为什么用 Fun-ASR-Nano？

| | Fun-ASR-Nano | Whisper |
|---|---|---|
| 中文错字率 | ~8% | ~20% |
| 同音字纠错 | 内置 LLM 自动修正 | 无 |
| 速度 | 0.2-0.4 倍实时 | 0.1-0.3 倍实时 |
| 中英混杂 | 优秀 | 一般 |

实测：B 站中文口播视频，"导师""画饼""preliminary"等词全部识别正确，whisper 会错成"导致""画笔""pronimeral"。

## 合规说明

- 仅供个人学习、研究、存档使用
- 遵守平台服务条款，只下载有权访问的内容
- 不要二次分发下载的视频

## 仓库结构

```
video-to-notes-skill/
├── SKILL.md              # Agent Skills 标准格式（英文）
├── README.md             # 英文说明
├── README.zh-CN.md       # 本文件
├── video-notes.sh        # 一键执行脚本
└── LICENSE               # MIT
```

## 技术栈

- yt-dlp：视频下载
- FunASR（通义实验室）：语音识别，Fun-ASR-Nano 模型内置 Qwen3 LLM 解码
- ffmpeg：音视频处理

## 致谢

- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [FunASR](https://github.com/modelscope/FunASR)
- [ffmpeg](https://ffmpeg.org/)
