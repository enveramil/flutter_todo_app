import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/screens/add_new_task.dart';
import 'package:todo_app/services/notification_services.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/utility/themes.dart';
import 'package:todo_app/widgets/SideNavBar.dart';
import 'package:todo_app/widgets/button.dart';
import 'package:todo_app/widgets/task_tile.dart';

import '../services/google_admob_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color selectionColor = HexColor('6F217A');
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  var notifyHelper = NotifyHelper();
  BannerAd? _banner;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  int rewardedScore = 0;
  final Color buttonColor = HexColor('6F217A');
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];

  @override
  void initState() {
    super.initState();

    _taskController.getTasks();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _createBannerAd();
    _createInterstitialAd();
    _createRewardedAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //notifyHelper.initializeNotification();
    disposeAds();
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createInterstitialAd();
      });
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  void disposeAds() {
    _banner?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }

  _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createRewardedAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createRewardedAd();
      }, onAdWillDismissFullScreenContent: (closeAd) {
        closeAd.dispose();
        closeAd.printError(info: 'error');
        _createRewardedAd();
      }, onAdShowedFullScreenContent: (ad) {
        ad.dispose();
        _createRewardedAd();
      });
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        setState(() {
          rewardedScore++;
        });
      });
      _rewardedAd = null;
    }
  }

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: GoogleAdMobServices.rewardedAdUnitId!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          setState(() {
            _rewardedAd = null;
          });
        },
      ),
    );
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: GoogleAdMobServices.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null,
      ),
    );
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: GoogleAdMobServices.bannerAdUnitId!,
      listener: GoogleAdMobServices.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNavBar(),
      bottomNavigationBar: _banner == null
          ? Container()
          : Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 52,
              child: AdWidget(
                ad: _banner!,
              ),
            ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10),
          _displayAllTasks(),
        ],
      ),
    );
  }

  _displayAllTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: (_, index) {
          //print(_taskController.taskList.length);

          Task task = _taskController.taskList[index];

          if (task.repeat == 'Her gün' && task.isCompleted == 0 || task.isCompleted == 1) {
            var id = task.id!;
            notifyHelper.disposeNotificationService(id);

            if (task.isCompleted == 0) {
              DateTime date = DateFormat?.jm('tr').parse(task.endTime.toString());
              var inputEndTime = DateFormat("HH:mm").format(date);

              notifyHelper.scheduledNotification(
                int.parse(inputEndTime.toString().split(":")[0]),
                int.parse(inputEndTime.toString().split(":")[1]),
                task,
              );
            }

            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showBottomSheet(context, task);
                        },
                        child: TaskTile(task),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          if (task.date == DateFormat?.yMd('tr').format(_selectedDate) && task.isCompleted == 0 ||
              task.isCompleted == 1) {
            var id = task.id!;
            notifyHelper.disposeNotificationService(id);

            if (task.date == DateFormat?.yMd('tr').format(_selectedDate) && task.isCompleted == 0) {
              DateTime date = DateFormat?.jm('tr').parse(task.endTime.toString());
              var inputEndTime = DateFormat("HH:mm").format(date);

              notifyHelper.scheduledNotification(
                int.parse(inputEndTime.toString().split(":")[0]),
                int.parse(inputEndTime.toString().split(":")[1]),
                task,
              );
            }

            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showBottomSheet(context, task);
                        },
                        child: TaskTile(task),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      );
    }));
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
          padding: EdgeInsets.only(top: 4),
          height: task.isCompleted == 1
              ? MediaQuery.of(context).size.height * 0.24
              : MediaQuery.of(context).size.height * 0.32,
          color: Get.isDarkMode ? darkGreyColor : Colors.white,
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey,
                ),
              ),
              //Spacer(),
              task.isCompleted == 1
                  ? Container()
                  : _bottomSheetButton(
                      label: 'Görev Tamamlandı',
                      onPressed: () {
                        setState(() {
                          var selectedId = task.id!;
                          _showInterstitialAd();
                          _taskController.isTaskCompleted(selectedId);
                          print(selectedId);
                          notifyHelper.disposeNotificationService(selectedId);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              '!!!  Harika Görevini Tamamladın  !!!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Get.isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            duration: Duration(seconds: 10),
                            backgroundColor: Colors.grey,
                          ));
                          Get.back();
                        });
                      },
                      color: primaryColor,
                      context: context),
              _bottomSheetButton(
                  label: 'Görevi Sil',
                  onPressed: () {
                    var selectedId = task.id!;
                    _taskController.delete(task);
                    notifyHelper.disposeNotificationService(selectedId);

                    Get.back();
                  },
                  color: Colors.red,
                  context: context),
              SizedBox(height: 20),
              _bottomSheetButton(
                  label: 'Pencereyi Kapat',
                  onPressed: () {
                    Get.back();
                  },
                  color: Colors.red,
                  isClose: true,
                  context: context),
              SizedBox(
                height: 10,
              )
            ],
          )),
    );
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onPressed,
      required Color color,
      bool isClose = false,
      required BuildContext context}) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          height: 55,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: isClose == true ? Colors.red : color),
            borderRadius: BorderRadius.circular(20),
            color: isClose == true ? Colors.transparent : color,
          ),
          child: Center(
            child: Text(
              label,
              style: isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Container _addDateBar() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: selectionColor,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle:
              TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle:
              TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
        locale: 'tr_TR',
      ),
    );
  }

  Container _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat?.yMMMMd('tr').format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Bugün",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
            label: 'Görev Ekle',
            onTap: () async {
              //_showRewardedAd();
              _showInterstitialAd();
              await Get.to(() => const AddNewTask());
              _taskController.getTasks();
            },
            addTaskButtonColor: Get.isDarkMode ? buttonColor : buttonColor,
          )
        ],
      ),
    );
  }

  List<String> menuBar = ['Tamamlanan Görevler', 'Devam eden görevler'];

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                ThemeService().switchTheme();
              },
              child: Icon(
                Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                size: 20,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: CircleAvatar(
            backgroundImage: AssetImage("images/user.png"),
            backgroundColor: Get.isDarkMode ? Colors.white : Colors.white,
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
