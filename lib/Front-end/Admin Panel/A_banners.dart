import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:electrocitybd1/config/app_config.dart';

import '../Provider/Banner_provider.dart';
import '../pages/home_page.dart';
import '../utils/api_service.dart';
import '../utils/constants.dart';
import 'A_Help.dart';
import 'A_Reports.dart';
import 'A_Settings.dart';
import 'A_carts.dart';
import 'A_deals.dart';
import 'A_discounts.dart';
import 'A_flash_sales.dart';
import 'A_orders.dart';
import 'A_products.dart';
import 'A_promotions.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';
import 'A_payments.dart';

class AdminBannersPage extends StatefulWidget {
  final bool embedded;

  const AdminBannersPage({super.key, this.embedded = false});

  @override
  State<AdminBannersPage> createState() => _AdminBannersPageState();
}

class _AdminBannersPageState extends State<AdminBannersPage> {
  File? _pickedHeroImageFile;
  bool _uploading = false;
  
  Future<void> _pickHeroImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pickedHeroImageFile = File(result.files.single.path!);
        _uploading = true;
      });
      try {
        // Use dynamic API base URL from ApiService
        final url = Uri.parse(ApiService.getUploadUrl());
        final request = http.MultipartRequest('POST', url);
        request.files.add(
          await http.MultipartFile.fromPath('image', result.files.single.path!),
        );
        final response = await request.send();
        if (response.statusCode == 200) {
          final respStr = await response.stream.bytesToString();
          String? imgUrl;
          try {
            final map = Map<String, dynamic>.from(jsonDecode(respStr) as Map);
            final u = map['url']?.toString();
            if (u != null && u.isNotEmpty) {
              imgUrl = u;
            }
          } catch (_) {
            imgUrl = RegExp(
              r'"url"\s*:\s*"([^"]+)"',
            ).firstMatch(respStr)?.group(1);
          }
          if (imgUrl != null) {
            setState(() {
              _heroImageController.text = imgUrl!;
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Image uploaded successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Upload failed: ${response.statusCode}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() {
          _uploading = false;
        });
      }
    }
  }

  Future<void> _pickMidImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _midUploading = true;
      });
      try {
        final url = Uri.parse(ApiService.getUploadUrl());
        final request = http.MultipartRequest('POST', url);
        request.files.add(
          await http.MultipartFile.fromPath('image', result.files.single.path!),
        );
        final response = await request.send();
        if (response.statusCode == 200) {
          final respStr = await response.stream.bytesToString();
          String? imgUrl;
          try {
            final map = Map<String, dynamic>.from(jsonDecode(respStr) as Map);
            final u = map['url']?.toString();
            if (u != null && u.isNotEmpty) {
              imgUrl = u;
            }
          } catch (_) {
            imgUrl = RegExp(
              r'"url"\s*:\s*"([^"]+)"',
            ).firstMatch(respStr)?.group(1);
          }
          if (imgUrl != null) {
            setState(() {
              _midImageController.text = imgUrl!;
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mid banner image uploaded!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Upload failed: ${response.statusCode}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() {
          _midUploading = false;
        });
      }
    }
  }

  final Color darkBg = const Color(0xFF0B121E);
  final Color cardBg = const Color(0xFF151C2C);
  final Color brandOrange = const Color(0xFFF59E0B);

  final TextEditingController _heroImageController = TextEditingController();
  final TextEditingController _heroLabelController = TextEditingController();
  final TextEditingController _midImageController = TextEditingController();
  final List<TextEditingController> _midControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final TextEditingController _sidebarTitleController = TextEditingController();
  final TextEditingController _sidebarSubtitleController =
      TextEditingController();
  final TextEditingController _sidebarButtonController =
      TextEditingController();

  int? _editingHeroIndex;
  int? _midEditingIndex;
  bool _heroFormVisible = false;
  bool _midFormVisible = false;
  bool _syncedFromProvider = false;
  bool _midUploading = false;

  @override
  void initState() {
    super.initState();
    // Ensure BannerProvider is loaded
    Future.microtask(() => context.read<BannerProvider>().load());
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncFromProvider());
  }

  void _ensureSyncedFromProvider(BannerProvider bp) {
    if (!bp.loaded || _syncedFromProvider) return;
    _syncedFromProvider = true;
    _midControllers[0].text = bp.midBanners.isNotEmpty
        ? (bp.midBanners[0]['img'] ?? '')
        : '';
    if (bp.midBanners.length > 1) {
      _midControllers[1].text = bp.midBanners[1]['img'] ?? '';
    }
    if (bp.midBanners.length > 2) {
      _midControllers[2].text = bp.midBanners[2]['img'] ?? '';
    }
    _sidebarTitleController.text = bp.sidebarTitle;
    _sidebarSubtitleController.text = bp.sidebarSubtitle;
    _sidebarButtonController.text = bp.sidebarButtonText;
    if (mounted) setState(() {});
  }

  void _syncFromProvider() {
    final bp = context.read<BannerProvider>();
    if (!bp.loaded) return;
    _syncedFromProvider = true;
    _midControllers[0].text = bp.midBanners.isNotEmpty
        ? (bp.midBanners[0]['img'] ?? '')
        : '';
    if (bp.midBanners.length > 1) {
      _midControllers[1].text = bp.midBanners[1]['img'] ?? '';
    }
    if (bp.midBanners.length > 2) {
      _midControllers[2].text = bp.midBanners[2]['img'] ?? '';
    }
    _sidebarTitleController.text = bp.sidebarTitle;
    _sidebarSubtitleController.text = bp.sidebarSubtitle;
    _sidebarButtonController.text = bp.sidebarButtonText;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _heroImageController.dispose();
    _heroLabelController.dispose();
    _midImageController.dispose();
    for (final c in _midControllers) {
      c.dispose();
    }
    _sidebarTitleController.dispose();
    _sidebarSubtitleController.dispose();
    _sidebarButtonController.dispose();
    super.dispose();
  }

  void _navigate(BuildContext context, AdminSidebarItem item) {
    if (item == AdminSidebarItem.banners) return;
    if (item == AdminSidebarItem.viewStore) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
      return;
    }
    Widget page;
    switch (item) {
      case AdminSidebarItem.dashboard:
        page = const AdminDashboardPage(embedded: true);
        break;
      case AdminSidebarItem.orders:
        page = const AdminOrdersPage(embedded: true);
        break;
      case AdminSidebarItem.products:
        page = const AdminProductUploadPage(embedded: true);
        break;
      case AdminSidebarItem.payments:
        page = const AdminPaymentsPage(embedded: true);
        break;
      case AdminSidebarItem.carts:
        page = const AdminCartsPage(embedded: true);
        break;
      case AdminSidebarItem.reports:
        page = const AdminReportsPage(embedded: true);
        break;
      case AdminSidebarItem.discounts:
        page = const AdminDiscountPage(embedded: true);
        break;
      case AdminSidebarItem.deals:
        page = const AdminDealsPage(embedded: true);
        break;
      case AdminSidebarItem.flashSales:
        page = const AdminFlashSalesPage(embedded: true);
        break;
      case AdminSidebarItem.promotions:
        page = const AdminPromotionsPage(embedded: true);
        break;
      case AdminSidebarItem.help:
        page = const AdminHelpPage(embedded: true);
        break;
      case AdminSidebarItem.settings:
        page = const AdminSettingsPage(embedded: true);
        break;
      default:
        return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(),
                const SizedBox(height: 28),
                _buildMidSection(),
                const SizedBox(height: 28),
                _buildSidebarPromoSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() => Container(
    height: 70,
    width: double.infinity,
    color: cardBg,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: const Text(
      "Management / Banners",
      style: TextStyle(color: Colors.white54, fontSize: 14),
    ),
  );

  Widget _buildHeroSection() {
    return Consumer<BannerProvider>(
      builder: (context, bp, _) {
        final slides = bp.heroSlides;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hero Banners (Home page carousel)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _heroFormVisible = true;
                        _editingHeroIndex = null;
                        _heroImageController.clear();
                        _heroLabelController.clear();
                        _pickedHeroImageFile = null;
                      });
                    },
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text("Add slide"),
                    style: TextButton.styleFrom(foregroundColor: brandOrange),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_heroFormVisible || _editingHeroIndex != null) ...[
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _heroImageController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Image path or pick file',
                              labelStyle: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              suffixIcon: _uploading
                                  ? const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.folder_open,
                                        color: Colors.white,
                                      ),
                                      onPressed: _pickHeroImage,
                                      tooltip: 'Pick image from computer',
                                    ),
                            ),
                          ),
                          if (_heroImageController.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: 60,
                                child: Builder(
                                  builder: (context) {
                                    final path = _heroImageController.text;
                                    if (path.startsWith('http') ||
                                        path.startsWith('/uploads/')) {
                                      return Image.network(
                                        path.startsWith('/uploads/')
                                            ? AppConfig.uploadPath(path)
                                            : path,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                              Icons.broken_image,
                                              color: Colors.red,
                                            ),
                                      );
                                    } else {
                                      try {
                                        if (path.isEmpty)
                                          return const SizedBox();
                                        return Image.file(
                                          File(path),
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(
                                                Icons.broken_image,
                                                color: Colors.red,
                                              ),
                                        );
                                      } catch (e) {
                                        return Text(
                                          'Invalid image: $e',
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _heroLabelController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Label',
                          labelStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        final img = _heroImageController.text.trim();
                        final label = _heroLabelController.text.trim();
                        if (img.isEmpty) return;
                        final newSlides = List<Map<String, String>>.from(
                          slides,
                        );
                        final entry = {
                          'image': img,
                          'label': label.isEmpty ? 'OFFER' : label,
                        };
                        if (_editingHeroIndex != null) {
                          newSlides[_editingHeroIndex!] = entry;
                        } else {
                          newSlides.add(entry);
                        }
                        await bp.saveHero(newSlides);
                        setState(() {
                          _heroFormVisible = false;
                          _editingHeroIndex = null;
                          _heroImageController.clear();
                          _heroLabelController.clear();
                          _pickedHeroImageFile = null;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => setState(() {
                        _heroFormVisible = false;
                        _editingHeroIndex = null;
                        _heroImageController.clear();
                        _heroLabelController.clear();
                        _pickedHeroImageFile = null;
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              ...slides.asMap().entries.map((e) {
                final i = e.key;
                final s = e.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: darkBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${i + 1}.',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          s['image'] ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        s['label'] ?? '',
                        style: TextStyle(
                          color: brandOrange,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _editingHeroIndex = i;
                            _heroFormVisible = true;
                            _heroImageController.text = s['image'] ?? '';
                            _heroLabelController.text = s['label'] ?? '';
                            // Only set _pickedHeroImageFile if it's a local file
                            if ((s['image'] ?? '').isNotEmpty &&
                                !(s['image']!.startsWith('http') ||
                                    s['image']!.startsWith('/uploads/'))) {
                              _pickedHeroImageFile = File(s['image']!);
                            } else {
                              _pickedHeroImageFile = null;
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        onPressed: () async {
                          final newSlides = List<Map<String, String>>.from(
                            slides,
                          )..removeAt(i);
                          await bp.saveHero(newSlides);
                          if (_editingHeroIndex == i) {
                            setState(() {
                              _editingHeroIndex = null;
                              _heroImageController.clear();
                              _heroLabelController.clear();
                              _pickedHeroImageFile = null;
                            });
                          } else {
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
              if (slides.isEmpty && !_heroFormVisible)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "No hero slides. Click \"Add slide\" to add one.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMidSection() {
    return Consumer<BannerProvider>(
      builder: (context, bp, _) {
        if (bp.loaded && !_syncedFromProvider) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _ensureSyncedFromProvider(context.read<BannerProvider>());
            }
          });
        }
        
        final midBanners = bp.midBanners;
        
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mid Banners (3 banners below Flash Sale)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (midBanners.length < 3)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _midEditingIndex = midBanners.length;
                          _midFormVisible = true;
                          _midImageController.clear();
                        });
                      },
                      icon: const Icon(Icons.add, color: Colors.white, size: 18),
                      label: const Text("Add banner"),
                      style: TextButton.styleFrom(foregroundColor: brandOrange),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Add/Edit Form
              if (_midFormVisible || _midEditingIndex != null) ...[
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _midImageController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Image path or pick file',
                              labelStyle: TextStyle(color: Colors.grey.shade400),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade700),
                              ),
                              suffixIcon: _midUploading
                                  ? const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.folder_open, color: Colors.white),
                                      onPressed: () => _pickMidImage(),
                                      tooltip: 'Pick image from computer',
                                    ),
                            ),
                          ),
                          if (_midImageController.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: 60,
                                child: Builder(
                                  builder: (context) {
                                    final path = _midImageController.text;
                                    if (path.startsWith('http') || path.startsWith('/uploads/')) {
                                      return Image.network(
                                        path.startsWith('/uploads/')
                                            ? AppConfig.uploadPath(path)
                                            : path,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.broken_image, color: Colors.red),
                                      );
                                    } else if (path.startsWith('assets/')) {
                                      return Image.asset(
                                        path,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.broken_image, color: Colors.red),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        final img = _midImageController.text.trim();
                        if (img.isEmpty) return;
                        
                        final newBanners = List<Map<String, String>>.from(midBanners);
                        final entry = {'img': img};
                        
                        if (_midEditingIndex != null && _midEditingIndex! < newBanners.length) {
                          newBanners[_midEditingIndex!] = entry;
                        } else {
                          newBanners.add(entry);
                        }
                        
                        await bp.saveMid(newBanners);
                        setState(() {
                          _midFormVisible = false;
                          _midEditingIndex = null;
                          _midImageController.clear();
                        });
                        
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mid banner saved!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => setState(() {
                        _midFormVisible = false;
                        _midEditingIndex = null;
                        _midImageController.clear();
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              
              // List of existing mid banners
              ...midBanners.asMap().entries.map((e) {
                final i = e.key;
                final banner = e.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: darkBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${i + 1}.',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          banner['img'] ?? '',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: () {
                          setState(() {
                            _midEditingIndex = i;
                            _midFormVisible = true;
                            _midImageController.text = banner['img'] ?? '';
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        onPressed: () async {
                          final newBanners = List<Map<String, String>>.from(midBanners)
                            ..removeAt(i);
                          await bp.saveMid(newBanners);
                          if (_midEditingIndex == i) {
                            setState(() {
                              _midEditingIndex = null;
                              _midImageController.clear();
                            });
                          } else {
                            setState(() {});
                          }
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Mid banner deleted!'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
              
              if (midBanners.isEmpty && !_midFormVisible)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "No mid banners. Click \"Add banner\" to add one.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebarPromoSection() {
    return Consumer<BannerProvider>(
      builder: (context, bp, _) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sidebar Promo Card (Flash Sale card)",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _sidebarTitleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _sidebarSubtitleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Subtitle',
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _sidebarButtonController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Button text',
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await bp.saveSidebarPromo({
                    'title': _sidebarTitleController.text.trim().isEmpty
                        ? 'FLASH SALE'
                        : _sidebarTitleController.text.trim(),
                    'subtitle': _sidebarSubtitleController.text.trim().isEmpty
                        ? 'Up to 40% Off on Earbuds'
                        : _sidebarSubtitleController.text.trim(),
                    'buttonText': _sidebarButtonController.text.trim().isEmpty
                        ? 'VIEW ALL'
                        : _sidebarButtonController.text.trim(),
                  });
                  if (mounted) setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sidebar promo saved.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandOrange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Sidebar Promo'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return Container(color: darkBg, child: _buildContent());
    }
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.banners,
            onItemSelected: (item) => _navigate(context, item),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }
}
