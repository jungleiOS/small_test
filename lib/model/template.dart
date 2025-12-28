import 'package:small_test/util/json_to_model_util.dart';

class Template {
  String title;
  String image;
  String price;
  String highlight;
  String config;

  Template({
    this.title = '',
    this.image = '',
    this.price = '',
    this.highlight = '',
    this.config = '',
  });

  static Template fromJson(Map<String, dynamic> json) {
    return Template(
      title: JsonToModelUtil.toStr(json['title']),
      image: JsonToModelUtil.toStr(json['image']),
      price: JsonToModelUtil.toStr(json['price']),
      highlight: JsonToModelUtil.toStr(json['highlight']),
      config: JsonToModelUtil.toStr(json['config']),
    );
  }

  static List<Template> fromJsonList(dynamic json) {
    return JsonToModelUtil.toList(json, (v) => Template.fromJson(v));
  }
}
