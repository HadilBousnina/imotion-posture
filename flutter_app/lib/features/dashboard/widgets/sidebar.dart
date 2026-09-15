import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import 'sidebar_item.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;

  const Sidebar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        border: Border(
          right: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // =========================
          // LOGO
          // =========================
          Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              36,
              24,
              32,
            ),

            child: SizedBox(
              height: 80,
              width: double.infinity,

              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),



          // =========================
          // MENU
          // =========================
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: Column(
              children: [

                SidebarItem(
                  icon: Icons.home_outlined,
                  title: "Accueil",
                  selected: selectedIndex == 0,

                  onTap: () {
                    context.go('/dashboard');
                  },
                ),


                const SizedBox(height: 14),


                SidebarItem(
                  icon: Icons.people_outline,
                  title: "Adhérents",
                  selected: selectedIndex == 1,

                  onTap: () {
                    context.go('/adherents');
                  },
                ),


                const SizedBox(height: 14),


                SidebarItem(
                  icon: Icons.bar_chart_outlined,
                  title: "Analyse",
                  selected: selectedIndex == 2,

                  onTap: () {
                    context.go('/analyse');
                  },
                ),


                const SizedBox(height: 14),


                SidebarItem(
                  icon: Icons.access_time_outlined,
                  title: "Historique",
                  selected: selectedIndex == 3,

                  onTap: () {
                    context.go('/historique');
                  },
                ),

              ],
            ),
          ),



          // =========================
          // ESPACE
          // =========================
          Expanded(
            child: Container(),
          ),



          // =========================
          // LOGOUT
          // =========================
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              0,
              20,
              28,
            ),

            child: SidebarItem(

              icon: Icons.power_settings_new,

              title: "Déconnexion",

              selected: false,

              color: Colors.redAccent,

              onTap: () {
                context.go('/login');
              },
            ),
          ),
        ],
      ),
    );
  }
}