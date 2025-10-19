const loremIpsum = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce placerat nulla felis, ac efficitur dui faucibus consectetur. Nam imperdiet leo mi, tempus porta eros molestie ac. Quisque scelerisque ex lectus, eget placerat metus bibendum auctor. Mauris dignissim nibh sed suscipit vehicula. Sed sed maximus risus, sed faucibus sapien. Morbi risus dui, auctor eu mauris id, vehicula vehicula urna. Mauris fringilla venenatis tincidunt. In aliquet dolor euismod, malesuada lectus id, gravida dui. Donec cursus risus eget fermentum tincidunt.

Aliquam erat volutpat. Curabitur ultrices ex vitae neque elementum mattis. Sed ut lacinia nisi. Sed in est odio. Suspendisse porta dui nec lacinia feugiat. Nulla id felis ultrices, cursus lacus nec, elementum augue. Aenean nisl magna, placerat tempus blandit id, imperdiet a neque. Morbi consequat nisi id justo consequat gravida. Vestibulum tincidunt nisl nisi, at vestibulum lacus faucibus ut.

Mauris posuere elit ut lacus ultrices, scelerisque rhoncus leo sagittis. Nullam molestie, mi a tristique efficitur, massa elit faucibus massa, a molestie purus nisl quis quam. In at purus a dolor molestie tristique et non justo. Proin eget ante ut tortor finibus cursus ut non nibh. Nullam tempor mi eget velit ullamcorper accumsan euismod sed tortor. Nulla a scelerisque enim, eget posuere ante. Donec a lobortis odio. Vestibulum malesuada commodo mauris, congue tempor ligula elementum sed. Proin eget nisi in purus molestie fermentum. Vivamus porta ligula id erat commodo, nec cursus arcu faucibus. Aliquam aliquet lacus vel interdum viverra. Donec mi velit, consequat ut ex a, feugiat scelerisque dolor.
""";

Map<String, String> splitNombreApellido(String? fullName) {
  final clean = (fullName ?? '').trim().replaceAll(RegExp(r'\s+'), ' ');
  final parts = clean.split(' ');

  String nombres = '';
  String apellidos = '';

  if (parts.isEmpty || clean.isEmpty) {
    nombres = '';
    apellidos = '';
  } else if (parts.length <= 2) {
    nombres = parts.join(' ');
    apellidos = parts.length == 2 ? parts[1] : '';
  } else if (parts.length == 3) {
    nombres = '${parts[0]} ${parts[1]}';
    apellidos = parts[2];
  } else {
    nombres = '${parts[0]} ${parts[1]}';
    apellidos = '${parts[parts.length - 2]} ${parts.last}';
  }

  return {'nombres': nombres, 'apellidos': apellidos};
}
