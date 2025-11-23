import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../note_list/provider/note_list_provider.dart';
import 'widgets/note_list_view.dart';

class NoteListPage extends ConsumerStatefulWidget {
  const NoteListPage({super.key});

  @override
  ConsumerState<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends ConsumerState<NoteListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(noteListProvider.notifier).switchTab(_tabController.index);
      }
    });

    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(noteListProvider.notifier).loadActiveNotes();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noteListProvider);

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
          '노트 목록',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(96.h),
          child: Column(
            children: [
              // 검색 버튼
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: SizedBox(
                  width: double.infinity,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 검색 페이지로 이동
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB3C1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      '검색',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              // TabBar
              TabBar(
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
                  Tab(text: '사용중'),
                  Tab(text: '보관함'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 사용중 탭
                NoteListView(
                  notes: state.activeNotes,
                  isLoading: state.isLoading,
                  isArchived: false,
                ),
                // 보관함 탭
                NoteListView(
                  notes: state.archivedNotes,
                  isLoading: state.isLoading,
                  isArchived: true,
                ),
              ],
            ),
          ),
          // 광고 배너 플레이스홀더
          Container(
            width: double.infinity,
            height: 50.h,
            color: Colors.red,
            alignment: Alignment.center,
            child: Text(
              '광고배너',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 노트 추가 페이지로 이동
        },
        backgroundColor: const Color(0xFFFFD147),
        child: Icon(Icons.add, color: Colors.black, size: 28.sp),
      ),
    );
  }
}