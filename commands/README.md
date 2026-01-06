# Commands 설명서

## 개요
**슬래시 커맨드(Slash Commands)**는 `/command-name` 형태로 호출하는 사용자 정의 명령어입니다.

## 폴더 구조

```
commands/
├── hello.md           # /hyeong-plugin:hello
├── advanced.md        # /hyeong-plugin:advanced
└── jira/              # 하위 폴더 (네임스페이싱)
    └── my-tickets.md  # /hyeong-plugin:my-tickets (설명에 jira 표시)
```

### 하위 폴더 (Namespacing)
- **하위 폴더 가능**: 관련 커맨드를 그룹화
- **호출 방식**: 파일명만 사용 (`/hyeong-plugin:my-tickets`)
- **표시 방식**: 설명에 폴더명 포함 (`(plugin:jira)`)

## 파일 형식

### Frontmatter 옵션

```yaml
---
description: 커맨드 설명 (필수)
allowed-tools: Bash(git:*), Read, Write
argument-hint: [name] [option]
model: claude-sonnet-4-20250514
disable-model-invocation: false
---
```

| 옵션 | 필수 | 설명 |
|------|------|------|
| `description` | O | 커맨드 설명 (help에 표시) |
| `allowed-tools` | X | 사용 가능한 도구 제한 |
| `argument-hint` | X | 인자 힌트 (자동완성에 표시) |
| `model` | X | 특정 모델 지정 |
| `disable-model-invocation` | X | SlashCommand 도구로 실행 불가 (기본: false) |

## 변수

### 인자 변수
| 변수 | 설명 |
|------|------|
| `$ARGUMENTS` | 모든 인자 (공백 포함) |
| `$1` | 첫 번째 인자 |
| `$2` | 두 번째 인자 |
| `$N` | N번째 인자 |

### Bash 실행
```markdown
Git 상태: !`git status --short`
최근 커밋: !`git log --oneline -5`
```
- `` !`command` `` 형태로 Bash 명령 실행 결과 포함

### 파일 참조
```markdown
@README.md 파일을 분석하세요.
@src/utils/helpers.ts 와 @src/utils/formatters.ts 비교
```
- `@file-path` 형태로 파일 참조

## 호출 방법

플러그인 커맨드는 네임스페이스로 호출:
```
/hyeong-plugin:hello Alice
/hyeong-plugin:advanced --verbose
```

## 참고
- 공식 문서: https://code.claude.com/docs/en/slash-commands.md
