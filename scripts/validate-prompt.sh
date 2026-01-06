#!/bin/bash
# UserPromptSubmit 훅: 사용자 프롬프트 제출 시 호출
# Matcher 없음 (모든 프롬프트)

set -e

# stdin에서 JSON 읽기
input=$(cat)

# 프롬프트 추출
prompt=$(echo "$input" | jq -r '.prompt // empty')

# 예시: 특정 키워드 차단
# if echo "$prompt" | grep -qiE 'password|secret|api.?key'; then
#   echo '{"decision": "block", "reason": "민감한 정보가 포함된 프롬프트"}'
#   exit 0
# fi

# 허용
echo '{"decision": "approve"}'
