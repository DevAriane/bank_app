import 'package:get/get.dart';
import '../../objectbox.g.dart';

class ObjectBoxService extends GetxController {
  static ObjectBoxService get to => Get.find<ObjectBoxService>();

  late final Store store;

  Future<ObjectBoxService> init() async {
    store = await openStore();

    return this;
  }
}
