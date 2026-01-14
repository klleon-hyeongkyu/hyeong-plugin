# web-almigo 프로젝트 패턴 분석

**분석일**: 2026-01-14

## 프로젝트 개요

- **Stack**: Next.js 16 + React 19 + Tailwind CSS v4
- **상태관리**: TanStack Query, TanStack Form
- **i18n**: next-intl (ko, en, ja)

## 현재 hyeong-plugin 스킬 현황

- ✅ `web-tailwind-patterns` (Tailwind v3/v4)
- ✅ `web-tanstack-form-patterns` (TanStack Form)
- ✅ `web-tanstack-query-patterns` (TanStack Query)
- ✅ `web-artifacts-builder` (React artifact 번들링)

## web-almigo 내부 스킬 분석

| 스킬 | 범용성 | 설명 |
|------|--------|------|
| `api-patterns` | ❌ 프로젝트 특화 | Klleon API 인터셉터, FailResponse 타입 |
| `form-patterns` | ❌ 프로젝트 특화 | Almigo UI 컴포넌트 연동 |
| `component-patterns` | 🟡 일부 범용 | Skeleton, Modal 패턴 |
| `project-patterns` | 🟡 일부 범용 | Context, Feature 모듈 패턴 |
| `localization-patterns` | ✅ 범용 | next-intl 패턴 |
| `i18n-sync` | ❌ 프로젝트 특화 | Google Sheets 동기화 |
| `sdk-patterns` | ❌ 프로젝트 특화 | Klleon SDK |
| `styling-patterns` | ❌ 프로젝트 특화 | Figma 토큰 매핑 |

---

## 🎯 새 스킬 추천

### 1. web-nextjs-patterns ⭐ 우선순위 1

**범용 패턴:**
- App Router (Next.js 15+) 구조
- Server Components vs Client Components
- Streaming with Suspense
- SSR/Hydration 에러 해결
- i18n 라우팅 통합
- Middleware 대체 (proxy.ts)
- 환경변수 설정 (Amplify Lambda 호환)

**CLAUDE.md에서 발견한 패턴:**
```tsx
// ❌ middleware.ts (Next.js 16 deprecated)
// ✅ proxy.ts 사용

// ❌ isMounted 직접 구현
const [isMounted, setIsMounted] = useState(false);

// ✅ Client 컴포넌트 사용
import Client from '@/components/Client';
<Client fallback={<Loading />}>
  <ClientOnlyComponent />
</Client>

// ✅ SSR + Suspense 분리
<header>정적 컨텐츠 (SSR)</header>
<Suspense fallback={<Skeleton />}>
  <DataProvider><DataBody /></DataProvider>
</Suspense>

// ❌ process.env.NEW_KEY (API Route에서 Amplify Lambda 접근 불가)
// ✅ next.config.ts의 env 객체에 추가
```

---

### 2. web-context-patterns 🟢 우선순위 2

**범용 패턴:**
- `use-context-selector` 최적화
- Provider/hooks 분리
- Selector 패턴
- 불필요한 리렌더링 방지

**CLAUDE.md에서 발견한 패턴:**
```tsx
// ❌ Provider에 모든 로직
export const MyProvider = ({ children }) => {
  const [state, setState] = useState(...);
  const handleA = useCallback(...);
  const handleB = useCallback(...);
  // 100줄의 로직...
  return <MyContext.Provider value={...}>{children}</MyContext.Provider>;
};

// ✅ hooks로 분리
const useMyFeature = () => {
  const [state, setState] = useState(...);
  const handleA = useCallback(...);
  return useMemo(() => ({ state, handleA, ... }), [...]);
};

export const MyProvider = ({ children }) => {
  const value = useMyFeature();
  return <MyContext.Provider value={value}>{children}</MyContext.Provider>;
};

// ❌ 전체 context 구독
const { characters, stats, handleEdit } = useMyContext();

// ✅ selector로 필요한 값만
const characters = useMySelector(ctx => ctx.state.characters);
const handleEdit = useMySelector(ctx => ctx.actions.handleEdit);
```

---

### 3. web-i18n-nextintl-patterns 🟡 우선순위 2

**범용 패턴:**
- next-intl 설정
- locale 유지 라우팅
- 번역 키 네이밍 규칙
- 타입 안전 번역

**CLAUDE.md에서 발견한 패턴:**
```tsx
// ❌ next/link → locale 유실
import { Link } from 'next/link';

// ✅ i18n-aware navigation
import { Link, useRouter, usePathname } from '@/i18n/navigation';

// ❌ 번역 키에 . 포함
t('Common.키')  // next-intl 네임스페이스 구분자로 해석

// ✅ 별도 선언
const tCommon = useTranslations('Common');
tCommon('키')

// ❌ 번역 키에 . 사용
{ "User.Profile.Name": "이름" }

// ✅ 키에서 . 제거
{ "UserProfileName": "이름" }
```

---

### 4. web-polymorphic-components 🟡 우선순위 3

**범용 패턴:**
- Polymorphic Component (`as` prop)
- TypeScript 타입 정의
- Button as Link 패턴

**CLAUDE.md에서 발견한 패턴:**
```tsx
// ❌ buttonVariants 직접 사용
import { buttonVariants } from '@/components/ui/button/Button.variants';
<Link className={buttonVariants()}>...</Link>

// ✅ Button as={Link}
import { Link } from '@/i18n/navigation';
import Button from '@/components/ui/button/Button';
<Button as={Link} href="/path">링크 버튼</Button>
```

---

## 실행 계획

**Step 1**: web-nextjs-patterns 생성
- 대상: App Router, SSR/Hydration, Suspense, i18n, 환경변수

**Step 2**: web-context-patterns 생성 (선택)
**Step 3**: web-i18n-nextintl-patterns 생성 (선택)
**Step 4**: web-polymorphic-components 생성 (선택)

---

## 추출하지 않을 패턴

- API 인터셉터 (프로젝트마다 다름)
- UI 컴포넌트 연동 (디자인 시스템 의존적)
- Feature 모듈 구조 (프로젝트 컨벤션)
- SDK 통합 (특정 서비스 전용)
- Figma 토큰 매핑 (디자인 워크플로우 전용)
