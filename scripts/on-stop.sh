#!/bin/bash
# Stop 훅: Claude 중단 시 호출
# Matcher 없음

set -e

# stdin에서 JSON 읽기
input=$(cat)

# 중단 정보 추출
reason=$(echo "$input" | jq -r '.reason // empty')
stop_hook_active=$(echo "$input" | jq -r '.stop_hook_active // false')

# 예시: 세션 종료 로깅
echo "[Stop] reason: $reason, hook_active: $stop_hook_active" >> /tmp/claude-session.log 2>/dev/null || true

# 예시: 정리 작업
# rm -f /tmp/claude-temp-* 2>/dev/null || true

# 허용
echo '{"decision": "approve", "suppressOutput": true}'
