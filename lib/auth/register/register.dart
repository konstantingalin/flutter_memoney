import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordlController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  Future<void> singUp() async {
    try {
      await supabase.auth.signUp(
        password: passwordlController.text.trim(),
        email: emailController.text.trim(),
        data: {'username': usernameController.text.trim()},
      );

      if (!mounted) return;

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyApp(),
          ));
    } on AuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_auth_img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  width: 91,
                  height: 86,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    const Text(
                      "Имя",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller: usernameController,
                      autofocus: false,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Иван Иванов",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(0, 255, 255, 255)
                            .withOpacity(0.16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            20, 14, 20, 14),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Электронная почта",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller: emailController,
                      autofocus: false,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Email",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(0, 255, 255, 255)
                            .withOpacity(0.16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            20, 14, 20, 14),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Пароль",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller: passwordlController,
                      autofocus: false,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "*********",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(0, 255, 255, 255)
                            .withOpacity(0.16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            20, 14, 20, 14),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF4C82D), Color(0xFFFFF61E)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          minimumSize: const Size(double.infinity, 56),
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          'Зарегистрироваться'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 16 * 0.04,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "У меня уже есть аккаунт",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
