# Agents 설명서

## 개요
**커스텀 에이전트(Custom Agents)**는 특정 작업을 수행하도록 설계된 전문 에이전트입니다.
Task tool에서 `subagent_type`으로 호출됩니다.

## 폴더 구조

```
agents/
├── helper.md      # 기본 에이전트
└── reviewer.md    # 모든 옵션 포함
```

**주의**: 하위 폴더는 **지원되지 않습니다**.

## 파일 형식

### Frontmatter 옵션

```yaml
---
name: agent-name
description: 에이전트 설명. 자동 활성화 트리거 포함.
tools: Read, Grep, Glob, Bash
model: inherit
permissionMode: default
skills: skill-name-1, skill-name-2
---
```

| 옵션 | 필수 | 설명 |
|------|------|------|
| `name` | O | 에이전트 고유 이름 (lowercase + hyphen) |
| `description` | O | 에이전트 용도 (Claude가 자동 호출 판단) |
| `tools` | X | 사용 가능한 도구 (쉼표 구분) |
| `model` | X | 사용할 모델 |
| `permissionMode` | X | 권한 모드 |
| `skills` | X | 사용할 스킬 (쉼표 구분) |

## model 옵션

| 값 | 설명 |
|----|------|
| `inherit` | 부모 에이전트의 모델 상속 (기본값) |
| `sonnet` | Claude Sonnet 사용 |
| `opus` | Claude Opus 사용 |
| `haiku` | Claude Haiku 사용 |
| 모델 ID | 특정 모델 ID 지정 |

## permissionMode 옵션

| 값 | 설명 |
|----|------|
| `default` | 기본 권한 모드 |
| `acceptEdits` | 편집 자동 수락 |
| `dontAsk` | 묻지 않고 진행 |
| `bypassPermissions` | 권한 우회 |
| `plan` | 계획 모드 |
| `ignore` | 무시 |

## 사용 가능한 도구

- `Read` - 파일 읽기
- `Write` - 파일 쓰기
- `Edit` - 파일 편집
- `Glob` - 파일 패턴 검색
- `Grep` - 내용 검색
- `Bash` - 셸 명령 (제한 가능: `Bash(git:*)`)
- `WebFetch` - URL 내용 가져오기
- `WebSearch` - 웹 검색
- `Task` - 서브 에이전트 호출
- MCP 도구 - `mcp__server__tool` 형태

## 자동 호출

`description`에 트리거 키워드 포함:
- "코드 변경 후 자동 사용"
- "PR 리뷰 시 MUST BE USED"
- "코드 리뷰 시 자동 활성화"

## 참고
- 공식 문서: https://code.claude.com/docs/en/sub-agents.md
