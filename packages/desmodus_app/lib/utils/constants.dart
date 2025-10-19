import 'package:flutter/widgets.dart';

Future<String> appVersion(BuildContext context) {
  final bundle = DefaultAssetBundle.of(context);
  // or use root bundle if no BuildContext is available
  return bundle
      .loadString("pubspec.yaml")
      .then((res) {
        final version =
            res.split("version: ")[1].split(RegExp(r'\s+'))[0].trim();
        return version;
      })
      .catchError((err) {
        return "NaN";
      });
}

const departamentosPeru = {
  "000000": "Exterior",
  "01": "Amazonas",
  "02": "Áncash",
  "03": "Apurímac",
  "04": "Arequipa",
  "05": "Ayacucho",
  "06": "Cajamarca",
  "07": "Callao",
  "08": "Cusco",
  "09": "Huancavelica",
  "10": "Huánuco",
  "11": "Ica",
  "12": "Junín",
  "13": "La Libertad",
  "14": "Lambayeque",
  "15": "Lima",
  "16": "Loreto",
  "17": "Madre de Dios",
  "18": "Moquegua",
  "19": "Pasco",
  "20": "Piura",
  "21": "Puno",
  "22": "San Martín",
  "23": "Tacna",
  "24": "Tumbes",
  "25": "Ucayali",
};

const loremIpsum = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce placerat nulla felis, ac efficitur dui faucibus consectetur. Nam imperdiet leo mi, tempus porta eros molestie ac. Quisque scelerisque ex lectus, eget placerat metus bibendum auctor. Mauris dignissim nibh sed suscipit vehicula. Sed sed maximus risus, sed faucibus sapien. Morbi risus dui, auctor eu mauris id, vehicula vehicula urna. Mauris fringilla venenatis tincidunt. In aliquet dolor euismod, malesuada lectus id, gravida dui. Donec cursus risus eget fermentum tincidunt.

Aliquam erat volutpat. Curabitur ultrices ex vitae neque elementum mattis. Sed ut lacinia nisi. Sed in est odio. Suspendisse porta dui nec lacinia feugiat. Nulla id felis ultrices, cursus lacus nec, elementum augue. Aenean nisl magna, placerat tempus blandit id, imperdiet a neque. Morbi consequat nisi id justo consequat gravida. Vestibulum tincidunt nisl nisi, at vestibulum lacus faucibus ut.

Mauris posuere elit ut lacus ultrices, scelerisque rhoncus leo sagittis. Nullam molestie, mi a tristique efficitur, massa elit faucibus massa, a molestie purus nisl quis quam. In at purus a dolor molestie tristique et non justo. Proin eget ante ut tortor finibus cursus ut non nibh. Nullam tempor mi eget velit ullamcorper accumsan euismod sed tortor. Nulla a scelerisque enim, eget posuere ante. Donec a lobortis odio. Vestibulum malesuada commodo mauris, congue tempor ligula elementum sed. Proin eget nisi in purus molestie fermentum. Vivamus porta ligula id erat commodo, nec cursus arcu faucibus. Aliquam aliquet lacus vel interdum viverra. Donec mi velit, consequat ut ex a, feugiat scelerisque dolor.
""";
