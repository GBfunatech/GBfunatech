// Import necessary Flutter and Firebase packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase core for initialization
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore for database operations

// Import pages for navigation and routing within the app
import 'pages/plans_page.dart';
import 'pages/my_account_page.dart';
import 'pages/synchronize_data_page.dart';
import 'pages/storage_page.dart';
import 'pages/users_page.dart';
import 'pages/vehicles_user_page.dart';
import 'pages/vehicles_detail_page.dart';
import 'pages/fuel_list_page.dart';
import 'pages/gas_station_page.dart';
import 'pages/places_page.dart';
import 'pages/type_of_expense_page.dart';
import 'pages/type_of_income_page.dart';
import 'pages/type_of_service_page.dart';
import 'pages/payment_methods_page.dart';
import 'pages/reasons_page.dart';
import 'pages/forms_page.dart';
import 'pages/where_to_refuel_page.dart';
import 'pages/my_places_page.dart';
import 'pages/flex_calculator_page.dart';  // Correctly formatted import statement
import 'pages/achievements_page.dart';
import 'pages/settings_page.dart';
import 'pages/translation_page.dart';
import 'pages/contact_page.dart';
import 'pages/about_page.dart';
import 'pages/history_page.dart';
import 'pages/reports_page.dart';
import 'pages/reminders_page.dart';
import 'pages/more_page.dart';
import 'pages/widgets/bottom_nav_bar.dart'; // Custom widget for bottom navigation bar

// The main entry point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter bindings are initialized
  await Firebase.initializeApp(); // Initializes Firebase before running the app
  runApp(MyApp()); // Runs the app
}

// Define the main application widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Tracker', // Sets the app title
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define the primary color theme
      ),
      home: MainPage(), // Set the initial home page to MainPage
      routes: { // Define named routes for navigation
        '/plans': (context) => PlansPage(),
        '/my-account': (context) => MyAccountPage(),
        '/synchronize-data': (context) => SynchronizeDataPage(),
        '/storage': (context) => StoragePage(),
        '/users': (context) => UsersPage(),
        '/vehicles': (context) => VehiclesDetailPage(),
        '/vehicles-use': (context) => VehiclesUserPage(),
        '/fuel': (context) => FuelListPage(),
        '/gas-stations': (context) => GasStationsPage(),
        '/places': (context) => PlacesPage(),
        '/types-of-service': (context) => TypeOfServicePage(),
        '/type-of-expense': (context) => TypeOfExpensePage(),
        '/type-of-income': (context) => TypeOfIncomePage(),
        '/payment-methods': (context) => PaymentMethodsPage(),
        '/reasons': (context) => ReasonsPage(),
        '/forms': (context) => FormsPage(),
        '/where-to-refuel': (context) => WhereToRefuelPage(),
        '/my-places': (context) => MyPlacesPage(),
        '/flex-calculator': (context) => FlexCalculatorPage(),
        '/achievements': (context) => AchievementsPage(),
        '/settings': (context) => SettingsPage(),
        '/translation': (context) => TranslationPage(),
        '/contact': (context) => ContactPage(),
        '/about': (context) => AboutPage(),
        '/history': (context) => HistoryPage(),
        '/reports': (context) => ReportsPage(),
        '/reminders': (context) => RemindersPage(),
        '/more': (context) => MorePage(),
      },
    );
  }

  // Empty class declarations to avoid errors if not implemented elsewhere
  VehiclesDetailPage() {}
  TypeOfServicePage() {}
  TypeOfExpensePage() {}
  TypeOfIncomePage() {}
  VehiclesUserPage() {}
}

// Define the main page of the application with a stateful widget
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

// State class for MainPage to handle navigation and state changes
class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // Track the selected index for the bottom navigation bar

  // List of pages to navigate between using the bottom navigation bar
  static List<Widget> _pages = <Widget>[
    HistoryPage(), // Initial page
    ReportsPage(),
    RemindersPage(),
    MorePage(),
    FuelListPage(), // Add FuelListPage to the navigation
  ];

  // Handler for changing the selected index on navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Tracker'), // Set the title of the app bar
      ),
      body: _pages[_selectedIndex], // Display the page at the selected index
      bottomNavigationBar: BottomNavBar( // Display the custom bottom navigation bar
        selectedIndex: _selectedIndex, // Pass the current selected index
        onItemTapped: _onItemTapped, // Pass the tap handler to change the page
      ),
    );
  }
}
