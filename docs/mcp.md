# MCP 서버 설명서

## 개요
**MCP (Model Context Protocol)** 서버는 Claude에게 외부 도구와 데이터 소스를 제공합니다.

## 설정 파일

`.mcp.json` 파일을 플러그인 루트에 생성:

```json
{
  "mcpServers": {
    "server-name": {
      "command": "실행 명령어",
      "args": ["인자들"],
      "env": { "환경변수": "값" }
    }
  }
}
```

## 서버 타입 (3가지)

### 1. stdio (기본)

로컬 프로세스 실행:

```json
{
  "mcpServers": {
    "local-server": {
      "command": "${CLAUDE_PLUGIN_ROOT}/scripts/mcp-server.py",
      "args": ["--mode", "production"],
      "env": {
        "DEBUG": "false",
        "API_KEY": "${MY_API_KEY}"
      }
    }
  }
}
```

### 2. http

HTTP 엔드포인트:

```json
{
  "mcpServers": {
    "http-server": {
      "type": "http",
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer ${API_TOKEN}",
        "X-Custom-Header": "value"
      }
    }
  }
}
```

### 3. sse (Server-Sent Events)

실시간 스트리밍:

```json
{
  "mcpServers": {
    "sse-server": {
      "type": "sse",
      "url": "https://api.example.com/sse"
    }
  }
}
```

## 환경 변수 확장

### 사용 가능한 변수

| 변수 | 설명 |
|------|------|
| `${CLAUDE_PLUGIN_ROOT}` | 플러그인 루트 경로 |
| `${CLAUDE_PROJECT_DIR}` | 현재 프로젝트 경로 |
| `${VAR_NAME}` | 시스템 환경 변수 |
| `${VAR:-default}` | 기본값 포함 |

### 예시

```json
{
  "mcpServers": {
    "my-server": {
      "command": "${CLAUDE_PLUGIN_ROOT}/bin/server",
      "env": {
        "API_KEY": "${API_KEY:-test-key}",
        "LOG_LEVEL": "${LOG_LEVEL:-info}"
      }
    }
  }
}
```

## 설정 옵션

### stdio 타입

| 옵션 | 타입 | 필수 | 설명 |
|------|------|------|------|
| `command` | string | ✅ | 실행할 명령어 |
| `args` | string[] | ❌ | 명령어 인자 |
| `env` | object | ❌ | 환경 변수 |
| `cwd` | string | ❌ | 작업 디렉토리 |

### http/sse 타입

| 옵션 | 타입 | 필수 | 설명 |
|------|------|------|------|
| `type` | string | ✅ | `"http"` 또는 `"sse"` |
| `url` | string | ✅ | 서버 URL |
| `headers` | object | ❌ | HTTP 헤더 |

## MCP 서버 개발

### Python (FastMCP)

```python
from fastmcp import FastMCP

mcp = FastMCP("my-server")

@mcp.tool()
def greet(name: str) -> str:
    """인사를 합니다."""
    return f"안녕하세요, {name}님!"

if __name__ == "__main__":
    mcp.run()
```

### Node.js

```javascript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";

const server = new Server({
  name: "my-server",
  version: "1.0.0",
});

server.setRequestHandler("tools/call", async (request) => {
  // 도구 구현
});
```

## 디버깅

```bash
# MCP 서버 직접 실행
python scripts/mcp-server.py

# Claude에서 확인
claude --debug
```

## 참고

- MCP 공식 문서: https://modelcontextprotocol.io
- Claude Code 문서: https://code.claude.com/docs/en/mcp.md
