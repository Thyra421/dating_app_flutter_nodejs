import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lust/data/pictures_data.dart';
import 'package:lust/global/navigation.dart';
import 'package:lust/theme.dart';

import '../../../data/picture_data.dart';
import '../../../global/api.dart';
import '../../../global/messenger.dart';
import '../../../global/format.dart';

class PicturesPage extends StatefulWidget {
  const PicturesPage({
    super.key,
    required this.initialPicturesData,
    required this.onChange,
  });

  final PicturesData initialPicturesData;
  final void Function(PicturesData newData) onChange;

  @override
  State<PicturesPage> createState() => _PicturesPageState();
}

class _PicturesPageState extends State<PicturesPage>
    with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  late TabController _controller;
  late PicturesData _picturesData;

  void _onReorder(int oldIndex, int newIndex) async {
    final PicturesData backup =
        PicturesData(pictures: List.from(_picturesData.pictures!));

    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final PictureData item = _picturesData.pictures!.removeAt(oldIndex);
      _picturesData.pictures!.insert(newIndex, item);
    });

    try {
      await Api.setPictures(_picturesData);
      widget.onChange(_picturesData);
    } catch (error) {
      setState(() => _picturesData = backup);
      Messenger.showSnackBar("Failed reordering the pictures");
    }
  }

  void _onDelete() async {
    final PicturesData backup =
        PicturesData(pictures: List.from(_picturesData.pictures!));
    final PictureData toRemove =
        _picturesData.pictures!.elementAt(_controller.index);

    setState(() {
      _picturesData.pictures!.removeAt(_controller.index);
      _controller =
          TabController(length: _picturesData.pictures!.length, vsync: this);
    });

    try {
      await Api.deletePicture(toRemove);
      widget.onChange(_picturesData);
      Navigation.pop();
    } catch (e) {
      setState(() {
        _picturesData = backup;
        _controller =
            TabController(length: _picturesData.pictures!.length, vsync: this);
      });
      Messenger.showSnackBar("Failed deleting the picture");
    }
  }

  // TODO add a loading
  void _onAdd(ImageSource imageSource) async {
    final XFile? file = await _picker.pickImage(source: imageSource);
    if (file == null) return;
    try {
      final PictureData newPicture = await Api.addPicture(file.path);

      setState(() {
        _picturesData.pictures!.add(newPicture);
        _controller =
            TabController(length: _picturesData.pictures!.length, vsync: this);
      });
      widget.onChange(_picturesData);
      Navigation.pop();
    } catch (_) {
      setState(() {
        _controller =
            TabController(length: _picturesData.pictures!.length, vsync: this);
      });
      Messenger.showSnackBar("Failed adding the picture");
    }
  }

  void _showRemovePictureModal() => showModalBottomSheet(
      context: context,
      builder: _removePictureModal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)));

  void _showAddPictureModal() => showModalBottomSheet(
      context: context,
      builder: _addPictureModal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)));

  Widget _addFromGallery() => Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Theme.of(context).dividerColor)),
      child: IconButton(
          iconSize: 32,
          onPressed: () => _onAdd(ImageSource.gallery),
          icon: const Icon(Icons.photo)));

  Widget _addFromCamera() => Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Theme.of(context).dividerColor)),
      child: IconButton(
          iconSize: 32,
          onPressed: () => _onAdd(ImageSource.camera),
          icon: const Icon(Icons.camera_alt)));

  Widget _confirmDelete() =>
      TextButton(onPressed: _onDelete, child: const Text("Delete"));

  Widget _cancelDelete() =>
      const ElevatedButton(onPressed: Navigation.pop, child: Text("Cancel"));

  Widget _addPictureModal(context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: kHorizontalPadding),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            section("Add a picture"),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kHorizontalPadding),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_addFromGallery(), _addFromCamera()]),
            ),
          ]));

  Widget _removePictureModal(context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: kHorizontalPadding),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            section("Do you want to delete this picture permanently?"),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kHorizontalPadding),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_confirmDelete(), _cancelDelete()]),
            ),
          ]));

  Widget _delete() => IconButton(
      onPressed: _showRemovePictureModal, icon: const Icon(Icons.delete));

  Widget _add() =>
      IconButton(onPressed: _showAddPictureModal, icon: const Icon(Icons.add));

  List<Widget> _pages() =>
      _picturesData.pictures!.map((p) => Image.network(p.url!)).toList();

  Widget _previewItem(int index, String pic) => InkWell(
      key: Key(pic),
      child: Image.network(pic),
      onTap: () => _controller.animateTo(index));

  Widget _preview() => SizedBox(
      height: 100,
      child: ReorderableListView(
          scrollDirection: Axis.horizontal,
          onReorder: _onReorder,
          children: _picturesData.pictures!
              .asMap()
              .map((p, i) => MapEntry(i, _previewItem(p, i.url!)))
              .values
              .toList()));

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: widget.initialPicturesData.pictures!.length, vsync: this);
    _picturesData = widget.initialPicturesData;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar:
          AppBar(actions: [_delete(), _add()], automaticallyImplyLeading: true),
      bottomNavigationBar: _preview(),
      body: TabBarView(controller: _controller, children: _pages()));
}
