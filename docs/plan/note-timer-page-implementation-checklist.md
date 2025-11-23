# Note Timer 페이지 구현 체크리스트

## 개요

- **목표**: 노트 타이머 페이지 구현 (스톱워치, 집중/휴식 모드, 할일/메모 탭)
- **디자인 기준**: 360x800 (flutter_screenutil 사용)
- **아키텍처**: Clean Architecture 준수 (Domain → Data → Presentation 의존성 규칙)
- **스톱워치**: 간단한 스톱워치 기능만 우선 구현 (백그라운드 동작은 추후)

---

## 1. Domain Layer 확장

### 1-1. 도메인 모델 확인

- [x] `lib/domain/model/focus_record_model.dart` 확인
  - FocusRecordModel이 이미 존재함 (id, noteId, startTime, endTime, duration, userId, createdAt)
  - 필요 시 필드 추가 검토 (예: `isBreakTime` - 휴식 시간 여부)

### 1-2. Repository 인터페이스 확장

- [x] `lib/domain/repository/focus_record_repository.dart` 생성 또는 확장
  - `Future<FocusRecordModel?> getOngoingFocusRecord(String noteId)` - 진행 중인 집중 기록 조회
  - `Future<void> createFocusRecord(FocusRecordModel record)` - 집중 세션 시작
  - `Future<void> updateFocusRecord(FocusRecordModel record)` - 집중 세션 업데이트
  - `Future<int> getTodayTotalFocusTimeByNote(String noteId, DateTime date)` - 오늘 총 집중 시간 조회

### 1-3. UseCase 작성

- [x] `lib/domain/usecase/focus_record/get_ongoing_focus_record_usecase.dart`
- [x] `lib/domain/usecase/focus_record/create_focus_record_usecase.dart`
- [x] `lib/domain/usecase/focus_record/update_focus_record_usecase.dart`
- [x] `lib/domain/usecase/focus_record/get_today_total_focus_time_by_note_usecase.dart`

---

## 2. Data Layer 확장

### 2-1. DataSource 확장

- [x] `lib/data/data_source/local_storage/focus_record_local_data_source.dart` 확장
  - `Future<FocusRecordModel?> getOngoingFocusRecord(String noteId)`
  - `Future<int> getTodayTotalFocusTimeByNote(String noteId, DateTime date)`

### 2-2. Repository 구현 확장

- [x] `lib/data/repository_impl/focus_record_repository_impl.dart` 확장
  - FocusRecordRepository 인터페이스의 모든 메서드 구현
  - FocusRecordLocalDataSource 의존성 주입 사용

---

## 3. Dependency Injection 설정

- [x] `lib/core/di/service_locator.dart`에 UseCase 등록
  - `GetOngoingFocusRecordUseCase`
  - `CreateFocusRecordUseCase`
  - `UpdateFocusRecordUseCase`
  - `GetTodayTotalFocusTimeByNoteUseCase`

---

## 4. Presentation Layer - Provider 작성

### 4-1. Timer State 클래스 정의

- [x] `lib/presentation/note_timer/provider/note_timer_state.dart` 생성
  - `note` (NoteModel) - 현재 노트 정보
  - `currentTime` (int, 초 단위) - 현재 진행 중인 시간 (집중 타이머)
  - `todayTotalFocusTime` (int, 초 단위) - 오늘 총 집중 시간
  - `breakTime` (int, 초 단위) - 휴식 시간
  - `isFocusMode` (bool) - true: 집중 모드, false: 휴식 모드
  - `isRunning` (bool) - 타이머 실행 중 여부
  - `focusRecordId` (String?) - 진행 중인 집중 기록 ID
  - `isLoading` (bool)
  - `errorMessage` (String?)
  - `copyWith` 메서드 포함

### 4-2. Timer Provider 작성

- [x] `lib/presentation/note_timer/provider/note_timer_provider.dart` 생성
  - Riverpod `StateNotifierProvider` 사용
  - UseCase들만 의존성 주입 (❌ Repository/DataSource 직접 참조 금지)
  - Timer 객체를 사용하여 1초마다 currentTime 증가
  - 메서드:
    - `loadNoteData(String noteId)` - 노트 정보 로드 및 진행 중인 세션 확인
    - `startFocus()` - 집중 시작 (FocusRecord 생성)
    - `endFocus()` - 집중 종료 (FocusRecord 업데이트, 타이머 정지)
    - `startBreak()` - 휴식 시작 (집중 일시정지, 휴식 타이머 시작)
    - `endBreak()` - 휴식 종료 (집중 재개)
    - `dispose()` - Timer 해제

### 4-3. Todo/Memo Tab Provider

- [x] 기존 `NoteDetailProvider` 재사용
  - 이미 할일/메모 관리 기능이 모두 구현되어 있음
  - `toggleTodo`, `deleteTodo`, `updateTodoTitle` 등 지원
  - 노트 타이머 페이지에서 `noteDetailProvider(noteId)` 사용

---

## 5. Presentation Layer - UI 구현

### 5-1. 노트 타이머 페이지 구조

- [x] `lib/presentation/pages/note_timer/note_timer_page.dart` 생성
  - Scaffold + AppBar
  - 타이머 영역 + 할일/메모 영역 (비율: 5:5)

### 5-2. AppBar 위젯

- [x] AppBar 구현
  - 뒤로가기 버튼 (좌측)
  - 노트 제목 (중앙)

### 5-3. 타이머 영역 위젯

