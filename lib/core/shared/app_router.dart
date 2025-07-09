

import 'package:auto_route/auto_route.dart';

import '../../presentation/pages/absence_list_page.dart';
part 'app_router.gr.dart';
 

@AutoRouterConfig()
class AppRouter extends RootStackRouter{
  @override
  final List<AutoRoute> routes = [
    
    AutoRoute(page: AbsenceListRoute.page, initial: true),
   
    
  ];
}