#!/bin/bash
# PreCompact 훅: Compact 실행 전 호출
# Matcher: manual|auto

set -e

# stdin에서 JSON 읽기
input=$(cat)

# 트리거 추출
trigger=$(echo "$input" | jq -r '.trigger // empty')

# 예시: compact 전 상태 저장
echo "[PreCompact] trigger: $trigger, time: $(date)" >> /tmp/claude-compact.log 2>/dev/null || true

# 허용
echo '{"decision": "approve"}'
