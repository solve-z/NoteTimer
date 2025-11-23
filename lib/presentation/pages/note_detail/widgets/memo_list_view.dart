import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../domain/model/memo_model.dart';
import '../../../../domain/model/note_model.dart';
import 'memo_item.dart';

class MemoListView extends StatelessWidget {
  final List<MemoModel> memos;
  final NoteModel? note;
  final Function(String memoId)? onTap;

  const MemoListView({super.key, required this.memos, this.note, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (memos.isEmpty) {
      return Center(
        child: Text(
          '메모가 없습니다',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    // 날짜별로 그룹화
    final groupedMemos = _groupByDate(memos);
    final sortedDates =
        groupedMemos.keys.toList()..sort((a, b) => b.compareTo(a)); // 최신순

    final noteColor = note != null ? Color(note!.colorValue) : Colors.grey;

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final memosForDate = groupedMemos[date]!;
        final dateStr = DateFormat('yyyy/MM/dd').format(date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 헤더
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                dateStr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            // 메모 리스트
            ...memosForDate.map(
              (memo) => MemoItem(
                memo: memo,
                noteColor: noteColor,
                onTap: () => onTap?.call(memo.id),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }

  Map<DateTime, List<MemoModel>> _groupByDate(List<MemoModel> memos) {
    final Map<DateTime, List<MemoModel>> grouped = {};

    for (final memo in memos) {
      final date = DateTime(
        memo.assignedDate.year,
        memo.assignedDate.month,
        memo.assignedDate.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(memo);
    }

    // 각 날짜 내에서 sortOrder로 정렬
    grouped.forEach((key, value) {
      value.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    });

    return grouped;
  }
}
