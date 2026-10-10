import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import '../widgets/movie_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  static const List<Movie> _movies = [
    Movie(
      id: 1,
      title: 'Человек-паук',
      subtitle: 'Киновселенная MARVEL - 2002',
      categories: ['Фантастика', 'Боевик', 'Приключения'],
      imageUrl: 'https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/428e2842-4157-45e8-a9af-1e5245e52c37/600x900',
    ),
    Movie(
      id: 2,
      title: 'Человек-паук 2',
      subtitle: 'Киновселенная MARVEL - 2004',
      categories: ['Фантастика', 'Боевик', 'Приключения'],
      // ВАША ОРИГИНАЛЬНАЯ ДЛИННАЯ ССЫЛКА СОХРАНЕНА
      imageUrl: 'https://kinopoisk-ru.clstorage.net/29tK54n16/cfa00cHr5O2V/l4C_-tl5a9JBabnIQWAtqglGGRHIGBaM1c4dVGVib8pcfTuSQaATdA3QzZy0g1B-SyBivLSXQ6QJIoeQCmAptbNA-g546Y4Xpa28WMEAOavJ4z3ALJ0izQT7GLGXkW1JfuoZ8bMiEbIZtCntUUZFGk8FogiEE7cQTgEWtf2lvfTUAB14vsnawkapqovR8sw8GWVKthk6ddil7B6X9CA9aDwo6HLggEAyyeUKO1D39lp89PArl7eWYS-CkBVPJF-ltGG8qm2JWXE3WvmoE0H9v9m2OifZeJfpNz5_VuUBr2mMe8gxABNAILo0Wcrz55TJ_1ewSJbGNyMPgiDXL0fvVgSQ3Fj9ORky1skq2GPxLy9KtzkHWnt3eTVO_3f1Il377Pv7Y8NSArJ5ldkYs0Qmyg-k0alnxNdwnSNB1IxV3_QngP767glqM9c5q0kD4G9suAV5FVipVYhkb42m1nBNGm2a2CMxguPxW1WbupCEFHqfVsA79aZXYFzCMCRtlj7ld2Isqu_LeJPF-bkJ0wCNbqtEOHZ4uQSo5E-9BnQiPxvua3tzAhPDkGi1mLgQlJc6PVUAW6bkBCC9kZCVffdex5XBvjtd2dkRFVobyrMCLv6K5TomKvt2mUcsTtR0k-3pncjpYsPAAfBadFpY06RkWP7HQFg2RmdBjoFi1l9V_NUmoQ95LRnKgDVbSKmyIg0OSLQo1Uj7V_uVHgzVxKBM-R-pS6Hg4lFTiaTaCCOGtXostyI5BEelU42z4lU8BIyEpkItSY3IuxD2mNtKA_JuHUqky8YJC8arRm_dpoVAH_hMiQpBo-IQoVuH6MnTB-XoTIXhmPeExwJdQ4HWnha85UYRDBiP-UthpCiI6AMwHtxLBrqEqHiFmSWuDKbk0HxIbAr4gsMyc0JI1kjZgOTE-n53wEnUx2QCHOCihX93j6XWsE96TerqAOc6y_jDkB4eueTq5fgpdQhHrewXNLHvCRwI6zBhEXKyelea2UDlt8guZPPZxdXncFyh4kcsZG6VBdJeit84GQIWKWjKshCfj2i2uOdamOX5Jh5P5TSSDij96JhBsjPxcimX-qvQtdSbHWeRqNXVl2Jcc-A1DiWMxwZz3jrtSOsDxttLaBOzDnx4p1gl-jhnK1Wd_6X2k7xYzBqpwYFAU1CYZmqo0RQHWfzFAZi3pdYSDKOQB99m3VSU4Ly7nqtYwgX4eMniUe8daxcpJAt6xRmWDk3GJUBMS66JupIxchBAW7QoSYKmpWoeddLI5EX1Q55j07RvBM5UtYMMKu7YujMG6RiY8-H_P7gFyveIeec4dQ6f95bD7AgueElTMfAioavlqmjTRbWaDPWgWse19BGco3HWX2TMx9fxvYm_qojRxwt5qpOzHG_I9At0KwgHqPTsvdbHUH-5_LqZ4uERMWKK1tuL4MQHS5yk8Lq0lebSjlCghL5V3aXWkhyZDojIAwUYaMggQz9ve-TY17gIhurW3S00ZXH9ShwJmhAgsBGRmPVIWuMVx4rO93Aa5GWkIU9DsYadp57WlWDMeI0qipBk-wtK4RHtTltXOwY5Gzb69l6v5fbB_zgfmrhRsXDB8bvG25qBJCaobCZjqoaHBzPfILPXPbXMdAWyzZiPK3qztPjZWrHD3M9J1xikOMnkWYXvr5WmAt9p_JlqAxFj4gOYp5p6oFVHWG1WQnmUVYaz3LHjJTy2befE4E547dj48ZSYO5pDkl7tucQZJciot0mETQ02tvPfOY-J2eMB4BARimZrOZE31IvuFgAolSWGoQ7CwaQ95kzWxtGd-K86GvHlGopII2DsTcvHyHR7OicLRt3N5Lbw3SnMuruBwIFREdrmaeoxJPTb_KRi-JWVFkG9M-IVfkZ_tiRgbBp_qrrBx_g7i5JAvr77xipHK0sHiIUtnjaEM-84zFnacbKA8dG7pGjZIQSlSh9GENlHlWZQvbLQRLxETlbkMA3KrBl4okYKivgAMVx-iWfo1SrbB0pkPt-WJUIOSezpmqCAgxKDyhbauMDX9vnc1hLKN4QHcF3RQcQ_hAzkhYLea0wI6AOkG0q7MlKeXXtHyUY7Knfop2_vVfQwf7pemNnSIJCxAqoGSOrhtefJzxcA6zbn5nGvgqM2TZQeFRfBDJj-itvSVorLWiETPA6a9mhmSFjVmsYu7ab3MR5obdhrsEHxULBYpavLEUTHGy6nwijmdWahvPCw5o9mjYfV4kxrfft74nTbavrBAL2umQa5deq5JsrHXmzHppPuaYwZuyDBgHNhunWbmIOk9vvNZeGKJPcGU0ySIdevRq5HBDBemT_Ze1JEChl4gZNcvAmWuPUIOJUbhQ3tBKay3Pl9uYohkuJzkjq0KFrwdaaaPBXT6zcnNIBNo6KHz4ddtKZD31nMuLrQ1djYy7CjbM3LlBnH20iWSsVsX-bVMo85v9j4AYPSAGFYVtp7MdXFGOxWYlsklxcAvICSxr8n_DcXk_5r3LvqkPTYGuryox5uWCaZ9pjYpLl1rR81B2COegwJWZPwENHAu7doWpL19ur-hML654ekwY1igiSOV4w3xmKfWx3ayIL02gl4weHurIjW2_XpCVToZ82u9EXBnmhuWuhw0TMAEapmKsjChUaK3EUBGcZ1tOJ_Q8A1Tres5-bTr-uPaQvBxspbykHijG4btcqF2lo32iddvwT0Ur-bXVsrswECgGLodXhYEuelCm0mQtum95TiHZKR923kLrU10h1Y7auLovfIyTgzYWxOSPb4twlpZVr27N-Ed8IO2C1ZeWJDErNDy8coC0M2J0pM1lGINyX2oD-wEod_1W6XZLAcWJ1YKLB1uLm4AgN-v7okydZLyuSqhd0MpsRQ3trtuLhTEOFj0ehl6grRJiVabIYQGhWERuEOkDGlreSPtUYSjml-OSlQVfjZmeJDXm9p1WsEWvsXSJXefPamMt9KHFqLYeHzM_Fp1MgrkyeW-t5EAnuFN-bDQ',
    ),
    Movie(
      id: 3,
      title: 'Человек-паук 3: Враг в отражении',
      subtitle: 'Киновселенная MARVEL - 2007',
      categories: ['Фантастика', 'Боевик', 'Приключения'],
      imageUrl: 'https://avatars.mds.yandex.net/get-kinopoisk-image/1773646/2fc0214a-668d-4453-9abf-30b201b767ba/600x900',
    ),
    Movie(
      id: 4,
      title: 'Новый Человек-паук',
      subtitle: 'Киновселенная MARVEL - 2012',
      categories: ['Фантастика', 'Боевик', 'Приключения'],
      imageUrl: 'https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/94bbf625-f375-4629-8345-2e9565c07d56/600x900',
    ),
    Movie(
      id: 5,
      title: 'Новый Человек-паук: Высокое напряжение',
      subtitle: 'Киновселенная MARVEL - 2014',
      categories: ['Фантастика', 'Боевик', 'Приключения'],
      imageUrl: 'https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/6018c36f-464c-4933-8a83-1b07b90c4e4e/600x900',
    ),
    Movie(
      id: 6,
      title: 'Человек-паук: Возвращение домой',
      subtitle: 'Киновселенная MARVEL - 2017',
      categories: ['Фантастика', 'Боевик', 'Приключения'],
      imageUrl: 'https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/51bf8584-2863-4412-9627-a3dca16c5c4d/600x900',
    ),
    Movie(
      id: 7,
      title: 'Человек-паук: Вдали от дома',
      subtitle: 'Киновселенная MARVEL - 2019',
      // Здесь как в вашем оригинале было 5 категорий
      categories: ['Фантастика', 'Фэнтези', 'Боевик', 'Комедия', 'Приключения'],
      imageUrl: 'https://avatars.mds.yandex.net/get-kinopoisk-image/1900788/5cadd28b-996e-4224-ab98-f7aed64aa56c/600x900',
    ),
    Movie(
      id: 8,
      title: 'Человек-паук: Нет пути домой',
      subtitle: 'Киновселенная MARVEL - 2021',
      categories: ['Фантастика', 'Боевик', 'Приключения', 'Фэнтези'],
      imageUrl: 'https://avatars.mds.yandex.net/get-kinopoisk-image/6201401/731c4031-7389-44f4-8c15-f9f4e3b0ed90/600x900',
    ),
    Movie(
      id: 9,
      title: 'Человек-паук: Новый день',
      subtitle: 'Киновселенная MARVEL - 2026',
      categories: ['Фантастика', 'Боевик', 'Приключения'],
      imageUrl: 'https://avatars.mds.yandex.net/get-kinopoisk-image/9784475/9d8f64fc-dc63-43c5-9279-b6fb527426e2/600x900',
    ),
  ];

  final Set<int> _likedIds = {};
  bool _showOnlyLiked = false;

  void _toggleLike(int id) {
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedMovies = _showOnlyLiked
        ? _movies.where((movie) => _likedIds.contains(movie.id)).toList()
        : _movies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог фильмов'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'В избранном: ${_likedIds.length}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Только избранные', style: TextStyle(fontSize: 16)),
                Switch(
                  value: _showOnlyLiked,
                  onChanged: (value) {
                    setState(() {
                      _showOnlyLiked = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: displayedMovies.isEmpty
                ? const Center(
                    child: Text('Ничего не нашлось', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: displayedMovies.length,
                    itemBuilder: (context, index) {
                      final movie = displayedMovies[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: MovieCard(
                          movie: movie,
                          isLiked: _likedIds.contains(movie.id),
                          onLikeTap: () => _toggleLike(movie.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}