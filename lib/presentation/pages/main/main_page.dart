import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../main/provider/main_provider.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loadDataByDateProvider)(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Main 탭
          _buildMainTab(),
          // 통계 탭 (임시)
          const Center(child: Text('통계')),
          // 내정보 탭 (임시)
          const Center(child: Text('내정보')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              width: 48.w,
              height: 48.h,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/chart.svg',
              width: 48.w,
              height: 48.h,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/people.svg',
              width: 48.w,
              height: 48.h,
            ),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildMainTab() {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 36.h,
        leadingWidth: 48.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Center(
            child: GestureDetector(
              onTap: () {
                // TODO: 드로어 열기
              },
              child: SvgPicture.asset(
                'assets/icons/drawer.svg',
                width: 18.w,
                height: 18.h,
              ),
            ),
          ),
        ),
        title: Text(
          '11월 13일 (토)',
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF323232)),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  await context.push('/note-list');
                  // 노트 목록에서 돌아왔을 때 데이터 새로고침
                  if (mounted) {
                    final state = ref.read(mainStateProvider);
                    ref.read(loadDataByDateProvider)(state.selectedDate);
                  }
                },
                child: SvgPicture.asset(
                  'assets/icons/clipboard.svg',
                  width: 18.w,
                  height: 18.h,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 날짜 선택 + 컨트롤 영역 (배경색 통일)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE).withValues(alpha: 0.3),
              border: Border(
                top: BorderSide(
                  color: const Color(0xFF323232).withValues(alpha: 0.4),
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: const Color(0xFF323232).withValues(alpha: 0.4),
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              children: [
                // 날짜 영역 (주간 캘린더)
                _buildWeekCalendar(),

                // 컨트롤 영역
                _buildControlBar(),
              ],
            ),
          ),

          // 메인 영역
          Expanded(child: _buildMainContent()),

          // 하단 영역
          _buildBottomArea(),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar() {
    // 임시 데이터: 요일, 날짜, 선택 여부, 컨텐츠 유무
    final weekDays = ['월', '화', '수', '목', '금', '토', '일'];
    final dates = [18, 19, 20, 21, 22, 23, 24];
    final hasContent = [true, false, true, false, false, true, false];
    final selectedIndex = 5; // 토요일 선택 (오늘)

    return Padding(
      padding: EdgeInsets.only(top: 9.h),
      child: SizedBox(
        height: 63.h,
        child: Table(
          border: TableBorder.all(
            color: const Color(0xFF323232).withValues(alpha: 0.4),
            width: 0.5,
          ),
          children: [
            // 첫 번째 행: 요일
            TableRow(
              children: List.generate(7, (index) {
                Color textColor;
                if (index == 5) {
                  textColor = const Color(0xFF071C92); // 토요일
                } else if (index == 6) {
                  textColor = const Color(0xFF920707); // 일요일
                } else {
                  textColor = const Color(
                    0xFF4B4B4B,
                  ).withValues(alpha: 0.5); // 평일
                }

                return Center(
                  child: Text(
                    weekDays[index],
                    style: TextStyle(fontSize: 9.sp, color: textColor),
                  ),
                );
              }),
            ),
            // 두 번째 행: 날짜 (높이 2배)
            TableRow(
              children: List.generate(7, (index) {
                final isSelected = index == selectedIndex;
                final hasContentMark = hasContent[index];

                Color textColor;
                if (index == 5) {
                  textColor = const Color(0xFF071C92); // 토요일
                } else if (index == 6) {
                  textColor = const Color(0xFF920707); // 일요일
                } else {
                  textColor = const Color(
                    0xFF4B4B4B,
                  ).withValues(alpha: 0.5); // 평일
                }

                return Container(
                  height: 42.h, // 첫 번째 행의 2배
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 날짜 배경 (선택된 경우 검은색, 아니면 투명)
                      Container(
                        width: 31.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFF323232)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(9.r),
                        ),
                      ),
                      // 날짜 텍스트 (중앙)
                      Text(
                        '${dates[index]}',
                        style: TextStyle(
                          fontSize: 9.sp,
                          color:
                              isSelected ? const Color(0xFFFFFFFF) : textColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      // 컨텐츠 유무 점 표시 (하단)
                      if (hasContentMark)
                        Positioned(
                          bottom: 4.h,
                          child: Container(
                            width: 3.w,
                            height: 3.h,
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFFFFFFFF)
                                      : const Color(0xFF323232),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlBar() {
    return SizedBox(
      height: 70.h,
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
        child: Row(
          children: [
            // 왼쪽 영역 - 할일 보기 버튼
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: () {
                    // TODO: 할일 토글
                  },
                  child: Container(
                    width: 28.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.circular(11.r),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/list.svg',
                        width: 16.w,
                        height: 16.h,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 중앙 - 총 집중시간
            Container(
              width: 120.w,
              height: 34.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Center(
                child: Text(
                  '12H 30M',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF323232).withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),

            // 오른쪽 영역 - 공유 & 타임테이블 토글
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO: 공유
                      },
                      child: Container(
                        width: 28.w,
                        height: 26.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6E6E6),
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/camera.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        // TODO: 타임테이블 토글
                      },
                      child: Container(
                        width: 28.w,
                        height: 26.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6E6E6),
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/table.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        // Note 헤더
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFF323232).withValues(alpha: 0.4),
                width: 0.5,
              ),
            ),
          ),
          padding: EdgeInsets.only(left: 16.w, top: 14.h, bottom: 14.h),
          child: Text(
            'Note',
            style: TextStyle(fontSize: 11.sp, color: const Color(0xFF323232)),
          ),
        ),
        // 노트 목록 영역
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final mainState = ref.watch(mainStateProvider);
              final todayNotes = mainState.todayNotes;

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  // 실제 오늘 선택된 노트 표시
                  if (todayNotes.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(20.h),
                      child: Center(
                        child: Text(
                          '오늘 선택된 노트가 없습니다.\n노트 목록에서 노트를 선택하세요.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF323232).withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    )
                  else
                    ...todayNotes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final note = entry.value;
                      final todos = mainState.todosByNote[note.id] ?? [];
                      return _buildNoteCard(
                        note.title,
                        Color(note.colorValue),
                        Color(note.colorValue),
                        '00:00:00', // TODO: 실제 집중 시간 표시
                        isFirst: index == 0,
                        isLastNote: index == todayNotes.length - 1,
                        noteId: note.id,
                        todos: todos,
                      );
                    }),

                  // 노트 목록 버튼
                  SizedBox(height: 20.h),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        await context.push('/note-list');
                        // 노트 목록에서 돌아왔을 때 데이터 새로고침
                        if (mounted) {
                          final state = ref.read(mainStateProvider);
                          ref.read(loadDataByDateProvider)(state.selectedDate);
                        }
                      },
                      child: Container(
                        width: 120.w,
                        height: 33.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF323232).withValues(alpha: 0.4),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                        child: Center(
                          child: Text(
                            '노트 목록',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: const Color(0xFF323232).withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(
    String title,
    Color mainColor,
    Color textColor,
    String time, {
    bool isFirst = false,
    bool isLastNote = false,
    String? noteId,
    List<dynamic> todos = const [],
  }) {
    return Column(
      children: [
        // 노트 헤더
        GestureDetector(
          onTap: () {
            if (noteId != null) {
              context.push('/note-timer/$noteId');
            }
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                top:
                    isFirst
                        ? BorderSide.none
                        : BorderSide(
                          color: const Color(0xFF323232).withValues(alpha: 0.4),
                          width: 0.5,
                        ),
                bottom: BorderSide(
                  color: const Color(0xFF323232).withValues(alpha: 0.4),
                  width: 0.5,
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Row(
              children: [
                // 색상 박스
                Container(
                  width: 23.w,
                  height: 23.h,
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 8.w),
                // 노트 제목
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 집중시간 표시
                Container(
                  width: 63.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  child: Center(
                    child: Text(
                      time,
                      style: TextStyle(fontSize: 11.sp, color: textColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 할일 목록 (실제 데이터)
        if (todos.isNotEmpty)
          ...todos.asMap().entries.map((entry) {
            final index = entry.key;
            final todo = entry.value;
            return _buildTodoItem(
              todo.title,
              todo.isCompleted,
              todoId: todo.id,
              isLast: index == todos.length - 1 && isLastNote,
            );
          })
        else
          // 할일이 없을 때
          _buildTodoItem(
            '할일이 없습니다',
            false,
            isLast: isLastNote,
            isEmpty: true,
          ),
      ],
    );
  }

  Widget _buildTodoItem(
    String title,
    bool isChecked, {
    bool isLast = false,
    String? todoId,
    bool isEmpty = false,
  }) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(
                  color: const Color(0xFF323232).withValues(alpha: 0.4),
                  width: 0.5,
                ),
        ),
      ),
      child: Row(
        children: [
          // 체크 영역 (8%)
          Container(
            width: MediaQuery.of(context).size.width * 0.08,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: const Color(0xFF323232).withValues(alpha: 0.4),
                  width: 0.5,
                ),
              ),
            ),
            child: Center(
              child: isEmpty
                  ? SizedBox(width: 14.w, height: 10.h)
                  : GestureDetector(
                      onTap: () {
                        if (todoId != null) {
                          ref.read(toggleTodoCompleteProvider)(todoId);
                        }
                      },
                      child: isChecked
                          ? SvgPicture.asset(
                              'assets/icons/check.svg',
                              width: 14.w,
                              height: 10.h,
                            )
                          : SizedBox(width: 14.w, height: 10.h),
                    ),
            ),
          ),
          // 할일 텍스트 (나머지)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isEmpty
                      ? const Color(0xFF323232).withValues(alpha: 0.4)
                      : const Color(0xFF323232),
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomArea() {
    return Column(
      children: [
        // 광고 배너 플레이스홀더
        Container(
          height: 50.h,
          color: Colors.grey[300],
          child: const Center(child: Text('광고 배너')),
        ),
      ],
    );
  }
}
