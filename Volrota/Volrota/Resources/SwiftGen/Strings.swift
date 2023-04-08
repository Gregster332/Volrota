// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings {
  public enum Auth {
    /// Отмена
    public static let cancel = Strings.tr("Localizable", "auth.cancel", fallback: "Отмена")
    /// Создать
    public static let create = Strings.tr("Localizable", "auth.create", fallback: "Создать")
    /// Создать аккаунт?
    public static let createAccount = Strings.tr("Localizable", "auth.createAccount", fallback: "Создать аккаунт?")
    /// Почтовый адрес
    public static let emailAddress = Strings.tr("Localizable", "auth.emailAddress", fallback: "Почтовый адрес")
    /// Почтовый адрес...
    public static let emailAddressPlaceholder = Strings.tr("Localizable", "auth.emailAddressPlaceholder", fallback: "Почтовый адрес...")
    /// Еще пару секунд...
    public static let fewSeconds = Strings.tr("Localizable", "auth.fewSeconds", fallback: "Еще пару секунд...")
    /// Похоже, что такого пользователя не существует
    public static let noSuchUser = Strings.tr("Localizable", "auth.noSuchUser", fallback: "Похоже, что такого пользователя не существует")
    /// Пароль
    public static let password = Strings.tr("Localizable", "auth.password", fallback: "Пароль")
    /// Пароль...
    public static let passwordPlaceholder = Strings.tr("Localizable", "auth.passwordPlaceholder", fallback: "Пароль...")
    /// Войдите или зарегистрируйтесь через почту и пароль
    public static let prompt = Strings.tr("Localizable", "auth.prompt", fallback: "Войдите или зарегистрируйтесь через почту и пароль")
    /// Войти
    public static let signIn = Strings.tr("Localizable", "auth.signIn", fallback: "Войти")
  }
  public enum Main {
    /// Актуальное
    public static let actualsSectionTitle = Strings.tr("Localizable", "main.actualsSectionTitle", fallback: "Актуальное")
    /// Мероприятия
    public static let eventsSectionTitle = Strings.tr("Localizable", "main.eventsSectionTitle", fallback: "Мероприятия")
    /// Локация выключена
    public static let locationUnavailable = Strings.tr("Localizable", "main.locationUnavailable", fallback: "Локация выключена")
    /// Localizable.strings
    ///   Volrota
    /// 
    ///   Created by Greg Zenkov on 3/21/23.
    public static let mainTitle = Strings.tr("Localizable", "main.mainTitle", fallback: "Главная")
    /// См. все
    public static let seeAll = Strings.tr("Localizable", "main.seeAll", fallback: "См. все")
  }
  public enum Onboarding {
    /// Продолжить
    public static let `continue` = Strings.tr("Localizable", "onboarding.continue", fallback: "Продолжить")
    /// Включите уведомления, чтобы быть вкурсе последних новостей. Так же можно изменить в настройках
    public static let title = Strings.tr("Localizable", "onboarding.title", fallback: "Включите уведомления, чтобы быть вкурсе последних новостей. Так же можно изменить в настройках")
  }
  public enum Profile {
    /// Редактировать профиль
    public static let editProfile = Strings.tr("Localizable", "profile.editProfile", fallback: "Редактировать профиль")
    /// События
    public static let events = Strings.tr("Localizable", "profile.events", fallback: "События")
    /// Выйти
    public static let signOut = Strings.tr("Localizable", "profile.signOut", fallback: "Выйти")
  }
  public enum Settings {
    /// О нас
    public static let about = Strings.tr("Localizable", "settings.about", fallback: "О нас")
    /// Внешний вид
    public static let appearance = Strings.tr("Localizable", "settings.appearance", fallback: "Внешний вид")
    /// Настройки приложения
    public static let appSettings = Strings.tr("Localizable", "settings.appSettings", fallback: "Настройки приложения")
    /// Уведомления
    public static let notifications = Strings.tr("Localizable", "settings.notifications", fallback: "Уведомления")
    /// Профиль
    public static let profile = Strings.tr("Localizable", "settings.profile", fallback: "Профиль")
    /// Безопасность
    public static let security = Strings.tr("Localizable", "settings.security", fallback: "Безопасность")
  }
  public enum SignUp {
    /// Почта
    public static let email = Strings.tr("Localizable", "signUp.email", fallback: "Почта")
    /// Почта...
    public static let emailPlaceholder = Strings.tr("Localizable", "signUp.emailPlaceholder", fallback: "Почта...")
    /// Имя
    public static let name = Strings.tr("Localizable", "signUp.name", fallback: "Имя")
    /// Имя...
    public static let namePlaceholder = Strings.tr("Localizable", "signUp.namePlaceholder", fallback: "Имя...")
    /// Регистрация
    public static let navTitle = Strings.tr("Localizable", "signUp.navTitle", fallback: "Регистрация")
    /// Организация
    public static let organization = Strings.tr("Localizable", "signUp.organization", fallback: "Организация")
    /// Пароль
    public static let password = Strings.tr("Localizable", "signUp.password", fallback: "Пароль")
    /// Пароль...
    public static let passwordPlaceholder = Strings.tr("Localizable", "signUp.passwordPlaceholder", fallback: "Пароль...")
    /// Фамилия
    public static let secondName = Strings.tr("Localizable", "signUp.secondName", fallback: "Фамилия")
    /// Фамилия...
    public static let secondNamePlaceholder = Strings.tr("Localizable", "signUp.secondNamePlaceholder", fallback: "Фамилия...")
    /// Зарегистрироваться
    public static let signUp = Strings.tr("Localizable", "signUp.signUp", fallback: "Зарегистрироваться")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
