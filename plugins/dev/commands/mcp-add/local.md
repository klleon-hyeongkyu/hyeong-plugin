---
name: local
description: "MCP 로컬 설치 (local scope) - 현재 프로젝트만, 개인용"
---

# /mcp-add:local

로컬 MCP 설치 (현재 프로젝트만, git 미포함)

## 인자

$ARGUMENTS: `<transport> <name> <url_or_command>`

## 실행

```bash
claude mcp add --scope local --transport $ARGUMENTS
```

## 예시

```
/mcp-add:local http api https://api.example.com/mcp
/mcp-add:local stdio serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --project $PWD
```
