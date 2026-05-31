# 🎬 Burmeditor

### Professional Video Editing Suite for Mobile & Web

![Flutter](https://img.shields.io/badge/Flutter-3.16.9-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0.0-0175C2?style=for-the-badge&logo=dart)
![Python](https://img.shields.io/badge/Python-Flask-3776AB?style=for-the-badge&logo=python)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-FF6B6B?style=for-the-badge)

---

> **Burmeditor** is a powerful, cross-platform video editing application designed for content creators, filmmakers, and professionals. Transform your footage into stunning videos with 15 built-in professional tools.

[![Star](https://img.shields.io/badge/⭐%20Star-This%20Repo-FAB0050?style=for-the-badge)](https://github.com/amkyawdev/burmeditor/stargazers)
[![Fork](https://img.shields.io/badge/🍴%20Fork-On%20GitHub-333333?style=for-the-badge)](https://github.com/amkyawdev/burmeditor/fork)

---

## ✨ Features

### 🎯 15 Professional Editing Tools

| Icon | Tool | Description |
|------|------|-------------|
| 🌐 | **Crop** | Precision crop and resize with aspect ratio presets |
| 🔊 | **Audio** | Advanced audio editing with volume, fade, and mixing |
| 🎨 | **Color** | Professional color grading with curves and LUT support |
| 📝 | **Text** | Dynamic text overlays with custom fonts and animations |
| 📰 | **Title** | Cinematic title sequences with animated templates |
| 🔢 | **Layering** | Multi-track compositing with z-order control |
| ↔️ | **Transform** | Scale, rotate, and position with keyframe animation |
| ⚡ | **Speed** | Variable speed control from 0.25x to 4x |
| 🔄 | **Transition** | 20+ smooth transitions between clips |
| ✨ | **Effects** | Visual effects library including blur, glow, and distortion |
| ⬜ | **Masking** | Shape and brush masks for advanced compositing |
| 📐 | **Stabilize** | Video stabilization for shaky footage |
| 🖼️ | **Image Overlay** | Picture-in-picture with positioning controls |
| 📑 | **Subtitles** | Subtitle editor with styling and positioning |
| 💾 | **Export** | Multi-format export with quality presets |

### 🌎 Multi-Language Support

| Language | Code | Status |
|----------|------|--------|
| 🇺🇸 English | EN | ✅ |
| 🇲🇲 မြန်မာ | MY | ✅ |
| 🇹🇭 ภาษาไทย | TH | ✅ |
| 🇻🇳 Tiếng Việt | VI | ✅ |
| 🇷🇺 Русский | RU | ✅ |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         BURMEDITOR                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │   Android    │    │     iOS      │    │     Web      │      │
│  │     📱       │    │     🍎       │    │     🌐       │      │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘      │
│         │                   │                   │                │
│         └───────────────────┼───────────────────┘                │
│                             │                                    │
│                    ┌────────▼────────┐                          │
│                    │   Flutter App    │                        │
│                    │   (Dart/State)   │                        │
│                    └────────┬────────┘                          │
│                             │                                    │
│         ┌───────────────────┼───────────────────┐                │
│         │                   │                   │                │
│  ┌──────▼───────┐    ┌──────▼───────┐    ┌──────▼───────┐      │
│  │   Services   │    │    Models    │    │    Widgets   │      │
│  └──────────────┘    └──────────────┘    └──────────────┘      │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│                         Backend API                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │   Video     │  │   Audio     │  │  Subtitle   │              │
│  │  Processing │  │  Processing │  │  Processing │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│                                                                  │
│                    Flask + FFmpeg + Redis                       │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 Quick Start

### Prerequisites

```bash
# Flutter SDK
Flutter 3.16.9+

# Dart SDK
Dart 3.0.0+

# For Backend
Python 3.11+
FFmpeg
Docker (optional)
```

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/amkyawdev/burmeditor.git
cd burmeditor

# 2. Install Flutter dependencies
cd mobile
flutter pub get

# 3. Run the app
flutter run
```

### Build Commands

| Platform | Command | Output |
|----------|---------|--------|
| Android APK | `flutter build apk --release` | `.apk` file |
| Android AAB | `flutter build appbundle --release` | `.aab` file |
| iOS | `flutter build ios --release --no-codesign` | `.app` folder |
| Web | `flutter build web --release` | `build/web/` folder |

---

## 🐳 Docker Deployment

```bash
# Development Environment
cd docker
docker-compose up -d

# Production Environment
docker-compose -f docker-compose.prod.yml up -d

# Access the app
open http://localhost:5000
```

---

## 🌐 API Documentation

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/videos` | List all videos |
| `POST` | `/api/videos` | Upload video |
| `GET` | `/api/videos/<id>` | Get video details |
| `DELETE` | `/api/videos/<id>` | Delete video |
| `POST` | `/api/videos/process` | Process video |
| `GET` | `/api/audio` | List audio files |
| `POST` | `/api/audio` | Upload audio |
| `GET` | `/api/subtitles` | List subtitles |
| `POST` | `/api/subtitles` | Upload subtitle |
| `GET` | `/api/update/check` | Check for updates |

---

## 🧪 CI/CD Pipeline

| Workflow | Trigger | Status |
|----------|---------|--------|
| `01-build-apk.yml` | Push to main/develop | ✅ |
| `02-build-aab.yml` | New tag (v*) | ✅ |
| `03-build-ios.yml` | Push to main/develop | ✅ |
| `04-build-web.yml` | Push to main/develop | ✅ |
| `05-auto-release.yml` | New tag (v*) | ✅ |
| `06-docker-publish.yml` | Push to main | ✅ |
| `07-update-checker.yml` | Every 6 hours | ✅ |
| `08-cleanup.yml` | Weekly | ✅ |

---

## 📂 Project Structure

```
burmeditor/
├── .github/
│   └── workflows/           # 8 CI/CD workflows
│
├── backend/                  # Flask Backend API
│   └── app/
│       ├── routes/         # API endpoints
│       ├── services/       # Business logic
│       ├── models/         # Data models
│       └── utils/          # Utilities
│
├── mobile/                  # Flutter Mobile App
│   └── lib/
│       ├── app/            # App configuration
│       ├── screens/        # UI Screens
│       ├── widgets/        # Reusable Widgets
│       ├── services/        # App Services
│       └── models/         # Data Models
│
├── docker/                  # Docker Configuration
│
├── version.json            # Version Info
├── README.md               # This file
└── LICENSE                # MIT License
```

---

## 🛠️ Tech Stack

### Frontend
| Technology | Version | Purpose |
|------------|---------|---------|
| Flutter | 3.16.9 | Cross-platform UI |
| Dart | 3.0.0 | Programming language |
| Riverpod | 2.4.0 | State management |
| Material Design 3 | - | UI framework |

### Backend
| Technology | Version | Purpose |
|------------|---------|---------|
| Flask | 3.0.0 | Web framework |
| Python | 3.11 | Language |
| FFmpeg | Latest | Video processing |
| Redis | 7 | Caching |
| PostgreSQL | 15 | Database |

---

## 📊 Version History

| Version | Build | Date | Changes |
|---------|-------|------|---------|
| 1.0.0 | 101 | 2026-05-31 | Initial release with 15 tools |

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](docs/CONTRIBUTING.md) before submitting a PR.

```bash
# Fork and clone the repo
git clone https://github.com/your-username/burmeditor.git

# Create a feature branch
git checkout -b feature/your-feature

# Make your changes and commit
git commit -m "feat: add new feature"

# Push and create PR
git push origin feature/your-feature
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Developer

**Aung Myo Kyaw** (amkyawdev)  
🌐 [GitHub](https://github.com/amkyawdev)  
📧 amkyawdev@example.com

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) - Cross-platform UI framework
- [FFmpeg](https://ffmpeg.org) - Video processing powerhouse
- [Riverpod](https://riverpod.dev) - State management
- All contributors and open-source community

---

<div align="center">

### ⭐ If you find Burmeditor helpful, please give it a star!

**Made with ❤️ for video creators worldwide**

*Copyright © 2026 Burmeditor. All rights reserved.*

</div>
