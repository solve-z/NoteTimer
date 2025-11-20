# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

타이머+투두+메모 앱 with Clean Architecture. Flutter 프로젝트로 확장 가능한 구조를 목표로 설계됨.

## Architecture

**Clean Architecture 4-Layer Structure:**

```
lib/
├── main.dart                    # 앱 진입점 (Riverpod ProviderScope, DI/Hive 초기화)
├── core/                        # 공통 레이어 (모든 레이어에서 사용)
│   ├── di/                      # Dependency Injection (get_it)
│   ├── theme/                   # 테마 설정
│   └── utils/                   # 공통 유틸리티
├── domain/                      # 비즈니스 로직 (Framework 독립적)
│   ├── model/                   # 순수 도메인 모델
│   ├── repository/              # Repository 인터페이스 (추상)
│   └── usecase/                 # Use Cases (비즈니스 규칙)
├── data/                        # 데이터 레이어 (외부 의존성)
│   ├── data_source/
│   │   ├── local_storage/       # Hive 설정 및 Local DataSource
│   │   ├── remote/              # API DataSource
│   │   └── mock/                # Mock DataSource
│   ├── dto/                     # Data Transfer Objects (API 응답)
│   ├── mapper/                  # DTO ↔ Domain Model 변환
│   └── repository_impl/         # Repository 구현체
└── presentation/                # UI 레이어
    ├── main/provider/           # Riverpod Providers
    └── pages/                   # 화면별 UI 컴포넌트
```

**의존성 규칙:**
- Domain은 어떤 레이어도 참조하지 않음 (순수 Dart)
- Data는 Domain만 참조
- Presentation은 Domain만 참조 (Data 직접 참조 금지)
- Core는 모든 레이어에서 사용 가능

**주요 패턴:**
- **State Management:** flutter_riverpod
- **Dependency Injection:** get_it (수동 등록 방식, injectable 설정은 있으나 미사용)
- **Local Database:** Hive (TypeAdapter로 Domain Model 직접 저장)
- **Responsive UI:** flutter_screenutil (피그마 디자인 기준: 360x800)
- **No Entity Layer:** DTO와 Domain Model만 사용 (Entity 제거됨)

## Key Files

- **`lib/main.dart`**: WidgetsFlutterBinding, Hive 초기화, DI 설정, ScreenUtilInit(360x800), ProviderScope 래핑
- **`lib/core/di/service_locator.dart`**: get_it 수동 등록 (getIt.registerSingleton/Factory)
- **`lib/data/data_source/local_storage/hive_setup.dart`**: Hive.initFlutter(), TypeAdapter 등록, Box 열기

## Development Commands

```bash
# 의존성 설치
flutter pub get

# 앱 실행
flutter run

# 코드 생성 (Hive TypeAdapter 등)
flutter pub run build_runner build --delete-conflicting-outputs

# 테스트 실행
flutter test

# 빌드
flutter build apk          # Android
flutter build ios          # iOS
flutter build windows      # Windows
```

## Adding New Features

1. **Domain 모델 정의** (`domain/model/`)
2. **Hive TypeAdapter 생성** (코드 생성 사용)
3. **Repository 인터페이스** (`domain/repository/`)
4. **Repository 구현** (`data/repository_impl/`)
5. **DataSource 구현** (`data/data_source/local_storage/`)
6. **UseCase 작성** (`domain/usecase/`)
7. **DI 등록** (`core/di/service_locator.dart`에 수동 등록)
8. **Riverpod Provider** (`presentation/main/provider/`)
9. **UI 구현** (`presentation/pages/`)

## Important Notes

- Hive TypeAdapter는 `@HiveType`, `@HiveField` 어노테이션 사용 후 build_runner 실행
- get_it 등록은 `setupServiceLocator()` 함수에서 수동으로 추가
- Repository는 Domain의 인터페이스를 Data에서 구현
- DTO는 API 응답용, Domain Model은 앱 내부 로직용으로 분리
- 에러 처리는 try-catch 사용 (dartz/fpdart 미사용)
- **Supabase SQL 쿼리**: 모든 데이터베이스 스키마 및 설정 SQL은 `docs/` 폴더에 마크다운 파일로 문서화
  - 파일명 형식: `supabase-{테이블명}-setup.md`
  - 예시: `docs/supabase-users-table-setup.md`, `docs/supabase-google-oauth-setup.md`

