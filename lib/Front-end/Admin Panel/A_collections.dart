import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import 'Admin_sidebar.dart';
import 'admin_pages.dart';

class AdminCollectionsPage extends StatelessWidget {
  final bool embedded;

  const AdminCollectionsPage({super.key, this.embedded = false});

  static void _navigateFromSidebar(
    BuildContext context,
    AdminSidebarItem item,
  ) {
    if (item == AdminSidebarItem.collections) return;
    if (item == AdminSidebarItem.viewStore) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
      return;
    }
    final page = getAdminPage(item);
    if (page != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);

    if (embedded) {
      return Container(
        color: darkBg,
        child: const _CollectionsContent(),
      );
    }
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.collections,
            onItemSelected: (item) => _navigateFromSidebar(context, item),
          ),
          const Expanded(child: _CollectionsContent()),
        ],
      ),
    );
  }
}

class _CollectionsContent extends StatefulWidget {
  const _CollectionsContent();

  @override
  State<_CollectionsContent> createState() => _CollectionsContentState();
}
class _CollectionsContentState extends State<_CollectionsContent> {
  List<Map<String, dynamic>> _collections = [];
  bool _isLoading = true;
  String? _selectedCollectionId;

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    setState(() => _isLoading = true);
    
    // TODO: Load from database
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _collections = [
        {
          'id': '1',
          'name': 'Fans',
          'slug': 'fans',
          'icon': 'air',
          'items': ['Charger Fan', 'Mini Hand Fan'],
          'itemCount': 20,
          'isActive': true,
        },
        {
          'id': '2',
          'name': 'Cookers',
          'slug': 'cookers',
          'icon': 'kitchen',
          'items': ['Rice Cooker', 'Mini Cooker', 'Curry Cooker'],
          'itemCount': 46,
          'isActive': true,
        },
        {
          'id': '3',
          'name': 'Blenders',
          'slug': 'blenders',
          'icon': 'blender',
          'items': ['Hand Blender', 'Blender'],
          'itemCount': 38,
          'isActive': true,
        },
        {
          'id': '4',
          'name': 'Phone Related',
          'slug': 'phone-related',
          'icon': 'phone',
          'items': ['Telephone Set', 'Sim Telephone'],
          'itemCount': 14,
          'isActive': true,
        },
        {
          'id': '5',
          'name': 'Massager Items',
          'slug': 'massager-items',
          'icon': 'spa',
          'items': ['Massage Gun', 'Head Massage'],
          'itemCount': 18,
          'isActive': true,
        },
        {
          'id': '6',
          'name': 'Trimmer',
          'slug': 'trimmer',
          'icon': 'content_cut',
          'items': ['Trimmer'],
          'itemCount': 12,
          'isActive': true,
        },
        {
          'id': '7',
          'name': 'Electric Chula',
          'slug': 'electric-chula',
          'icon': 'electric_bolt',
          'items': ['Electric Chula'],
          'itemCount': 8,
          'isActive': true,
        },
        {
          'id': '8',
          'name': 'Iron',
          'slug': 'iron',
          'icon': 'iron',
          'items': ['Iron'],
          'itemCount': 15,
          'isActive': true,
        },
        {
          'id': '9',
          'name': 'Chopper',
          'slug': 'chopper',
          'icon': 'restaurant',
          'items': ['Chopper'],
          'itemCount': 10,
          'isActive': true,
        },
        {
          'id': '10',
          'name': 'Grinder',
          'slug': 'grinder',
          'icon': 'settings',
          'items': ['Grinder'],
          'itemCount': 9,
          'isActive': true,
        },
        {
          'id': '11',
          'name': 'Kettle',
          'slug': 'kettle',
          'icon': 'coffee_maker',
          'items': ['Kettle'],
          'itemCount': 11,
          'isActive': true,
        },
        {
          'id': '12',
          'name': 'Hair Dryer',
          'slug': 'hair-dryer',
          'icon': 'air',
          'items': ['Hair Dryer'],
          'itemCount': 7,
          'isActive': true,
        },
        {
          'id': '13',
          'name': 'Oven',
          'slug': 'oven',
          'icon': 'microwave',
          'items': ['Oven'],
          'itemCount': 6,
          'isActive': true,
        },
        {
          'id': '14',
          'name': 'Air Fryer',
          'slug': 'air-fryer',
          'icon': 'kitchen',
          'items': ['Air Fryer'],
          'itemCount': 13,
          'isActive': true,
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            // Left side - Collections list
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Collections',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: _showAddCollectionDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Collection'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Collections list
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _collections.length,
                              itemBuilder: (context, index) {
                                final collection = _collections[index];
                                final isSelected = _selectedCollectionId == collection['id'];
                                
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  color: isSelected ? Colors.red.shade50 : Colors.white,
                                  child: ListTile(
                                    leading: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.red : Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        _getIconData(collection['icon']),
                                        color: isSelected ? Colors.white : Colors.grey[600],
                                      ),
                                    ),
                                    title: Text(
                                      collection['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? Colors.red : Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${collection['itemCount']} items • ${(collection['items'] as List).length} categories',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Switch(
                                          value: collection['isActive'],
                                          onChanged: (value) {
                                            setState(() {
                                              collection['isActive'] = value;
                                            });
                                          },
                                          activeColor: Colors.green,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit, size: 20),
                                          onPressed: () => _showEditCollectionDialog(collection),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                          onPressed: () => _deleteCollection(collection['id']),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedCollectionId = collection['id'];
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Right side - Collection items detail
            Expanded(
              flex: 3,
              child: _selectedCollectionId == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.category_outlined, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'Select a collection to view items',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : _buildCollectionDetail(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionDetail() {
    final collection = _collections.firstWhere(
      (c) => c['id'] == _selectedCollectionId,
    );
    
    return Container(
      color: const Color(0xFFF7F8FA),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconData(collection['icon']),
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        collection['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Slug: ${collection['slug']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddItemDialog(collection),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Items list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: (collection['items'] as List).length,
              itemBuilder: (context, index) {
                final item = (collection['items'] as List)[index];
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.inventory_2_outlined, color: Colors.grey[600]),
                    ),
                    title: Text(
                      item,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Category item',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _showEditItemDialog(collection, item, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                          onPressed: () => _deleteItem(collection, index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'air':
        return Icons.air;
      case 'kitchen':
        return Icons.kitchen;
      case 'blender':
        return Icons.blender;
      case 'phone':
        return Icons.phone;
      case 'spa':
        return Icons.spa;
      case 'content_cut':
        return Icons.content_cut;
      case 'electric_bolt':
        return Icons.electric_bolt;
      case 'iron':
        return Icons.iron;
      case 'restaurant':
        return Icons.restaurant;
      case 'settings':
        return Icons.settings;
      case 'coffee_maker':
        return Icons.coffee_maker;
      case 'microwave':
        return Icons.microwave;
      default:
        return Icons.category;
    }
  }

  void _showAddCollectionDialog() {
    final nameController = TextEditingController();
    final slugController = TextEditingController();
    String selectedIcon = 'category';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Collection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Collection Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: slugController,
              decoration: const InputDecoration(
                labelText: 'Slug (e.g., fans, cookers)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Save to database
              setState(() {
                _collections.add({
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'name': nameController.text,
                  'slug': slugController.text,
                  'icon': selectedIcon,
                  'items': [],
                  'itemCount': 0,
                  'isActive': true,
                });
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditCollectionDialog(Map<String, dynamic> collection) {
    final nameController = TextEditingController(text: collection['name']);
    final slugController = TextEditingController(text: collection['slug']);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Collection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Collection Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: slugController,
              decoration: const InputDecoration(
                labelText: 'Slug',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Update in database
              setState(() {
                collection['name'] = nameController.text;
                collection['slug'] = slugController.text;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(Map<String, dynamic> collection) {
    final itemController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Item to ${collection['name']}'),
        content: TextField(
          controller: itemController,
          decoration: const InputDecoration(
            labelText: 'Item Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Save to database
              setState(() {
                (collection['items'] as List).add(itemController.text);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(Map<String, dynamic> collection, String item, int index) {
    final itemController = TextEditingController(text: item);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: TextField(
          controller: itemController,
          decoration: const InputDecoration(
            labelText: 'Item Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Update in database
              setState(() {
                (collection['items'] as List)[index] = itemController.text;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteCollection(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Collection'),
        content: const Text('Are you sure you want to delete this collection?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete from database
              setState(() {
                _collections.removeWhere((c) => c['id'] == id);
                if (_selectedCollectionId == id) {
                  _selectedCollectionId = null;
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(Map<String, dynamic> collection, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete from database
              setState(() {
                (collection['items'] as List).removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
