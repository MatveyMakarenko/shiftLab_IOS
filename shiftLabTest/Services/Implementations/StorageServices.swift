import Foundation

final class StorageService: StorageServiceProtocol {
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let userName = "user_name_key"
        static let isRegistered = "is_registered_key"
    }
    
    func saveUserName(_ name: String) {
        defaults.set(name, forKey: Keys.userName)
    }
    
    func getUserName() -> String? {
        defaults.string(forKey: Keys.userName)
    }
    
    func setIsRegistered(_ value: Bool) {
        defaults.set(value, forKey: Keys.isRegistered)
    }
    
    func getIsRegistered() -> Bool {
        defaults.bool(forKey: Keys.isRegistered)
    }
}
