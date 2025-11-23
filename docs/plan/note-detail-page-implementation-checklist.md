# Note Detail 페이지 구현 체크리스트

## 개요

- **목표**: 노트 상세 페이지 구현 (할일/메모 탭, 노트별/날짜별 그룹화, 접기/펼치기)
- **디자인 기준**: 360x800 (flutter_screenutil 사용)
- **아키텍처**: Clean Architecture 준수 (Domain → Data → Presentation 의존성 규칙)

---

## 1. Domain Layer 확장

### 1-1. 도메인 모델 생성

- [x] TodoModel 생성 (`lib/domain/model/todo_model.dart`)
  - `@HiveType(typeId: 3)` 사용
  - id, title, isCompleted, assignedDate, noteId, createdAt, updatedAt, userId, sortOrder
- [x] MemoModel 생성 (`lib/domain/model/memo_model.dart`)
  - `@HiveType(typeId: 4)` 사용
  - id, content, assignedDate, noteId, createdAt, updatedAt, userId, sortOrder
- [x] NoteModel 확인 (기존 모델 사용)

### 1-2. Repository 인터페이스 생성

- [x] TodoRepository 생성 (`lib/domain/repository/todo_repository.dart`)
  - `getTodosByNoteId()`, `getTodosByDate()`, `getTodosByNoteIdAndDate()`
  - `createTodo()`, `updateTodo()`, `deleteTodo()`
  - `toggleTodoCompletion()`, `moveTodoToDate()`, `updateTodoOrder()`
- [x] MemoRepository 생성 (`lib/domain/repository/memo_repository.dart`)
  - `getMemosByNoteId()`, `getMemosByDate()`, `getMemosByNoteIdAndDate()`
  - `createMemo()`, `updateMemo()`, `deleteMemo()`
  - `moveMemoToDate()`, `updateMemoOrder()`, `getMemoById()`
- [x] NoteRepository 확장 (`getNoteById()` 메서드 추가)

### 1-3. UseCase 작성

- [x] `lib/domain/usecase/todo/get_todos_by_note_id_usecase.dart`
- [x] `lib/domain/usecase/todo/toggle_todo_complete_usecase.dart`
- [x] `lib/domain/usecase/todo/move_todo_to_date_usecase.dart`
- [x] `lib/domain/usecase/todo/delete_todo_usecase.dart`
- [x] `lib/domain/usecase/todo/update_todo_usecase.dart`
- [x] `lib/domain/usecase/memo/get_memos_by_note_id_usecase.dart`
- [x] `lib/domain/usecase/note/get_note_by_id_usecase.dart`

---

## 2. Data Layer 확장

### 2-1. DataSource 생성

- [x] `TodoLocalDataSource` 생성 (`lib/data/data_source/local_storage/todo_local_data_source.dart`)
  - Hive Box 사용하여 CRUD 구현
  - `getTodosByNoteId()`, `getTodosByDate()`, `getTodosByNoteIdAndDate()`
  - `createTodo()`, `updateTodo()`, `deleteTodo()`, `toggleTodoCompletion()`, `moveTodoToDate()` 등

- [x] `MemoLocalDataSource` 생성 (`lib/data/data_source/local_storage/memo_local_data_source.dart`)
  - Hive Box 사용하여 CRUD 구현
  - `getMemosByNoteId()`, `getMemosByDate()`, `getMemosByNoteIdAndDate()`
  - `createMemo()`, `updateMemo()`, `deleteMemo()`, `moveMemoToDate()`, `getMemoById()` 등

### 2-2. Repository 구현 생성

- [x] `TodoRepositoryImpl` 생성 (`lib/data/repository_impl/todo_repository_impl.dart`)
  - TodoRepository 인터페이스 구현
  - TodoLocalDataSource 의존성 주입

- [x] `MemoRepositoryImpl` 생성 (`lib/data/repository_impl/memo_repository_impl.dart`)
  - MemoRepository 인터페이스 구현
  - MemoLocalDataSource 의존성 주입

- [x] `NoteRepositoryImpl`에 `getNoteById()` 메서드 구현 추가

### 2-3. Hive 설정

- [x] `hive_setup.dart`에 TodoModel, MemoModel import 추가
- [x] TodoModelAdapter, MemoModelAdapter 등록 추가
- [x] Todo, Memo Box 초기화 코드 추가
- [x] build_runner 실행하여 TypeAdapter 코드 생성 (`.g.dart` 파일)

