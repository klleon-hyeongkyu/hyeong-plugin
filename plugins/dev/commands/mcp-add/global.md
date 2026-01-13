---
name: global
description: "MCP 전역 설치 (user scope) - 모든 프로젝트에서 사용"
---

# /mcp-add:global

전역 MCP 설치 (모든 프로젝트에서 사용 가능)

## 인자

$ARGUMENTS: `<transport> <name> <url_or_command>`

## 실행

```bash
claude mcp add --scope user --transport $ARGUMENTS
```

## 예시

```
/mcp-add:global http notion https://mcp.notion.com/mcp
/mcp-add:global sse atlassian https://mcp.atlassian.com/v1/sse
/mcp-add:global stdio context7 -- npx -y @upstash/context7-mcp
```
