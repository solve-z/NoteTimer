import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/model/note_model.dart';
import '../../../note_list/provider/note_list_provider.dart';

class NoteCard extends ConsumerWidget {
  final NoteModel note;
  final bool isArchived;

  const NoteCard({
    super.key,
    required this.note,
    required this.isArchived,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        // 메인 카드
        GestureDetector(
          onTap: () {
            // TODO: 노트 상세 페이지로 이동
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(note.colorValue),
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 32.h), // 상단 아이콘 공간 (체크박스/고정 핀)
                // 노트 제목
                Expanded(
                  child: Center(
                    child: Text(
                      note.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 좌측 상단: 체크박스 또는 고정 아이콘
        if (!isArchived)
          Positioned(
            top: 4.h,
            left: 4.w,
            child: note.isPinned
                ? // 고정된 노트: 고정 아이콘 표시
                Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      Icons.push_pin,
                      color: Colors.red,
                      size: 24.sp,
                    ),
                  )
                : // 일반 노트: 체크박스 표시
                Transform.scale(
                    scale: 1.1,
                    child: Checkbox(
                      value: note.isSelectedForToday,
                      onChanged: (value) {
                        ref.read(noteListProvider.notifier).toggleSelectForToday(note.id);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
          ),
        // 더보기 메뉴 (우측 상단)
          Positioned(
            top: 4.h,
            right: 4.w,
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
                size: 20.sp,
              ),
              onSelected: (value) async {
                switch (value) {
                  case 'pin':
                    await ref.read(noteListProvider.notifier).togglePin(note.id);
                    break;
                  case 'edit':
                    await context.push('/note-edit', extra: note);
                    // 수정 후 돌아왔을 때 목록 새로고침
                    if (context.mounted) {
                      if (isArchived) {
                        await ref.read(noteListProvider.notifier).loadArchivedNotes();
                      } else {
                        await ref.read(noteListProvider.notifier).loadActiveNotes();
                      }
                    }
                    break;
                  case 'archive':
                    if (isArchived) {
                      await ref.read(noteListProvider.notifier).unarchiveNote(note.id);
                    } else {
                      await ref.read(noteListProvider.notifier).archiveNote(note.id);
                    }
                    break;
                  case 'delete':
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('노트 삭제'),
                        content: const Text('정말 삭제하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('삭제'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await ref.read(noteListProvider.notifier).deleteNote(note.id);
                    }
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'pin',
                  child: Text(note.isPinned ? '고정 해제' : '고정'),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('수정'),
                ),
                PopupMenuItem(
                  value: 'archive',
                  child: Text(isArchived ? '보관 해제' : '보관'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('삭제'),
                ),
              ],
            ),
          ),
        ],
      );
  }
}