# Burme Editor

Professional Video Editor with 15 Built-in Tools

## 📱 Features

- **15 Professional Tools**: Crop, Audio, Color, Text, Title, Layering, Transform, Speed, Transition, Effects, Masking, Stabilize, Image Overlay, Subtitles, Export
- **Multi-language Support**: English, Myanmar, Thai, Vietnamese, Russian
- **FFmpeg-powered Processing**: Fast and efficient video processing
- **Cross-platform**: Android, iOS, and Web support
- **Modern UI**: Built with Flutter Material Design 3

## 🛠️ Tools Overview

| Tool | Description |
|------|-------------|
| 🌐 Crop | Crop and resize video frames |
| 🔊 Audio | Edit audio tracks, volume, fade in/out |
| 🎨 Color | Adjust brightness, contrast, saturation, hue |
| 📝 Text | Add text overlays with customizable fonts |
| 📰 Title | Create title sequences with various styles |
| 🔢 Layering | Manage video layers and z-order |
| ↔️ Transform | Scale, rotate, and position elements |
| ⚡ Speed | Adjust playback speed (0.25x - 4x) |
| 🔄 Transition | Add smooth transitions between clips |
| ✨ Effects | Apply visual effects (blur, vignette, etc.) |
| ⬜ Masking | Create custom masks for compositing |
| 📐 Stabilize | Stabilize shaky footage |
| 🖼️ Image Overlay | Overlay images on video |
| 📑 Subtitles | Add and style subtitles |
| 💾 Export | Export in multiple formats and qualities |

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.16.9+
- Dart SDK 3.0.0+
- Android Studio / Xcode (for mobile builds)

### Installation

```bash
# Clone the repository
git clone https://github.com/amkyawdev/burmeeditor.git
cd burmeeditor

# Install Flutter dependencies
cd mobile
flutter pub get

# Run the app
flutter run
```

### Build Instructions

#### Android APK
```bash
cd mobile
flutter build apk --release
```

#### iOS
```bash
cd mobile
flutter build ios --release --no-codesign
```

#### Web
```bash
cd mobile
flutter build web --release
```

## 📁 Project Structure

```
burmeeditor/
├── .github/
│   └── workflows/          # CI/CD workflows
├── backend/                # Backend API (Flask)
├── docker/                 # Docker configuration
├── mobile/                 # Flutter mobile app
│   ├── lib/
│   │   ├── app/           # App configuration
│   │   ├── screens/       # UI screens
│   │   ├── widgets/       # Reusable widgets
│   │   ├── services/     # App services
│   │   ├── models/        # Data models
│   │   └── utils/         # Utilities
│   └── assets/            # App assets
├── scripts/               # Build scripts
├── docs/                 # Documentation
└── version.json           # Version info
```

## 🐳 Docker Deployment

```bash
# Development
cd docker
docker-compose up -d

# Production
docker-compose -f docker-compose.prod.yml up -d
```

## 🌐 Backend API

The backend provides REST APIs for:
- Video processing (trim, watermark, thumbnails)
- Audio processing (extract, mix, normalize)
- Subtitle management
- Version checking and updates

### API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/videos` | GET/POST | List/Upload videos |
| `/api/videos/<id>` | GET/DELETE | Video operations |
| `/api/audio` | GET/POST | List/Upload audio |
| `/api/subtitles` | GET/POST | Subtitle management |
| `/api/update/check` | GET | Check for updates |

## 📦 CI/CD

GitHub Actions workflows for:
- APK build
- AAB build (Google Play)
- iOS build
- Web build
- Auto releases
- Docker image publishing

## 🌎 Supported Languages

- 🇺🇸 English (en)
- 🇲🇲 Myanmar (my)
- 🇹🇭 Thai (th)
- 🇻🇳 Vietnamese (vi)
- 🇷🇺 Russian (ru)

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**Aung Myo Kyaw** (amkyawdev)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- FFmpeg for video processing capabilities
- All contributors and supporters

---

Made with ❤️ for video creators