# Note List 페이지 구현 체크리스트

## 개요

- **목표**: 노트 목록 페이지 구현 (사용중/보관함 탭, CRUD 기능, 드래그 앤 드롭 정렬)
- **디자인 기준**: 360x800 (flutter_screenutil 사용)
- **아키텍처**: Clean Architecture 준수 (Domain → Data → Presentation 의존성 규칙)

---

## 1. Domain Layer 확장

### 1-1. 도메인 모델 확장

- [x] `lib/domain/model/note_model.dart`에 필드 추가 확인
  - `isArchived` (bool, 보관 여부)
  - `isSelectedForToday` (bool, 오늘 사용 체크 여부)
  - `sortOrder` (int, 정렬 순서)
  - 기존 필드 확인: `isPinned`, `title`, `colorValue`, `createdAt`, `updatedAt`

### 1-2. Repository 인터페이스 확장

- [x] `lib/domain/repository/note_repository.dart`에 메서드 추가
  - `Future<List<NoteModel>> getAllActiveNotes()` - 사용중 노트 목록 (isArchived = false)
  - `Future<List<NoteModel>> getAllArchivedNotes()` - 보관함 노트 목록 (isArchived = true)
  - `Future<void> createNote(NoteModel note)` - 노트 추가
  - `Future<void> updateNote(NoteModel note)` - 노트 수정
  - `Future<void> deleteNote(String noteId)` - 노트 삭제
  - `Future<void> archiveNote(String noteId)` - 노트 보관
  - `Future<void> unarchiveNote(String noteId)` - 보관 해제
  - `Future<void> togglePinNote(String noteId)` - 고정/고정 해제
  - `Future<void> toggleSelectForToday(String noteId)` - 오늘 사용 체크
  - `Future<void> updateNoteOrder(List<String> noteIds)` - 드래그 앤 드롭으로 순서 변경
  - `Future<void> resetTodaySelection()` - 오늘 사용 체크 초기화 (오전 6시 이후)

### 1-3. UseCase 작성

- [x] `lib/domain/usecase/note/get_all_active_notes_usecase.dart`
- [x] `lib/domain/usecase/note/get_all_archived_notes_usecase.dart`
- [x] `lib/domain/usecase/note/create_note_usecase.dart`
- [x] `lib/domain/usecase/note/update_note_usecase.dart`
- [x] `lib/domain/usecase/note/delete_note_usecase.dart`
- [x] `lib/domain/usecase/note/archive_note_usecase.dart`
- [x] `lib/domain/usecase/note/unarchive_note_usecase.dart`
- [x] `lib/domain/usecase/note/toggle_pin_note_usecase.dart`
- [x] `lib/domain/usecase/note/toggle_select_for_today_usecase.dart`
- [x] `lib/domain/usecase/note/update_note_order_usecase.dart`
- [x] `lib/domain/usecase/note/reset_today_selection_usecase.dart`

---

## 2. Data Layer 확장

### 2-1. DataSource 확장

- [x] `lib/data/data_source/local_storage/note_local_data_source.dart`에 메서드 추가
  - `Future<List<NoteModel>> getAllActiveNotes()`
  - `Future<List<NoteModel>> getAllArchivedNotes()`
  - `Future<void> createNote(NoteModel note)`
  - `Future<void> updateNote(NoteModel note)`
  - `Future<void> deleteNote(String noteId)`
  - `Future<void> updateNoteOrder(List<String> noteIds)`

### 2-2. Repository 구현 확장

- [x] `lib/data/repository_impl/note_repository_impl.dart`에 메서드 구현
  - NoteRepository 인터페이스의 모든 메서드 구현
  - NoteLocalDataSource 의존성 주입 사용

### 2-3. Hive 코드 재생성

- [x] 모델 필드 추가 후 `flutter pub run build_runner build --delete-conflicting-outputs` 실행
  - `NoteModelAdapter` 재생성 확인

---

## 3. Dependency Injection 설정

