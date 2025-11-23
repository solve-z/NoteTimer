import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/model/note_model.dart';
import '../../note_add_update/provider/note_form_provider.dart';
import 'widgets/color_picker_dialog.dart';
import 'widgets/note_cover_preview.dart';

class NoteAddUpdatePage extends ConsumerStatefulWidget {
  final NoteModel? note; // 수정 모드일 때 전달받는 노트

  const NoteAddUpdatePage({
    super.key,
    this.note,
  });

  @override
  ConsumerState<NoteAddUpdatePage> createState() => _NoteAddUpdatePageState();
}

class _NoteAddUpdatePageState extends ConsumerState<NoteAddUpdatePage> {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // 수정 모드인 경우 기존 노트 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.note != null) {
        ref.read(noteFormProvider.notifier).loadNoteForEdit(widget.note!);
        _titleController.text = widget.note!.title;
      } else {
        ref.read(noteFormProvider.notifier).reset();
      }
      // 자동 포커스
      _titleFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final userId = 'temp-user-id'; // TODO: 실제 사용자 ID로 교체
    final success = await ref.read(noteFormProvider.notifier).saveNote(userId);

    if (success && mounted) {
      context.pop(); // 이전 화면으로 이동
    } else {
      final errorMessage = ref.read(noteFormProvider).errorMessage;
      if (errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => const ColorPickerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noteFormProvider);
    final isEditMode = state.isEditMode;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEditMode ? '노트 수정' : '노트 추가',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: state.isSaving ? null : _handleSave,
            child: Text(
              '완료',
              style: TextStyle(
                color: state.isSaving ? Colors.grey : const Color(0xFFFFB3C1),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 노트 표지 미리보기
              NoteCoverPreview(
                noteTitle: state.noteTitle,
                colorValue: state.selectedColor,
              ),

              SizedBox(height: 32.h),

              // 노트 이름 입력 필드
              Text(
                '노트 이름',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                onChanged: (value) {
                  ref.read(noteFormProvider.notifier).setNoteTitle(value);
                },
                decoration: InputDecoration(
                  hintText: '노트 이름을 입력하세요',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
              ),

              SizedBox(height: 24.h),

              // 노트 색상 선택 영역
              Text(
                '노트 색상',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: _showColorPickerDialog,
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '색상 선택',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: Color(state.selectedColor),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}