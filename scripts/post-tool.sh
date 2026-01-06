#!/bin/bash
# PostToolUse 훅: 도구 성공 후 호출
# Matcher: Write|Edit (파일 수정 도구만)

set -e

# stdin에서 JSON 읽기
input=$(cat)

# 도구 정보 추출
tool_name=$(echo "$input" | jq -r '.tool_name // empty')
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# 예시: 파일 수정 로깅
if [[ -n "$file_path" ]]; then
  echo "[PostToolUse] $tool_name: $file_path" >> /tmp/claude-file-changes.log 2>/dev/null || true
fi

# 허용 (PostToolUse는 이미 실행 완료됨)
echo '{"decision": "approve", "suppressOutput": true}'
