import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fav_provider.dart';
import 'image_provider.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

final responseImages = <String>{
  'https://cdn.pixabay.com/photo/2015/09/05/07/28/writing-923882_960_720.jpg',
  'https://cdn.pixabay.com/photo/2015/11/19/21/14/glasses-1052023_960_720.jpg',
  'https://cdn.pixabay.com/photo/2015/09/05/21/51/reading-925589_960_720.jpg',
  'https://cdn.pixabay.com/photo/2015/11/19/21/10/glasses-1052010_960_720.jpg',
  'https://cdn.pixabay.com/photo/2016/09/10/17/18/book-1659717_960_720.jpg',
  'https://cdn.pixabay.com/photo/2014/09/05/18/32/old-books-436498_960_720.jpg',
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ListTile(
                    title: const Text('Favourites'),
                    trailing: ref.watch(favProvider).isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              ref.read(favProvider.notifier).clearImages();
                            },
                            icon: const Icon(Icons.clear_all),
                          ),
                  ),
                ),
                Consumer(
                  builder: (context, ref, _) {
                    final favImages = ref.watch(favProvider);
                    if (favImages.isEmpty) {
                      return const Center(
                          child: Text(
                        'No Images',
                      ));
                    }

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: favImages.length,
                      itemBuilder: (context, index) {
                        final image = favImages.elementAt(index);
                        return InkWell(
                          onTap: () {
                            ref.read(favProvider.notifier).removeImage(image);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(8),
                            child: Image.network(image, fit: BoxFit.cover),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('All Images (${ref.watch(imgProvider).length})'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(imgProvider.notifier).addImages(responseImages);
            },
            icon: const Icon(Icons.restore),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text(ref.watch(favProvider).length.toString()),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.favorite_border),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ref.watch(imgProvider).isEmpty
            ? const Center(
                child: Text('No Images', style: TextStyle(fontSize: 20)))
            : GridView.extent(
                primary: false,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                maxCrossAxisExtent: 200.0,
                children: List.generate(ref.watch(imgProvider).length, (index) {
                  final image = ref.watch(imgProvider).elementAt(index);
                  final isFav = ref.watch(favProvider).contains(image);
                  return GridTile(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: IconButton(
                            onPressed: () {
                              ref.read(imgProvider.notifier).removeImage(image);
                            },
                            icon: const Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    footer: Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (isFav) {
                                ref
                                    .read(favProvider.notifier)
                                    .removeImage(image);
                              } else {
                                ref.read(favProvider.notifier).addImage(image);
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 10),
                                Text(isFav ? '1' : ''.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Image ${index + 1}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (isFav) {
                          ref.read(favProvider.notifier).removeImage(image);
                        } else {
                          ref.read(favProvider.notifier).addImage(image);
                        }
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: isFav ? Colors.grey[300] : Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.network(image, fit: BoxFit.cover),
                      ),
                    ),
                  );
                }),
              ),
      ),
    );
  }
}
