import Foundation

final class MainViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showGreeting: Bool = false
    @Published var greetingText: String = ""
    
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         storageService: StorageServiceProtocol = StorageService()) {
        self.networkService = networkService
        self.storageService = storageService
    }
    
    // MARK: Actions
    func fetchProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedProducts = try await networkService.fetchProducts()
            self.products = fetchedProducts
        } catch {
            self.errorMessage = "Ошибка загрузки: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func greetUser() {
        if let name = storageService.getUserName() {
            greetingText = "Привет, \(name)! 👋"
        } else {
            greetingText = "Привет, Гость!"
        }
        showGreeting = true
    }
}
