import 'package:flutter/material.dart';

class PromotionsPage extends StatelessWidget {
  final String title;
  const PromotionsPage({Key? key, this.title = 'Promotions'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://picsum.photos/800/300?random=21',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Current Promotions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore our limited-time offers and best deals across categories. Tap any offer to view details.',
            style: TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 16),
          // simple list of promotional tiles
          ...List.generate(5, (i) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    'https://picsum.photos/80/80?random=${30 + i}',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text('Promo Item ${i + 1} - Up to 50% Off'),
                subtitle: const Text('Limited time offer'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // navigate to a basic details page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(title: Text('Promo Item ${i + 1}')),
                        body: Center(
                          child: Text('Details for Promo Item ${i + 1}'),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
