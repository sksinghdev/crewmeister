import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui';
import '../../core/shared/injection_container.dart';
import '../cubit/absence_cubit.dart';
import '../widgets/absence_card.dart';

@RoutePage()
class AbsenceListPage extends StatelessWidget {
  const AbsenceListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AbsenceCubit>()..loadAbsences(),
      child: AbsenceListView(),
    );
  }
}

class AbsenceListView extends StatelessWidget {
  AbsenceListView({super.key});

  final ValueNotifier<String?> selectedType = ValueNotifier(null);
  final ValueNotifier<DateTimeRange?> selectedDateRange = ValueNotifier(null);
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> showScrollToTop = ValueNotifier(false);

  void _onScroll(BuildContext context) {
    final cubit = context.read<AbsenceCubit>();

    // FAB visibility
    if (scrollController.offset > 300 && !showScrollToTop.value) {
      showScrollToTop.value = true;
    } else if (scrollController.offset <= 300 && showScrollToTop.value) {
      showScrollToTop.value = false;
    }

    // Load more when near bottom
    if (cubit.hasMore &&
        scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 &&
        !(cubit.state is AbsenceLoading)) {
      Future.delayed(const Duration(seconds: 2), () {
        cubit.loadMore(
          typeFilter: selectedType.value,
          dateFilter: selectedDateRange.value,
        );
      });
    }
  }

  void _refresh(BuildContext context) {
    context.read<AbsenceCubit>().refresh(
          typeFilter: selectedType.value,
          dateFilter: selectedDateRange.value,
        );
  }

  void _showFilterDialog(BuildContext context) async {
    String? tempType = selectedType.value;
    DateTimeRange? tempDate = selectedDateRange.value;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Filter Absences'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: tempType,
              isExpanded: true,
              hint: const Text("Select type"),
              items: ["sickness", "vacation"].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (val) => tempType = val,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text("Select Date Range"),
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) tempDate = picked;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Clear"),
            onPressed: () {
              selectedType.value = null;
              selectedDateRange.value = null;
              Navigator.pop(context);
              _refresh(context);
            },
          ),
          TextButton(
            child: const Text("Apply"),
            onPressed: () {
              selectedType.value = tempType;
              selectedDateRange.value = tempDate;
              Navigator.pop(context);
              _refresh(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() => _onScroll(context));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<AbsenceCubit, AbsenceState>(
        builder: (context, state) {
          if (state is AbsenceLoading && state.isFirstFetch) {
            return _buildShimmerList();
          }

          if (state is AbsenceError) {
            return _buildErrorState(state.message, context);
          }

          if (state is AbsenceEmpty) {
            return _buildEmptyState();
          }

          if (state is AbsenceLoaded || state is AbsenceLoading) {
            final absences = state is AbsenceLoaded
                ? state.absences
                : (state as AbsenceLoading).absences;
            final hasMore = context.read<AbsenceCubit>().hasMore;

            return Stack(

              children: [
                Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.0,
            colors: [
              Color(0xFF9E9E9E), // Pink spot
              Color(0xFFF9F9FB), // Light pink background
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(color: Colors.transparent),
        ),
      ),
                SafeArea(
                  child: RefreshIndicator(
                        onRefresh: () async => _refresh(context),
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverList(
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
                                    return const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    );
                                  }
                  
                                  return AbsenceCard(absence: absences[index]);
                                },
                                childCount: absences.length + 1,
                              ),
                            ),
                            const SliverToBoxAdapter(child: SizedBox(height: 5)), // Bottom space
                          ],
                        ),
                      ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.white, radius: 20),
            title: Container(height: 12, color: Colors.white),
            subtitle: Container(height: 10, margin: const EdgeInsets.only(top: 8), color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _refresh(context),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('No absences found', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
