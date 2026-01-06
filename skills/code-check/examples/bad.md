# Bad Code Examples

## 피해야 할 패턴

### 거대한 함수

```typescript
// ❌ 너무 많은 책임
function processUserData(data) {
  // 100줄 이상의 로직...
  // 검증, 변환, 저장, 알림 모두 한 함수에
}
```

### 매직 넘버

```typescript
// ❌ 의미 불명
if (user.age >= 19) {
  allowAccess();
}

// 개선 필요
const LEGAL_AGE = 19;
if (user.age >= LEGAL_AGE) {
  allowAccess();
}
```

### 중첩된 콜백

```typescript
// ❌ 콜백 지옥
getUser(id, (user) => {
  getPosts(user.id, (posts) => {
    getComments(posts[0].id, (comments) => {
      // ...
    });
  });
});

// 개선 필요: async/await 사용
```

### 전역 상태 남용

```typescript
// ❌ 전역 변수
let currentUser = null;

function login(user) {
  currentUser = user;
}

// 개선 필요: 상태 관리 라이브러리 사용
```

### 에러 무시

```typescript
// ❌ 에러 무시
try {
  riskyOperation();
} catch (e) {
  // 아무것도 안함
}

// 개선 필요: 적절한 에러 처리
```

## 결론

이런 패턴을 발견하면 리팩토링을 권장합니다.
