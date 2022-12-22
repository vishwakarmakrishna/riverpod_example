import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main.dart';

class ImgProvider extends StateNotifier<Set<String>> {
  ImgProvider() : super(responseImages);

  void addImage(String image) {
    state = {...state, image};
  }

  void removeImage(String image) {
    state = state.where((element) => element != image).toSet();
  }

  void clearImages() {
    state = <String>{};
  }

  void addImages(Set<String> images) {
    state = {...state, ...images};
  }
}

final imgProvider = StateNotifierProvider<ImgProvider, Set<String>>(
  (ref) => ImgProvider(),
);
