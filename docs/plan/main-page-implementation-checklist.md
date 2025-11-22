# Main 페이지 구현 체크리스트

## 개요
- **목표**: Main 페이지의 대략적인 UI 구조 구현 (세부 기능은 추후 구현)
- **디자인 기준**: 360x800 (flutter_screenutil 사용)
- **아키텍처**: Clean Architecture 준수 (Domain → Data → Presentation 의존성 규칙)

---

## ✅ 1. Domain Layer 작성

### 1-1. 도메인 모델 정의
- [x] `lib/domain/model/note_model.dart` 생성
  - 노트 기본 정보 (id, title, color, isPinned 등)
- [x] `lib/domain/model/focus_record_model.dart` 생성
  - 집중 기록 정보 (noteId, startTime, endTime, duration 등)
- [x] Hive TypeAdapter 어노테이션 추가 (`@HiveType`, `@HiveField`)

### 1-2. Repository 인터페이스 정의
- [x] `lib/domain/repository/note_repository.dart` 생성
  - `Future<List<NoteModel>> getPinnedNotes()`
  - `Future<List<NoteModel>> getNotesByDate(DateTime date)`
- [x] `lib/domain/repository/focus_record_repository.dart` 생성
  - `Future<List<FocusRecordModel>> getRecordsByDate(DateTime date)`
  - `Future<int> getTotalFocusTimeByDate(DateTime date)` (초 단위)

### 1-3. UseCase 작성
- [x] `lib/domain/usecase/note/get_pinned_notes_usecase.dart`
- [x] `lib/domain/usecase/note/get_notes_by_date_usecase.dart`
- [x] `lib/domain/usecase/focus/get_records_by_date_usecase.dart`
- [x] `lib/domain/usecase/focus/get_total_focus_time_usecase.dart`

---

## ✅ 2. Data Layer 작성

### 2-1. DataSource 작성
- [x] `lib/data/data_source/local_storage/note_local_data_source.dart`
  - Hive Box<NoteModel> 사용
- [x] `lib/data/data_source/local_storage/focus_record_local_data_source.dart`
  - Hive Box<FocusRecordModel> 사용

### 2-2. Repository 구현
- [x] `lib/data/repository_impl/note_repository_impl.dart`
  - NoteRepository 인터페이스 구현
  - NoteLocalDataSource 의존성 주입
- [x] `lib/data/repository_impl/focus_record_repository_impl.dart`
  - FocusRecordRepository 인터페이스 구현
  - FocusRecordLocalDataSource 의존성 주입

### 2-3. Hive 설정 업데이트
- [x] `lib/data/data_source/local_storage/hive_setup.dart`에 TypeAdapter 등록
  - `Hive.registerAdapter(NoteModelAdapter())`
  - `Hive.registerAdapter(FocusRecordModelAdapter())`
- [x] Hive Box 열기 추가
  - `await Hive.openBox<NoteModel>('notes')`
  - `await Hive.openBox<FocusRecordModel>('focus_records')`

---

## ✅ 3. Dependency Injection 설정

- [x] `lib/core/di/service_locator.dart`에 수동 등록
  - DataSource: `registerSingleton<NoteLocalDataSource>`
  - DataSource: `registerSingleton<FocusRecordLocalDataSource>`
  - Repository: `registerSingleton<NoteRepository>(NoteRepositoryImpl(getIt()))`
  - Repository: `registerSingleton<FocusRecordRepository>(FocusRecordRepositoryImpl(getIt()))`
  - UseCase: `registerFactory<GetPinnedNotesUseCase>(() => GetPinnedNotesUseCase(getIt()))`
  - UseCase: 나머지 UseCase들도 registerFactory로 등록

---

## ✅ 4. Presentation Layer - Provider 작성

### 4-1. State 클래스 정의
- [x] `lib/presentation/main/provider/main_state.dart` 생성
  - `selectedDate` (DateTime)
  - `pinnedNotes` (List<NoteModel>)
  - `focusRecords` (List<FocusRecordModel>)
  - `totalFocusTime` (int, 초 단위)
  - `isTimeTableVisible` (bool)
  - `isTodoVisible` (bool)
  - `copyWith` 메서드 포함 (Riverpod용 순수 Dart 클래스)

