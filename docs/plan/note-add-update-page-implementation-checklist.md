# Note Add & Update 페이지 구현 체크리스트

## 개요

- **목표**: 노트 추가/수정 페이지 구현 (노트 생성, 수정, 색상 선택)
- **디자인 기준**: 360x800 (flutter_screenutil 사용)
- **아키텍처**: Clean Architecture 준수 (Domain → Data → Presentation 의존성 규칙)

---

## 1. Domain Layer 확장 (필요시)

### 1-1. 색상 상수 정의

- [x] `lib/core/constants/note_colors.dart` 생성
  - 16가지 노트 색상 상수 정의 (4x4 그리드)
  - 색상 값 리스트 제공

### 1-2. UseCase 확인

- [x] 기존 UseCase 사용 확인
  - `CreateNoteUseCase` - 노트 추가
  - `UpdateNoteUseCase` - 노트 수정
  - (이미 구현됨, 추가 작업 불필요)

---

## 2. Data Layer (추가 작업 없음)

- [x] 기존 DataSource 및 Repository 사용
  - `NoteLocalDataSource.addNote()` - 노트 추가
  - `NoteLocalDataSource.updateNote()` - 노트 수정

---

## 3. Dependency Injection (추가 작업 없음)

- [x] 기존 DI 설정 사용
  - `CreateNoteUseCase` 이미 등록됨
  - `UpdateNoteUseCase` 이미 등록됨

---

## 4. Presentation Layer - Provider 작성

### 4-1. State 클래스 정의

- [x] `lib/presentation/note_add_update/provider/note_form_state.dart` 생성
  - `noteTitle` (String) - 노트 이름
  - `selectedColor` (int) - 선택된 색상 값
  - `isEditMode` (bool) - 수정 모드 여부
  - `editingNoteId` (String?) - 수정 중인 노트 ID
  - `isSaving` (bool) - 저장 중 상태
  - `errorMessage` (String?) - 에러 메시지
  - `copyWith` 메서드 포함

### 4-2. Provider 작성

- [x] `lib/presentation/note_add_update/provider/note_form_provider.dart` 생성
  - Riverpod `StateNotifierProvider` 사용
  - UseCase들만 의존성 주입 (❌ Repository/DataSource 직접 참조 금지)
  - 메서드:
    - `setNoteTitle(String title)` - 노트 이름 설정
    - `setSelectedColor(int colorValue)` - 색상 설정
    - `loadNoteForEdit(NoteModel note)` - 수정할 노트 로드
    - `saveNote()` - 노트 저장 (추가 또는 수정)
    - `reset()` - 상태 초기화

---

## 5. Presentation Layer - UI 구현

### 5-1. 노트 추가/수정 페이지 구조

- [x] `lib/presentation/pages/note_add_update/note_add_update_page.dart` 생성
  - Scaffold + AppBar
  - 노트 표지 미리보기
  - 노트 이름 입력 필드
  - 노트 색상 선택 영역
  - 키보드 영역

### 5-2. AppBar 위젯

- [x] AppBar 구현
  - 뒤로가기 버튼 (좌측)
  - 타이틀: "노트 추가" 또는 "노트 수정" (모드에 따라 표시)
  - 완료 버튼 (우측 상단, 키보드 영역 고려)

### 5-3. 노트 표지 미리보기 위젯

- [x] `lib/presentation/pages/note_add_update/widgets/note_cover_preview.dart` 생성
  - 중앙 상단에 표지 카드 표시
  - 선택한 색상으로 배경 표시
  - 입력한 노트 이름 실시간 반영
  - 텍스트 자동 줄바꿈 처리

### 5-4. 노트 이름 입력 필드

- [x] TextField 구현
  - 화면 진입 시 자동 포커스
  - 플레이스홀더: "노트 이름을 입력하세요"
  - 실시간으로 Provider 상태 업데이트
  - 텍스트 변경 시 표지 미리보기 반영

### 5-5. 노트 색상 선택 영역

