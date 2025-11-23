import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../note_detail/provider/note_detail_provider.dart';
import 'widgets/todo_list_view.dart';
import 'widgets/memo_list_view.dart';

class NoteDetailPage extends ConsumerStatefulWidget {
  final String noteId;

  const NoteDetailPage({
    super.key,
    required this.noteId,
  });

  @override
  ConsumerState<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends ConsumerState<NoteDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref
            .read(noteDetailProvider(widget.noteId).notifier)
            .switchTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noteDetailProvider(widget.noteId));

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.note == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Text(
            '노트를 찾을 수 없습니다',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey),
          ),
        ),
      );
    }

    final note = state.note!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          note.title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          indicatorWeight: 2.h,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: '할일'),
            Tab(text: '메모'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 할일 탭
          TodoListView(
            todos: state.todos,
            note: state.note,
            onToggle: (todoId) {
              ref
                  .read(noteDetailProvider(widget.noteId).notifier)
                  .toggleTodoComplete(todoId);
            },
            onDelete: (todoId) {
              ref
                  .read(noteDetailProvider(widget.noteId).notifier)
                  .deleteTodo(todoId);
            },
            onEdit: (todoId, newTitle) {
              ref
                  .read(noteDetailProvider(widget.noteId).notifier)
                  .updateTodoTitle(todoId, newTitle);
            },
            onMove: (todoId, newDate) {
              ref
                  .read(noteDetailProvider(widget.noteId).notifier)
                  .moveTodoToDate(todoId, newDate);
            },
          ),
          // 메모 탭
          MemoListView(
            memos: state.memos,
            note: state.note,
            onTap: (memoId) {
              // TODO: 메모 상세 페이지로 이동
            },
          ),
        ],
      ),
    );
  }
}