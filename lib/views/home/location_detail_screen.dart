import 'package:flutter/material.dart';
import 'package:learnvocabulary/view_models/location_view_model.dart';
import 'package:provider/provider.dart';
import '../../models/location.dart';
import '../../models/vocabulary.dart';
import '../../view_models/vocabulary_view_model.dart';
import '../../constants/app_colors.dart';

class LocationDetailScreen extends StatefulWidget {
  final Location location;
  const LocationDetailScreen({super.key, required this.location});

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  late VocabularyViewModel vm;
  late String _locationName;

  @override
  void initState() {
    super.initState();
    vm = VocabularyViewModel();
    vm.fetchVocabularies(widget.location.id);
    _locationName = widget.location.name; // Khởi tạo tên
  }
  void _showEditLocationDialog() {
    final nameController = TextEditingController(text: _locationName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sửa địa điểm'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Tên địa điểm'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryColor),
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty && newName != _locationName) {
                final updatedLocation = Location(
                  id: widget.location.id,
                  name: newName,
                );
                final locationVM = Provider.of<LocationViewModel>(context, listen: false);
                await locationVM.updateLocation(updatedLocation);

                setState(() {
                  _locationName = newName; // Cập nhật hiển thị
                });

                Navigator.pop(context);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteLocation() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn xóa địa điểm này cùng toàn bộ từ vựng không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );

    if (shouldDelete ?? false) {
      // Xóa toàn bộ vocabularies trước
      for (final vocab in vm.vocabularies) {
        await vm.deleteVocabulary(vocab.id);
      }

      // TODO: Gọi ViewModel để xóa Location nếu có
      final locationVM = Provider.of<LocationViewModel>(context, listen: false);
      await locationVM.deleteLocation(widget.location.id);
      Navigator.pop(context); // Quay lại màn hình trước
    }
  }

  void _confirmDeleteVocabulary(String vocabId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn xóa từ vựng này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );

    if (shouldDelete ?? false) {
      vm.deleteVocabulary(vocabId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            _locationName,
            style: const TextStyle(
              color: AppColors.textColor,
              fontFamily: 'JacquesFrancois',
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _showEditLocationDialog,
              tooltip: 'Sửa địa điểm',
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: _confirmDeleteLocation,
              tooltip: 'Xóa địa điểm',
            ),
          ],
        ),
        body: Consumer<VocabularyViewModel>(
          builder: (context, vm, _) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: vm.vocabularies.length,
              itemBuilder: (context, index) {
                final vocab = vm.vocabularies[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(vocab.toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditDialog(vocab),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDeleteVocabulary(vocab.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.secondaryColor,
          child: const Icon(Icons.add),
          onPressed: _showAddDialog,
        ),
      ),
    );
  }

  void _showAddDialog() {
    final wordController = TextEditingController();
    final meaningController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Thêm từ mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: wordController, decoration: const InputDecoration(labelText: 'Từ vựng')),
            TextField(controller: meaningController, decoration: const InputDecoration(labelText: 'Nghĩa')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryColor),
            onPressed: () async {
              final word = wordController.text.trim();
              final meaning = meaningController.text.trim();
              if (word.isNotEmpty && meaning.isNotEmpty) {
                final vocab = Vocabulary(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  word: word,
                  meaning: meaning,
                  idLocation: widget.location.id,
                );
                await vm.addVocabulary(vocab);
                Navigator.pop(context);
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Vocabulary vocab) {
    final wordController = TextEditingController(text: vocab.word);
    final meaningController = TextEditingController(text: vocab.meaning);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sửa từ vựng'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: wordController, decoration: const InputDecoration(labelText: 'Từ vựng')),
            TextField(controller: meaningController, decoration: const InputDecoration(labelText: 'Nghĩa')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryColor),
            onPressed: () async {
              final word = wordController.text.trim();
              final meaning = meaningController.text.trim();
              if (word.isNotEmpty && meaning.isNotEmpty) {
                final updatedVocab = Vocabulary(
                  id: vocab.id,
                  word: word,
                  meaning: meaning,
                  idLocation: vocab.idLocation,
                );
                await vm.updateVocabulary(updatedVocab);
                Navigator.pop(context);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }



}
