import SwiftUI

struct RegistrationView: View {
    
    @StateObject private var viewModel = RegistrationViewModel()
    var onSuccess: () -> Void
    
    // Получаем текущую тему (светлая или темная)
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            // Используем системный фон группы, он сам адаптируется под тему
            ScrollView {
                VStack(spacing: 25) {
                    // Заголовок
                    VStack(spacing: 8) {
                        Text("Регистрация")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary) // .primary автоматически черный/белый
                        
                        Text("Создайте аккаунт")
                            .font(.subheadline)
                            .foregroundColor(.secondary) // .secondary автоматически темно-серый/светло-серый
                    }
                    .padding(.top, 20)
                    
                    // Секция: Личные данные
                    VStack(alignment: .leading, spacing: 12) {
                        Text("ЛИЧНЫЕ ДАННЫЕ")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            // Имя
                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                TextField("Имя", text: $viewModel.firstName)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(Color(.systemBackground)) // Адаптивный фон карточки
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0 : 0.05), radius: 5, x: 0, y: 2) // Тень только для светлой темы
                            
                            if let error = viewModel.firstNameError {
                                HStack {
                                    Image(systemName: "exclamationmark.circle")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal, 4)
                            }
                            
                            // Фамилия
                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                TextField("Фамилия", text: $viewModel.lastName)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0 : 0.05), radius: 5, x: 0, y: 2)
                            
                            if let error = viewModel.lastNameError {
                                HStack {
                                    Image(systemName: "exclamationmark.circle")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal, 4)
                            }
                            
                            // Дата рождения
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                Text("Дата рождения")
                                    .foregroundColor(.primary)
                                Spacer()
                                DatePicker("", selection: $viewModel.birthDate, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .colorScheme(colorScheme) // Принудительно наследуем тему
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0 : 0.05), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding(.top)
                    
                    if let error = viewModel.birthDateError {
                        HStack {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(.red)
                                .font(.caption)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .padding(.horizontal, 4)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("БЕЗОПАСНОСТЬ")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            // Пароль
                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                SecureField("Пароль", text: $viewModel.password)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0 : 0.05), radius: 5, x: 0, y: 2)
                            
                            if let error = viewModel.passwordError {
                                HStack {
                                    Image(systemName: "exclamationmark.circle")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal, 4)
                            }
                            
                            // Подтверждение пароля
                            HStack {
                                Image(systemName: "lock.shield")
                                    .foregroundColor(.blue)
                                    .frame(width: 20)
                                SecureField("Подтвердите пароль", text: $viewModel.confirmPassword)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0 : 0.05), radius: 5, x: 0, y: 2)
                            
                            if let error = viewModel.confirmPasswordError {
                                HStack {
                                    Image(systemName: "exclamationmark.circle")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                    
                    // Кнопка регистрации
                    // Кнопка регистрации
                    Button(action: {
                        viewModel.register()
                        if viewModel.isFormValid {
                            onSuccess()
                        }
                    }) {
                        Text("Зарегистрироваться")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .disabled(!viewModel.isFormValid)
                    // 👇 ВОТ ПРАВИЛЬНОЕ РЕШЕНИЕ ЧЕРЕЗ if/else 👇
                    .background {
                        if viewModel.isFormValid {
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            Color(.systemGray4)
                        }
                    }
                    .cornerRadius(12)
                    .shadow(color: viewModel.isFormValid ? Color.blue.opacity(0.3) : Color.clear,
                           radius: 10, x: 0, y: 5)
                    .padding(.top, 10)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
            }
            .background(Color(.systemGroupedBackground)) // Адаптивный фон всего экрана
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
