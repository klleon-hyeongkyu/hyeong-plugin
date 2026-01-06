# Changelog

모든 주요 변경 사항을 기록합니다.

## [1.0.0] - 2025-01-06

### 추가됨

- **플러그인 기본 구조**
  - `.claude-plugin/plugin.json` 매니페스트
  - 모든 필드 포함 (name, version, author, hooks, outputStyles 등)

- **Commands (슬래시 커맨드)**
  - `hello.md` - 기본 커맨드 예제
  - `advanced.md` - 모든 frontmatter 옵션 예제
  - `jira/my-tickets.md` - 하위 폴더 네임스페이싱 예제

- **Agents (커스텀 에이전트)**
  - `helper.md` - 기본 에이전트
  - `reviewer.md` - 모든 옵션 포함 (tools, model, permissionMode, skills)

- **Skills (자동 활성화 스킬)**
  - `greeting/` - 단일 참조 파일 패턴 (SKILL.md, REFERENCE.md, scripts/)
  - `code-check/` - 다중 참조 폴더 패턴 (references/, examples/)

- **Hooks (10개 이벤트)**
  - PreToolUse, PostToolUse, PermissionRequest, Notification
  - UserPromptSubmit, Stop, SubagentStop
  - PreCompact, SessionStart, SessionEnd

- **Scripts (훅 스크립트)**
  - 각 훅 이벤트에 대응하는 10개 쉘 스크립트
  - stdin JSON 파싱, stdout JSON 응답 예제

- **Output Styles (응답 스타일)**
  - `teaching.md` - 교육 모드 (keep-coding-instructions: true)
  - `formal.md` - 공식 모드 (keep-coding-instructions: false)

- **MCP 서버 설정**
  - stdio 타입 (로컬 프로세스)
  - http 타입 (HTTP 엔드포인트)
  - sse 타입 (Server-Sent Events)

- **LSP 서버 설정**
  - TypeScript (typescript-language-server)
  - Python (pyright)

- **문서**
  - 각 폴더별 README.md 설명서
  - `docs/mcp.md` - MCP 서버 가이드
  - `docs/lsp.md` - LSP 서버 가이드

### 참고

- 공식 문서 기준 모든 가능한 구성요소 포함
- 학습/테스트 목적으로 생성
