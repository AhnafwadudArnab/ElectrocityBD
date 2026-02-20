import 'package:flutter/material.dart';


// 2️⃣ Kitchen Appliances
class KitchenAppliancesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kitchen Appliances (কিচেন অ্যাপ্লায়েন্সেস)')),
      body: Center(
        child: Text('Kitchen Appliances Content'),
      ), // Add Bengali if needed
    );
  }
}

// 3️⃣ Personal Care & Lifestyle
class PersonalCareLifestylePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Care & Lifestyle (ব্যক্তিগত যত্ন)')),
      body: Center(
        child: Text('Personal Care & Lifestyle Content'),
      ), // Add Bengali if needed
    );
  }
}

// 4️⃣ Home Comfort & Utility
class HomeComfortUtilityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Comfort & Utility (গৃহস্থালি প্রয়োজনীয় জিনিস)'),
      ),
      body: Center(
        child: Text('Home Comfort & Utility Content'),
      ), // Add Bengali if needed
    );
  }
}
