# React Hook Form → TanStack Form 마이그레이션 가이드

React Hook Form에서 TanStack Form으로 전환하는 단계별 가이드.

## 핵심 개념 매핑

| React Hook Form | TanStack Form |
|----------------|---------------|
| `useForm()` | `useForm()` |
| `register('name')` | `<form.Field name="name">` |
| `handleSubmit` | `form.handleSubmit()` |
| `watch('name')` | `useStore(form.store, s => s.values.name)` |
| `setValue('name', value)` | `form.setFieldValue('name', value)` |
| `reset()` | `form.reset()` |
| `formState.errors` | `field.state.meta.errors` |
| `formState.isSubmitting` | `form.Subscribe` + `state.isSubmitting` |

---

## 기본 폼 마이그레이션

### Before: React Hook Form

```tsx
import { useForm } from 'react-hook-form';

function LoginForm() {
  const { register, handleSubmit, formState: { errors } } = useForm({
    defaultValues: {
      email: '',
      password: '',
    },
  });

  const onSubmit = async (data) => {
    await login(data);
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('email', { required: 'Required' })} />
      {errors.email && <span>{errors.email.message}</span>}

      <input type="password" {...register('password', { required: 'Required' })} />
      {errors.password && <span>{errors.password.message}</span>}

      <button type="submit">Login</button>
    </form>
  );
}
```

---

### After: TanStack Form

```tsx
import { useForm } from '@tanstack/react-form';

function LoginForm() {
  const form = useForm({
    defaultValues: {
      email: '',
      password: '',
    },
    onSubmit: async ({ value }) => {
      await login(value);
    },
  });

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        form.handleSubmit();
      }}
    >
      <form.Field
        name="email"
        validators={{
          onChange: ({ value }) => {
            if (!value) return 'Required';
            return undefined;
          },
        }}
      >
        {(field) => (
          <>
            <input
              value={field.state.value}
              onChange={(e) => field.handleChange(e.target.value)}
              onBlur={field.handleBlur}
            />
            {field.state.meta.errors[0] && (
              <span>{field.state.meta.errors[0]}</span>
            )}
          </>
        )}
      </form.Field>

      <form.Field
        name="password"
        validators={{
          onChange: ({ value }) => {
            if (!value) return 'Required';
            return undefined;
          },
        }}
      >
        {(field) => (
          <>
            <input
              type="password"
              value={field.state.value}
              onChange={(e) => field.handleChange(e.target.value)}
              onBlur={field.handleBlur}
            />
            {field.state.meta.errors[0] && (
              <span>{field.state.meta.errors[0]}</span>
            )}
          </>
        )}
      </form.Field>

      <form.Subscribe selector={(s) => [s.canSubmit, s.isSubmitting]}>
        {([canSubmit, isSubmitting]) => (
          <button type="submit" disabled={!canSubmit}>
            {isSubmitting ? 'Loading...' : 'Login'}
          </button>
        )}
      </form.Subscribe>
    </form>
  );
}
```

---

## Zod Validation 마이그레이션

### Before: React Hook Form + Zod

```tsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const schema = z.object({
  username: z.string().min(3),
  age: z.number().min(18),
});

const { register, handleSubmit } = useForm({
  resolver: zodResolver(schema),
});
```

---

### After: TanStack Form + Zod Adapter

```tsx
import { useForm } from '@tanstack/react-form';
import { zodValidator } from '@tanstack/zod-form-adapter';
import { z } from 'zod';

const form = useForm({
  defaultValues: {
    username: '',
    age: 0,
  },
  validatorAdapter: zodValidator(),
  validators: {
    onChange: z.object({
      username: z.string().min(3),
      age: z.number().min(18),
    }),
  },
});
```

**차이점:**
- resolver → validators + validatorAdapter
- Schema를 validators 안에 직접 사용

---

## watch → useStore

### Before: React Hook Form

```tsx
import { useWatch } from 'react-hook-form';

function EmailDisplay({ control }) {
  const email = useWatch({ control, name: 'email' });

  return <div>Email: {email}</div>;
}

// 부모에서
<EmailDisplay control={control} />
```

---

### After: TanStack Form

```tsx
import { useStore } from '@tanstack/react-form';

function EmailDisplay({ form }) {
  const email = useStore(form.store, (state) => state.values.email);

  return <div>Email: {email}</div>;
}

// 또는 Subscribe
<form.Subscribe selector={(state) => [state.values.email]}>
  {([email]) => <div>Email: {email}</div>}
</form.Subscribe>
```

**장점:**
- Selector 패턴으로 최적화
- 명확한 의존성

---

## setValue → setFieldValue

### Before: React Hook Form

```tsx
const { setValue } = useForm();

// 사용
setValue('email', 'test@example.com');
```

---

### After: TanStack Form

```tsx
const form = useForm();

// 사용
form.setFieldValue('email', 'test@example.com');
```

**동일:** API가 거의 같음

---

## Custom Input 마이그레이션

### Before: React Hook Form Controller

```tsx
import { Controller } from 'react-hook-form';

<Controller
  name="myInput"
  control={control}
  render={({ field }) => (
    <CustomInput
      value={field.value}
      onChange={field.onChange}
      onBlur={field.onBlur}
    />
  )}
/>
```

---

### After: TanStack Form Field

```tsx
<form.Field name="myInput">
  {(field) => (
    <CustomInput
      value={field.state.value}
      onChange={(value) => field.handleChange(value)}
      onBlur={field.handleBlur}
    />
  )}
</form.Field>
```

**차이:**
- Controller → form.Field
- field.onChange → field.handleChange
- field.value → field.state.value

---

## 마이그레이션 체크리스트

### Step 1: 설치

```bash
npm uninstall react-hook-form @hookform/resolvers
npm install @tanstack/react-form

# Zod 사용 시
npm install @tanstack/zod-form-adapter
```

---

### Step 2: useForm 전환

- [ ] `defaultValues` 유지 (동일)
- [ ] `resolver` → `validators` + `validatorAdapter`
- [ ] `handleSubmit(onSubmit)` → `onSubmit` 옵션

---

### Step 3: 필드 전환

- [ ] `register('name')` → `<form.Field name="name">`
- [ ] `errors.name` → `field.state.meta.errors[0]`
- [ ] Render props 패턴 적용

---

### Step 4: 상태 구독 전환

- [ ] `formState.isSubmitting` → `<form.Subscribe>`
- [ ] `watch()` → `useStore()` 또는 `<form.Subscribe>`
- [ ] `formState.errors` → 필드별 에러 접근

---

### Step 5: 검증

- [ ] 모든 폼 기능 정상 작동
- [ ] TypeScript 에러 없음
- [ ] Validation 정상 작동
- [ ] 성능 개선 확인 (리렌더 감소)

---

## 결론

**마이그레이션 난이도: 중간**

**핵심 변경:**
- register → Field render props
- formState → Subscribe selector
- resolver → validators

**예상 시간:**
- 간단한 폼: 30분
- 복잡한 폼: 2-4시간

**효과:**
- 타입 안전성 개선
- 성능 최적화
- Framework 독립성
