import Foundation

protocol NetworkServiceProtocol {
    func fetchProducts() async throws -> [Product]
}
