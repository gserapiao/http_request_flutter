import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'user_details_tela.dart';
import '../models/user_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  void _searchUser() async {
    final id = int.tryParse(_controller.text);
    if (id == null || id < 1 || id > 12) {
      _showError('Digite um ID entre 1 e 12!');
      return;
    }

    setState(() => _isLoading = true);
    final user = await ApiService.fetchUser(id);
    setState(() => _isLoading = false);

    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UserDetailsScreen(user: user)),
      );
    } else {
      _showError('Usuário não encontrado!');
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Buscar Usuário', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Insira um ID (1 a 12)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ID do usuário',
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              onPressed: _searchUser,
              icon: const Icon(Icons.search),
              label: const Text('Buscar'),
            )
          ],
        ),
      ),
    );
  }
}
