import 'package:flutter/material.dart';
import 'package:app_film/thema/app_colors.dart';
import 'package:app_film/screens/profile_screen.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onLogout; // Função para passar o logout

  const CustomDrawer({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 290,
      backgroundColor: Colors.black,
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.blackColor),
            child: Center(
              child: Icon(Icons.movie_filter_outlined, size: 94, color: AppColors.accent),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.book, color: AppColors.thirdColor),
            title: const Text(' Meu Perfil ', style: TextStyle(color: AppColors.thirdColor)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.thirdColor),
            title: const Text('LogOut', style: TextStyle(color: AppColors.thirdColor)),
            onTap: onLogout,
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text("Versão 1.0.0", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
