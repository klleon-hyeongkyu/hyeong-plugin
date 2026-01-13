---
name: shared
description: "MCP 프로젝트 설치 (project scope) - 팀 공유용, .mcp.json에 저장"
---

# /mcp-add:shared

프로젝트 MCP 설치 (팀 공유, .mcp.json에 저장)

## 인자

$ARGUMENTS: `<transport> <name> <url_or_command>`

## 실행

```bash
claude mcp add --scope project --transport $ARGUMENTS
```

## 예시

```
/mcp-add:shared http github https://api.githubcopilot.com/mcp/
/mcp-add:shared stdio shared-tool -- npx -y @team/shared-mcp
```

## 참고

- `.mcp.json`에 저장됨
- git 커밋하여 팀 공유
- 처음 사용 시 승인 필요
