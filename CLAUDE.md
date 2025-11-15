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
- **No Entity Layer:** DTO와 Domain Model만 사용 (Entity 제거됨)

## Key Files

- **`lib/main.dart`**: WidgetsFlutterBinding, Hive 초기화, DI 설정, ProviderScope 래핑
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

## Coding Style

- **Color opacity**: NEVER use `withOpacity()`. Always use `withValues(alpha: value)` instead.
  ```dart
  // ❌ Bad
  color: const Color(0xFFFFD147).withOpacity(0.2)

  // ✅ Good
  color: const Color(0xFFFFD147).withValues(alpha: 0.2)
  ```