## Clean Architecture 준수 규칙

**IMPORTANT: 모든 코드 작성 시 Clean Architecture 의존성 규칙을 엄격히 준수해야 합니다.**

### 의존성 방향 규칙
```
Presentation → Domain ← Data
     ↓           ↑
   Core ←────────┘
```

### 레이어별 금지 사항

#### ❌ Presentation Layer (UI)
- **절대 금지**: Data Layer 직접 참조 (Repository 구현체, DataSource, DTO 등)
- **절대 금지**: Supabase, Hive 등 외부 라이브러리 직접 사용
- **허용**: Domain (Model, Repository 인터페이스, UseCase), Core, Riverpod Provider

```dart
// ❌ BAD - Presentation에서 Data 직접 참조
import '../../data/data_source/remote/auth_data_source.dart';
final user = await AuthDataSource().getCurrentUser();

// ✅ GOOD - UseCase 통해서만 접근
final getUserUseCase = getIt<GetCurrentUserUseCase>();
final user = await getUserUseCase();
```

#### ❌ Domain Layer (비즈니스 로직)
- **절대 금지**: 어떤 레이어도 참조 불가 (순수 Dart만 사용)
- **절대 금지**: Flutter, Supabase, Hive 등 모든 외부 패키지
- **허용**: Dart 기본 라이브러리만 (dart:core, dart:async 등)

```dart
// ❌ BAD - Domain에서 외부 패키지 사용
import 'package:supabase_flutter/supabase_flutter.dart';

// ✅ GOOD - 순수 Dart만 사용
class UserModel {
  final String id;
  final String? nickname;
}
```

#### ❌ Data Layer (데이터 소스)
- **절대 금지**: Presentation Layer 참조 (Provider, Widget 등)
- **허용**: Domain의 Model과 Repository 인터페이스만 참조
- **허용**: Supabase, Hive 등 데이터 관련 외부 라이브러리

```dart
// ❌ BAD - Data에서 Presentation 참조
import '../../presentation/main/provider/auth_provider.dart';

// ✅ GOOD - Domain만 참조
import '../../domain/model/user_model.dart';
import '../../domain/repository/auth_repository.dart';
```

### 새 기능 추가 시 체크리스트

1. **UseCase 먼저 작성** - Domain Layer에 비즈니스 로직 정의
2. **Repository 인터페이스 확인** - Domain에 필요한 메서드가 있는지 확인
3. **Repository 구현** - Data Layer에서 실제 데이터 소스 연결
4. **DI 등록** - `service_locator.dart`에 수동 등록
5. **Provider 작성** - Presentation에서 UseCase만 호출
6. **UI 구현** - Provider를 통해서만 데이터 접근

### 의존성 위반 예방

- 코드 작성 전 "이 레이어가 저 레이어를 참조해도 되는가?" 항상 확인
- `main.dart`나 `router.dart`에서 직접 DataSource 호출 금지
- 비즈니스 로직은 항상 UseCase에 작성
- UI에서 데이터 필요 시 반드시 UseCase 경유

## Coding Style

- **Color opacity**: NEVER use `withOpacity()`. Always use `withValues(alpha: value)` instead.
  ```dart
  // ❌ Bad
  color: const Color(0xFFFFD147).withOpacity(0.2)

  // ✅ Good
  color: const Color(0xFFFFD147).withValues(alpha: 0.2)
  ```

- **Responsive sizing**: ALWAYS use flutter_screenutil extensions for sizes (피그마 값 그대로 사용)
  ```dart
  // ✅ Good - 피그마 디자인 기준 (360x800)
  SizedBox(height: 60.h)          // 높이
  Container(width: 200.w)         // 너비
  Text(style: TextStyle(fontSize: 16.sp))  // 폰트 크기
  BorderRadius.circular(8.r)      // 반경
  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)  // 패딩/마진

  // ❌ Bad - 고정 값 사용 금지
  SizedBox(height: 60)
  Container(width: 200)
  ```
