import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:true_motors/used_vehicle_module/buy_car.dart';
import 'package:true_motors/used_vehicle_module/used_vehicle_detail_screen.dart';
import 'favourites_manager.dart';

class SavedVehiclesScreen extends StatefulWidget {
  const SavedVehiclesScreen({super.key});

  @override
  State<SavedVehiclesScreen> createState() => _SavedVehiclesScreenState();
}

class _SavedVehiclesScreenState extends State<SavedVehiclesScreen> {
  final FavoritesManager _manager = FavoritesManager.instance;

  @override
  void initState() {
    super.initState();
    _manager.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _manager.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final favorites = _manager.favorites;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: statusBarHeight,
              color: const Color(0xFF615C5C),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    _buildTopBar(context),
                    Expanded(
                      child: favorites.isEmpty
                          ? _buildEmptyState()
                          : _buildFavoritesList(favorites),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          // Back arrow → just Navigator.pop; AppDrawer's _pushAndReopenDrawer
          // awaits this push and re-opens the drawer automatically.
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back,
                size: 24, color: Color(0xFF01442D)),
          ),
          const SizedBox(width: 12),
          const Text(
            'Saved Vehicles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF01422D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No Saved Vehicles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Vehicles you like will appear here.\nTap the heart icon on any car to save it.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF8C8C8C)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<CarListing> favorites) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          for (int i = 0; i < favorites.length; i++) ...[
            CarListingCard(
              car: favorites[i],
              isFav: true,
              onFavToggle: () => _manager.toggle(favorites[i]),
              onViewDetails: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UsedVehicleDetailScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}