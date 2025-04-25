# Test App

A SwiftUI-based iOS application designed for the latest version of iOS, running in **portrait mode** only.  
This app is focused on **smooth performance**, **clean UI**, and **maintainable code**.

---

## 🛠 Configuration

- **iOS Deployment Target**: Latest iOS version
- **Orientation**: Portrait mode only
- **Language**: Swift
- **UI Framework**: SwiftUI
- **Architecture**: MVVM (optional - adjust based on your project)

---

## 🧰 Dependencies

The project uses the following third-party libraries:

### 🔹 [SnapKit](https://github.com/SnapKit/SnapKit)
Used for elegant and readable Auto Layout constraints in UIKit-based views (if any UIKit components are bridged in).

### 🔹 [Alamofire](https://github.com/Alamofire/Alamofire)
Used for HTTP networking, including API requests, response handling, and error management.

### 🔹 [Kingfisher](https://github.com/onevcat/Kingfisher)
Used for asynchronous image downloading and caching.

---

## 🚀 Getting Started

### ✅ Requirements

- Xcode (latest version)
- CocoaPods or Swift Package Manager (SPM)
- iOS device or simulator running the latest iOS version

### 📦 Installation

**Swift Package Manager (SPM)**:

1. Open your Xcode project.
2. Go to `File > Add Packages`.
3. Add these URLs:
   - SnapKit: `https://github.com/SnapKit/SnapKit`
   - Alamofire: `https://github.com/Alamofire/Alamofire`
   - Kingfisher: `https://github.com/onevcat/Kingfisher`


## 🧾 Customization

All configurable parameters (such as API base URLs, themes, or feature flags) are stored in the `Defines.swift` file.

Update these files to fit your environment or branding needs.

---

## 🐞 Troubleshooting

- **App crashes on launch?**
  - Check if all required Info.plist entries (e.g., for network access or permissions) are correctly configured.
- **Images not loading?**
  - Ensure the image URLs are valid and accessible over the network.
- **Networking issues?**
  - Inspect Alamofire logs and make sure API endpoints are up and running.

---

## 📚 External Libraries Justification

### 🔹 SnapKit
Used for situations where UIKit views are necessary (like integrating custom UIKit views with SwiftUI). It improves readability and reduces boilerplate compared to native Auto Layout.

### 🔹 Alamofire
Provides a cleaner and more expressive API than native `URLSession`, especially for handling JSON APIs, error management, and request chaining.

### 🔹 Kingfisher
Efficient and lightweight solution for loading remote images with caching support, critical for improving user experience in image-heavy interfaces.

---

## 📂 Deliverables

- ✅ Full source code, written in Swift
- ✅ Well-commented and readable
- ✅ Readme file (you’re reading it 😊)
- ✅ External libraries are documented with justification

