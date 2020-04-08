import 'package:corona_stats/utils/theme.dart';
import 'package:corona_stats/widgets/all_list_page.dart';
import 'package:corona_stats/widgets/favorite_page.dart';
import 'package:corona_stats/widgets/info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'blocs/covid19/covid19_bloc.dart';
import 'blocs/covid19/covid19_event.dart';
import 'blocs/covid19/covid19_state.dart';
import 'blocs/favorites/fav_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = await HydratedBlocDelegate.build();
  final myApp = MyApp();
  runApp(myApp);
  WidgetsBinding.instance.addObserver(myApp);
}

Covid19Bloc covid19Bloc;
FavBloc favBloc;

class MyApp extends StatefulWidget with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      covid19Bloc.add(Covid19NeedsUpdateEvent());
    }
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final List<Tab> myTabs = <Tab>[
    Tab(icon: Icon(Icons.star), text: 'Bookmarked'),
    Tab(icon: Icon(Icons.language), text: 'All countries'),
    Tab(icon: Icon(Icons.info_outline), text: 'Information'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<Covid19Bloc>(
          create: ((BuildContext context) {
            if (covid19Bloc == null) {
              covid19Bloc = Covid19Bloc();
            }
            return covid19Bloc;
          }),
        ),
        BlocProvider<FavBloc>(
          create: ((BuildContext context) {
            if (favBloc == null) {
              favBloc = FavBloc();
            }
            return favBloc;
          }),
        ),
      ],
      child: MaterialApp(
        title: 'Corona Virus Numbers',
        theme: ThemeData(
          primarySwatch: Covid19Theme.colorCustom,
        ),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                controller: _tabController,
                tabs: myTabs,
              ),
              title: AppTitleWidget(title: 'Corona Virus Numbers 1'),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                FavoritePage(
                  goToAllListCallback: () {
                    _tabController.animateTo(1);
                  },
                ),
                AllListPage(),
                InfoPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppTitleWidget extends StatelessWidget {
  final String title;
  AppTitleWidget({this.title});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = new DateFormat('d MMMM yyyy hh:mm');

    return BlocBuilder<Covid19Bloc, Covid19State>(
      bloc: BlocProvider.of<Covid19Bloc>(context),
      builder: (context, covid19State) {
        List<Widget> widgets = [
          Text(
            this.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w200,
              fontStyle: FontStyle.italic,
              fontFamily: 'Open Sans',
              fontSize: 25,
            ),
          ),
        ];

        if (covid19State is Covid19HasDataState) {
          widgets.add(
            Text(
              'Last updated: ${dateFormatter.format(covid19State.lastUpdateTime)}',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w200,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
                fontSize: 12,
              ),
            ),
          );
        }
        return Column(
          children: widgets,
        );
      },
    );
  }
}
