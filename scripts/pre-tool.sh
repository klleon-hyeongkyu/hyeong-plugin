#!/bin/bash
# PreToolUse 훅: 도구 실행 전 호출
# Matcher: * (모든 도구)

set -e

# stdin에서 JSON 읽기
input=$(cat)

# 도구 이름 추출
tool_name=$(echo "$input" | jq -r '.tool_name // empty')

# 예시: 특정 도구 차단 (주석 해제 시 활성화)
# if [[ "$tool_name" == "Bash" ]]; then
#   echo '{"decision": "block", "reason": "Bash 도구 사용 금지"}'
#   exit 0
# fi

# 허용
echo '{"decision": "approve"}'