---

## 3. Dependency Injection 설정

- [x] `lib/core/di/service_locator.dart`에 import 추가
  - TodoLocalDataSource, MemoLocalDataSource
  - TodoRepositoryImpl, MemoRepositoryImpl
  - TodoRepository, MemoRepository
  - TodoModel, MemoModel
  - Todo/Memo UseCases

- [x] DataSource 등록
  - `TodoLocalDataSource(Hive.box<TodoModel>('todos'))`
  - `MemoLocalDataSource(Hive.box<MemoModel>('memos'))`

- [x] Repository 등록
  - `TodoRepositoryImpl(getIt<TodoLocalDataSource>())`
  - `MemoRepositoryImpl(getIt<MemoLocalDataSource>())`

- [x] UseCase 등록
  - `GetTodosByNoteIdUseCase`, `ToggleTodoCompleteUseCase`
  - `MoveTodoToDateUseCase`, `DeleteTodoUseCase`, `UpdateTodoUseCase`
  - `GetMemosByNoteIdUseCase`
  - `GetNoteByIdUseCase`

---

## 4. Presentation Layer - Provider 작성

### 4-1. State 클래스 정의

- [x] `lib/presentation/note_detail/provider/note_detail_state.dart` 생성
  - `note` (NoteModel?) - 현재 노트 정보
  - `todos` (List<TodoModel>) - 할일 목록
  - `memos` (List<MemoModel>) - 메모 목록
  - `selectedTab` (int, 0: 할일, 1: 메모)
  - `expandedNotes` (Set<String>) - 펼쳐진 노트 그룹 ID Set
  - `expandedDates` (Map<String, Set<String>>) - 노트별 펼쳐진 날짜 Set
  - `isLoading` (bool)
  - `errorMessage` (String?)
  - `copyWith` 메서드 포함

### 4-2. Provider 작성

- [x] `lib/presentation/note_detail/provider/note_detail_provider.dart` 생성
  - Riverpod `StateNotifierProvider.family` 사용 (noteId 파라미터)
  - UseCase들만 의존성 주입 (Clean Architecture 준수)
  - 메서드:
    - `loadNoteDetail(String noteId)` - 노트 정보 및 할일/메모 로드
    - `toggleTodoComplete(String todoId)` - 할일 완료/미완료 토글
    - `moveTodoToDate(String todoId, DateTime date)` - 할일 날짜 이동
    - `deleteTodo(String todoId)` - 할일 삭제
    - `toggleNoteExpanded(String noteId)` - 노트 그룹 접기/펼치기
    - `toggleDateExpanded(String noteId, String date)` - 날짜 그룹 접기/펼치기
    - `switchTab(int tabIndex)` - 탭 전환

---

## 5. Presentation Layer - UI 구현

### 5-1. 노트 상세 페이지 구조

- [ ] `lib/presentation/pages/note_detail/note_detail_page.dart` 생성
  - Scaffold + AppBar + TabBar
  - 2개 탭: 할일, 메모

### 5-2. AppBar 위젯

- [ ] AppBar 구현
  - 뒤로가기 버튼 (좌측)
  - 노트 이름 타이틀 (중앙)
  - (옵션) 노트 메뉴 버튼 (우측)

### 5-3. TabBar 위젯

- [ ] TabBar 구현
  - 2개 탭: "할일", "메모"
  - 탭 인디케이터 스타일링

### 5-4. 노트 그룹 헤더 위젯

- [ ] `lib/presentation/pages/note_detail/widgets/note_group_header.dart` 생성
  - 노트 아이콘 (색상 표시)
  - 노트 이름
  - 할일 개수 (할일 탭만)
  - "보관중" 배지 (보관된 노트)
  - 접기/펼치기 아이콘
  - 클릭 시 토글 동작

### 5-5. 날짜 그룹 헤더 위젯

- [ ] `lib/presentation/pages/note_detail/widgets/date_group_header.dart` 생성
  - 날짜 표시 (YYYY/MM/DD)
  - 접기/펼치기 아이콘
  - 미완료 할일 색상 규칙 (지난날 미완료 있으면 색상 변경)
  - 클릭 시 토글 동작

### 5-6. 할일 아이템 위젯

- [ ] `lib/presentation/pages/note_detail/widgets/todo_item.dart` 생성
  - 체크박스 (완료/미완료)
  - 할일 제목
  - 더보기 메뉴 (⋮): 수정/삭제/이동
  - 보관중 노트: 전체 비활성화, 회색 배경

