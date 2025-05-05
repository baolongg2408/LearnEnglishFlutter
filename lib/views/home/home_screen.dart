import 'package:flutter/material.dart';
import 'package:learnvocabulary/view_models/location_view_model.dart';
import 'package:learnvocabulary/views/quiz/location_list_quiz.dart';
import 'package:provider/provider.dart';
import '../quiz/quiz_screen.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../../constants/app_colors.dart';
import '../../models/location.dart';
import 'location_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Location> _locations = [];

  final List<Widget> _screens = [const HomeContent(), const LocationListForQuiz()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final locationVM = Provider.of<LocationViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Learn Vocabulary',
          style: TextStyle(
            color: AppColors.textColor,
            fontFamily: 'JacquesFrancois',
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Chọn địa điểm của bạn',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                    fontFamily: 'JacquesFrancois',
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/images/timi.png',
                    height: 150,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: locationVM.locations.length,
              itemBuilder: (context, index) {
                final location = locationVM.locations[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(location.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationDetailScreen(location: location),
                        ),
                      );
                    },

                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddLocationDialog(context, locationVM);
        },
      ),
    );
  }

  void _showAddLocationDialog(BuildContext context, LocationViewModel vm) {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm địa điểm mới'),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Nhập tên địa điểm',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
            ),
            onPressed: () async {
              final name = _controller.text.trim();
              if (name.isNotEmpty) {
                final newLocation = Location(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                );
                await vm.addLocation(newLocation);
              }
              Navigator.pop(context);
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }
}

