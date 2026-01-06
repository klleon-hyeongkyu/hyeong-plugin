#!/bin/bash
# SessionEnd 훅: 세션 종료 시 호출
# Matcher: * (모든 종료)

set -e

# stdin에서 JSON 읽기
input=$(cat)

# 세션 정보 추출
session_id=$(echo "$input" | jq -r '.session_id // empty')
reason=$(echo "$input" | jq -r '.reason // empty')

# 예시: 세션 종료 로깅
echo "[SessionEnd] session: $session_id, reason: $reason, time: $(date)" >> /tmp/claude-session.log 2>/dev/null || true

# 예시: 정리 작업
# rm -f /tmp/claude-session-$session_id-* 2>/dev/null || true

# 허용
echo '{"decision": "approve", "suppressOutput": true}'
