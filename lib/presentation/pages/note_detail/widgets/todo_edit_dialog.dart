import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodoEditDialog extends StatefulWidget {
  final String initialTitle;

  const TodoEditDialog({
    super.key,
    required this.initialTitle,
  });

  @override
  State<TodoEditDialog> createState() => _TodoEditDialogState();
}

class _TodoEditDialogState extends State<TodoEditDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '할일 수정',
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: '할일 제목',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        maxLines: 1,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('취소', style: TextStyle(fontSize: 14.sp)),
        ),
        ElevatedButton(
          onPressed: () {
            final newTitle = _controller.text.trim();
            if (newTitle.isNotEmpty) {
              Navigator.of(context).pop(newTitle);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD147),
            foregroundColor: Colors.black,
          ),
          child: Text('확인', style: TextStyle(fontSize: 14.sp)),
        ),
      ],
    );
  }
}
