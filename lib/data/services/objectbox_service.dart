import 'package:get_x/get.dart';
import '../../objectbox.g.dart';

class ObjectboxService extends GetxController {
  static ObjectboxService get to => Get.find<ObjectboxService>();

  late final Store store;
}
