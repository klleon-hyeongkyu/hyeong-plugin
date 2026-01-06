#!/bin/bash
# SessionStart 훅: 세션 시작 시 호출
# Matcher: startup|resume

set -e

# stdin에서 JSON 읽기
input=$(cat)

# 세션 정보 추출
session_id=$(echo "$input" | jq -r '.session_id // empty')
trigger=$(echo "$input" | jq -r '.trigger // empty')

# 예시: 세션 시작 로깅
echo "[SessionStart] session: $session_id, trigger: $trigger, time: $(date)" >> /tmp/claude-session.log 2>/dev/null || true

# 예시: 환경 변수 설정 (CLAUDE_ENV_FILE 사용)
if [[ -n "$CLAUDE_ENV_FILE" ]]; then
  echo "SESSION_START_TIME=$(date +%s)" >> "$CLAUDE_ENV_FILE" 2>/dev/null || true
fi

# 허용
echo '{"decision": "approve", "suppressOutput": true}'