### 4-2. Provider 작성
- [x] `lib/presentation/main/provider/main_provider.dart` 생성
  - Riverpod `StateProvider` 또는 함수형 Provider 사용
  - UseCase들만 의존성 주입 (❌ Repository/DataSource 직접 참조 금지)
  - 메서드: `loadDataByDate(DateTime)`, `toggleTimeTable()`, `toggleTodo()`

---

## ✅ 5. Presentation Layer - UI 구현

### 5-1. 메인 페이지 구조
- [x] `lib/presentation/pages/main/main_page.dart` 생성 (기존 home_page.dart 대체)
  - Scaffold + BottomNavigationBar
  - 3개 탭: Main, 통계, 내정보

### 5-2. Main 탭 화면
- [x] Main 탭 화면 기본 구조 (main_page.dart 내부)
  - AppBar
  - 날짜 영역 (주간 캘린더 플레이스홀더)
  - 컨트롤 영역
  - 메인 영역 (노트 리스트 + 타임테이블 플레이스홀더)
  - 하단 영역

### 5-3. AppBar 위젯
- [x] AppBar 기본 구조 포함
  - 드로어 아이콘 (좌측)
  - 날짜 표시 중앙 (예: "11월 13일 (토)")
  - 노트 목록 아이콘 (우측)

### 5-4. 날짜 영역 위젯
- [x] 주간 캘린더 플레이스홀더
  - (추후 세부 구현 예정)

### 5-5. 컨트롤 영역 위젯
- [x] 컨트롤 바 기본 구조
  - 할일 보기 버튼 (좌측)
  - 총 집중시간 표시 (중앙, "12H 30M" 형식)
  - 공유 버튼, 타임테이블 토글 버튼

### 5-6. 메인 영역 위젯
- [x] 노트 리스트 기본 구조
  - 노트 카드 예시 (수학, 영어)
  - 노트 목록 버튼 (하단)

### 5-7. 하단 영역 위젯
- [x] 하단 영역 기본 구조
  - 광고 배너 플레이스홀더
  - 오늘로 이동 버튼

### 5-8. BottomNavigationBar
- [x] Main, 통계, 내정보 3개 탭 아이콘 및 라벨
  - 통계/내정보 페이지는 Placeholder로 임시 구현

---

## ✅ 6. 코드 생성 및 빌드

- [x] `flutter pub run build_runner build --delete-conflicting-outputs` 실행
  - Hive TypeAdapter 생성 확인
- [x] `flutter run` 실행하여 UI 확인

---

## ✅ 7. Clean Architecture 준수 확인

### 검증 체크리스트
- [ ] ❌ Presentation에서 Data Layer (Repository 구현체, DataSource, DTO) 직접 참조 없음
- [ ] ❌ Presentation에서 Supabase, Hive 등 외부 라이브러리 직접 사용 없음
- [ ] ✅ Presentation은 UseCase만 호출
- [ ] ❌ Domain Layer에서 외부 패키지 import 없음 (순수 Dart만)
- [ ] ❌ Data Layer에서 Presentation 참조 없음
- [ ] ✅ Repository는 Domain 인터페이스를 Data에서 구현
- [ ] ✅ 모든 의존성은 get_it으로 주입

---

## ✅ 8. 스타일 가이드 준수

- [ ] Color opacity는 `withValues(alpha:)` 사용 (❌ `withOpacity()` 금지)
- [ ] 모든 크기는 flutter_screenutil 확장 사용 (`.w`, `.h`, `.sp`, `.r`)
- [ ] 피그마 디자인 값(360x800 기준) 그대로 사용

---

## 📝 추후 구현 예정 (이번 단계에서는 제외)

- 실제 데이터 CRUD 기능
- 타임테이블 상세 구현
- 할일 목록 상세 구현
- 노트 상세 페이지
- 공유 기능
- 광고 배너 연동
- 통계 페이지
- 내정보 페이지
- 드로어 메뉴
- 캘린더 팝업

---

## 🎯 이번 단계 완료 기준

1. Main 페이지가 에러 없이 렌더링됨
2. BottomNavigationBar로 3개 탭 전환 가능
3. 주간 캘린더에서 날짜 선택 시 UI 업데이트
4. 토글 버튼 동작 (타임테이블/할일 표시/숨김)
5. Clean Architecture 의존성 규칙 위반 없음
6. 코딩 스타일 가이드 준수 (`withValues`, screenutil 등)