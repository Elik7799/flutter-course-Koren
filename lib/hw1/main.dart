// ЛР 1 — шесть независимых виджетов.
//
// Как сдавать: скопируйте этот файл целиком себе в main.dart, допишите
// шесть функций ниже вместо TODO, запустите — все шесть элементов должны
// появиться на экране. Пришлите готовый файл на проверку.
//
// Основной виджет трогать не нужно. Редактируйте там, где написано TODO.

import 'package:flutter/material.dart';

void main() {
  runApp(const Lab1App());
}

class Lab1App extends StatelessWidget {
  const Lab1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ЛР 1')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task 1:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task1(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 2:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task2(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 3:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task3(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 4:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task4(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 5:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task5(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 6:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task6(),
            ],
          ),
        ),
      ),
    );
  }
}

// 1. Заголовок — Text, крупный жирный текст чёрного цвета, обрезается в одну строку, если не помещается.
Widget task1() {
  // TODO: замените Placeholder на Text()
  return const Text(
    'Очень длинный заголовок, который по идее не может поместиться на вашем экране, это я вам точно говорю',
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: Color(0xFF000000)
      ),
  );
}

// 2. Подпись — небольшой, нежирный курсивный текст белого цвета, обрезается в две строки.
// Также реализуйте подложку из тёмно-серого контейнера с закруглениями, чтобы текст было видно
Widget task2() {
  // TODO: замените Placeholder на ...
  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 80, 74, 74),
      borderRadius: BorderRadius.circular(10)
    ),
    child: Text('Небольшая уже подпись, которая также не помещается на вашем экране, как и предыдущяя, но только она длинее, потому что уже должна быть небольшой, но также и очень длинной, чтобы дотянуть количество символов до двух строк, чтобы показать, что этот текст обрезается в две строки. И так, на чем я оставновился...А да, мне нужно налить здесь воды немеренно, чтобы этот текст ну уж точно не поместился в две строки на любом экране',
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 20,
      fontStyle: FontStyle.italic,
      color: Color(0xFFFFFFFF)
    ),),

  );
}

// 3. Иконка — любая Icon на ваш вкус,
// с применением цвета и размером.
Widget task3() {
  // TODO: замените Placeholder на...
  return const Icon(Icons.access_alarm_sharp, color: Color.fromARGB(255, 6, 194, 219), size: 40);
}

// 4. Кнопка с иконкой избранного — большая иконка сердца красного цвета без фона.
// При нажатии пишет в консоль "Вы добавили в избранное"
Widget task4() {
  // TODO: замените Placeholder на ...
  return IconButton(
    icon: const Icon(Icons.favorite, color: Color.fromARGB(255, 255, 0, 0), size: 40),
    onPressed: (){print('Вы добавили в избранное');},
    );
}

// 5. Кнопка «Подробнее» — кнопка с текстом и обводкой, при нажатии пишет в консоль "Узнать детали"
Widget task5() {
  // TODO: замените Placeholder на ...
  return ElevatedButton(
    onPressed: (){print('Узнать детали');},
    child: Text('Подробнее', style: TextStyle(fontSize: 20)),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(color: Color.fromARGB(255, 34, 28, 202), width: 6)
      )
    )
  );
}

// 6. Изображение в стиле Polaroid—  выберите любое из каталога по ссылке
// https://picsum.photos/ (необходим vpn), либо используйте https://docs.flutter.dev/assets/images/dash/dash-fainting.gif
// Добавьте чёрную обводку, а внутри белую рамку в стиле фотографии Polaroid (https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAeKRHzUEOMCX836O6p8R5-XBkrSlf8C4go4C7f1q8ClnmlFaV9emSrUFL&s=10)
// Для реализации используйте Container
Widget task6() {
  // TODO: замените Placeholder на Container()
  return Container(
    child: Image.network('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif', height: 180),
    padding: const EdgeInsets.fromLTRB(12, 12, 12, 50),
    decoration: BoxDecoration(
      color: Color(0xFFFFFFFF),
      border: Border.all(color: Colors.black, width: 3)
    ),
  );
}