- [x] 타이머 영역 구현 (인라인)
  - **메인 타이머 표시** (MM:SS 또는 HH:MM:SS)
    - 집중 모드일 때: 강조 표시 (큰 폰트, 진한 색)
    - 휴식 모드일 때: 회색 처리
  - **시작/종료 버튼**
    - 초기: "시작" 버튼
    - 실행 중: "종료" 버튼
  - **휴식 버튼**
    - 초기: "휴식" 버튼
    - 휴식 중: "그만 쉬기" 버튼
  - **오늘 총 시간 표시**
    - 집중 모드일 때: 강조 표시
    - 휴식 모드일 때: 회색 처리
  - **휴식 시간 표시**
    - 휴식 모드일 때만 활성화 (강조 표시)
    - 집중 모드일 때: 회색 처리

### 5-4. 할일/메모 탭 영역 위젯

- [x] 할일/메모 탭 구현 (인라인)
  - TabBar (할일 / 메모)
  - TabBarView로 탭 내용 전환

### 5-5. 할일 리스트 위젯

- [x] 할일 리스트 구현 (인라인)
  - 할일 항목 표시 (체크박스 + 제목)
  - 체크박스 클릭 시 완료 처리
  - 삭제 버튼
  - "+ 할일 추가" 버튼 (다이얼로그는 TODO)

### 5-6. 메모 리스트 위젯

- [x] 메모 리스트 구현 (인라인)
  - 메모 항목 표시 (내용 + 작성 시간)
  - 삭제 버튼
  - "+ 메모 추가" 버튼 (다이얼로그는 TODO)

### 5-7. 시간 포맷 유틸리티

- [x] `lib/core/utils/time_formatter.dart` 생성
  - `String formatTime(int seconds)` - 초를 MM:SS 또는 HH:MM:SS로 변환
  - 예: 65초 → "01:05", 3665초 → "01:01:05"

---

## 6. 라우팅 설정

- [x] `lib/presentation/router/router.dart`에 라우트 추가
  - `/note-timer/:noteId` 경로 추가
  - NoteTimerPage로 연결
  - noteId 파라미터 전달
- [x] MainPage에서 노트 클릭 시 `/note-timer/:noteId`로 이동
  - 노트 카드 헤더에 GestureDetector 추가
  - context.push('/note-timer/$noteId') 호출

---

## 7. 스톱워치 기능 구현 (간단 버전)

### 7-1. Timer 구현

- [x] `dart:async` 패키지의 `Timer.periodic` 사용
  - 1초마다 currentTime 증가
  - dispose 시 Timer 취소

### 7-2. 집중/휴식 전환 로직

- [x] 집중 시작: FocusRecord 생성, Timer 시작
- [x] 집중 종료: FocusRecord 업데이트 (endTime, duration), Timer 정지
- [x] 휴식 시작: 집중 Timer 일시정지, breakTime Timer 시작
- [x] 휴식 종료: breakTime Timer 정지, 집중 Timer 재개

### 7-3. 상태별 UI 업데이트

- [x] 집중 모드: 메인 타이머 강조, 오늘 총 시간 강조, 휴식 시간 회색
- [x] 휴식 모드: 메인 타이머 회색, 집중 시간 회색, 휴식 시간 강조

---

## 8. 코드 생성 및 빌드

- [ ] `flutter pub run build_runner build --delete-conflicting-outputs` 실행 (필요 시)
- [x] `flutter analyze` 실행하여 에러 확인 (warning만 있음, error 없음)

---

## 9. Clean Architecture 준수 확인

### 검증 체크리스트

- [x] ✅ Presentation에서 Data Layer (Repository 구현체, DataSource, DTO) 직접 참조 없음
- [x] ✅ Presentation에서 Supabase, Hive 등 외부 라이브러리 직접 사용 없음
- [x] ✅ Presentation은 UseCase만 호출 (note_timer_provider.dart 확인)
- [x] ⚠️ Domain Layer에서 Hive 패키지 import (TypeAdapter 생성 목적으로 허용)
- [x] ✅ Data Layer에서 Presentation 참조 없음
- [x] ✅ Repository는 Domain 인터페이스를 Data에서 구현
- [x] ✅ 모든 의존성은 get_it으로 주입

---

## 10. 스타일 가이드 준수

- [x] Color opacity는 `withValues(alpha:)` 사용 (❌ `withOpacity()` 금지)
- [x] 모든 크기는 flutter_screenutil 확장 사용 (`.w`, `.h`, `.sp`, `.r`)
- [x] 피그마 디자인 값(360x800 기준) 그대로 사용
- [x] 타이머 강조 색상: 노트 색상 사용
- [x] 회색 처리 색상: Color(0xFF323232).withValues(alpha: 0.4)

---

## 📝 추후 구현 예정 (이번 단계에서는 제외)

- 백그라운드 타이머 동작 (앱 종료 시에도 타이머 유지)
- 집중 기록 통계 기능
- 할일/메모 수정 기능 (이번 단계에서는 추가/삭제만)
- 타이머 알림 (집중 시간 목표 도달 시 알림)
- 타임테이블 기능 연동

---

## 🎯 이번 단계 완료 기준

1. 노트 타이머 페이지가 에러 없이 렌더링됨
2. 스톱워치 시작/종료 가능
3. 집중/휴식 모드 전환 가능
4. 메인 타이머, 오늘 총 시간, 휴식 시간이 실시간 업데이트됨
5. 상태별 UI 변경 (집중 모드 / 휴식 모드)
6. 할일/메모 탭 전환 가능
7. 할일 추가/삭제/완료 처리 가능
8. 메모 추가/삭제 가능
9. FocusRecord가 Hive에 정상 저장됨
10. Clean Architecture 의존성 규칙 위반 없음
11. 코딩 스타일 가이드 준수 (`withValues`, screenutil 등)
