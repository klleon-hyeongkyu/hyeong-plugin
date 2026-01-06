# hyeong-plugin

Claude Code 플러그인의 **모든 구성요소**를 포함한 테스트/학습용 플러그인입니다.

## 목적

- Claude Code 플러그인의 모든 기능 학습
- 각 구성요소를 하나씩 제거하며 동작 이해
- 공식 문서 기준 완전한 구조 파악

## 설치

```bash
# 플러그인 디렉토리로 이동
cd /path/to/hyeong-plugin

# Claude Code에서 플러그인 로드
claude --plugin-dir .

# 디버그 모드로 실행
claude --plugin-dir . --debug
```

## 구조

```
hyeong-plugin/
│
├── .claude-plugin/
│   ├── plugin.json          # 플러그인 매니페스트
│   └── README.md            # plugin.json 설명서
│
├── commands/                 # 슬래시 커맨드
│   ├── README.md            # commands 설명서
│   ├── hello.md             # 기본 커맨드
│   ├── advanced.md          # 모든 옵션 예제
│   └── jira/                # 하위 폴더 (네임스페이싱)
│       └── my-tickets.md    # 호출: /hyeong-plugin:my-tickets
│
├── agents/                   # 커스텀 에이전트
│   ├── README.md            # agents 설명서
│   ├── helper.md            # 기본 에이전트
│   └── reviewer.md          # 모든 옵션 예제
│
├── skills/                   # 자동 활성화 스킬
│   ├── README.md            # skills 설명서
│   ├── greeting/            # 패턴1: 단일 참조 파일
│   │   ├── SKILL.md
│   │   ├── REFERENCE.md
│   │   ├── examples.md
│   │   └── scripts/
│   │       └── helper.py
│   └── code-check/          # 패턴2: 다중 참조 폴더
│       ├── SKILL.md
│       ├── references/
│       │   ├── security.md
│       │   ├── performance.md
│       │   └── patterns.md
│       └── examples/
│           ├── good.md
│           └── bad.md
│
├── hooks/
│   ├── README.md            # hooks 설명서
│   └── hooks.json           # 10개 훅 이벤트 설정
│
├── scripts/                  # 훅 스크립트
│   ├── README.md            # scripts 설명서
│   ├── pre-tool.sh
│   ├── post-tool.sh
│   ├── permission.sh
│   ├── notify.sh
│   ├── validate-prompt.sh
│   ├── on-stop.sh
│   ├── subagent-stop.sh
│   ├── pre-compact.sh
│   ├── session-start.sh
│   └── session-end.sh
│
├── outputStyles/             # 응답 스타일
│   ├── README.md            # outputStyles 설명서
│   ├── teaching.md          # 교육 모드
│   └── formal.md            # 공식 모드
│
├── docs/                     # 추가 문서
│   ├── mcp.md               # MCP 서버 설명서
│   └── lsp.md               # LSP 서버 설명서
│
├── .mcp.json                 # MCP 서버 설정 (stdio, http, sse)
├── .lsp.json                 # LSP 서버 설정 (TypeScript, Python)
│
├── LICENSE
├── CHANGELOG.md
└── README.md                 # 이 파일
```

## 사용법

### Commands

```bash
# 기본 커맨드
/hyeong-plugin:hello World

# 고급 커맨드 (모든 옵션)
/hyeong-plugin:advanced arg1 arg2

# 하위 폴더 커맨드 (jira/)
/hyeong-plugin:my-tickets
```

### Agents

Task 도구에서 자동 사용:
- `helper`: 기본 도움 에이전트
- `reviewer`: 코드 리뷰 에이전트 (code-check 스킬 연동)

### Skills

설명(description)에 있는 키워드로 자동 활성화:
- `greeting`: "인사" 관련 작업
- `code-check`: "코드 리뷰" 관련 작업

### Output Styles

```bash
/output-style Teaching Mode
/output-style Formal Mode
```

## 구성요소별 하위 구조 지원

| 구성요소 | 하위 폴더 | scripts/ | references/ |
|---------|----------|----------|-------------|
| commands/ | ✅ 가능 (네임스페이싱) | ❌ | ❌ |
| agents/ | ❌ 불가 | ❌ | ❌ |
| skills/ | ✅ 가능 | ✅ 가능 | ✅ 가능 |
| hooks/ | ❌ | ❌ (루트 scripts/) | ❌ |

## 각 폴더별 설명서

모든 폴더에 `README.md`가 있습니다:
- `.claude-plugin/README.md` - plugin.json 모든 필드 설명
- `commands/README.md` - frontmatter 옵션, 변수, Bash 실행
- `agents/README.md` - frontmatter 옵션, permissionMode, model
- `skills/README.md` - SKILL.md, references/, scripts/ 패턴
- `hooks/README.md` - 10개 훅 이벤트, matcher, decision
- `scripts/README.md` - stdin/stdout JSON, 환경 변수
- `outputStyles/README.md` - keep-coding-instructions 옵션
- `docs/mcp.md` - MCP 서버 타입, 환경 변수 확장
- `docs/lsp.md` - LSP 설정, 언어별 예제

## 테스트 방법

```bash
# 1. 플러그인 디렉토리로 이동
cd /path/to/hyeong-plugin

# 2. Claude Code 실행
claude --plugin-dir . --debug

# 3. 커맨드 테스트
/hyeong-plugin:hello World

# 4. 스킬 테스트 (키워드로 자동 활성화)
"코드 리뷰해줘"

# 5. 스타일 변경
/output-style Teaching Mode
```

## 학습 방법

1. **전체 구조 이해**: 모든 폴더와 파일 확인
2. **설명서 읽기**: 각 폴더의 README.md 참조
3. **하나씩 제거**: 구성요소를 제거하며 동작 변화 확인
4. **수정 후 테스트**: 옵션 변경 후 효과 확인

## 참고

- [Claude Code 공식 문서](https://code.claude.com/docs)
- [MCP 공식 문서](https://modelcontextprotocol.io)
- [LSP 공식 문서](https://microsoft.github.io/language-server-protocol/)

## 라이선스

MIT License
