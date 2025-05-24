import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grip/extensions/extension_util/context_extensions.dart';
import 'package:grip/extensions/extension_util/int_extensions.dart';
import 'package:grip/extensions/text_styles.dart';
import 'package:grip/utils/app_images.dart';
import '../../components/body_part_component.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/loader_widget.dart';
import '../../extensions/widgets.dart';
import '../components/adMob_component.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../main.dart';
import '../models/body_part_response.dart';
import '../network/rest_api.dart';

class ViewBodyPartScreen extends StatefulWidget {
  @override
  _ViewBodyPartScreenState createState() => _ViewBodyPartScreenState();
}

class _ViewBodyPartScreenState extends State<ViewBodyPartScreen> {
  ScrollController scrollController = ScrollController();

  List<BodyPartModel> bodyPartList = [];

  int page = 1;
  int? numPage;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((val) {
      init();
      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
          if (page < numPage!) {
            page++;
            init();
          }
        }
      });
    });
  }

  void init() {
    getBodyPartData();
  }

  Future<void> getBodyPartData() async {
    appStore.setLoading(true);
    await getBodyPartApi(page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        bodyPartList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => bodyPartList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    }).whenComplete(() {
      if (page < numPage!) {
        if(page==1){
          page++;
          getBodyPartData();
        }

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(languages.lblBodyPartExercise, elevation: 0, context: context),
        body: Stack(
          children: [
            bodyPartList.isNotEmpty? SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(bottom: 16, top: 20, right: 16, left: 16),
              child:LayoutBuilder(
                builder: (context, constraints) {
                  double spacing = constraints.maxWidth > 600 ? 15 : 15;
                  return AnimatedWrap(
                    runSpacing: spacing,
                    spacing: spacing,
                    children: List.generate(
                      bodyPartList.length,
                          (index) {
                        return BodyPartComponent(
                            bodyPartModel: bodyPartList[index],
                            isGrid: true
                        );
                      },
                    ),
                  );
                },
              )
            ):Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(no_data_found, height: context.height() * 0.2, width: context.width() * 0.4),
                16.height,
                Text(languages.lblNoFoundData, style: boldTextStyle()),
              ],
            ).center(),
            Observer(builder: (context) {
              return Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Loader().center()).visible(appStore.isLoading);
            })
          ],
        ),
        bottomNavigationBar: userStore.adsBannerDetailShowBannerOnBodyPart == 1 && userStore.isSubscribe == 0 ? showBannerAds(context) : SizedBox());
  }
}
