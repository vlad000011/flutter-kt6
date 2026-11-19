# Firebase Auth App

Учебное Flutter-приложение с авторизацией через Firebase Authentication по email и паролю.

## Возможности

- Гостевой режим: пользователь может открыть приложение без регистрации.
- Открытый раздел доступен всем.
- Личный раздел заблокирован для гостей и доступен после входа.
- Регистрация нового пользователя по email и паролю.
- Вход в существующий аккаунт.
- Выход из аккаунта.
- Состояние авторизации отслеживается через `authStateChanges()`.

## Требования

- Flutter SDK
- Аккаунт Google и проект в Firebase Console
- FlutterFire CLI

## Настройка Firebase

1. Создайте проект в [Firebase Console](https://console.firebase.google.com/).
2. Откройте **Authentication → Sign-in method**.
3. Включите провайдер **Email/Password** и сохраните изменения.
4. Установите FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
5. Установите Firebase CLI, если он ещё не установлен, и войдите:
   ```bash
   firebase login
   ```
6. В корне проекта выполните:
   ```bash
   flutterfire configure
   ```
   Выберите созданный Firebase-проект и нужные платформы. Команда создаст `lib/firebase_options.dart` и платформенную конфигурацию.
7. В `lib/main.dart` замените:
   ```dart
   await Firebase.initializeApp();
   ```
   на:
   ```dart
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```
   и добавьте импорт:
   ```dart
   import 'firebase_options.dart';
   ```
8. Установите зависимости и запустите:
   ```bash
   flutter pub get
   flutter run
   ```

> Важно: приложение не будет подключаться к вашему Firebase-проекту, пока вы не выполните настройку Firebase для своих платформ. Файл `firebase_options.dart` намеренно не включён в репозиторий, поскольку он генерируется для конкретного Firebase-проекта.

## Запуск на macOS

```bash
cd firebase_auth_app
flutter create --project-name firebase_auth_app .
flutter pub get
dart pub global activate flutterfire_cli
firebase login
flutterfire configure
flutter run
```

После `flutterfire configure` выполните изменение `Firebase.initializeApp`, описанное выше.

## Проверка

1. Запустите приложение — откроется гостевой режим.
2. Откройте «Личный раздел»: приложение сообщит, что нужна авторизация.
3. Нажмите «Войти / зарегистрироваться».
4. Создайте аккаунт с email и паролем (не менее 6 символов).
5. После успешной регистрации откроется главный экран в авторизованном состоянии.
6. Откройте «Личный раздел» — доступ теперь разрешён.
7. Нажмите кнопку выхода — приложение вернётся в гостевой режим.

## Структура

```text
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   └── sign_in_screen.dart
└── services/
    └── auth_service.dart
```