- [x] 색상 선택 Row 구현
  - 좌측: "노트 색상" 레이블
  - 우측: 현재 선택된 색상 원형 아이콘
  - 클릭 시 색상 선택 다이얼로그 표시

### 5-6. 색상 선택 다이얼로그

- [x] `lib/presentation/pages/note_add_update/widgets/color_picker_dialog.dart` 생성
  - 16가지 색상 그리드 (4x4)
  - 각 색상을 원형 아이콘으로 표시
  - 현재 선택된 색상 표시 (테두리 등)
  - 하단 버튼: "취소", "선택"
  - 선택 버튼 클릭 시 Provider 상태 업데이트 및 다이얼로그 닫기

### 5-7. 키보드 영역

- [x] 키보드 영역 처리
  - 키보드가 올라올 때 레이아웃 조정
  - `Scaffold`의 `resizeToAvoidBottomInset: true` 설정

### 5-8. 완료 버튼 동작

- [x] 완료 버튼 로직 구현
  - 노트 이름 유효성 검사 (빈 값 체크)
  - 추가 모드: `CreateNoteUseCase` 호출
  - 수정 모드: `UpdateNoteUseCase` 호출
  - 저장 성공 시 이전 화면으로 이동
  - 저장 실패 시 에러 메시지 표시

---

## 6. 라우팅 설정

- [x] `lib/presentation/router/router.dart`에 라우트 추가

  - `/note-add` 경로 추가 (추가 모드)
  - `/note-edit` 경로 추가 (수정 모드, NoteModel extra 파라미터)
  - NoteAddUpdatePage로 연결

- [x] 기존 페이지에서 연결
  - NoteListPage의 FAB 클릭 시 `/note-add`로 이동
  - NoteCard의 수정 메뉴 클릭 시 `/note-edit`로 이동 (note 전달)

---

## 7. 코드 생성 및 빌드

- [x] `flutter analyze` 실행하여 에러 확인 (노트 추가/수정 관련 에러 없음)
- [x] `flutter run` 실행하여 UI 확인
  - 노트 추가 기능 테스트
  - 노트 수정 기능 테스트
  - 색상 선택 다이얼로그 테스트
  - 표지 미리보기 실시간 반영 확인

---

## 8. Clean Architecture 준수 확인

### 검증 체크리스트

- [x] ✅ Presentation에서 Data Layer (Repository 구현체, DataSource, DTO) 직접 참조 없음
- [x] ✅ Presentation에서 Supabase, Hive 등 외부 라이브러리 직접 사용 없음
- [x] ✅ Presentation은 UseCase만 호출 (note_form_provider.dart 확인)
- [x] ✅ Data Layer에서 Presentation 참조 없음
- [x] ✅ 모든 의존성은 get_it으로 주입

---

## 9. 스타일 가이드 준수

- [x] Color opacity는 `withValues(alpha:)` 사용 (❌ `withOpacity()` 금지)
- [x] 모든 크기는 flutter_screenutil 확장 사용 (`.w`, `.h`, `.sp`, `.r`)
- [x] 피그마 디자인 값(360x800 기준) 그대로 사용
- [x] 색상 아이콘은 원형으로 표시
- [x] 완료 버튼 색상 및 스타일 일관성 유지

---

## 📝 추후 구현 예정 (이번 단계에서는 제외)

- 노트 이름 글자 수 제한
- 노트 표지 미리보기 애니메이션
- 색상 선택 다이얼로그 애니메이션
- 키보드 완료 버튼으로 저장
- 노트 순서 변경

---

## 🎯 이번 단계 완료 기준

1. 노트 추가 페이지가 에러 없이 렌더링됨
2. 노트 이름 입력 시 표지 미리보기에 실시간 반영
3. 색상 선택 다이얼로그에서 16가지 색상 선택 가능
4. 완료 버튼 클릭 시 노트 추가/수정 성공
5. 저장 후 노트 목록 페이지로 이동 및 목록 갱신
6. Clean Architecture 의존성 규칙 위반 없음
7. 코딩 스타일 가이드 준수 (`withValues`, screenutil 등)
