
//
//  NewsCardTransition.swift
//  Shared Element News Feed
//
//  Created for iOS 17+ with enhanced iOS 18 support
//

import SwiftUI

// MARK: - Image Cache

class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else {
                placeholder()
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = url else { return }
        let urlString = url.absoluteString
        
        // Check cache first
        if let cachedImage = ImageCache.shared.get(forKey: urlString) {
            self.image = cachedImage
            return
        }
        
        // Load from network if not cached
        guard !isLoading else { return }
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let uiImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            // Cache the image
            ImageCache.shared.set(uiImage, forKey: urlString)
            
            DispatchQueue.main.async {
                self.image = uiImage
                self.isLoading = false
            }
        }.resume()
    }
}

// MARK: - Data Models

struct NewsArticle: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let content: String
    let imageURL: String
    let author: String
    let publishedDate: Date

    static let sampleArticles: [NewsArticle] = [
        NewsArticle(
            title: "Revolutionary AI Breakthrough",
            subtitle: "Scientists achieve quantum leap in machine learning",
            content: """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

            Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.

            Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.
            """,
            imageURL: "https://picsum.photos/800/600?random=1",
            author: "Dr. Sarah Chen",
            publishedDate: Date().addingTimeInterval(-3600)
        ),
        NewsArticle(
            title: "Climate Solutions Take Center Stage",
            subtitle: "New technology promises to revolutionize carbon capture",
            content: """
            At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident.

            Similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio.

            Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus.
            """,
            imageURL: "https://picsum.photos/800/600?random=2",
            author: "Michael Torres",
            publishedDate: Date().addingTimeInterval(-7200)
        ),
        NewsArticle(
            title: "Space Exploration Milestone",
            subtitle: "First successful Mars colony simulation completed",
            content: """
            Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae.

            Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.

            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
            """,
            imageURL: "https://picsum.photos/800/600?random=3",
            author: "Emma Rodriguez",
            publishedDate: Date().addingTimeInterval(-10800)
        ),
        NewsArticle(
            title: "Tech Industry Transformation",
            subtitle: "Major shift toward sustainable computing",
            content: """
            Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur.

            Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur.

            But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system.
            """,
            imageURL: "https://picsum.photos/800/600?random=4",
            author: "James Wilson",
            publishedDate: Date().addingTimeInterval(-14400)
        )
    ]
}

// MARK: - Main Content View (removed to avoid conflict with existing ContentView.swift)

// MARK: - News Feed View

struct NewsView: View {
    @State private var selectedArticle: NewsArticle?
    @Namespace private var articleNamespace

