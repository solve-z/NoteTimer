import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '통계',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내정보',
          ),
        ],
      ),
    );
  }

  Widget _buildMainTab() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // TODO: 드로어 열기
          },
        ),
        title: const Text('11월 13일 (토)'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              // TODO: 노트 목록 화면으로 이동
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 날짜 영역 (주간 캘린더)
          _buildWeekCalendar(),

          // 컨트롤 영역
          _buildControlBar(),

          // 메인 영역
          Expanded(
            child: _buildMainContent(),
          ),

          // 하단 영역
          _buildBottomArea(),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar() {
    return Container(
      height: 80.h,
      color: Colors.grey[100],
      child: const Center(
        child: Text('주간 캘린더 (TODO)'),
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 할일 보기 버튼
          TextButton.icon(
            onPressed: () {
              // TODO: 할일 토글
            },
            icon: const Icon(Icons.list),
            label: const Text('Note'),
          ),

          // 총 집중시간
          Text(
            '12H 30M',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          // 공유 & 타임테이블 토글
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // TODO: 공유
                },
              ),
              IconButton(
                icon: const Icon(Icons.table_chart),
                onPressed: () {
                  // TODO: 타임테이블 토글
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // 노트 카드 예시
        _buildNoteCard('수학', Colors.pink[100]!, '00:00:00'),
        SizedBox(height: 12.h),
        _buildNoteCard('영어', Colors.blue[100]!, '00:00:00'),
        SizedBox(height: 12.h),

        // 노트 목록 버튼
        SizedBox(height: 40.h),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // TODO: 노트 목록 화면으로 이동
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: const Text('오늘 날짜로 이동'),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(String title, Color color, String time) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.check_box_outline_blank, size: 24.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '문제집 35p 까지 풀기',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
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
          child: const Center(
            child: Text('광고 배너'),
          ),
        ),
      ],
    );
  }
}