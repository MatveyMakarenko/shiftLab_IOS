import XCTest
@testable import shiftLabTest

final class RegistrationViewModelTests: XCTestCase {

    var viewModel: RegistrationViewModel!
    var mockStorage: MockStorageService!
    
    override func setUp() {
        super.setUp()
        mockStorage = MockStorageService()
        viewModel = RegistrationViewModel(storageService: mockStorage)
    }
    
    // MARK: Тесты Имени
    
    func testFirstNameValidation_Empty_ReturnsNoError() {
        viewModel.firstName = ""
        XCTAssertNil(viewModel.firstNameError, "Пустое имя не должно вызывать ошибку до начала ввода")
        XCTAssertFalse(viewModel.isFormValid)
    }
    
    func testFirstNameValidation_TooShort_ReturnsError() {
        viewModel.firstName = "A"
        XCTAssertNotNil(viewModel.firstNameError, "Имя из 1 символа должно вызывать ошибку")
    }
    
    func testFirstNameValidation_Valid_ReturnsNoError() {
        viewModel.firstName = "Иван"
        XCTAssertNil(viewModel.firstNameError)
    }
    
    // MARK: Тесты Пароля
    
    func testPasswordValidation_NoUppercase_ReturnsError() {
        viewModel.password = "password123"
        XCTAssertNotNil(viewModel.passwordError, "Пароль без заглавной буквы должен вызывать ошибку")
    }
    
    func testPasswordValidation_NoDigit_ReturnsError() {
        viewModel.password = "Password"
        XCTAssertNotNil(viewModel.passwordError, "Пароль без цифры должен вызывать ошибку")
    }
    
    func testPasswordValidation_Valid_ReturnsNoError() {
        viewModel.password = "Password123"
        XCTAssertNil(viewModel.passwordError)
    }
    
    // MARK: Тесты Подтверждения пароля
    
    func testConfirmPasswordValidation_Mismatch_ReturnsError() {
        viewModel.password = "Password123"
        viewModel.confirmPassword = "Password321"
        XCTAssertNotNil(viewModel.confirmPasswordError)
    }
    
    func testConfirmPasswordValidation_Match_ReturnsNoError() {
        viewModel.password = "Password123"
        viewModel.confirmPassword = "Password123"
        XCTAssertNil(viewModel.confirmPasswordError)
    }
    
    // MARK: Тест Регистрации
    
    func testRegister_Success_CallsStorageService() {
        viewModel.firstName = "Иван"
        viewModel.lastName = "Иванов"
        viewModel.password = "Password123"
        viewModel.confirmPassword = "Password123"
        
        XCTAssertTrue(viewModel.isFormValid)
        
        viewModel.register()
        
        XCTAssertTrue(mockStorage.isSaveUserNameCalled, "Метод saveUserName должен быть вызван")
        XCTAssertEqual(mockStorage.savedUserName, "Иван", "Должно сохраниться имя 'Иван'")
        XCTAssertTrue(mockStorage.setIsRegisteredCalled, "Статус регистрации должен быть обновлен")
        XCTAssertTrue(mockStorage.isRegistered, "Статус должен стать true")
    }
}
