# LSP 서버 설명서

## 개요
**LSP (Language Server Protocol)** 서버는 코드 인텔리전스 기능을 제공합니다.
- 정의로 이동
- 참조 찾기
- 자동 완성
- 호버 정보

## 설정 파일

`.lsp.json` 파일을 플러그인 루트에 생성:

```json
{
  "language-id": {
    "command": "language-server-command",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".ext": "language-id"
    }
  }
}
```

## 설정 옵션

| 옵션 | 타입 | 필수 | 설명 |
|------|------|------|------|
| `command` | string | ✅ | LSP 서버 실행 명령어 |
| `args` | string[] | ❌ | 명령어 인자 |
| `extensionToLanguage` | object | ❌ | 파일 확장자 → 언어 ID 매핑 |
| `initializationOptions` | object | ❌ | 서버 초기화 옵션 |
| `settings` | object | ❌ | 서버 설정 |

## 언어별 설정 예시

### TypeScript

```json
{
  "typescript": {
    "command": "typescript-language-server",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".ts": "typescript",
      ".tsx": "typescriptreact",
      ".js": "javascript",
      ".jsx": "javascriptreact"
    },
    "initializationOptions": {
      "preferences": {
        "includeInlayParameterNameHints": "all"
      }
    }
  }
}
```

### Python

```json
{
  "python": {
    "command": "pyright",
    "args": [],
    "extensionToLanguage": {
      ".py": "python",
      ".pyi": "python"
    },
    "settings": {
      "python": {
        "analysis": {
          "typeCheckingMode": "basic"
        }
      }
    }
  }
}
```

### Rust

```json
{
  "rust": {
    "command": "rust-analyzer",
    "args": [],
    "extensionToLanguage": {
      ".rs": "rust"
    }
  }
}
```

### Go

```json
{
  "go": {
    "command": "gopls",
    "args": [],
    "extensionToLanguage": {
      ".go": "go"
    }
  }
}
```

## 다중 언어 설정

```json
{
  "typescript": {
    "command": "typescript-language-server",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".ts": "typescript",
      ".tsx": "typescriptreact"
    }
  },
  "python": {
    "command": "pyright",
    "extensionToLanguage": {
      ".py": "python"
    }
  },
  "rust": {
    "command": "rust-analyzer",
    "extensionToLanguage": {
      ".rs": "rust"
    }
  }
}
```

## 환경 변수

`.mcp.json`과 동일하게 환경 변수 확장 지원:

```json
{
  "typescript": {
    "command": "${CLAUDE_PLUGIN_ROOT}/node_modules/.bin/typescript-language-server",
    "args": ["--stdio"]
  }
}
```

## LSP 도구 사용

Claude에서 LSP 도구 사용 예:

```
LSP goToDefinition src/index.ts:10:5
LSP findReferences src/utils.ts:20:10
LSP hover src/types.ts:5:15
```

## 지원되는 LSP 기능

| 기능 | 설명 |
|------|------|
| `goToDefinition` | 심볼 정의 위치로 이동 |
| `findReferences` | 심볼 참조 찾기 |
| `hover` | 심볼 정보 표시 |
| `documentSymbol` | 문서 내 심볼 목록 |
| `workspaceSymbol` | 워크스페이스 심볼 검색 |
| `goToImplementation` | 구현체로 이동 |
| `prepareCallHierarchy` | 호출 계층 준비 |
| `incomingCalls` | 호출하는 함수 찾기 |
| `outgoingCalls` | 호출되는 함수 찾기 |

## 설치 필요 패키지

| 언어 | 패키지 |
|------|--------|
| TypeScript | `npm install -g typescript-language-server typescript` |
| Python | `pip install pyright` |
| Rust | `rustup component add rust-analyzer` |
| Go | `go install golang.org/x/tools/gopls@latest` |

## 디버깅

```bash
# LSP 서버 직접 실행
typescript-language-server --stdio

# 로그 확인
claude --debug
```

## 참고

- LSP 공식 문서: https://microsoft.github.io/language-server-protocol/
- Claude Code 문서: https://code.claude.com/docs/en/lsp.md
