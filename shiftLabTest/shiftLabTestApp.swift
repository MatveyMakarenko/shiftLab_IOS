import SwiftUI

@main
struct shiftLabTestApp: App {
    
    private let storageService: StorageServiceProtocol = StorageService()
    @State private var isRegistered: Bool
    
    init() {
        let service = StorageService()
        _isRegistered = State(initialValue: service.getIsRegistered())
    }
    
    var body: some Scene {
        WindowGroup {
            if isRegistered {
                MainView()
            } else {
                RegistrationView(onSuccess: {
                    isRegistered = true
                })
            }
        }
    }
}
