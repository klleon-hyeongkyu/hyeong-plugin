# Security Patterns

## 취약점 체크리스트

### SQL Injection
```typescript
// 나쁜 예
const query = `SELECT * FROM users WHERE id = ${userId}`;

// 좋은 예
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);
```

### XSS (Cross-Site Scripting)
```typescript
// 나쁜 예
element.innerHTML = userInput;

// 좋은 예
element.textContent = userInput;
```

### 민감 정보 노출
```typescript
// 나쁜 예
console.log('API Key:', apiKey);

// 좋은 예
console.log('API Key: [REDACTED]');
```

## 권장 사항

- [ ] 사용자 입력 검증
- [ ] 출력 이스케이프
- [ ] 환경 변수 사용
- [ ] HTTPS 강제
- [ ] 보안 헤더 설정
