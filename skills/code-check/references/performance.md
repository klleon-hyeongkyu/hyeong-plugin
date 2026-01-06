# Performance Patterns

## 성능 체크리스트

### 불필요한 리렌더링
```tsx
// 나쁜 예
const Component = () => {
  const items = data.filter(x => x.active); // 매번 새 배열
  return <List items={items} />;
};

// 좋은 예
const Component = () => {
  const items = useMemo(() => data.filter(x => x.active), [data]);
  return <List items={items} />;
};
```

### N+1 Query
```typescript
// 나쁜 예
for (const user of users) {
  const posts = await getPosts(user.id);
}

// 좋은 예
const posts = await getPostsByUserIds(users.map(u => u.id));
```

### 대용량 데이터
```typescript
// 나쁜 예
const allData = await fetchAll();

// 좋은 예
const data = await fetchPaginated(page, limit);
```

## 권장 사항

- [ ] 메모이제이션 활용
- [ ] 페이지네이션 적용
- [ ] 이미지 최적화
- [ ] 코드 스플리팅
- [ ] 캐싱 전략
