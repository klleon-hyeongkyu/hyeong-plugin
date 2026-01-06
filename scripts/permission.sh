#!/bin/bash
# PermissionRequest 훅: 권한 요청 시 호출
# Matcher: Bash (Bash 도구만)

set -e

# stdin에서 JSON 읽기
input=$(cat)

# 명령어 추출
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# 예시: 위험한 명령어 차단
# if echo "$command" | grep -qE 'rm -rf|sudo|chmod 777'; then
#   echo '{"decision": "block", "reason": "위험한 명령어 감지"}'
#   exit 0
# fi

# 허용 (사용자에게 권한 요청 팝업 표시)
echo '{"decision": "approve"}'
