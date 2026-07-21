import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var isDarkMode: Bool = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Загрузка товаров...")
                            .foregroundColor(.secondary)
                    }
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button("Попробовать снова") {
                            Task { await viewModel.fetchProducts() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if viewModel.products.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "cart")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("Список пуст")
                            .foregroundColor(.secondary)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.products) { product in
                                VStack(alignment: .leading, spacing: 12) {
                                    AsyncImage(url: URL(string: product.image)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 200)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 200)
                                                .background(Color(.systemGray6))
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 200)
                                                .foregroundColor(.secondary)
                                                .background(Color(.systemGray6))
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .cornerRadius(12)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(product.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                            .lineLimit(2)
                                        
                                        Text(product.description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                        Text("\(product.price, specifier: "%.2f") $")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.green)
                                    }
                                    .padding(.horizontal, 4)
                                }
                                .padding()
                                
                                .background(
                                    colorScheme == .dark ?
                                    Color(.systemGray6) :
                                    Color(.systemBackground)
                                )
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            colorScheme == .dark ?
                                            Color.white.opacity(0.1) :
                                            Color.clear,
                                            lineWidth: 1
                                        )
                                )
                                .shadow(
                                    color: colorScheme == .dark ?
                                    Color.clear :
                                    Color.black.opacity(0.08),
                                    radius: 8, x: 0, y: 4
                                )
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Товары")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isDarkMode.toggle()
                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                    }) {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(isDarkMode ? .yellow : .orange)
                            .font(.title3)
                            .padding(.horizontal, 8)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.greetUser() }) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .alert("Приветствие", isPresented: $viewModel.showGreeting) {
                Button("Отлично!", role: .cancel) { }
            } message: {
                Text(viewModel.greetingText)
            }
            .task { await viewModel.fetchProducts() }
            .onAppear {
                isDarkMode = colorScheme == .dark
            }
        }
    }
}
