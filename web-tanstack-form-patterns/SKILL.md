---
name: web-tanstack-form-patterns
description: TanStack Form 팀 컨벤션. useForm, Field, validators, Subscribe 사용법. 폼 구현 시 참조.
---

# TanStack Form 팀 컨벤션

## 최신 API 확인

코드 작성 전 Context7으로 최신 문서 확인:

```
mcp__context7__query-docs(libraryId="/tanstack/form", query="useForm options validators")
mcp__context7__query-docs(libraryId="/tanstack/form", query="field validation async")
mcp__context7__query-docs(libraryId="/tanstack/form", query="Subscribe useStore array field")
```

---

## 왜 TanStack Form?

TanStack Form을 선택하는 이유와 React Hook Form 대비 장점.

### 핵심 장점

| 장점 | 설명 |
|------|------|
| **Type Safety** | 필드 이름 오타 시 TypeScript 컴파일 에러 |
| **Framework Agnostic** | React, Vue, Svelte, Angular, Solid, Lit 모두 지원 |
| **Headless** | UI 제약 없음, 자유로운 스타일링 |
| **Performance** | Selector 패턴으로 불필요한 리렌더 방지 |
| **Validation** | Zod, Yup, Valibot 어댑터 지원 |

### React Hook Form vs TanStack Form

| 항목 | React Hook Form | TanStack Form |
|------|----------------|---------------|
| 타입 안전성 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ (필드명 컴파일 체크) |
| 프레임워크 지원 | React only | React, Vue, Svelte 등 |
| 성능 최적화 | useWatch | Subscribe selector |
| Validation | resolver | Built-in + adapters |

**상세:** [references/vs-react-hook-form.md](references/vs-react-hook-form.md)

---

## 상세 문서

| 문서 | 용도 |
|------|------|
| [references/vs-react-hook-form.md](references/vs-react-hook-form.md) | React Hook Form 비교, 선택 가이드 |
| [references/migration-guide.md](references/migration-guide.md) | React Hook Form 마이그레이션 단계별 가이드 |
| [references/validators.md](references/validators.md) | onChange, onBlur, onChangeListenTo, async, form-level 검증 |
| [references/subscribe-store.md](references/subscribe-store.md) | form.Subscribe, useStore 패턴 |
| [references/advanced-patterns.md](references/advanced-patterns.md) | 배열 필드, 컴포넌트 분리, 모달 리셋, 멀티스텝, 페이지 이탈 |

---

## 핵심 규칙

| 규칙 | ✅ 올바름 | ❌ 금지 |
|------|----------|--------|
| 폼 상태 관리 | `useForm()` | `useState` + 필드 |
| 버튼 상태 | `<form.Subscribe>` | `form.state.canSubmit` 직접 참조 |
| 동적 값 읽기 | `<form.Subscribe>` or `useStore` | `form.getFieldValue()` 직접 |
| 에러 표시 | `field.state.meta.errors[0]` | 직접 에러 state |
| 폼 리셋 (모달) | `key={String(open)}` | `useEffect` + reset |
| 폼 전달 | props로 form 객체 전달 | Context 사용 |

---

## 기본 폼 패턴

```tsx
const form = useForm({
  defaultValues: {
    email: '',
    password: '',
  },
  onSubmit: async ({ value }) => {
    await submitData(value);
  },
});

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
        if (!value) return '필수 입력입니다';
        if (!value.includes('@')) return '올바른 이메일 형식을 입력해주세요';
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
          <span className="error">{field.state.meta.errors[0]}</span>
        )}
      </>
    )}
  </form.Field>
</form>
```

---

## 버튼 상태 연동 (Subscribe)

```tsx
<form.Subscribe selector={(s) => [s.canSubmit, s.isSubmitting] as const}>
  {([canSubmit, isSubmitting]) => (
    <button type="submit" disabled={!canSubmit || isSubmitting}>
      {isSubmitting ? '처리 중...' : '제출'}
    </button>
  )}
</form.Subscribe>
```

---

## 폼 상태 조작

```tsx
// 필드 값 설정
form.setFieldValue('email', savedEmail);

// 폼 초기화
form.reset();
```

---

## useMutation 연동

```tsx
const form = useForm({
  defaultValues: { password: '', confirmPassword: '' },
  onSubmit: async ({ value }) => {
    mutation.mutate(value.password);
  },
});

const mutation = useMutation({
  mutationFn: changePassword,
  onSuccess: () => {
    form.reset();
    onClose();
  },
  onError: (error) => {
    // 에러 처리
  },
});
```
