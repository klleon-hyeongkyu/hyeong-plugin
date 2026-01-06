#!/bin/bash
# Notification 훅: 알림 발송 시 호출
# Matcher: * (모든 알림)

set -e

# stdin에서 JSON 읽기
input=$(cat)

# 알림 정보 추출
title=$(echo "$input" | jq -r '.title // empty')
body=$(echo "$input" | jq -r '.body // empty')
type=$(echo "$input" | jq -r '.type // empty')

# 예시: 커스텀 알림 (macOS)
# osascript -e "display notification \"$body\" with title \"$title\"" 2>/dev/null || true

# 예시: 알림 로깅
echo "[Notification] $type: $title - $body" >> /tmp/claude-notifications.log 2>/dev/null || true

# 허용
echo '{"decision": "approve", "suppressOutput": true}'
