import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavProvider extends StateNotifier<Set<String>> {
  FavProvider() : super(<String>{});

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

final favProvider = StateNotifierProvider<FavProvider, Set<String>>(
  (ref) => FavProvider(),
);