### 5-7. 메모 아이템 위젯

- [ ] `lib/presentation/pages/note_detail/widgets/memo_item.dart` 생성
  - 메모 내용 표시 (3줄 정도 미리보기)
  - 메모 배경색 (노트 색상)
  - 클릭 시 메모 상세 페이지로 이동
  - 보관중 노트도 클릭 가능 (메모는 수정 가능)

### 5-8. 날짜 이동 다이얼로그

- [ ] `lib/presentation/pages/note_detail/widgets/move_todo_dialog.dart` 생성
  - 캘린더 위젯 (기본값: 오늘)
  - 날짜 선택
  - 확인/취소 버튼

### 5-9. 할일/메모 리스트 뷰

- [ ] `lib/presentation/pages/note_detail/widgets/todo_list_view.dart` 생성
  - 노트별 그룹화 → 날짜별 그룹화 (2단계)
  - 접기/펼치기 상태 관리
  - 빈 목록 안내 메시지

- [ ] `lib/presentation/pages/note_detail/widgets/memo_list_view.dart` 생성
  - 노트별 그룹화 → 날짜별 그룹화 (2단계)
  - 접기/펼치기 상태 관리
  - 빈 목록 안내 메시지

---

## 6. 라우팅 설정

- [ ] `lib/presentation/router/router.dart`에 라우트 추가
  - `/note-detail/:noteId` 경로 추가 (noteId 파라미터)
  - NoteDetailPage로 연결

- [ ] 기존 페이지에서 연결
  - NoteCard 클릭 시 `/note-detail/:noteId`로 이동
  - (추후) MainPage의 "오늘 사용" 노트 클릭 시 이동

---

## 7. 코드 생성 및 빌드

- [ ] `flutter analyze` 실행하여 에러 확인
- [ ] `flutter run` 실행하여 UI 확인
  - 할일 탭 표시 확인
  - 메모 탭 표시 확인
  - 노트 그룹 접기/펼치기 동작
  - 날짜 그룹 접기/펼치기 동작
  - 할일 완료/미완료 토글
  - 할일 날짜 이동
  - 보관중 노트 비활성화 처리 (할일만)

---

## 8. Clean Architecture 준수 확인

### 검증 체크리스트

- [ ] ✅ Presentation에서 Data Layer (Repository 구현체, DataSource, DTO) 직접 참조 없음
- [ ] ✅ Presentation에서 Supabase, Hive 등 외부 라이브러리 직접 사용 없음
- [ ] ✅ Presentation은 UseCase만 호출 (note_detail_provider.dart 확인)
- [ ] ✅ Data Layer에서 Presentation 참조 없음
- [ ] ✅ 모든 의존성은 get_it으로 주입

---

## 9. 스타일 가이드 준수

- [ ] Color opacity는 `withValues(alpha:)` 사용 (❌ `withOpacity()` 금지)
- [ ] 모든 크기는 flutter_screenutil 확장 사용 (`.w`, `.h`, `.sp`, `.r`)
- [ ] 피그마 디자인 값(360x800 기준) 그대로 사용
- [ ] 보관중 배지 스타일링 일관성
- [ ] 비활성화 상태 회색 처리
- [ ] 메모 배경색은 노트 색상과 동일

---

## 📝 추후 구현 예정 (이번 단계에서는 제외)

- 검색 키워드 하이라이트 (형광펜 효과)
- 할일 수정 인라인 편집
- 메모 상세 페이지
- 드래그 앤 드롭으로 할일 순서 변경
- 할일 일괄 날짜 이동
- 완료된 할일 숨기기/보이기 토글

---

## 🎯 이번 단계 완료 기준

1. 노트 상세 페이지가 에러 없이 렌더링됨
2. 할일/메모 탭 전환 가능
3. 노트별 → 날짜별 2단계 그룹화 표시
4. 노트 그룹 접기/펼치기 동작
5. 날짜 그룹 접기/펼치기 동작
6. 할일 체크박스로 완료/미완료 토글
7. 할일 더보기 메뉴로 수정/삭제/이동 가능
8. 보관중 노트의 할일은 비활성화 처리
9. 메모 클릭 시 메모 상세 페이지로 이동 (추후 구현)
10. Clean Architecture 의존성 규칙 위반 없음
11. 코딩 스타일 가이드 준수 (`withValues`, screenutil 등)