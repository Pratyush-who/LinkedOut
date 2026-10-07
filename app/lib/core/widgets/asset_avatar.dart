import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class AssetAvatar extends StatelessWidget {
  final String symbol;
  final String? iconUrl;
  final double size;

  const AssetAvatar({
    super.key,
    required this.symbol,
    this.iconUrl,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (iconUrl != null && iconUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.network(
          iconUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _fallbackAvatar(),
        ),
      );
    }
    return _fallbackAvatar();
  }

  Widget _fallbackAvatar() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryLight.withOpacity(0.3), width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        symbol.length > 3 ? symbol.substring(0, 3).toUpperCase() : symbol.toUpperCase(),
        style: GoogleFonts.sora(
          fontSize: size * 0.32,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryLight,
        ),
      ),
    );
  }
}
