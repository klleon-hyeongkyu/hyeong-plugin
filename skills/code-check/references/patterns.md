# General Patterns

## 코드 품질

### 함수 크기
- 한 함수는 **20줄 이하** 권장
- 한 가지 책임만 담당

### 네이밍
```typescript
// 나쁜 예
const d = new Date();
const fn = (x) => x * 2;

// 좋은 예
const currentDate = new Date();
const doubleValue = (value) => value * 2;
```

### 에러 처리
```typescript
// 나쁜 예
try {
  await doSomething();
} catch (e) {
  console.log(e);
}

// 좋은 예
try {
  await doSomething();
} catch (error) {
  logger.error('Failed to do something', { error });
  throw new ApplicationError('Operation failed', error);
}
```

## DRY (Don't Repeat Yourself)

```typescript
// 나쁜 예
const userA = { name: 'A', age: 20, active: true };
const userB = { name: 'B', age: 25, active: true };

// 좋은 예
const createUser = (name, age) => ({ name, age, active: true });
const userA = createUser('A', 20);
const userB = createUser('B', 25);
```

## 권장 사항

- [ ] 명확한 네이밍
- [ ] 적절한 에러 처리
- [ ] 중복 코드 제거
- [ ] 단일 책임 원칙
- [ ] 테스트 코드 작성
