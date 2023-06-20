import 'dart:io';

import 'package:app2/base/base_event_bus.dart';
import 'package:app2/base/base_viewmodel.dart';
import 'package:app2/main.dart';
import 'package:app2/model/body/contact_body.dart';
import 'package:app2/utils/constants/enums.dart';
import 'package:app2/utils/extension.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class EditContactViewModel extends BaseViewModel {
  Future<void> editContact(ContactBean contact) async {
    String avatarUrl = contact.imagePath ?? '';

    final contactDoc = collectionReference.doc(contact.id);

    final refUploadAvatarName = storageReference.child("${contact.id}");

    if (contact.imagePath != '') {
      refUploadAvatarName.putFile(File("${contact.imagePath}"));
      avatarUrl = await refUploadAvatarName.getDownloadURL();
    }

    final updateData = ContactBean(
      name: contact.name,
      contactNo: contact.contactNo,
      organisation: contact.organisation,
      email: contact.email,
      address: contact.address,
      note: contact.note,
      imagePath: avatarUrl,
    );

    final json = updateData.toJson();

    await contactDoc.update(json).request(onSuccess: (value) {
      showToast("Successfully Updated!");
      eventBus?.fire(BaseEventBus(EventBusAction.REFRESH_CONTACT));
      Get.back();
    });
  }
}
