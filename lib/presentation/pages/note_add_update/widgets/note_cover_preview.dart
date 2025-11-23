import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 노트 표지 미리보기 위젯
class NoteCoverPreview extends StatelessWidget {
  final String noteTitle;
  final int colorValue;

  const NoteCoverPreview({
    super.key,
    required this.noteTitle,
    required this.colorValue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150.w,
        height: 200.h,
        decoration: BoxDecoration(
          color: Color(colorValue),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              noteTitle.isEmpty ? '노트 이름' : noteTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: noteTitle.isEmpty ? Colors.grey[600] : Colors.black87,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}