- [x] `lib/core/di/service_locator.dart`에 UseCase 등록
  - `registerFactory<GetAllActiveNotesUseCase>(() => GetAllActiveNotesUseCase(getIt()))`
  - `registerFactory<GetAllArchivedNotesUseCase>(() => GetAllArchivedNotesUseCase(getIt()))`
  - `registerFactory<CreateNoteUseCase>(() => CreateNoteUseCase(getIt()))`
  - `registerFactory<UpdateNoteUseCase>(() => UpdateNoteUseCase(getIt()))`
  - `registerFactory<DeleteNoteUseCase>(() => DeleteNoteUseCase(getIt()))`
  - `registerFactory<ArchiveNoteUseCase>(() => ArchiveNoteUseCase(getIt()))`
  - `registerFactory<UnarchiveNoteUseCase>(() => UnarchiveNoteUseCase(getIt()))`
  - `registerFactory<TogglePinNoteUseCase>(() => TogglePinNoteUseCase(getIt()))`
  - `registerFactory<ToggleSelectForTodayUseCase>(() => ToggleSelectForTodayUseCase(getIt()))`
  - `registerFactory<UpdateNoteOrderUseCase>(() => UpdateNoteOrderUseCase(getIt()))`
  - `registerFactory<ResetTodaySelectionUseCase>(() => ResetTodaySelectionUseCase(getIt()))`

---

## 4. Presentation Layer - Provider 작성

### 4-1. State 클래스 정의

- [x] `lib/presentation/note_list/provider/note_list_state.dart` 생성
  - `activeNotes` (List<NoteModel>) - 사용중 노트 목록
  - `archivedNotes` (List<NoteModel>) - 보관함 노트 목록
  - `selectedTab` (int, 0: 사용중, 1: 보관함)
  - `isLoading` (bool)
  - `errorMessage` (String?)
  - `copyWith` 메서드 포함

### 4-2. Provider 작성

- [x] `lib/presentation/note_list/provider/note_list_provider.dart` 생성
  - Riverpod `StateNotifierProvider` 사용
  - UseCase들만 의존성 주입 (❌ Repository/DataSource 직접 참조 금지)
  - 메서드:
    - `loadActiveNotes()` - 사용중 노트 로드
    - `loadArchivedNotes()` - 보관함 노트 로드
    - `createNote(NoteModel note)` - 노트 추가
    - `updateNote(NoteModel note)` - 노트 수정
    - `deleteNote(String noteId)` - 노트 삭제
    - `archiveNote(String noteId)` - 보관
    - `unarchiveNote(String noteId)` - 보관 해제
    - `togglePin(String noteId)` - 고정 토글
    - `toggleSelectForToday(String noteId)` - 오늘 사용 체크
    - `updateOrder(int oldIndex, int newIndex)` - 드래그 앤 드롭 정렬
    - `switchTab(int tabIndex)` - 탭 전환

---

## 5. Presentation Layer - UI 구현

### 5-1. 노트 목록 페이지 구조

- [x] `lib/presentation/pages/note_list/note_list_page.dart` 생성
  - Scaffold + AppBar + TabBar
  - 2개 탭: 사용중, 보관함

### 5-2. AppBar 위젯

- [x] AppBar 구현
  - 뒤로가기 버튼 (좌측)
  - "노트 목록" 타이틀 (중앙)
  - 검색 버튼 (우측, 핑크색 배경, 전체 너비)

### 5-3. TabBar 위젯

- [x] TabBar 구현
  - 2개 탭: "사용중", "보관함"
  - 탭 인디케이터 스타일링

### 5-4. 노트 카드 위젯

- [x] `lib/presentation/pages/note_list/widgets/note_card.dart` 생성
  - 노트 제목 표시
  - 노트 색상 적용
  - 고정 아이콘 (isPinned = true일 때, 좌측 상단 빨간 핀)
  - 더보기 메뉴 버튼 (우측 상단, ⋮)
  - 체크박스 (좌측 하단, 오늘 사용 선택용)
  - 노트 클릭 시 상세 페이지로 이동 (추후 구현)
  - 드래그 핸들 (ReorderableListView 사용)

### 5-5. 더보기 메뉴 (PopupMenuButton)

