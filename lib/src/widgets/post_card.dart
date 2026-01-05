import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moto_tracking_flutter/src/theme/app_theme.dart';

class PostCard extends StatelessWidget {
  final String authorName;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;

  const PostCard({
    super.key,
    required this.authorName,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x11000000)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, 6),
            color: Color(0x0A000000),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primary.withOpacity(0.15),
                    child: Text(
                      authorName.isNotEmpty ? authorName.characters.first.toUpperCase() : 'M',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      authorName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              ),
            ),
            if (content.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(content),
              ),
            if (imageUrl != null) ...[
              const SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 16 / 10,
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: const Color(0xFFF3F3F3)),
                  errorWidget: (_, __, ___) => Container(
                    color: const Color(0xFFF3F3F3),
                    child: const Center(child: Icon(Icons.broken_image_outlined)),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  _Pill(icon: Icons.thumb_up_outlined, label: likes.toString()),
                  const SizedBox(width: 8),
                  _Pill(icon: Icons.mode_comment_outlined, label: comments.toString()),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.share_outlined),
                    tooltip: 'Compartilhar',
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

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}
