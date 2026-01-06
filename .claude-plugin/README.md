# plugin.json 설명서

## 개요
`plugin.json`은 플러그인의 메타데이터를 정의하는 **필수 파일**입니다.

## 필드 설명

### 필수 필드

| 필드 | 타입 | 설명 |
|------|------|------|
| `name` | string | 플러그인 고유 식별자 (kebab-case, 소문자+하이픈) |

### 선택 필드

| 필드 | 타입 | 설명 |
|------|------|------|
| `version` | string | 시맨틱 버전 (예: "1.0.0") |
| `description` | string | 플러그인 설명 |
| `author` | object | 제작자 정보 `{ name, email, url }` |
| `homepage` | string | 문서/홈페이지 URL |
| `repository` | string | 소스 코드 저장소 URL |
| `license` | string | 라이선스 (MIT, Apache-2.0 등) |
| `keywords` | string[] | 검색 태그 배열 |
| `commands` | string\|string[] | 커스텀 commands 경로 |
| `agents` | string\|string[] | 커스텀 agents 경로 |
| `skills` | string\|string[] | 커스텀 skills 경로 |
| `hooks` | string\|object | hooks 설정 파일 경로 또는 인라인 객체 |
| `mcpServers` | string\|object | MCP 서버 설정 파일 경로 또는 인라인 객체 |
| `lspServers` | string\|object | LSP 서버 설정 파일 경로 또는 인라인 객체 |
| `outputStyles` | string\|string[] | 아웃풋 스타일 경로 |

## 예제

### 최소 구성
```json
{
  "name": "my-plugin"
}
```

### 전체 구성
```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "My awesome plugin",
  "author": {
    "name": "Developer",
    "email": "dev@example.com",
    "url": "https://github.com/dev"
  },
  "homepage": "https://docs.example.com",
  "repository": "https://github.com/dev/my-plugin",
  "license": "MIT",
  "keywords": ["utility", "automation"],
  "hooks": "./hooks/hooks.json",
  "outputStyles": "./outputStyles/"
}
```

## 경로 규칙

- 모든 경로는 **상대 경로**로 `./`로 시작
- 플러그인 루트 위로 `../` 이동 불가
- 환경 변수 확장: `${CLAUDE_PLUGIN_ROOT}`

## 참고
- 공식 문서: https://code.claude.com/docs/en/plugins-reference.md
