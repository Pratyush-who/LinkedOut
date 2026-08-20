import 'package:flutter/material.dart';
import 'package:linkedout/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: Text(
          'N',
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Evening,',
                style: GoogleFonts.inter(fontSize: 16, color: AppColors.grey),
              ),
              Text(
                'Pratyush.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('For You', true),
                    _buildCategoryChip('India', false),
                    _buildCategoryChip('World', false),
                    _buildCategoryChip('Business', false),
                    _buildCategoryChip('Tech', false),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'TOP STORY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Global AI Summit changes regulation across Europe.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    '7 min read',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const CircleAvatar(
                    radius: 3,
                    backgroundColor: AppColors.lightGrey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'World',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.greenLight, // Custom green tint
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Dummy Image for top story
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&q=80&w=800',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.black,
        unselectedItemColor: AppColors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Categories',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.greenLight : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.black : AppColors.grey,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
