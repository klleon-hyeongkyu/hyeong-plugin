#!/bin/bash
# SubagentStop 훅: 서브에이전트 중단 시 호출
# Matcher 없음

set -e

# stdin에서 JSON 읽기
input=$(cat)

# 서브에이전트 정보 추출
agent_id=$(echo "$input" | jq -r '.agent_id // empty')
reason=$(echo "$input" | jq -r '.reason // empty')

# 예시: 서브에이전트 종료 로깅
echo "[SubagentStop] agent: $agent_id, reason: $reason" >> /tmp/claude-agents.log 2>/dev/null || true

# 허용
echo '{"decision": "approve", "suppressOutput": true}'
