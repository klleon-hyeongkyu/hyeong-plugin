# Output Styles 설명서

## 개요
**Output Styles**는 Claude의 응답 스타일을 커스터마이즈합니다.
`/output-style` 명령어로 활성화합니다.

## 파일 구조

```
outputStyles/
├── README.md      # 이 파일
├── teaching.md    # 교육 모드 (코딩 지침 유지)
└── formal.md      # 공식 모드 (코딩 지침 제거)
```

## 설정 방법

`plugin.json`에서 지정:

```json
{
  "outputStyles": "./outputStyles/"
}
```

## 파일 형식

### Frontmatter (필수)

```yaml
---
name: 스타일 이름
description: 스타일 설명
keep-coding-instructions: true
---
```

### Frontmatter 옵션

| 옵션 | 타입 | 설명 |
|------|------|------|
| `name` | string | 스타일 이름 (필수) |
| `description` | string | 스타일 설명 (선택) |
| `keep-coding-instructions` | boolean | 코딩 지침 유지 여부 |

### keep-coding-instructions

| 값 | 동작 |
|----|------|
| `true` | 기존 코딩 관련 시스템 지침 유지 |
| `false` | 코딩 지침 제거, 순수 대화 스타일 |

## 활성화 방법

```bash
# 스타일 목록 확인
/output-style

# 특정 스타일 활성화
/output-style Teaching Mode

# 플러그인 네임스페이스 사용
/hyeong-plugin:output-style Teaching Mode
```

## 예시

### 교육 모드 (teaching.md)

```markdown
---
name: Teaching Mode
description: 교육적 설명 모드
keep-coding-instructions: true
---

# 응답 스타일

1. 개념을 단계별로 설명
2. 예제 코드 포함
3. 왜 이렇게 하는지 이유 설명
4. 초보자도 이해할 수 있게
```

### 공식 모드 (formal.md)

```markdown
---
name: Formal Mode
description: 공식 비즈니스 모드
keep-coding-instructions: false
---

# 응답 스타일

1. 격식체 사용
2. 간결하고 명확하게
3. 불필요한 설명 생략
```

## 스타일 내용

Frontmatter 아래의 마크다운 내용이 Claude의 시스템 프롬프트에 추가됩니다.

## 참고

- 공식 문서: https://code.claude.com/docs/en/plugins.md
- 프로젝트별 설정도 가능: `.claude/settings.json`
