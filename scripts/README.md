# Scripts 설명서

## 개요
**Scripts**는 훅에서 호출되는 쉘 스크립트입니다.
플러그인 루트의 `scripts/` 폴더에 위치합니다.

## 파일 구조

```
scripts/
├── README.md           # 이 파일
├── pre-tool.sh         # PreToolUse 훅
├── post-tool.sh        # PostToolUse 훅
├── permission.sh       # PermissionRequest 훅
├── notify.sh           # Notification 훅
├── validate-prompt.sh  # UserPromptSubmit 훅
├── on-stop.sh          # Stop 훅
├── subagent-stop.sh    # SubagentStop 훅
├── pre-compact.sh      # PreCompact 훅
├── session-start.sh    # SessionStart 훅
└── session-end.sh      # SessionEnd 훅
```

## 환경 변수

| 변수 | 설명 |
|------|------|
| `CLAUDE_PLUGIN_ROOT` | 플러그인 루트 경로 |
| `CLAUDE_PROJECT_DIR` | 현재 프로젝트 경로 |
| `CLAUDE_ENV_FILE` | 환경 변수 파일 (SessionStart 전용) |
| `CLAUDE_CODE_REMOTE` | `"true"` (원격) 또는 `""` (로컬) |

## stdin (JSON)

스크립트는 stdin으로 JSON 데이터를 받습니다:

```json
{
  "hook_event_name": "PreToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file",
    "content": "file content"
  }
}
```

### 이벤트별 stdin 데이터

| 이벤트 | 주요 필드 |
|--------|----------|
| PreToolUse | `tool_name`, `tool_input` |
| PostToolUse | `tool_name`, `tool_input`, `tool_response` |
| PermissionRequest | `tool_name`, `tool_input` |
| Notification | `title`, `body`, `type` |
| UserPromptSubmit | `prompt` |
| Stop | `reason`, `stop_hook_active` |
| SubagentStop | `agent_id`, `reason` |
| PreCompact | `trigger` (manual/auto) |
| SessionStart | `session_id`, `trigger` (startup/resume) |
| SessionEnd | `session_id`, `reason` |

## stdout (JSON)

스크립트는 stdout으로 JSON 응답을 반환합니다:

```json
{
  "decision": "approve",
  "reason": "검증 통과",
  "suppressOutput": false
}
```

### decision 값

| 값 | 설명 |
|----|------|
| `approve` / `allow` | 허용 |
| `block` / `deny` | 차단 (도구 실행 중단) |

### 선택적 필드

| 필드 | 타입 | 설명 |
|------|------|------|
| `reason` | string | 결정 이유 (Claude에게 전달) |
| `suppressOutput` | boolean | `true`면 출력 숨김 |

## Exit Code

| 코드 | 의미 |
|------|------|
| `0` | 성공 |
| `0 이외` | 실패 (경고 표시, 도구는 계속 실행) |

## 스크립트 작성 예시

### Bash

```bash
#!/bin/bash

# stdin에서 JSON 읽기
input=$(cat)

# jq로 파싱
tool_name=$(echo "$input" | jq -r '.tool_name')
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# 조건 검사
if [[ "$tool_name" == "Write" && "$file_path" == *.secret ]]; then
  echo '{"decision": "block", "reason": "비밀 파일 수정 금지"}'
  exit 0
fi

# 허용
echo '{"decision": "approve"}'
exit 0
```

### Python

```python
#!/usr/bin/env python3
import json
import sys

# stdin에서 JSON 읽기
input_data = json.load(sys.stdin)

tool_name = input_data.get("tool_name", "")
file_path = input_data.get("tool_input", {}).get("file_path", "")

# 조건 검사
if tool_name == "Write" and file_path.endswith(".secret"):
    print(json.dumps({"decision": "block", "reason": "비밀 파일 수정 금지"}))
    sys.exit(0)

# 허용
print(json.dumps({"decision": "approve"}))
```

## 권한 설정

스크립트에 실행 권한 필요:

```bash
chmod +x scripts/*.sh
```

## 디버깅

환경 변수로 로그 활성화:

```bash
export CLAUDE_HOOK_DEBUG=1
```

## 참고

- 공식 문서: https://code.claude.com/docs/en/hooks.md
- hooks.json은 `hooks/` 폴더에 위치
