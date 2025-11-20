# Supabase Users Table Setup

닉네임 중복 체크 및 사용자 정보 관리를 위한 `users` 테이블 설정 가이드.

## 테이블 스키마

| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | UUID | PRIMARY KEY, FK → auth.users(id) | Supabase Auth User ID |
| email | TEXT | - | 이메일 주소 |
| nickname | TEXT | UNIQUE | 닉네임 (중복 불가) |
| profile_image_url | TEXT | - | 프로필 이미지 URL |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | 생성 일시 |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | 수정 일시 |

## SQL 실행 순서

Supabase Dashboard → SQL Editor에서 아래 쿼리를 **순서대로 하나씩** 실행하세요.

### 1단계: 테이블 생성
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  nickname TEXT UNIQUE,
  profile_image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 2단계: 인덱스 생성
```sql
CREATE INDEX idx_users_nickname ON users(nickname);
```

### 3단계: RLS 활성화
```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
```

### 4단계: SELECT 정책
```sql
CREATE POLICY "Users can view own data" ON users
  FOR SELECT USING (auth.uid() = id);
```

### 5단계: UPDATE 정책
```sql
CREATE POLICY "Users can update own data" ON users
  FOR UPDATE USING (auth.uid() = id);
```

### 6단계: INSERT 정책
```sql
CREATE POLICY "Users can insert own data" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);
```

### 7단계: 닉네임 중복 체크 정책 (Public Read)
```sql
CREATE POLICY "Anyone can check nickname duplicates" ON users
  FOR SELECT USING (nickname IS NOT NULL);
```

## RLS (Row Level Security) 정책 설명

- **SELECT (자기 데이터)**: 자신의 데이터만 조회 가능
- **SELECT (닉네임 체크)**: 모든 사용자가 닉네임 중복 확인 가능 (Public Read)
- **UPDATE**: 자신의 데이터만 수정 가능
- **INSERT**: 자신의 ID로만 데이터 생성 가능

## 중요 설계 포인트

### 1. ON DELETE CASCADE
```sql
REFERENCES auth.users(id) ON DELETE CASCADE
```
- 사용자가 계정 탈퇴 시 `auth.users`에서 삭제됨
- `users` 테이블의 해당 행도 자동 삭제 (데이터 일관성 유지)

### 2. 닉네임 중복 체크 정책
```sql
CREATE POLICY "Anyone can check nickname duplicates" ON users
  FOR SELECT USING (nickname IS NOT NULL);
```
- **문제**: 기본적으로 다른 사용자의 데이터를 조회할 수 없음
- **해결**: Public Read 정책 추가로 닉네임만 조회 가능하게 허용
- **보안**: `nickname IS NOT NULL` 조건으로 실제 존재하는 닉네임만 조회

### 3. 정책 우선순위
Supabase는 **OR 조건**으로 여러 정책을 평가합니다:
```
"Users can view own data" (자기 데이터)
OR
"Anyone can check nickname duplicates" (닉네임 체크)
```
→ 둘 중 하나라도 통과하면 조회 가능

### 4. 자동 사용자 생성 (Trigger)
```sql
-- 함수 생성
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, created_at)
  VALUES (new.id, new.email, now());
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger 등록
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```
- **효과**: 구글/카카오 로그인 시 자동으로 `users` 테이블에 행 생성
- **장점**: 앱 코드 수정 없이 DB 레벨에서 자동 동기화
- **nickname**: 초기값 NULL → 닉네임 입력 화면에서 UPDATE

### 5. 기존 데이터 마이그레이션
```sql
-- auth.users에는 있지만 users에 없는 유저 자동 생성
INSERT INTO public.users (id, email, created_at)
SELECT
  au.id,
  au.email,
  au.created_at
FROM auth.users au
LEFT JOIN public.users u ON au.id = u.id
WHERE u.id IS NULL;
```

## 관련 코드

- DataSource: `lib/data/data_source/remote/auth_data_source.dart`
  - `checkNicknameDuplicate()`: 닉네임 중복 체크
  - `updateNickname()`: 닉네임 업데이트
  - `updateUser()`: 사용자 정보 업데이트