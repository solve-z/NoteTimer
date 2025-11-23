import 'dart:ui';

/// 노트 색상 상수 정의 (16가지, 4x4 그리드)
class NoteColors {
  NoteColors._();

  /// 16가지 노트 색상 리스트
  static const List<Color> colors = [
    // Row 1
    Color(0xFFFFDADA), // 연한 핑크
    Color(0xFFFFE5CC), // 연한 오렌지
    Color(0xFFFFF4CC), // 연한 노란색
    Color(0xFFE8F5E9), // 연한 초록

    // Row 2
    Color(0xFFE3F2FD), // 연한 파랑
    Color(0xFFE1BEE7), // 연한 보라
    Color(0xFFFCE4EC), // 연한 자주
    Color(0xFFF5F5F5), // 연한 회색

    // Row 3
    Color(0xFFFFCDD2), // 핑크
    Color(0xFFFFCC80), // 오렌지
    Color(0xFFFFF59D), // 노란색
    Color(0xFFA5D6A7), // 초록

    // Row 4
    Color(0xFF90CAF9), // 파랑
    Color(0xFFCE93D8), // 보라
    Color(0xFFF48FB1), // 자주
    Color(0xFFE0E0E0), // 회색
  ];

  /// 기본 색상 (첫 번째 색상)
  static const Color defaultColor = Color(0xFFFFDADA);

  /// 색상 값으로부터 인덱스 찾기 (없으면 0 반환)
  static int getColorIndex(Color color) {
    final colorValue = color.toARGB32();
    final index = colors.indexWhere((c) => c.toARGB32() == colorValue);
    return index >= 0 ? index : 0;
  }

  /// 인덱스로부터 색상 가져오기
  static Color getColorByIndex(int index) {
    if (index < 0 || index >= colors.length) {
      return defaultColor;
    }
    return colors[index];
  }

  /// 색상 값(int)으로부터 Color 객체 가져오기
  static Color getColorByValue(int colorValue) {
    final color = colors.firstWhere(
      (c) => c.toARGB32() == colorValue,
      orElse: () => defaultColor,
    );
    return color;
  }
}