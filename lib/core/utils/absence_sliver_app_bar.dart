import 'package:flutter/material.dart';

class AbsenceSliverAppBar extends StatelessWidget {
  final int totalCount;
  final VoidCallback onFilterPressed;
  final VoidCallback onExportPressed;

  const AbsenceSliverAppBar({
    super.key,
    required this.totalCount,
    required this.onFilterPressed,
    required this.onExportPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 160,
      backgroundColor: Colors.white.withValues(alpha: 229),
      elevation: 4,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt, color: Colors.black),
          onPressed: onFilterPressed,
        ),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.black),
          onPressed: onExportPressed,
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double top = constraints.biggest.height;
          final bool isCollapsed = top <= kToolbarHeight + 20;

          return FlexibleSpaceBar(
            centerTitle: false,
            titlePadding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            title: isCollapsed
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Absences',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$totalCount',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Absences',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$totalCount',
                          style: const TextStyle(
                            fontSize: 32, // reduced from 36 to avoid overflow
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE3F2FD),
                    Color(0xFFFFFFFF),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
