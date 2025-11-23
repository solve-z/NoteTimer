import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/note_colors.dart';
import '../../../note_add_update/provider/note_form_provider.dart';

/// 색상 선택 다이얼로그 (16가지 색상, 4x4 그리드)
class ColorPickerDialog extends ConsumerStatefulWidget {
  const ColorPickerDialog({super.key});

  @override
  ConsumerState<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends ConsumerState<ColorPickerDialog> {
  late int _tempSelectedColor;

  @override
  void initState() {
    super.initState();
    _tempSelectedColor = ref.read(noteFormProvider).selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 타이틀
            Text(
              '노트 색상 선택',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 20.h),

            // 색상 그리드 (4x4)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: NoteColors.colors.length,
              itemBuilder: (context, index) {
                final color = NoteColors.colors[index];
                final isSelected = _tempSelectedColor == color.toARGB32();

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _tempSelectedColor = color.toARGB32();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.black
                            : Colors.grey[300]!,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: Colors.black87,
                            size: 24.sp,
                          )
                        : null,
                  ),
                );
              },
            ),

            SizedBox(height: 24.h),

            // 버튼 영역
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      ref
                          .read(noteFormProvider.notifier)
                          .setSelectedColor(_tempSelectedColor);
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: const Color(0xFFFFB3C1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      '선택',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}