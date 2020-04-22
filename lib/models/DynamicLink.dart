import 'package:handball_flutter/enums.dart';

class DynamicLinkModel {
  String linkingCode;
  DynamicLinkType type;

  DynamicLinkModel({
    this.linkingCode,
    this.type,
  });

  DynamicLinkModel.fromLink(Uri link) {
    if (_validateLink(link)) {
      linkingCode = link.queryParameters['linkingCode'];
      type = _coerceLinkType(link.queryParameters['type']);
    } else {
      linkingCode = '';
      type = DynamicLinkType.invalid;
    }
  }

  bool get isValid {
    return type == DynamicLinkType.invalid;
  }
}

bool _validateLink(Uri link) {
  return link.hasQuery &&
      link.queryParameters.containsKey('linkingCode') &&
      link.queryParameters['linkingCode'] != null &&
      link.queryParameters['linkingCode'] != '' &&
      link.queryParameters['type'] != '' &&
      link.queryParameters['type'] != null;
}

DynamicLinkType _coerceLinkType(String type) {
  switch (type) {
    case 'projectInvite':
      return DynamicLinkType.projectInvite;

    case 'invalid':
      return DynamicLinkType.invalid;

    default:
      return DynamicLinkType.invalid;
  }
}
