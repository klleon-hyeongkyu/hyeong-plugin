# TanStack Form vs React Hook Form

두 라이브러리의 상세 비교 및 선택 가이드.

## 핵심 차이점

| 항목 | React Hook Form | TanStack Form |
|------|----------------|---------------|
| **Type Safety** | ⭐⭐⭐ (런타임) | ⭐⭐⭐⭐⭐ (컴파일 타임) |
| **Framework** | React only | React, Vue, Svelte, Angular, Solid, Lit |
| **UI Approach** | Opinionated (register) | Headless (완전 제어) |
| **Performance** | useWatch | Subscribe selector |
| **Validation** | resolver (외부) | Built-in + adapters |
| **Learning Curve** | 낮음 | 중간 |
| **번들 크기** | ~8KB | ~11KB |

---

## 타입 안전성

### React Hook Form

```tsx
import { useForm } from 'react-hook-form';

const { register, handleSubmit } = useForm();

// ❌ 필드명 오타 → 런타임 에러 (컴파일은 통과)
<input {...register('emial')} />  // 'email' 오타
```

**문제:**
- 필드명을 문자열로 전달
- TypeScript가 오타 감지 못함
- 런타임에야 문제 발견

---

### TanStack Form

```tsx
import { useForm } from '@tanstack/react-form';

const form = useForm({
  defaultValues: {
    email: '',
  },
});

// ✅ 필드명 오타 → 컴파일 에러
<form.Field name="emial">  {/* TypeScript 에러! */}
  {(field) => <input {...} />}
</form.Field>
```

**장점:**
- 필드명이 타입으로 추론됨
- 오타 시 즉시 컴파일 에러
- IDE 자동완성 지원

---

## Framework 지원

### React Hook Form

- **React만 지원**
- Vue/Svelte 프로젝트는 사용 불가

---

### TanStack Form

```tsx
// React
import { useForm } from '@tanstack/react-form';

// Vue
import { useForm } from '@tanstack/vue-form';

// Svelte
import { createForm } from '@tanstack/svelte-form';

// Angular
import { injectForm } from '@tanstack/angular-form';

// Solid
import { createForm } from '@tanstack/solid-form';
```

**장점:**
- 멀티 프레임워크 프로젝트에서 유리
- API가 일관적 (학습 한 번만)
- 팀이 프레임워크 전환 시 유리

---

## 성능 최적화

### React Hook Form: useWatch

```tsx
import { useWatch } from 'react-hook-form';

function MyComponent({ control }) {
  // email 필드만 watch
  const email = useWatch({ control, name: 'email' });

  return <div>{email}</div>;
}
```

**제약:**
- control을 props로 전달해야 함
- Nested 구조에서 번거로움

---

### TanStack Form: Subscribe Selector

```tsx
function MyComponent() {
  // ✅ selector로 필요한 값만
  const email = useStore(form.store, (state) => state.values.email);

  return <div>{email}</div>;
}

// 또는
<form.Subscribe selector={(state) => [state.values.email]}>
  {([email]) => <div>{email}</div>}
</form.Subscribe>
```

**장점:**
- Selector 패턴 (web-context-patterns와 동일)
- props 전달 불필요
- 최적화 명확

---

## Validation

### React Hook Form: Resolver

```tsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
});

const { register } = useForm({
  resolver: zodResolver(schema),  // 외부 resolver 필요
});
```

**제약:**
- 외부 resolver 패키지 필요 (@hookform/resolvers)
- Schema와 form이 분리

---

### TanStack Form: Built-in + Adapters

```tsx
import { useForm } from '@tanstack/react-form';
import { zodValidator } from '@tanstack/zod-form-adapter';
import { z } from 'zod';

const form = useForm({
  defaultValues: {
    email: '',
    password: '',
  },
  validators: {
    // ✅ Built-in validation
    onChange: ({ value }) => {
      if (!value.email) return { email: '필수 입력' };
      return undefined;
    },
    // ✅ Zod adapter
    onChange: z.object({
      email: z.string().email(),
      password: z.string().min(8),
    }),
  },
});
```

**장점:**
- Built-in validation (간단한 경우)
- Adapter로 Schema 통합 (복잡한 경우)
- 유연한 선택

---

## API 디자인

### React Hook Form

```tsx
// register 패턴
<input {...register('email')} />

// Controller 패턴 (커스텀 컴포넌트)
<Controller
  name="email"
  control={control}
  render={({ field }) => <CustomInput {...field} />}
/>
```

**특징:**
- register로 간단히 연결
- Controller로 커스텀 컴포넌트

---

### TanStack Form

```tsx
// Field 패턴 (모든 경우 동일)
<form.Field
  name="email"
  validators={{
    onChange: ({ value }) => {
      if (!value) return '필수 입력';
      return undefined;
    },
  }}
>
  {(field) => (
    <input
      value={field.state.value}
      onChange={(e) => field.handleChange(e.target.value)}
    />
  )}
</form.Field>
```

**특징:**
- 모든 경우 Field 패턴 (일관성)
- Render props (명확한 제어)

---

## 언제 TanStack Form?

### ✅ TanStack Form 선택

- **타입 안전성 중요**: TypeScript 프로젝트, 필드명 오타 방지
- **멀티 프레임워크**: React + Vue 동시 사용, 프레임워크 전환 가능성
- **성능 중요**: 큰 폼, 많은 필드
- **Headless 필요**: 자유로운 UI 커스터마이징

---

### ✅ React Hook Form 선택

- **빠른 시작**: 간단한 폼, 프로토타입
- **React 전용**: Vue/Svelte 사용 계획 없음
- **번들 크기**: 최소화 필요 (8KB vs 11KB)
- **레거시**: 이미 React Hook Form 사용 중

---

## 실전 비교

### 간단한 폼 (React Hook Form 유리)

```tsx
// React Hook Form - 더 간단
const { register, handleSubmit } = useForm();

<form onSubmit={handleSubmit(onSubmit)}>
  <input {...register('email')} />
  <button type="submit">Submit</button>
</form>
```

---

### 복잡한 폼 (TanStack Form 유리)

```tsx
// TanStack Form - 타입 안전 + 성능
const form = useForm({
  defaultValues: { /* 20개 필드 */ },
  validators: { /* 복잡한 검증 */ },
});

// ✅ 필드명 자동완성
<form.Field name="email">  {/* IDE가 필드 제안 */}
  {(field) => <Input {...} />}
</form.Field>

// ✅ Selector로 최적화
<form.Subscribe selector={(s) => [s.canSubmit]}>
  {([canSubmit]) => <button disabled={!canSubmit}>Submit</button>}
</form.Subscribe>
```

---

## 마이그레이션 고려사항

**React Hook Form → TanStack Form 전환 시:**
- [ ] 타입 안전성 개선 효과 큰가?
- [ ] 멀티 프레임워크 지원 필요한가?
- [ ] 성능 최적화 필요한가?
- [ ] 팀의 학습 비용 감당 가능한가?

**상세:** [references/migration-guide.md](references/migration-guide.md)

---

## 결론

**TanStack Form 장점:**
- 타입 안전성 (컴파일 타임)
- Framework agnostic
- Headless (UI 자유)
- 성능 최적화 (Selector)

**React Hook Form 장점:**
- 간단함 (작은 폼)
- 작은 번들 크기
- 빠른 시작

**추천:**
- 중대형 프로젝트 → TanStack Form
- 소형 프로젝트/프로토타입 → React Hook Form
