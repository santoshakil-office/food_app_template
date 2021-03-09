import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../values/values.dart';
import '../widgets/custom_icon.dart';
import '../widgets/rounded_button.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key key}) : super(key: key);

  void _goBack() {
    ExtendedNavigator.root.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue200,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            CustomIcon(name: 'shopping_cart_alt'),
            SizedBox(height: Sizes.SIZE_8),
            Text(
              StringConst.NO_ORDERS_YET,
              style: Theme.of(context).textTheme.headline4.copyWith(
                    fontFamily: StringConst.SF_PRO_TEXT,
                    fontSize: Sizes.TEXT_SIZE_28,
                    color: Colors.black,
                  ),
            ),
            SizedBox(height: Sizes.SIZE_20),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.SIZE_80,
              ),
              child: Text(
                StringConst.CREATE_ORDER_INST,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontFamily: StringConst.SF_PRO_TEXT,
                      fontSize: Sizes.TEXT_SIZE_17,
                      color: AppColors.gray400,
                    ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(
                bottom: Theme.of(context).platform == TargetPlatform.android
                    ? Sizes.SIZE_20
                    : Sizes.SIZE_0,
              ),
              child: RoundedButton(
                width: MediaQuery.of(context).size.width / 2,
                height: Sizes.SIZE_60,
                onPressed: _goBack,
                label: StringConst.START_ORDERING,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.blue200,
      brightness: Brightness.light,
      leading: IconButton(
        onPressed: _goBack,
        icon: Icon(
          Icons.keyboard_arrow_left,
          color: Colors.black,
        ),
      ),
      title: Text(
        StringConst.ORDERS,
        style: Theme.of(context).textTheme.headline4.copyWith(
              fontFamily: StringConst.SF_PRO_TEXT,
              fontSize: Sizes.TEXT_SIZE_18,
              color: Colors.black,
            ),
      ),
      centerTitle: true,
    );
  }
}
