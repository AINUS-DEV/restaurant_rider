import 'package:flutter/material.dart';
import 'package:restaurant_rider/localization/language_constrants.dart';
import 'package:restaurant_rider/provider/location_provider.dart';
import 'package:restaurant_rider/provider/order_provider.dart';
import 'package:restaurant_rider/provider/profile_provider.dart';
import 'package:restaurant_rider/utill/color_resources.dart';
import 'package:restaurant_rider/utill/dimensions.dart';
import 'package:restaurant_rider/view/screens/home/widget/order_widget.dart';
import 'package:restaurant_rider/view/screens/language/choose_language_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false).getAllOrders(context);
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    Provider.of<LocationProvider>(context, listen: false).getUserLocation();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leadingWidth: 0,
        actions: [
          Consumer<OrderProvider>(
            builder: (context, orderProvider, child) => orderProvider.currentOrders.length > 0
                ? SizedBox.shrink()
                : IconButton(
                    icon: Icon(Icons.refresh, color: Theme.of(context).textTheme.bodyText1.color),
                    onPressed: () {
                      orderProvider.refresh(context);
                    }),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'language':
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChooseLanguageScreen(fromHomeScreen: true)));
              }
            },
            icon: Icon(
              Icons.more_vert_outlined,
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'language',
                child: Row(
                  children: [
                    Icon(Icons.language, color: Theme.of(context).textTheme.bodyText1.color),
                    SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                    Text(
                      getTranslated('change_language', context),
                      style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
        leading: SizedBox.shrink(),
        title: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => profileProvider.userInfoModel != null
              ? Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          profileProvider.userInfoModel.image,
                          width: 40,
                          height: 40,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      profileProvider.userInfoModel.fName != null
                          ? '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}'
                          : "",
                      style:
                          Theme.of(context).textTheme.headline3.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).textTheme.bodyText1.color),
                    )
                  ],
                )
              : SizedBox.shrink(),
        ),
      ),
      body: Consumer<OrderProvider>(
          builder: (context, orderProvider, child) => Padding(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getTranslated('active_order', context),
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor)),
                    SizedBox(height: 10),
                    Expanded(

                      child: RefreshIndicator(
                        child: orderProvider.currentOrders != null
                            ? orderProvider.currentOrders.length != 0
                                ? ListView.builder(
                                    itemCount: orderProvider.currentOrders.length,
                                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                    itemBuilder: (context, index) => OrderWidget(
                                      orderModel: orderProvider.currentOrders[index],
                                      index: index,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      getTranslated('no_order_found', context),
                                      style: Theme.of(context).textTheme.headline3,
                                    ),
                                  )
                            : SizedBox.shrink(),
                        key: _refreshIndicatorKey,
                        displacement: 0,
                        color: ColorResources.COLOR_WHITE,
                        backgroundColor: Theme.of(context).primaryColor,
                        onRefresh: () {
                          return orderProvider.refresh(context);
                        },
                      ),
                    ),
                  ],
                ),
          ),
      ),
    );
  }
}
