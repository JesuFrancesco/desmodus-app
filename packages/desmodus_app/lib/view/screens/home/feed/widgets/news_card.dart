import 'package:desmodus_app/model/entity/noticia.dart';
import 'package:flutter/material.dart';
import 'package:desmodus_app/view/ui/theme/fonts.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final VoidCallback onTap;

  const NoticiaCard({super.key, required this.noticia, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        noticia.noticiaArchivos.isNotEmpty
            ? noticia.noticiaArchivos.first.archivo.imageUrl
            : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image as background
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                image:
                    imageUrl != null
                        ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                        : null,
                color: Colors.grey[300],
              ),
              child:
                  imageUrl == null
                      ? const Center(
                        child: Icon(Icons.image, size: 48, color: Colors.grey),
                      )
                      : null,
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    noticia.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.primaryFont,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    noticia.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: AppFonts.primaryFont,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
