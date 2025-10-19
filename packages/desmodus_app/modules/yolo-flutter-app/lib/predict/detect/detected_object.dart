import 'dart:ui';

/// A detected object.
class DetectedObject {
  /// Creates a [DetectedObject].
  DetectedObject({
    required this.confidence,
    required this.boundingBox,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.index,
    required this.label,
  });

  /// Creates a [DetectedObject] from a [json] object.
  factory DetectedObject.fromJson(Map<dynamic, dynamic> json) {
    return DetectedObject(
      confidence: json['confidence'] as double,
      boundingBox: Rect.fromLTWH(
        json['x'] as double, // left
        json['y'] as double, // top
        json['width'] as double, // width
        json['height'] as double, // height
      ),

      // raw values from 0 to 1
      x: json['predX'] as double, // left
      y: json['predY'] as double, // top
      width: json['predWidth'] as double, // width
      height: json['predHeight'] as double, // height

      index: json['index'] as int,
      label: json['label'] as String,
    );
  }

  /// The confidence of the detection.
  final double confidence;

  /// The bounding box of the detection.
  final Rect boundingBox;

  /// The predicted bounding box of the detection [0-1].
  final double x;
  final double y;
  final double width;
  final double height;

  /// The index of the label.
  final int index;

  /// The label of the detection.
  final String label;
}
