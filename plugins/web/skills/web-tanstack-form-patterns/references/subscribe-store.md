# Subscribe & useStore 패턴

## form.Subscribe 패턴

### 버튼 상태 연동

```tsx
<form.Subscribe selector={(s) => [s.canSubmit, s.isSubmitting] as const}>
  {([canSubmit, isSubmitting]) => (
    <button
      type="submit"
      disabled={!canSubmit || isSubmitting}
    >
      {isSubmitting ? '처리 중...' : '제출'}
    </button>
  )}
</form.Subscribe>
```

### values 기반 버튼 활성화

```tsx
<form.Subscribe selector={(state) => state.values}>
  {(values) => {
    const isFormValid = values.email.trim() !== '' && values.password.trim() !== '';
    return (
      <button
        disabled={!isFormValid}
        onClick={() => form.handleSubmit()}
      >
        로그인
      </button>
    );
  }}
</form.Subscribe>
```

### 객체 selector (여러 값)

```tsx
<form.Subscribe
  selector={(state) => ({
    color1: state.values.color1,
    color2: state.values.color2,
    size: state.values.size,
  })}
>
  {({ color1, color2, size }) => (
    <Preview color1={color1} color2={color2} size={size} />
  )}
</form.Subscribe>
```

### isDirty + isValid 조합

```tsx
<form.Subscribe selector={(state) => [state.isDirty, state.isSubmitting, state.isValid]}>
  {([isDirty, isSubmitting, isValid]) => (
    <button
      type="submit"
      disabled={!isDirty || !isValid}
    >
      {isSubmitting ? '저장 중...' : '확인'}
    </button>
  )}
</form.Subscribe>
```

### 특정 필드 에러 표시

```tsx
<form.Subscribe selector={(state) => state.fieldMeta.email?.errors}>
  {(errors) =>
    errors?.[0] && <p className="error">{errors[0]}</p>
  }
</form.Subscribe>
```

---

## useStore 패턴

```tsx
import { useStore } from '@tanstack/react-form';

// 특정 값 구독 (컴포넌트 로직에서 사용)
const firstName = useStore(form.store, (state) => state.values.firstName);
const errors = useStore(form.store, (state) => state.errorMap);
const isDirty = useStore(form.store, (state) => state.isDirty);

// 폼 변경 감지 (useEffect 대안)
useEffect(() => {
  return form.store.subscribe(() => {
    setHasUnsavedChanges(form.state.isDirty);
  });
}, [form]);
```

---

## 폼 상태 조작

### setFieldValue

```tsx
// 외부에서 필드 값 설정
form.setFieldValue('email', savedEmail);

// 배열 필드 업데이트
form.setFieldValue('keywords', [...currentKeywords, newKeyword]);

// 연관 필드 초기화
const handleEmailChange = (value: string, fieldHandleChange: (value: string) => void) => {
  fieldHandleChange(value);

  if (isEmailSent) {
    setIsEmailSent(false);
    form.setFieldValue('verificationCode', '');
  }
};
```

### form.reset()

```tsx
const handleClose = () => {
  form.reset();  // 폼 초기화
  onClose();
};
```

### 변경된 필드만 제출 (isDirty)

```tsx
onSubmit: async ({ value, formApi }) => {
  // 변경 안됐으면 API 호출 안함
  if (!formApi.state.isDirty) {
    onClose();
    return;
  }

  // 변경된 필드만 추출
  const changedFields: Partial<typeof value> = {};
  const fieldMeta = formApi.state.fieldMeta;

  if (fieldMeta.nickname?.isDirty) {
    changedFields.nickname = value.nickname;
  }
  if (fieldMeta.gender?.isDirty) {
    changedFields.gender = value.gender;
  }

  mutation.mutate(changedFields);
},
```
