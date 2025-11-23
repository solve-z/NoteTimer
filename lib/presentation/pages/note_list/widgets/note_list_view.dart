import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../domain/model/note_model.dart';
import 'note_card.dart';

class NoteListView extends ConsumerWidget {
  final List<NoteModel> notes;
  final bool isLoading;
  final bool isArchived;

  const NoteListView({
    super.key,
    required this.notes,
    required this.isLoading,
    required this.isArchived,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notes.isEmpty) {
      return Center(
        child: Text(
          isArchived ? '보관된 노트가 없습니다' : '노트를 추가해주세요',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2열
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 0.75, // 카드 비율 (width / height) - 3:4 비율
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          key: ValueKey(note.id),
          note: note,
          isArchived: isArchived,
        );
      },
    );
  }
}