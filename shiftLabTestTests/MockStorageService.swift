import Foundation
@testable import shiftLabTest

// Заглушка
final class MockStorageService: StorageServiceProtocol {

    var savedUserName: String?
    var isRegistered: Bool = false
    
    var isSaveUserNameCalled = false
    var setIsRegisteredCalled = false
    
    func saveUserName(_ name: String) {
        savedUserName = name
        isSaveUserNameCalled = true
    }
    
    func getUserName() -> String? {
        return savedUserName
    }
    
    func setIsRegistered(_ value: Bool) {
        isRegistered = value
        setIsRegisteredCalled = true
    }
    
    func getIsRegistered() -> Bool {
        return isRegistered
    }
}
