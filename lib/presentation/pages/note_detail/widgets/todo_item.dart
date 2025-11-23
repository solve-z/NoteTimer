import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../domain/model/todo_model.dart';
import 'todo_edit_dialog.dart';

class TodoItem extends StatelessWidget {
  final TodoModel todo;
  final bool isArchived;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final Function(String newTitle)? onEdit;
  final Function(DateTime)? onMove;

  const TodoItem({
    super.key,
    required this.todo,
    this.isArchived = false,
    this.onToggle,
    this.onDelete,
    this.onEdit,
    this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isArchived
            ? Colors.grey.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // 체크박스
          Checkbox(
            value: todo.isCompleted,
            onChanged: isArchived ? null : (_) => onToggle?.call(),
            activeColor: Colors.green,
          ),
          SizedBox(width: 8.w),
          // 할일 제목
          Expanded(
            child: Text(
              todo.title,
              style: TextStyle(
                fontSize: 14.sp,
                color: isArchived
                    ? Colors.grey
                    : (todo.isCompleted ? Colors.grey : Colors.black),
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          // 더보기 메뉴 (보관중이 아닐 때만)
          if (!isArchived)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, size: 20.sp, color: Colors.grey),
              onSelected: (value) async {
                if (value == 'edit') {
                  final newTitle = await showDialog<String>(
                    context: context,
                    builder: (context) => TodoEditDialog(
                      initialTitle: todo.title,
                    ),
                  );
                  if (newTitle != null && newTitle != todo.title) {
                    onEdit?.call(newTitle);
                  }
                } else if (value == 'delete') {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('할일 삭제'),
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
                    onDelete?.call();
                  }
                } else if (value == 'move') {
                  _showDatePicker(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('수정', style: TextStyle(fontSize: 14.sp)),
                ),
                PopupMenuItem(
                  value: 'move',
                  child: Text('이동', style: TextStyle(fontSize: 14.sp)),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('삭제', style: TextStyle(fontSize: 14.sp, color: Colors.red)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: todo.assignedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && onMove != null) {
      onMove!(selectedDate);
    }
  }
}
