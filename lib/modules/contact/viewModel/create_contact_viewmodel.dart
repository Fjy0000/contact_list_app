import 'dart:io';

import 'package:app2/base/base_event_bus.dart';
import 'package:app2/base/base_viewmodel.dart';
import 'package:app2/main.dart';
import 'package:app2/model/body/contact_body.dart';
import 'package:app2/utils/constants/enums.dart';
import 'package:app2/utils/dialog_util.dart';
import 'package:app2/utils/extension.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class CreateContactViewModel extends BaseViewModel {
  Future<void> saveContact(ContactBean contact) async {
    final contactDoc = collectionReference.doc();
    final refUploadAvatarName = storageReference.child(contactDoc.id);

    bool _isLoadingDialogShown = false;
    String avatarUrl = '';

    if (contact.imagePath != '') {
      await refUploadAvatarName
          .putFile(File("${contact.imagePath}"))
          .snapshotEvents
          .listen((taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            if (!_isLoadingDialogShown) {
              showLoadingDialog();
              _isLoadingDialogShown = true;
            }
            break;
          case TaskState.paused:
            print("upload_paused".tr);
            break;
          case TaskState.canceled:
            print("upload_canceled".tr);
            break;
          case TaskState.error:
            showToast("upload_error".tr);
            break;
          case TaskState.success:
            avatarUrl = await refUploadAvatarName.getDownloadURL();
            final saveData = ContactBean(
              id: contactDoc.id,
              name: contact.name,
              contactNo: contact.contactNo,
              organisation: contact.organisation,
              email: contact.email,
              address: contact.address,
              note: contact.note,
              imagePath: avatarUrl,
            );

            final json = saveData.toJson();

            await contactDoc.set(json).request(
              onSuccess: (value) {
                dismissDialog();
                showToast("${"added_contact".tr} !!!");
                eventBus?.fire(BaseEventBus(EventBusAction.REFRESH_CONTACT));
                Get.back();
              },
            );
            break;
        }
      });
    } else {
      final saveData = ContactBean(
        id: contactDoc.id,
        name: contact.name,
        contactNo: contact.contactNo,
        organisation: contact.organisation,
        email: contact.email,
        address: contact.address,
        note: contact.note,
        imagePath: avatarUrl,
      );

      final json = saveData.toJson();

      await contactDoc.set(json).request(
        onSuccess: (value) {
          showToast("${"added_contact".tr} !!!");
          eventBus?.fire(BaseEventBus(EventBusAction.REFRESH_CONTACT));
          Get.back();
        },
      );
    }
  }
}
