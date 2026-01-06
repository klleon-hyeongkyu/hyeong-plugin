# Hooks 설명서

## 개요
**훅(Hooks)**은 Claude의 특정 이벤트에 반응하여 실행되는 스크립트입니다.

## 파일 구조

```
hooks/
└── hooks.json    # 훅 설정 파일
```

**주의**: 스크립트는 플러그인 루트의 `scripts/` 폴더에 위치합니다.

## 훅 이벤트 (10개)

| 이벤트 | Matcher | 설명 |
|--------|---------|------|
| `PreToolUse` | O | 도구 실행 **전** |
| `PostToolUse` | O | 도구 실행 **후** (성공 시) |
| `PermissionRequest` | O | 권한 요청 시 |
| `Notification` | O | 알림 발송 시 |
| `UserPromptSubmit` | X | 사용자 프롬프트 제출 시 |
| `Stop` | X | Claude 중단 시 |
| `SubagentStop` | X | 서브에이전트 중단 시 |
| `PreCompact` | O | Compact 실행 전 |
| `SessionStart` | O | 세션 시작 시 |
| `SessionEnd` | O | 세션 종료 시 |

## Matcher 패턴

| 패턴 | 설명 |
|------|------|
| `*` | 모든 도구 |
| `""` (빈 문자열) | 모든 도구 |
| `Write` | 정확히 일치 |
| `Write\|Edit` | OR 조건 |
| `Bash.*` | 정규식 |
| `mcp__github__.*` | MCP 도구 |

## 훅 타입

### command 타입
```json
{
  "type": "command",
  "command": "${CLAUDE_PLUGIN_ROOT}/scripts/pre-tool.sh",
  "timeout": 30
}
```

### prompt 타입 (Stop/SubagentStop 전용)
```json
{
  "type": "prompt",
  "prompt": "작업이 완료되었는지 확인하세요. $ARGUMENTS"
}
```

## 환경 변수

| 변수 | 설명 |
|------|------|
| `${CLAUDE_PLUGIN_ROOT}` | 플러그인 루트 경로 |
| `${CLAUDE_PROJECT_DIR}` | 프로젝트 루트 경로 |
| `${CLAUDE_ENV_FILE}` | 환경 변수 파일 (SessionStart) |
| `${CLAUDE_CODE_REMOTE}` | "true" (원격) 또는 "" (로컬) |

## 스크립트 입출력

### stdin (JSON)
```json
{
  "hook_event_name": "PreToolUse",
  "tool_name": "Write",
  "tool_input": { "file_path": "/path/to/file" }
}
```

### stdout (JSON)
```json
{
  "decision": "approve",
  "reason": "검증 통과",
  "suppressOutput": false
}
```

### decision 값
- `approve` / `allow` - 허용
- `block` / `deny` - 차단

### exit code
- `0` - 성공
- `0 이외` - 실패 (경고 표시)

## 참고
- 공식 문서: https://code.claude.com/docs/en/hooks.md
