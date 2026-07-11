/// 诗句库条目（离线 JSON）。
class PoemEntry {
  const PoemEntry({
    required this.id,
    required this.text,
    required this.author,
    this.source,
    this.byFigure = false,
    this.isDefault = false,
  });

  final String id;
  final String text;
  final String author;
  final String? source;
  final bool byFigure;
  final bool isDefault;

  factory PoemEntry.fromJson(Map<String, dynamic> json) {
    return PoemEntry(
      id: json['id'] as String,
      text: json['text'] as String,
      author: json['author'] as String,
      source: json['source'] as String?,
      byFigure: json['byFigure'] as bool? ?? false,
      isDefault: json['default'] as bool? ?? false,
    );
  }
}

class PoemBundle {
  const PoemBundle({
    required this.id,
    required this.name,
    required this.category,
    required this.tone,
    required this.poems,
    this.figureName,
    this.figureEra,
    this.lunar,
    this.solar,
    this.relation,
    this.subtype,
    this.theme,
  });

  final String id;
  final String name;
  final String category;
  final String tone;
  final List<PoemEntry> poems;
  final String? figureName;
  final String? figureEra;
  final String? lunar;
  final String? solar;
  final String? relation;
  final String? subtype;
  final String? theme;

  PoemEntry get defaultPoem {
    for (final p in poems) {
      if (p.isDefault) return p;
    }
    return poems.first;
  }

  factory PoemBundle.fromJson(String id, Map<String, dynamic> json) {
    final figure = json['figure'] as Map<String, dynamic>?;
    final rawPoems = json['poems'] as List<dynamic>? ?? [];
    return PoemBundle(
      id: id,
      name: json['name'] as String? ?? id,
      category: json['category'] as String? ?? '',
      tone: json['tone'] as String? ?? 'festive',
      poems: rawPoems
          .map((e) => PoemEntry.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      figureName: figure?['name'] as String?,
      figureEra: figure?['era'] as String?,
      lunar: json['lunar'] as String?,
      solar: json['solar'] as String?,
      relation: json['relation'] as String?,
      subtype: json['subtype'] as String?,
      theme: json['theme'] as String?,
    );
  }
}
