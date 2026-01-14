# Validators 패턴

## onChange (입력 시 검증)

```tsx
<form.Field
  name="email"
  validators={{
    onChange: ({ value }) => {
      if (!value) return '필수 입력입니다';
      if (!isValidEmail(value)) return '올바른 이메일 형식을 입력해주세요';
      return undefined;  // 에러 없음
    },
  }}
>
```

---

## onChangeListenTo (다른 필드 참조)

```tsx
// 비밀번호 확인 - password 필드 변경 시에도 재검증
<form.Field
  name="confirmPassword"
  validators={{
    onChangeListenTo: ['password'],  // password 변경 시에도 이 필드 재검증
    onChange: ({ value, fieldApi }) => {
      const password = fieldApi.form.getFieldValue('password');
      if (!value) return undefined;
      return password !== value ? '비밀번호가 일치하지 않습니다' : undefined;
    },
  }}
>
```

---

## onBlur (포커스 해제 시 검증)

```tsx
<form.Field
  name="email"
  validators={{
    onBlur: ({ value }) => {
      if (!isValidEmail(value)) return '올바른 이메일을 입력해주세요';
      return undefined;
    },
  }}
>
```

---

## onSubmitAsync (비동기 서버 검증)

```tsx
const form = useForm({
  defaultValues: { email: '', age: 0 },
  validators: {
    onSubmitAsync: async ({ value }) => {
      const hasErrors = await verifyDataOnServer(value);
      if (hasErrors) {
        return {
          form: '서버 검증 실패',  // form-level 에러 (선택)
          fields: {
            email: '이미 사용 중인 이메일입니다',
            age: '13세 이상만 가입 가능합니다',
          },
        };
      }
      return null;
    },
  },
});
```

---

## Form-level 검증

```tsx
const form = useForm({
  defaultValues: { age: 0 },
  validators: {
    onChange: ({ value }) => {
      if (value.age < 13) {
        return '13세 이상만 가입 가능합니다';
      }
      return undefined;
    },
  },
});

// 폼 에러 표시
const formErrorMap = useStore(form.store, (state) => state.errorMap);

{formErrorMap.onChange && (
  <p className="error">{formErrorMap.onChange}</p>
)}
```

---

## errorMap으로 특정 validator 에러

```tsx
<form.Field
  name="age"
  validators={{
    onChange: ({ value }) =>
      value < 13 ? '13세 이상만 가능합니다' : undefined,
  }}
>
  {(field) => (
    <>
      <input value={field.state.value} onChange={...} />
      {field.state.meta.errorMap['onChange'] && (
        <em>{field.state.meta.errorMap['onChange']}</em>
      )}
    </>
  )}
</form.Field>
```
