import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../domain/model/note_model.dart';
import '../../../note_list/provider/note_list_provider.dart';
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

    // 고정된 노트 개수 확인
    final pinnedCount = notes.where((n) => n.isPinned).length;

    return ReorderableListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: notes.length,
      onReorder: (oldIndex, newIndex) {
        // 고정되지 않은 노트가 고정된 노트보다 위로 올라가는 것을 방지
        if (oldIndex >= pinnedCount && newIndex < pinnedCount) {
          return; // 이동 불가
        }

        // newIndex 조정 (ReorderableListView의 특성상 필요)
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }

        ref.read(noteListProvider.notifier).updateOrder(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final note = notes[index];
        return Padding(
          key: ValueKey(note.id),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            children: [
              // 드래그 핸들
              ReorderableDragStartListener(
                index: index,
                child: Icon(
                  Icons.drag_handle,
                  color: Colors.grey,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 8.w),
              // 노트 카드
              NoteCard(
                note: note,
                isArchived: isArchived,
              ),
            ],
          ),
        );
      },
    );
  }
}