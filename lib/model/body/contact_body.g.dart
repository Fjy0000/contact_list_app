// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactBody _$ContactBodyFromJson(Map<String, dynamic> json) => ContactBody(
      contact: (json['contact'] as List<dynamic>?)
          ?.map((e) => ContactBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContactBodyToJson(ContactBody instance) =>
    <String, dynamic>{
      'contact': instance.contact,
    };

ContactBean _$ContactBeanFromJson(Map<String, dynamic> json) => ContactBean(
      id: json['id'] as String?,
      name: json['name'] as String?,
      contactNo: json['contactNo'] as String?,
      organisation: json['organisation'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      note: json['note'] as String?,
      imagePath: json['imagePath'] as String?,
    )..isShowSuspension = json['isShowSuspension'] as bool;

Map<String, dynamic> _$ContactBeanToJson(ContactBean instance) =>
    <String, dynamic>{
      'isShowSuspension': instance.isShowSuspension,
      'id': instance.id,
      'name': instance.name,
      'contactNo': instance.contactNo,
      'organisation': instance.organisation,
      'email': instance.email,
      'address': instance.address,
      'note': instance.note,
      'imagePath': instance.imagePath,
    };
