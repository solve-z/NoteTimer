import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Stack(
        children: [
          // 메인 카드
          GestureDetector(
            onTap: () {
              // TODO: 노트 상세 페이지로 이동
            },
            child: Container(
              width: 150.w,
              height: 180.h,
              decoration: BoxDecoration(
                color: Color(note.colorValue),
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h), // 고정 아이콘 공간
                  // 노트 제목
                  Expanded(
                    child: Text(
                      note.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 체크박스 (사용중 탭에서만 표시)
                  if (!isArchived)
                    Align(
                      alignment: Alignment.bottomLeft,
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
                ],
              ),
            ),
          ),
          // 고정 아이콘 (좌측 상단)
          if (note.isPinned)
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Icon(
                Icons.push_pin,
                color: Colors.red,
                size: 20.sp,
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
                    // TODO: 노트 수정 페이지로 이동
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
      ),
    );
  }
}