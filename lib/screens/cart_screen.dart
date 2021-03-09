import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/cart.dart';
import '../models/dish.dart';
import '../routes/router.gr.dart';
import '../values/values.dart';
import '../widgets/custom_icon.dart';
import '../widgets/info_card.dart';
import '../widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  void _goBack() {
    ExtendedNavigator.root.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue200,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.SIZE_30,
            vertical: Sizes.SIZE_16,
          ),
          child: _CartList(),
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
        StringConst.CART,
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

class _CartList extends StatelessWidget {
  const _CartList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<Cart>();

    return cart.items.length > 0
        ? _buildWhenCartIsNotEmpty(context, cart)
        : _buildWhenCartIsEmpty(context);
  }

  void _navigateToCheckoutPage(Cart cart) {
    ExtendedNavigator.root.push(
      Routes.checkoutScreen,
      arguments: CheckoutScreenArguments(
        cartItems: cart.items,
      ),
    );
  }

  Widget _buildWhenCartIsEmpty(BuildContext context) => Center(
        child: Column(
          children: [
            Spacer(),
            CustomIcon(
              name: 'shopping_cart_alt',
            ),
            SizedBox(height: Sizes.SIZE_20),
            Text(
              StringConst.EMPTY_CART,
              style: Theme.of(context).textTheme.headline4.copyWith(
                    fontFamily: StringConst.SF_PRO_TEXT,
                    fontSize: Sizes.TEXT_SIZE_28,
                    color: Colors.black,
                  ),
            ),
            Spacer(),
          ],
        ),
      );

  Widget _buildWhenCartIsNotEmpty(BuildContext context, Cart cart) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIcon(name: 'swipe'),
                SizedBox(width: Sizes.SIZE_6),
                Text(
                  StringConst.SWIPE_TO_DELETE,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontFamily: StringConst.SF_PRO_TEXT,
                        fontSize: Sizes.TEXT_SIZE_12,
                      ),
                ),
              ],
            ),
            SizedBox(height: Sizes.SIZE_20),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: Sizes.SIZE_16),
                  child: Slidable(
                    key: UniqueKey(),
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.2,
                    child: _CartItemCard(
                      item: cart.items[index],
                    ),
                    dismissal: SlidableDismissal(
                        child: SlidableDrawerDismissal(),
                        onDismissed: (actionType) {
                          var cart = context.read<Cart>();
                          cart.remove(index);
                        }),
                    secondaryActions: <Widget>[
                      SlideAction(
                        child: Container(
                          padding: const EdgeInsets.all(Sizes.SIZE_16),
                          decoration: BoxDecoration(
                            color: AppColors.red400,
                            borderRadius: BorderRadius.circular(Sizes.SIZE_30),
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) => SlideAction(
                          onTap: () {
                            Slidable.of(context).dismiss();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(Sizes.SIZE_20),
                            decoration: BoxDecoration(
                              color: AppColors.red400,
                              borderRadius:
                                  BorderRadius.circular(Sizes.SIZE_40),
                            ),
                            child: CustomIcon(
                              name: 'trash',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: Sizes.SIZE_20),
            child: RoundedButton(
              onPressed: () {
                _navigateToCheckoutPage(cart);
              },
              label: StringConst.COMPLETE_ORDER,
              width: MediaQuery.of(context).size.width - Sizes.SIZE_150,
              height: Sizes.SIZE_60,
            ),
          ),
        ),
      ],
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    Key key,
    @required this.item,
  }) : super(key: key);

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.SIZE_16),
        child: Row(
          children: [
            Transform.translate(
              offset: Offset(0.0, 8.0),
              child: Container(
                width: Sizes.SIZE_100,
                height: Sizes.SIZE_100,
                child: Image.asset(
                  '${item.dish.image}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${item.dish.name}'),
                  SizedBox(height: Sizes.SIZE_8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${toMoney(item.dish.price)}'),
                      QuantityButton(
                        quantity: item.quantity,
                        onChanged: (value) {
                          var cart = context.read<Cart>();
                          cart.updateQuanity(cart.items.indexOf(item), value);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuantityButton extends StatefulWidget {
  const QuantityButton({Key key, @required this.quantity, this.onChanged})
      : super(key: key);

  final int quantity;
  final void Function(int value) onChanged;

  @override
  _QuantityButtonState createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> {
  int _quantity;

  @override
  void initState() {
    _quantity = widget.quantity;
    super.initState();
  }

  void _increment() {
    setState(() {
      _quantity = _quantity + 1;
      _onChanged(_quantity);
    });
  }

  void _decrement() {
    if (!(_quantity <= 0)) {
      setState(() {
        _quantity = _quantity <= 0 ? 0 : _quantity - 1;
        _onChanged(_quantity);
      });
    }
  }

  void _onChanged(int value) {
    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Sizes.SIZE_2,
        horizontal: Sizes.SIZE_6,
      ),
      decoration: BoxDecoration(
        color: AppColors.red200,
        borderRadius: BorderRadius.circular(
          Sizes.SIZE_30,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _decrement,
            child: Icon(
              Icons.remove,
              size: Sizes.SIZE_14,
              color: Colors.white,
            ),
          ),
          SizedBox(width: Sizes.SIZE_10),
          Text(
            '$_quantity',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(width: Sizes.SIZE_10),
          GestureDetector(
            onTap: _increment,
            child: Icon(
              Icons.add,
              size: Sizes.SIZE_14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
