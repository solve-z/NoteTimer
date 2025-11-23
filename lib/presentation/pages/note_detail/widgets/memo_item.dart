import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../domain/model/memo_model.dart';

class MemoItem extends StatelessWidget {
  final MemoModel memo;
  final Color noteColor;
  final VoidCallback? onTap;

  const MemoItem({
    super.key,
    required this.memo,
    required this.noteColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: noteColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: noteColor.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          memo.content,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
