import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
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
      child: const AbsenceListView(),
    );
  }
}

class AbsenceListView extends StatefulWidget {
  const AbsenceListView({super.key});

  @override
  State<AbsenceListView> createState() => _AbsenceListViewState();
}

class _AbsenceListViewState extends State<AbsenceListView> {
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<String?> selectedType = ValueNotifier(null);
  final ValueNotifier<DateTimeRange?> selectedDateRange = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<AbsenceCubit>();
    if (cubit.hasMore &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
      cubit.loadAbsences(
        typeFilter: selectedType.value,
        dateFilter: selectedDateRange.value,
      );
    }
  }

  void _refresh() {
    context.read<AbsenceCubit>().loadAbsences(
          refresh: true,
          typeFilter: selectedType.value,
          dateFilter: selectedDateRange.value,
        );
  }

  void _showFilterDialog(BuildContext context) async {
    String? tempType = selectedType.value;
    DateTimeRange? tempDate = selectedDateRange.value;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Absences'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: tempType,
              hint: const Text("Select type"),
              isExpanded: true,
              items: ["sickness", "vacation"].map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
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
            )
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Clear"),
            onPressed: () {
              selectedType.value = null;
              selectedDateRange.value = null;
              Navigator.pop(context);
              _refresh();
            },
          ),
          TextButton(
            child: const Text("Apply"),
            onPressed: () {
              selectedType.value = tempType;
              selectedDateRange.value = tempDate;
              Navigator.pop(context);
              _refresh();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AbsenceError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                  const SizedBox(height: 12),
                  Text(state.message, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (state is AbsenceEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No absences found', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }

          if (state is AbsenceLoaded || state is AbsenceLoading) {
            final absences = state is AbsenceLoaded
                ? state.absences
                : (state as AbsenceLoading).absences;
            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: ListView.builder(
                controller: scrollController,
                itemCount: absences.length + (state is AbsenceLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= absences.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final a = absences[index];
                  return AbsenceCard(absence: a);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
