import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return HomeContent(user: snapshot.data);
      },
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key, required this.user});

  final User? user;

  bool get isAuthorized => user != null;

  Future<void> _openAuth(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await AuthService.signOut();
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Не удалось выйти из аккаунта')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          if (isAuthorized)
            IconButton(
              tooltip: 'Выйти',
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isAuthorized ? Icons.verified_user : Icons.person_outline,
                    size: 36,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isAuthorized ? 'Вы авторизованы' : 'Гостевой режим',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isAuthorized
                        ? 'Аккаунт: ${user!.email ?? 'email не указан'}'
                        : 'Основные возможности доступны без аккаунта. '
                            'Войдите или зарегистрируйтесь, чтобы открыть '
                            'закрытый раздел.',
                  ),
                  const SizedBox(height: 16),
                  if (!isAuthorized)
                    FilledButton.icon(
                      onPressed: () => _openAuth(context),
                      icon: const Icon(Icons.login),
                      label: const Text('Войти / зарегистрироваться'),
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.logout),
                      label: const Text('Выйти из аккаунта'),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.public),
              title: const Text('Открытый раздел'),
              subtitle: const Text('Доступен всем, включая гостей'),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
              onTap: () => showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Открытый раздел'),
                  content: const Text(
                    'Этот раздел доступен любому пользователю без авторизации.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Понятно'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.lock,
                color: isAuthorized
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              title: const Text('Личный раздел'),
              subtitle: Text(
                isAuthorized
                    ? 'Полный доступ открыт'
                    : 'Доступен только после авторизации',
              ),
              trailing: Icon(
                isAuthorized ? Icons.arrow_forward_ios : Icons.lock_outline,
              ),
              onTap: () {
                if (!isAuthorized) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Войдите в аккаунт, чтобы открыть раздел'),
                    ),
                  );
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AccountScreen(user: user!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Личный раздел')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_circle, size: 76),
              const SizedBox(height: 16),
              Text(
                'Добро пожаловать!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(user.email ?? 'Пользователь Firebase'),
              const SizedBox(height: 16),
              const Text(
                'Это закрытый функционал. Он отображается только '
                'авторизованным пользователям.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
