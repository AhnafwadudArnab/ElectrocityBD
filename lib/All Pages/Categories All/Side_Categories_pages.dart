import 'package:flutter/material.dart';

// 2️⃣ Kitchen Appliances
class KitchenAppliancesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kitchen Appliances')),
      body: Center(child: Text('Kitchen Appliances Content')),
    );
  }
}

// 3️⃣ Personal Care & Lifestyle
class PersonalCareLifestylePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Care & Lifestyle')),
      body: Center(child: Text('Personal Care & Lifestyle Content')),
    );
  }
}

// 4️⃣ Home Comfort & Utility
class HomeComfortUtilityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Comfort & Utility'),
      ),
      body: Center(child: Text('Home Comfort & Utility Content')),
    );
  }
}
