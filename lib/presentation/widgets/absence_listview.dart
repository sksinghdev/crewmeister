import 'package:crewmeister/presentation/widgets/absence_sliver_list.dart';
import 'package:crewmeister/presentation/widgets/error_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui';
import '../../core/utils/absence_sliver_app_bar.dart';
import '../../core/utils/filter_dialog.dart';
import '../cubit/absence_cubit.dart';

class AbsenceListView extends StatelessWidget {
  AbsenceListView({super.key});

  final ValueNotifier<String?> selectedType = ValueNotifier(null);
  final ValueNotifier<DateTimeRange?> selectedDateRange = ValueNotifier(null);
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> isFetchingMore = ValueNotifier(false);

  bool _onScroll(BuildContext context) {
    final cubit = context.read<AbsenceCubit>();

    if (!isFetchingMore.value &&
        cubit.hasMore &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        cubit.state is! AbsenceLoading) {
      isFetchingMore.value = true;

      Future.delayed(const Duration(seconds: 2), () {
        cubit.loadMore(
          typeFilter: selectedType.value,
          dateFilter: selectedDateRange.value,
        );
        isFetchingMore.value = false;
      });
    }

    return false;
  }

  void _refresh(BuildContext context) {
    context.read<AbsenceCubit>().refresh(
          typeFilter: selectedType.value,
          dateFilter: selectedDateRange.value,
        );
  }

  void _showFilterDialog(BuildContext context) {
    String? tempType = selectedType.value;
    DateTimeRange? tempDate = selectedDateRange.value;

    FilterDialog.show(
      context: context,
      initialType: selectedType.value,
      initialDateRange: selectedDateRange.value,
      onTypeChanged: (val) {
        tempType = val;
      },
      onDateChanged: (val) {
        if (val != null) tempDate = val;
      },
      onClear: () {
        selectedType.value = null;
        selectedDateRange.value = null;
        _refresh(context);
      },
      onApply: () {
        selectedType.value = tempType;
        selectedDateRange.value = tempDate;
        _refresh(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AbsenceCubit, AbsenceState>(
  listener: (context, state) {
    if (state is AbsenceExporting) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exporting iCal...')),
      );
    } else if (state is AbsenceExportSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('iCal file shared successfully!')),
      );
    } else if (state is AbsenceExportFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: BlocBuilder<AbsenceCubit, AbsenceState>(
      
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
            final totalCount = state is AbsenceLoaded ? state.totalAbsence : 0;
            final hasMore = context.read<AbsenceCubit>().hasMore;

            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topLeft,
                      radius: 1.0,
                      colors: [
                        Color(0xFF9E9E9E),
                        Color(0xFFF9F9FB),
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
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) =>
                          _onScroll(context),
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          AbsenceSliverAppBar(
                            totalCount: totalCount,
                            onFilterPressed: () => _showFilterDialog(context),
                            onExportPressed: () {
                              context
                                  .read<AbsenceCubit>()
                                  .exportAbsencesToICal(absences);
                            },
                          ),
                          AbsenceSliverList(
                            absences: absences,
                            hasMore: hasMore,
                            isFetchingMore: isFetchingMore,
                            onCardPressed: (absence) {},
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 5)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
)

      
      
      
      
      
      
      
      ,
    );
  }

  Widget _buildShimmerList() {
    return const Center(
      child: SpinKitSpinningLines(color: Colors.blue, size: 50),
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return ErrorStateWidget(
      message: message,
      onRetry: () => _refresh(context),
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
