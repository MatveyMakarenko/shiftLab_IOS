import Foundation

final class RegistrationViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthDate: Date = Date()
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    private let storageService: StorageServiceProtocol
    
    var firstNameError: String? {
        guard !firstName.isEmpty else { return nil }
        if firstName.count < 2 { return "Имя должно содержать минимум 2 символа" }
        return nil
    }
    
    var lastNameError: String? {
        guard !lastName.isEmpty else { return nil }
        if lastName.count < 2 { return "Фамилия должна содержать минимум 2 символа" }
        return nil
    }
    
    var birthDateError: String? {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        let age = ageComponents.year ?? 0
        
        if age < 15 {
            return "Регистрация доступна только с 15 лет"
        }
        return nil
    }
    
    var passwordError: String? {
        guard !password.isEmpty else { return nil }
        if password.count < 8 { return "Пароль должен содержать минимум 8 символов" }
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        if !hasNumber { return "Пароль должен содержать хотя бы одну цифру" }
        let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        if !hasUppercase { return "Пароль должен содержать хотя бы одну заглавную букву" }
        return nil
    }
    
    var confirmPasswordError: String? {
        guard !confirmPassword.isEmpty else { return nil }
        if password != confirmPassword { return "Пароли не совпадают" }
        return nil
    }
    
    var isFormValid: Bool {
        !firstName.isEmpty && firstNameError == nil &&
        !lastName.isEmpty && lastNameError == nil &&
        birthDateError == nil &&
        !password.isEmpty && passwordError == nil &&
        !confirmPassword.isEmpty && confirmPasswordError == nil
    }
    
    init(storageService: StorageServiceProtocol = StorageService()) {
        self.storageService = storageService
    }
    
    func register() {
        if isFormValid {
            storageService.saveUserName(firstName)
            storageService.setIsRegistered(true)
        }
    }
}
