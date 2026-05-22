import 'package:bank_app/modules/history_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bank_app/common/app_color.dart';
import '../../../common/cart_widget.dart';
import '../../../common/images_resources.dart';
import '../../../data/fake_datas.dart';
import '../../../utils/number_format.dart';
import '../../../common/card_action.dart';
import '../../../common/transaction_list.dart';
import '../../card_detail.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  List<TabModel> get tabElements => [
    TabModel(devise: 'USD', amount: 24092.67, flag: ImagesResources.usa),
    TabModel(devise: 'EUR', amount: 7805.91, flag: ImagesResources.eur),
    TabModel(devise: 'CNY', amount: 3693.70, flag: ImagesResources.china),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabElements.length, vsync: this);

    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  String _getCurrencySymbol(String devise) {
    switch (devise) {
      case 'EUR':
        return '€';
      case 'CNY':
        return '¥';
      default:
        return '\$';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: _buildTabBar(),
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.noir,
        title: SearchBar(
          constraints: const BoxConstraints(minHeight: 33.0, maxHeight: 33.0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 8.0),
          ),
          backgroundColor: const WidgetStatePropertyAll(Colors.white12),
          hintText: 'Search',
          hintStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 14, color: Colors.white60),
          ),

          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 14, color: Colors.white),
          ),

          leading: SvgPicture.asset(
            ImagesResources.search,
            height: 20,
            colorFilter: ColorFilter.mode(
              AppColor.blanc.withAlpha(50),
              BlendMode.srcIn,
            ),
          ),
        ),

        actions: [
          IconButton(
            onPressed: null,
            icon: SvgPicture.asset(
              ImagesResources.chat,
              colorFilter: const ColorFilter.mode(
                AppColor.blanc,
                BlendMode.srcIn,
              ),
              height: 18,
            ),
          ),
          IconButton(
            onPressed: null,
            icon: SvgPicture.asset(
              ImagesResources.bell,
              colorFilter: const ColorFilter.mode(
                AppColor.blanc,
                BlendMode.srcIn,
              ),
              height: 18,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentGeometry.topCenter,
                    end: AlignmentGeometry.bottomCenter,
                    colors: [
                      AppColor.noir,
                      AppColor.bleuSombre,
                      const Color.fromARGB(
                        255,
                        7,
                        5,
                        79,
                      ).withValues(alpha: 0.65),
                      const Color(0xFFA6F2F4).withValues(alpha: 0.40),
                    ],
                    stops: const [0.2, 0.5, 0.8, 1.0],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_getCurrencySymbol(tabElements[_currentIndex].devise)}${formatDouble(tabElements[_currentIndex].amount)}",
                        style: const TextStyle(
                          fontSize: 42,
                          color: AppColor.blanc,
                        ),
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        height: 30,
                        child: ListView.separated(
                          itemCount: fakeCardsList.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final card = fakeCardsList[index];
                            if (index == fakeCardsList.length - 1) {
                              return SizedBox(
                                height: double.infinity,
                                width: 30,
                                child: FilledButton.icon(
                                  onPressed: () {},
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.white24,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                  ),
                                  label: const Icon(Icons.add_rounded),
                                ),
                              );
                            }
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CardDetail(card: card),
                                  ),
                                );
                              },
                              child: CartWidget(
                                color: index == fakeCardsList.length - 1
                                    ? AppColor.blanc
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsetsGeometry.symmetric(
                          vertical: 20,
                          horizontal: 7,
                        ),
                        child: SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: actionCard.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 15),
                            itemBuilder: (context, index) {
                              final action = actionCard[index];

                              return CardActions(
                                title: action.title,
                                image: action.image,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: AppColor.blanc,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Transactions",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF1D3557),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const HistoryTransaction(),
                                ),
                              );
                            },
                            child: const Text(
                              "View all",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF8D99AE),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: fakeCardsList.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final carte = fakeCardsList[index];

                          return TransactionList(card: carte);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // child: TabBarView(
        //   controller: _tabController,
        //   children: [Text('Step 1'), Text('Step 2'), Text('Step 3')],
        // ),
      ),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white54,
      indicatorColor: Colors.white,
      dividerColor: Colors.black,
      indicatorWeight: 3.0,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      tabs: tabElements.map((tab) {
        return Tab(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 4,
              children: [
                Image.asset(
                  tab.flag,
                  width: 25,
                  height: 25,
                  fit: BoxFit.contain,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: [
                      Text(
                        tab.devise,
                        style: const TextStyle(fontSize: 10, height: 1.2),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          formatDouble(tab.amount),
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TabModel {
  final String devise;
  final double amount;
  final String flag;

  TabModel({required this.devise, required this.amount, required this.flag});
}