- [x] 더보기 메뉴 구현
  - 고정/고정 해제 (isPinned 토글)
  - 수정 (노트 추가 페이지와 동일, 타이틀만 "노트 수정")
  - 보관/보관 해제 (탭에 따라 다름)
  - 삭제 (확인 다이얼로그 표시)

### 5-6. 노트 리스트 (ReorderableListView)

- [x] `lib/presentation/pages/note_list/widgets/note_list_view.dart` 생성
  - `ReorderableListView.builder` 사용
  - 고정된 노트는 상단에 고정 (고정되지 않은 노트는 고정 노트보다 위로 올릴 수 없음)
  - 빈 목록일 때 안내 메시지

### 5-7. FAB (Floating Action Button)

- [x] FAB 구현
  - 우측 하단 고정
  - "+" 아이콘
  - 클릭 시 노트 추가 페이지로 이동 (추후 구현)

### 5-8. 광고 배너

- [x] 하단 광고 배너 플레이스홀더
  - 빨간색 배경 + "광고배너" 텍스트
  - (추후 실제 광고 SDK 연동)

---

## 6. 라우팅 설정

- [x] `lib/presentation/router/router.dart`에 라우트 추가
  - `/note-list` 경로 추가
  - NoteListPage로 연결
- [x] MainPage에서 노트 목록 아이콘 클릭 시 `/note-list`로 이동 연결

---

## 7. 코드 생성 및 빌드

- [x] `flutter pub run build_runner build --delete-conflicting-outputs` 실행
  - Hive TypeAdapter 재생성 확인
- [x] `flutter analyze` 실행하여 에러 확인 (경고만 있음, 노트 목록 기능과 무관)

---

## 8. Clean Architecture 준수 확인

### 검증 체크리스트

- [x] ✅ Presentation에서 Data Layer (Repository 구현체, DataSource, DTO) 직접 참조 없음
- [x] ✅ Presentation에서 Supabase, Hive 등 외부 라이브러리 직접 사용 없음
- [x] ✅ Presentation은 UseCase만 호출 (note_list_provider.dart 확인)
- [x] ⚠️ Domain Layer에서 Hive 패키지 import (TypeAdapter 생성 목적으로 허용)
- [x] ✅ Data Layer에서 Presentation 참조 없음
- [x] ✅ Repository는 Domain 인터페이스를 Data에서 구현
- [x] ✅ 모든 의존성은 get_it으로 주입

---

## 9. 스타일 가이드 준수

- [x] Color opacity는 `withValues(alpha:)` 사용 (❌ `withOpacity()` 금지)
- [x] 모든 크기는 flutter_screenutil 확장 사용 (`.w`, `.h`, `.sp`, `.r`)
- [x] 피그마 디자인 값(360x800 기준) 그대로 사용
- [x] 고정 핀 아이콘 색상: 빨간색
- [x] 검색 버튼 배경: 핑크색 (0xFFFFB3C1)
- [x] 광고 배너 배경: 빨간색

---

## 📝 추후 구현 예정 (이번 단계에서는 제외)

- [x] 노트 추가/수정 페이지 - note-add-update-page-implementation-checklist.md
- [x] 노트 상세 페이지 - note-detail-page-implementation-checklist.md
- 검색 페이지 (할일 & 메모 검색)
- 오전 6시 자동 체크 초기화 (백그라운드 스케줄링)
- 실제 광고 SDK 연동

---

## 🎯 이번 단계 완료 기준

1. 노트 목록 페이지가 에러 없이 렌더링됨
2. 사용중/보관함 탭 전환 가능
3. 노트 카드에 제목, 색상, 고정 아이콘, 체크박스 표시
4. 더보기 메뉴로 고정/보관/삭제 기능 동작
5. 드래그 앤 드롭으로 노트 순서 변경 가능 (고정 노트는 항상 상단)
6. FAB 클릭 시 노트 추가 페이지로 이동 (페이지는 플레이스홀더)
7. Clean Architecture 의존성 규칙 위반 없음
8. 코딩 스타일 가이드 준수 (`withValues`, screenutil 등)