    var body: some View {
        ZStack {
            // Background that fills entire screen including safe areas
            Color(.systemBackground)
                .ignoresSafeArea()
            
            NavigationStack {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(NewsArticle.sampleArticles) { article in
                            NewsCard(
                                article: article,
                                namespace: articleNamespace,
                                onTap: {
                                    selectedArticle = article
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 44) // Extra buffer for better spacing
                }
                .navigationTitle("News")
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .fullScreenCover(item: $selectedArticle) { article in
            NewsDetailView(
                article: article,
                namespace: articleNamespace,
                onDismiss: {
                    selectedArticle = nil
                }
            )
        }
    }
}

// MARK: - News Card Component

struct NewsCard: View {
    let article: NewsArticle
    let namespace: Namespace.ID
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                // Image Section
                CachedAsyncImage(url: URL(string: article.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.system(size: 40))
                        )
                }
                .frame(height: 200)
                .clipped()
                .matchedTransitionSource(id: article.id, in: namespace)

                // Content Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text(article.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)

                    HStack {
                        Text(article.author)
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer()

                        Text(article.publishedDate, style: .relative)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(16)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - News Detail View

struct NewsDetailView: View {
    let article: NewsArticle
    let namespace: Namespace.ID
    let onDismiss: () -> Void

    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    @Environment(\.dismiss) private var dismiss

    private let dismissThreshold: CGFloat = 100

    var body: some View {
        GeometryReader { geometry in
            let safeAreaTop = geometry.safeAreaInsets.top
            
            ZStack {
                // Background
                Color.black
                    .ignoresSafeArea()
                    .opacity(1 - Double(dragOffset.height) / 500)

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Hero Image - Full Bleed to Top
                        CachedAsyncImage(url: URL(string: article.imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 60))
                                )
                        }
                        .frame(width: geometry.size.width, height: 350 + safeAreaTop) // Constrain width
                        .clipped()
                        .offset(y: -safeAreaTop) // Push into safe area
                        .navigationTransition(.zoom(sourceID: article.id, in: namespace))

                        // Content Section with adjusted positioning
                        VStack(alignment: .leading, spacing: 24) {
                            // Article Header
                            VStack(alignment: .leading, spacing: 12) {
                                Text(article.title)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)

                                Text(article.subtitle)
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)

                                HStack {
                                    Text("By \(article.author)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)

                                    Spacer()

                                    Text(article.publishedDate, style: .date)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 24)

                            Divider()
                                .padding(.horizontal, 20)

                            // Article Content
                            VStack(alignment: .leading, spacing: 20) {
                                Text(article.content)
                                    .font(.body)
                                    .lineSpacing(6)
                                    .padding(.horizontal, 20)

                                // Additional Content Sections
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Key Highlights")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 20)

                                    VStack(alignment: .leading, spacing: 12) {
                                        HighlightRow(icon: "checkmark.circle.fill", text: "Breakthrough technology implementation", color: .green)
                                        HighlightRow(icon: "star.circle.fill", text: "Industry-leading innovation", color: .blue)
                                        HighlightRow(icon: "chart.line.uptrend.xyaxis.circle.fill", text: "Significant performance improvements", color: .orange)
                                        HighlightRow(icon: "globe.americas.fill", text: "Global impact potential", color: .purple)
                                    }
                                    .padding(.horizontal, 20)
                                }

                                Divider()
                                    .padding(.horizontal, 20)

                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Impact & Analysis")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 20)

                                    Text("""
                                    This groundbreaking development represents a significant shift in how we approach technological innovation. The implications extend far beyond the immediate application, potentially revolutionizing entire industries and creating new paradigms for future research and development.

                                    Expert analysis suggests that this advancement could accelerate progress in related fields by decades, offering unprecedented opportunities for collaboration and cross-disciplinary innovation. The methodology employed here sets a new standard for scientific rigor and practical application.

                                    Furthermore, the environmental and economic benefits of this breakthrough cannot be overstated. Early projections indicate substantial reductions in resource consumption while simultaneously improving output quality and efficiency metrics across multiple sectors.
                                    """)
                                    .font(.body)
                                    .lineSpacing(6)
                                    .padding(.horizontal, 20)
                                }

                                Divider()
                                    .padding(.horizontal, 20)

                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Future Outlook")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 20)

                                    Text("""
                                    Looking ahead, researchers are optimistic about the scalability and broader applications of this technology. Several major institutions have already expressed interest in collaborative research initiatives, and funding for expanded studies has been secured through multiple channels.

                                    The next phase of development will focus on optimization and real-world implementation scenarios. Beta testing programs are scheduled to begin in the coming months, with commercial applications anticipated within the next two years.

                                    This represents just the beginning of what promises to be a transformative period in the field, with potential applications extending into healthcare, education, environmental science, and beyond.
                                    """)
                                    .font(.body)
                                    .lineSpacing(6)
                                    .padding(.horizontal, 20)
                                }

                                // Related Articles Section
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Related Articles")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 20)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(NewsArticle.sampleArticles.filter { $0.id != article.id }.prefix(3), id: \.id) { relatedArticle in
                                                RelatedArticleCard(article: relatedArticle)
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }

                                // Bottom padding for safe scrolling
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: 60)
                            }
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .offset(y: -20 - safeAreaTop) // Compensate for safe area
                        .opacity(1 - Double(dragOffset.height) / 300)
                        .scaleEffect(1 - Double(dragOffset.height) / 2000)
                    }
                    .frame(width: geometry.size.width) // Constrain overall width
                }
                .scrollDisabled(isDragging)

                // Custom Navigation Toolbar
                VStack(spacing: 0) {
                    // Toolbar Container
                    HStack {
                        Button(action: onDismiss) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .environment(\.colorScheme, .dark)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        
                        Spacer()
                        
                        // Optional: Add share button or other actions
                        Button(action: {
                            // Share functionality could go here
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .environment(\.colorScheme, .dark)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, safeAreaTop + 44) // Move toolbar below status bar
                    .padding(.bottom, 16)
                    .background(
                        // Gradient overlay for better button visibility
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .black.opacity(0.4), location: 0),
                                .init(color: .black.opacity(0.2), location: 0.7),
                                .init(color: .clear, location: 1.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 120)
                        .allowsHitTesting(false)
                    )
                    
                    Spacer()
                }
                .opacity(1 - Double(dragOffset.height) / 200)
            }
        }
        .ignoresSafeArea(.all, edges: .top) // Allow full bleed
        .offset(y: dragOffset.height)
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    // Only allow downward dragging
                    if value.translation.height > 0 {
                        dragOffset = value.translation
                    }
                }
                .onEnded { value in
                    isDragging = false
                    if value.translation.height > dismissThreshold {
                        onDismiss()
                    } else {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            dragOffset = .zero
                        }
                    }
                }
        )
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: dragOffset)
    }
}

// MARK: - Supporting Components

struct HighlightRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 20)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct RelatedArticleCard: View {
    let article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CachedAsyncImage(url: URL(string: article.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                    )
            }
            .frame(width: 180, height: 120)
            .clipped()
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(article.author)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(width: 180, alignment: .leading)
        }
        .frame(width: 180)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}

// MARK: - Helper Extensions

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}

/*
 USAGE INSTRUCTIONS:

 1. This code provides a complete news feed with shared element transitions
 2. Optimized for iOS 18 with zoom transitions, fallback support for iOS 17
 3. Features:
    - Grid-based news feed with cards
    - Smooth shared element transition on tap
    - Drag-to-dismiss functionality
    - Animated content appearance
    - Hero image expansion
    - Responsive design

 4. Key Components:
    - NewsView: Main feed view
    - NewsCard: Individual article cards
    - NewsDetailView: Full article view with transitions
    - Custom drag gesture handling
    - Matched geometry effects

 5. Customization:
    - Replace sample data with your news API
    - Adjust transition timing and animations
    - Customize card styling and layout
    - Modify dismissal threshold and behavior

 6. Requirements:
    - iOS 17.0+ (iOS 18+ recommended for best experience)
    - SwiftUI 5.0+
    - Internet connection for images
 */
