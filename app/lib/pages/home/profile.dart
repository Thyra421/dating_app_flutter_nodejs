import 'dart:math';
import 'package:lust/components.dart/profile_description.dart';
import 'package:lust/components.dart/profile_item.dart';
import 'package:lust/data/hobbies_data.dart';
import 'package:lust/data/identity_data.dart';
import 'package:lust/data/pictures_data.dart';
import 'package:lust/global/api.dart';
import 'package:lust/global/format.dart';
import 'package:lust/global/messenger.dart';
import 'package:lust/global/navigation.dart';
import 'package:lust/theme.dart';
import 'package:lust/utils/future_widget.dart';
import 'package:flutter/material.dart';

import '../../components.dart/add_profile_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  late int _randomTipId;

  IdentityData _identityData = IdentityData();
  PicturesData _picturesData = PicturesData();

  List<String> _itemsList = [];

  static const List<String> _ideas = [
    "a movie",
    "a singer",
    "a band",
    "a food",
    "a place",
    "a show",
    "a song",
    "a book",
    "a drink",
    "an animal",
    "a music genre",
    "a sport",
    "a game",
    "a music instrument"
  ];

  void _scrollToBottom() =>
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

  void _scrollToTop() =>
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 200));

  void _onOtherTip() => _randomTipId = Random().nextInt(_ideas.length);

  void _onAddItem(String item) async {
    List<String> backup = List<String>.from(_itemsList);

    setState(() => _itemsList.add(formatItem(item)));

    try {
      await Api.addHobbies(HobbiesData(hobbies: [item]));
      _scrollToBottom();
    } catch (e) {
      setState(() => _itemsList = backup);
      Messenger.showSnackBar("Failed adding item");
    }
  }

  void _onRemoveItem(String item) async {
    List<String> backup = List<String>.from(_itemsList);

    setState(() => _itemsList.remove(item));

    try {
      await Api.removeHobbies(HobbiesData(hobbies: [item]));
    } catch (e) {
      setState(() => _itemsList = backup);
      Messenger.showSnackBar("Failed removing item");
    }
  }

  void _onEditItem(String oldValue, String newValue) async {
    List<String> backup = List<String>.from(_itemsList);

    setState(() {
      int index = _itemsList.indexOf(oldValue);
      _itemsList[index] = formatItem(newValue);
    });

    try {
      await Api.setHobbies(_itemsList);
    } catch (e) {
      setState(() => _itemsList = backup);
      Messenger.showSnackBar("Failed editing item");
    }
  }

  void _setIdentity(IdentityData identityData) async {
    IdentityData backup = IdentityData()..setFrom(identityData);

    setState(() => _identityData.setFrom(identityData));
    try {
      await Api.setIdentity(_identityData);
    } catch (error) {
      setState(() => _identityData.setFrom(backup));
      Messenger.showSnackBar("Failed changing identity");
    }
  }

  void _getPicturesList(PicturesData picturesData) =>
      setState(() => _picturesData = picturesData);

  void _getItemsList(HobbiesData hobbiesData) =>
      setState(() => _itemsList = hobbiesData.hobbies!);

  void _getIdentity(IdentityData identityData) =>
      setState(() => _identityData = identityData);

  Expanded _name() => Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(_identityData.firstName ?? "",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))));

  IconButton _settingsButton() => IconButton(
      iconSize: 30,
      onPressed: () => Navigation.settings(),
      icon: const Icon(Icons.settings));

  Container _profilePicture() => Container(
      height: 80,
      width: 80,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: _picturesData.pictures != null
          ? ClipOval(
              // borderRadius: BorderRadius.circular(kBorderRadius),
              child: Image.network(_picturesData.pictures![0]))
          : const Icon(Icons.person, color: Colors.black, size: 40));

  Widget _identity() => Padding(
      padding: const EdgeInsets.only(
          top: 30,
          bottom: 10,
          left: kHorizontalPadding,
          right: kHorizontalPadding),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [_profilePicture(), _name(), _settingsButton()]),
        ProfileDescription(
            description: _identityData.description ?? "",
            onChange: (String value) =>
                _setIdentity(IdentityData(description: value)))
      ]));

  Widget _youLike() => Container(
      padding: const EdgeInsets.only(
          left: kHorizontalPadding, right: kHorizontalPadding, bottom: 20),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text("You like ${_itemsList.length} items",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))));

  Widget _items() => Column(
      mainAxisSize: MainAxisSize.min,
      children: _itemsList
          .map((String item) => ProfileItem(
              key: UniqueKey(),
              item: item,
              onRemoveItem: () => _onRemoveItem(item),
              onEditItem: (String newValue) => _onEditItem(item, newValue),
              itemsList: _itemsList))
          .toList());

  Widget _noMoreIdea() =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            child: Icon(Icons.tips_and_updates)),
        Expanded(
            child: Text.rich(TextSpan(children: [
          const TextSpan(text: "No more idea? "),
          const TextSpan(text: "Try adding "),
          TextSpan(
              text: _ideas[_randomTipId],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: " you like")
        ]))),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            child: TextButton(
                onPressed: () => setState(() => _onOtherTip()),
                child: const Text("Other tip",
                    style: TextStyle(fontWeight: FontWeight.bold))))
      ]);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _onOtherTip();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureWidget(
        future: () => Future.wait([
              Api.getIdentity(),
              Api.getHobbies(),
              Api.getPictures(),
            ])
              ..then((values) {
                _getIdentity(values[0] as IdentityData);
                _getItemsList(values[1] as HobbiesData);
                _getPicturesList(values[2] as PicturesData);
              }, onError: (_) {}),
        widget: Column(children: [
          _identity(),
          _youLike(),
          Expanded(
              child: CustomScrollView(controller: _scrollController, slivers: [
            // SliverAppBar(
            //     automaticallyImplyLeading: false,
            //     floating: true,
            //     centerTitle: true,
            //     title: IconButton(
            //         padding: EdgeInsets.zero,
            //         icon: const Icon(Icons.keyboard_arrow_up),
            //         onPressed: _scrollToTop)),
            SliverList(
                delegate: SliverChildListDelegate([
              _items(),
              AddProfileItem(onAddItem: _onAddItem, itemsList: _itemsList),
              _noMoreIdea()
            ]))
          ]))
        ]));
  }
}
