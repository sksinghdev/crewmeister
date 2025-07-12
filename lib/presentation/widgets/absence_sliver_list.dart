import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../domain/entities/absence.dart';
import 'absence_card.dart'; // make sure this imports the card correctly

class AbsenceSliverList extends StatelessWidget {
  final List<Absence> absences;
  final bool hasMore;
  final ValueNotifier<bool> isFetchingMore;
  final void Function(Absence absence)? onCardPressed;

  const AbsenceSliverList({
    Key? key,
    required this.absences,
    required this.hasMore,
    required this.isFetchingMore,
    this.onCardPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= absences.length) {
            if (!hasMore) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    "No more data",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            return ValueListenableBuilder<bool>(
              valueListenable: isFetchingMore,
              builder: (context, fetching, _) {
                if (fetching) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: SpinKitWave(
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          }

          final absence = absences[index];
          return GestureDetector(
            onTap: () => onCardPressed?.call(absence),
            child: AbsenceCard(absence: absence),
          );
        },
        childCount: absences.length + 1,
      ),
    );
  }
}
