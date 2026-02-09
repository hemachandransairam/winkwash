import "package:injectable/injectable.dart";
import "package:wink_dupe/core/utils/compositions.dart";

@lazySingleton
class HomeState {
  final selectedIndex = ref(0);
  final currentBannerPage = ref(0);

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void setCurrentBannerPage(int page) {
    currentBannerPage.value = page;
  }
}
