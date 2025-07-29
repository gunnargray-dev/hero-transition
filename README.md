# SharedTransition

A modern iOS news feed application demonstrating advanced SwiftUI shared element transitions and smooth animations. Built for iOS 17+ with enhanced iOS 18 support.

## 📱 Features

### Core Functionality
- **News Feed**: Grid-based layout with beautiful article cards
- **Shared Element Transitions**: Smooth zoom transitions between feed and detail views
- **Drag-to-Dismiss**: Intuitive gesture-based dismissal from detail view
- **Image Caching**: Optimized image loading with intelligent caching system
- **Responsive Design**: Adapts to different screen sizes and orientations

### UI/UX Highlights
- **Modern Card Design**: Rounded corners with subtle shadows and gradients
- **Hero Image Expansion**: Images smoothly expand from cards to full-screen detail view
- **Animated Interactions**: Press animations and smooth state transitions
- **Dynamic Color Extraction**: Automatic dominant color detection for gradient overlays
- **Loading States**: Progress indicators and placeholder content

### Technical Features
- **iOS 18 Navigation Transitions**: Leverages the latest `.navigationTransition(.zoom)` API
- **Fallback Support**: Graceful degradation for iOS 17 devices
- **Memory Management**: Intelligent image cache with size limits and cleanup
- **Performance Optimized**: Lazy loading, preloading, and efficient rendering

## 🛠 Requirements

- **iOS**: 17.0+ (iOS 18+ recommended for best experience)
- **Xcode**: 15.0+
- **Swift**: 5.9+
- **SwiftUI**: 5.0+

## 🚀 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/SharedTransition.git
   cd SharedTransition
   ```

2. **Open in Xcode**
   ```bash
   open SharedTransition.xcodeproj
   ```

3. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## 📁 Project Structure

```
SharedTransition/
├── SharedTransition/
│   ├── SharedTransitionApp.swift      # Main app entry point
│   ├── ContentView.swift              # Root view container
│   ├── NewsCardTransition.swift       # Core news feed implementation
│   └── Assets.xcassets/              # App icons and colors
└── SharedTransition.xcodeproj/       # Xcode project files
```

## 🎯 Key Components

### NewsView
The main feed view that displays a scrollable list of news articles with smooth animations and transitions.

### NewsCard
Individual article cards featuring:
- Cached image loading with placeholder states
- Dynamic gradient overlays based on image colors
- Press animations and haptic feedback
- Responsive typography and spacing

### NewsDetailView
Full-screen article detail view with:
- Hero image expansion from card
- Rich content layout with typography hierarchy
- Drag-to-dismiss gesture handling
- Custom navigation toolbar

### ImageCache
Intelligent image caching system with:
- Memory-based caching with size limits
- Background loading and preloading
- Notification-based updates
- Automatic cleanup and memory management

## 🎨 Customization

### Styling
- Modify card corner radius and shadows in `NewsCard`
- Adjust color schemes and gradients
- Customize typography and spacing

### Animations
- Tune transition timing and easing curves
- Modify drag dismissal threshold
- Customize press animations

### Content
- Replace sample data with your news API
- Add more article metadata fields
- Implement additional content sections

## 🔧 Advanced Usage

### Adding New Transitions
```swift
// Example: Add a custom transition
.navigationTransition(.asymmetric(
    insertion: .move(edge: .trailing),
    removal: .move(edge: .leading)
))
```

### Customizing Image Cache
```swift
// Adjust cache limits
ImageCache.shared.cache.countLimit = 200
ImageCache.shared.cache.totalCostLimit = 100 * 1024 * 1024 // 100MB
```

### Implementing Custom Gestures
```swift
// Add custom gesture handling
.gesture(
    DragGesture()
        .onChanged { value in
            // Custom drag logic
        }
        .onEnded { value in
            // Custom end logic
        }
)
```

## 📱 Screenshots

*[Screenshots would be added here showing the news feed, card interactions, and detail view transitions]*

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with SwiftUI and iOS 18's latest navigation transition APIs
- Inspired by modern news app design patterns
- Uses Picsum Photos for sample images

## 📞 Support

If you have any questions or need help with the project, please open an issue on GitHub or contact the maintainers.

---

**Note**: This project demonstrates advanced SwiftUI techniques and is intended for educational purposes and as a reference implementation for shared element transitions in iOS applications.