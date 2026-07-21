import Foundation

protocol StorageServiceProtocol {
    func saveUserName(_ name: String)
    func getUserName() -> String?
    func setIsRegistered(_ value: Bool)
    func getIsRegistered() -> Bool
}
