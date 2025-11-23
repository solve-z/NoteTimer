import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../note_timer/provider/note_timer_provider.dart';
import '../../note_detail/provider/note_detail_provider.dart';
import '../../../core/utils/time_formatter.dart';

class NoteTimerPage extends ConsumerWidget {
  final String noteId;

  const NoteTimerPage({super.key, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(noteTimerProvider(noteId));
    final detailState = ref.watch(noteDetailProvider(noteId));

    if (timerState.isLoading || detailState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (timerState.note == null) {
      return const Scaffold(
        body: Center(child: Text('노트를 찾을 수 없습니다.')),
      );
    }

    final note = timerState.note!;
    final noteColor = Color(note.colorValue);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(note.title, style: TextStyle(fontSize: 16.sp)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 타이머 영역
          Expanded(
            flex: 5,
            child: _buildTimerSection(context, ref, noteColor),
          ),

          // 할일/메모 탭 영역
          Expanded(
            flex: 5,
            child: _buildContentTabSection(context, ref),
          ),
        ],
      ),
    );
  }

  /// 타이머 영역
  Widget _buildTimerSection(BuildContext context, WidgetRef ref, Color noteColor) {
    final timerState = ref.watch(noteTimerProvider(noteId));
    final notifier = ref.read(noteTimerProvider(noteId).notifier);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 메인 타이머 표시
          Text(
            formatTime(timerState.isFocusMode ? timerState.currentTime : timerState.breakTime),
            style: TextStyle(
              fontSize: 48.sp,
              fontWeight: FontWeight.bold,
              color: timerState.isFocusMode
                  ? const Color(0xFF323232)
                  : const Color(0xFF323232).withValues(alpha: 0.4),
            ),
          ),
          SizedBox(height: 20.h),

          // 상태 표시 텍스트
          Text(
            timerState.isFocusMode ? '집중 모드' : '휴식 모드',
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF323232).withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 30.h),

          // 시작/종료 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (timerState.isRunning && timerState.isFocusMode) {
                    notifier.endFocus();
                  } else if (!timerState.isRunning) {
                    notifier.startFocus();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: noteColor,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                ),
                child: Text(
                  timerState.isRunning && timerState.isFocusMode ? '종료' : '시작',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
              SizedBox(width: 16.w),

              // 휴식 버튼
              ElevatedButton(
                onPressed: () {
                  if (timerState.isFocusMode && timerState.isRunning) {
                    notifier.startBreak();
                  } else if (!timerState.isFocusMode) {
                    notifier.endBreak();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6E6E6),
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                ),
                child: Text(
                  timerState.isFocusMode ? '휴식' : '그만 쉬기',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF323232),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),

          // 오늘 총 시간 & 휴식 시간 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '오늘 총 시간',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: timerState.isFocusMode
                          ? const Color(0xFF323232)
                          : const Color(0xFF323232).withValues(alpha: 0.4),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    formatTime(timerState.todayTotalFocusTime),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: timerState.isFocusMode
                          ? const Color(0xFF323232)
                          : const Color(0xFF323232).withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '휴식 시간',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: !timerState.isFocusMode
                          ? const Color(0xFF323232)
                          : const Color(0xFF323232).withValues(alpha: 0.4),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    formatTime(timerState.breakTime),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: !timerState.isFocusMode
                          ? const Color(0xFF323232)
                          : const Color(0xFF323232).withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 할일/메모 탭 영역
  Widget _buildContentTabSection(BuildContext context, WidgetRef ref) {
    final detailNotifier = ref.read(noteDetailProvider(noteId).notifier);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(text: '할일'),
              Tab(text: '메모'),
            ],
            onTap: (index) => detailNotifier.switchTab(index),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // 할일 리스트
                _buildTodoList(context, ref),
                // 메모 리스트
                _buildMemoList(context, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 할일 리스트
  Widget _buildTodoList(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(noteDetailProvider(noteId));
    final detailNotifier = ref.read(noteDetailProvider(noteId).notifier);

    return ListView.builder(
      itemCount: detailState.todos.length + 1,
      itemBuilder: (context, index) {
        if (index == detailState.todos.length) {
          return ListTile(
            leading: const Icon(Icons.add),
            title: const Text('+ 할일 추가'),
            onTap: () => _showAddTodoDialog(context, ref),
          );
        }

        final todo = detailState.todos[index];
        return ListTile(
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (_) => detailNotifier.toggleTodoComplete(todo.id),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => detailNotifier.deleteTodo(todo.id),
          ),
        );
      },
    );
  }

  /// 메모 리스트
  Widget _buildMemoList(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(noteDetailProvider(noteId));

    return ListView.builder(
      itemCount: detailState.memos.length + 1,
      itemBuilder: (context, index) {
        if (index == detailState.memos.length) {
          return ListTile(
            leading: const Icon(Icons.add),
            title: const Text('+ 메모 추가'),
            onTap: () => _showAddMemoDialog(context, ref),
          );
        }

        final memo = detailState.memos[index];
        return ListTile(
          title: Text(memo.content),
          subtitle: Text(memo.createdAt.toString()),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // TODO: 메모 삭제 구현
            },
          ),
        );
      },
    );
  }

  /// 할일 추가 다이얼로그
  void _showAddTodoDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('할일 추가'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '할일을 입력하세요',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(noteDetailProvider(noteId).notifier).createTodo(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  /// 메모 추가 다이얼로그
  void _showAddMemoDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('메모 추가'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '메모를 입력하세요',
          ),
          maxLines: 5,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(noteDetailProvider(noteId).notifier).createMemo(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }
}