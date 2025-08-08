import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:loja_free_style/common/custom_drawer/custom_drawer.dart';
import 'package:loja_free_style/models/admin_users_manager.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUsersManager, __) {
          final users = adminUsersManager.users;
          return AzListView(
            data: users,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name ?? ''),
                subtitle: Text(user.email),
              );
            },
            susItemBuilder: (context, index) {
              final tag = users[index].getSuspensionTag();
              return Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.grey[300],
                alignment: Alignment.centerLeft,
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            indexBarOptions: const IndexBarOptions(
              selectTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              selectItemDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
          );
        },
      ),
    );
  }
}
