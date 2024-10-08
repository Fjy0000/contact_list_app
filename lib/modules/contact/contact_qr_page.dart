import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app2/base/base_event_bus.dart';
import 'package:app2/main.dart';
import 'package:app2/modules/contact/argument/contact_details_argument.dart';
import 'package:app2/utils/constants/enums.dart';
import 'package:app2/widgets/base_app_bar.dart';
import 'package:app2/widgets/base_avatar.dart';
import 'package:app2/widgets/base_scaffold.dart';
import 'package:app2/widgets/base_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ContactQrPage extends StatefulWidget {
  const ContactQrPage({Key? key}) : super(key: key);

  @override
  State<ContactQrPage> createState() => _ContactQrPageState();
}

class _ContactQrPageState extends State<ContactQrPage> {
  ContactArgument arguments = Get.arguments;

  StreamSubscription? subscription;

  final GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    subscription = eventBus?.on<BaseEventBus>().listen((event) {
      switch (event.type) {
        case EventBusAction.REFRESH_CONTACT:
          break;
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  Future<void> share() async {
    //capture the specific widget
    RenderRepaintBoundary? boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    // transfer to image
    final image = await boundary.toImage();
    //change to png format
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    //represents the image in binary form
    Uint8List? pngBytes = byteData?.buffer.asUint8List();

    //store temporarily
    final tempDir = await getTemporaryDirectory();
    File imgFile = File('${tempDir.path}/image.jpg');
    imgFile.writeAsBytes(pngBytes!);

    //share
    Share.shareFiles([imgFile.path]);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        backgroundColor: Colors.transparent,
        "contact_qr".tr,
        actions: [
          IconButton(
            onPressed: () {
              share();
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: RepaintBoundary(
            key: globalKey,
            child: buildQrCode(),
          ),
        ),
      ),
    );
  }

  Widget buildQrCode() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      decoration: BoxDecoration(
          color: const Color(0x33e8e8e8),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BaseAvatar(
            imagePath: arguments.contact?.imagePath,
          ),
          const SizedBox(height: 15),
          BaseText(
            arguments.contact?.name != "" ? arguments.contact?.name : arguments.contact?.contactNo,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 20),
          QrImage(
            data: arguments.contact?.contactNo.toString() ?? '',
            version: QrVersions.auto,
            size: 180,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
