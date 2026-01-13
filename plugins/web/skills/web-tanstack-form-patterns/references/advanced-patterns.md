# Advanced Patterns

## 배열 필드 패턴

### mode="array" (TanStack 공식)

```tsx
<form.Field
  name="hobbies"
  mode="array"
>
  {(hobbiesField) => (
    <div>
      {hobbiesField.state.value.map((_, i) => (
        <div key={i}>
          <form.Field name={`hobbies[${i}].name`}>
            {(field) => (
              <input
                value={field.state.value}
                onChange={(e) => field.handleChange(e.target.value)}
              />
            )}
          </form.Field>
          <button onClick={() => hobbiesField.removeValue(i)}>삭제</button>
        </div>
      ))}
      <button onClick={() => hobbiesField.pushValue({ name: '', description: '' })}>
        추가
      </button>
    </div>
  )}
</form.Field>
```

### Subscribe + setFieldValue (간단한 배열)

```tsx
// 키워드 배열 관리
<form.Subscribe selector={(state) => state.values.keywords}>
  {(keywords: string[]) => {
    const handleKeywordAdd = (keyword: string) => {
      if (keywords.length >= 10) return;  // 최대 10개
      if (keywords.includes(keyword)) return;  // 중복 방지
      form.setFieldValue('keywords', [...keywords, keyword]);
    };

    const handleKeywordRemove = (keyword: string) => {
      form.setFieldValue('keywords', keywords.filter((k) => k !== keyword));
    };

    return (
      <div>
        {keywords.map((keyword) => (
          <span key={keyword}>
            {keyword}
            <button onClick={() => handleKeywordRemove(keyword)}>X</button>
          </span>
        ))}
        <button onClick={() => handleKeywordAdd(inputValue)}>추가</button>
      </div>
    );
  }}
</form.Subscribe>
```

---

## 폼 컴포넌트 분리 패턴

### 타입 정의

```typescript
import type { ReactFormApi, FormApi } from '@tanstack/react-form';

interface MyFormValues {
  id: string;
  name: string;
  description: string;
  keywords: string[];
}

type MyForm = ReactFormApi<MyFormValues>;
// 또는
type MyForm = FormApi<MyFormValues>;
```

### 폼 props 전달

```tsx
// 부모 컴포넌트
const ParentPage = () => {
  const form = useForm({
    defaultValues: { /* ... */ },
    onSubmit: async ({ value }) => { /* ... */ },
  });

  return (
    <FormContent
      form={form}
      errors={fieldErrors}
      onSubmit={handleSubmit}
    />
  );
};

// 자식 컴포넌트
interface StepComponentProps {
  form: MyForm;
  errors?: Record<string, string>;
}

const StepComponent = ({ form, errors }: StepComponentProps) => {
  return (
    <form.Field name="description">
      {(field) => (
        <textarea
          value={field.state.value}
          onChange={(e) => field.handleChange(e.target.value)}
        />
      )}
    </form.Field>
  );
};
```

---

## 모달 폼 리셋 패턴

### key prop으로 자동 리셋 (권장)

```tsx
// 모달 래퍼
const EditModal = ({ open, onClose, initialData }: Props) => {
  return (
    <Modal open={open} onClose={onClose}>
      {/* key로 open 상태 전달 → 열릴 때마다 폼 컴포넌트 재생성 */}
      {initialData && (
        <EditForm key={String(open)} initialData={initialData} onClose={onClose} />
      )}
    </Modal>
  );
};

// 폼 컴포넌트 (내부)
const EditForm = ({ initialData, onClose }: FormProps) => {
  const form = useForm({
    defaultValues: {
      nickname: initialData.nickname ?? '',
      gender: initialData.gender ?? 'OTHER',
    },
  });
  // ...
};
```

---

## 외부 에러 처리 패턴

```tsx
// 폼 외부에서 에러 관리 (서버 검증 등)
const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({});

const handleSubmit = () => {
  const values = form.state.values;
  const errors: Record<string, string> = {};

  // 커스텀 검증
  if (!values.thumbnail) errors.thumbnail = '이미지를 등록해 주세요.';
  if (!values.voiceId) errors.voiceId = '음성을 선택해 주세요.';
  if (!values.name) errors.name = '이름을 입력해 주세요.';

  setFieldErrors(errors);

  if (Object.keys(errors).length > 0) {
    showToast('필수 항목을 모두 입력해 주세요.');
    return;
  }

  form.handleSubmit();
};

// 에러 표시
<input className={fieldErrors.name ? 'error' : ''} />
{fieldErrors.name && <span className="error">{fieldErrors.name}</span>}
```

---

## 단계별 폼 (멀티스텝)

```tsx
const [step, setStep] = useState(1);

const form = useForm({
  defaultValues: {
    email: '',
    verificationCode: '',
    password: '',
    confirmPassword: '',
  },
  onSubmit: async ({ value }) => {
    await submitSignup(value);
  },
});

// Step 1: 이메일 입력
if (step === 1) {
  return <form.Field name="email">{/* ... */}</form.Field>;
}

// Step 2: 인증코드 입력
if (step === 2) {
  return <form.Field name="verificationCode">{/* ... */}</form.Field>;
}

// Step 3: 비밀번호 설정
return (
  <>
    <form.Field name="password">{/* ... */}</form.Field>
    <form.Field name="confirmPassword">{/* ... */}</form.Field>
    <button onClick={() => form.handleSubmit()}>완료</button>
  </>
);
```

---

## 페이지 이탈 경고 (Unsaved Changes)

```tsx
const [hasUnsavedChanges, setHasUnsavedChanges] = useState(false);

// 폼 변경 감지
useEffect(() => {
  return form.store.subscribe(() => {
    setHasUnsavedChanges(form.state.isDirty);
  });
}, [form]);

// 페이지 이탈 시 확인 (브라우저 기본)
useEffect(() => {
  const handleBeforeUnload = (e: BeforeUnloadEvent) => {
    if (hasUnsavedChanges) {
      e.preventDefault();
      e.returnValue = '';
    }
  };

  window.addEventListener('beforeunload', handleBeforeUnload);
  return () => window.removeEventListener('beforeunload', handleBeforeUnload);
}, [hasUnsavedChanges]);
```
