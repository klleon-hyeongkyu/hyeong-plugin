# Claude Code 플러그인 공식 문서 정리

> 조사일: 2025-01-14
> 출처: Anthropic 공식 문서

## 1. 플러그인 폴더 구조 (공식 표준)

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # 플러그인 메타데이터 (필수)
├── commands/                # 슬래시 명령어 (선택)
├── agents/                  # 특화 에이전트 (선택)
├── skills/                  # 에이전트 스킬 (선택)
├── hooks/                   # 이벤트 핸들러 (선택)
├── .mcp.json               # MCP 서버 설정 (선택)
└── README.md               # 문서
```

### 플랫 구조 (마켓플레이스용)

```
marketplace-repo/
├── .claude-plugin/
│   └── marketplace.json    # 마켓플레이스 정의 (필수)
├── skill-1/
│   └── SKILL.md
├── skill-2/
│   └── SKILL.md
└── README.md
```

---

## 2. plugin.json 스키마

```json
{
  "name": "plugin-name",           // 필수: 플러그인 식별자
  "version": "1.0.0",              // 필수: 시맨틱 버전
  "description": "플러그인 설명",    // 필수: 간단한 설명
  "author": {                      // 필수: 작성자 정보
    "name": "Author Name",
    "email": "author@example.com",
    "url": "https://github.com/..."
  },
  "repository": "https://github.com/...",  // 선택: 저장소 URL
  "homepage": "https://...",               // 선택: 문서 URL
  "license": "MIT",                        // 선택: 라이선스
  "keywords": ["tag1", "tag2"],            // 선택: 검색 태그

  // 컴포넌트 경로 지정
  "commands": "./commands/",       // 슬래시 명령어 경로
  "agents": "./agents/",           // 에이전트 경로
  "skills": "./skills/",           // 스킬 경로
  "hooks": "./hooks/"              // 훅 경로
}
```

---

## 3. marketplace.json 스키마

```json
{
  "$schema": "https://anthropic.com/claude-code/marketplace.schema.json",
  "name": "marketplace-name",
  "version": "1.0.0",
  "description": "마켓플레이스 설명",
  "owner": {
    "name": "Organization",
    "email": "team@org.com"
  },
  "plugins": [
    {
      "name": "plugin-name",
      "description": "플러그인 설명",
      "version": "1.0.0",
      "author": {
        "name": "Author",
        "email": "author@example.com"
      },
      "source": "./plugins/plugin-name",  // 상대 경로 또는 GitHub URL
      "category": "development",          // 카테고리
      "homepage": "https://github.com/...",
      "tags": ["community-managed"]
    }
  ]
}
```

### 카테고리 종류

| 카테고리 | 설명 |
|----------|------|
| `development` | 개발 도구, 언어 서버 |
| `productivity-organization` | 생산성, 문서 관리 |
| `communication-writing` | 커뮤니케이션, 작문 |
| `creative-media` | 디자인, 미디어 |
| `security` | 보안 도구 |
| `testing` | 테스트 자동화 |
| `database` | 데이터베이스 통합 |
| `deployment` | 배포 플랫폼 |
| `monitoring` | 모니터링, 에러 추적 |
| `business-marketing` | 비즈니스, 마케팅 |

---

## 4. 플러그인 컴포넌트

### Commands (슬래시 명령어)

- `/` 접두사가 붙는 커스텀 명령어
- 예: `/code-review`, `/mcp-add:local`
- `commands/` 디렉토리에 위치

### Agents (에이전트)

- 특정 작업을 위한 특화 AI 에이전트
- 예: `code-explorer`, `code-architect`
- `agents/` 디렉토리에 위치

### Skills (스킬)

- 특정 컨텍스트에서 자동 호출되는 가이드/전문성
- 예: `frontend-design` - 프론트엔드 작업 시 자동 활성화
- `skills/` 디렉토리에 위치
- `SKILL.md` 파일로 정의

### Hooks (훅)

- 특정 이벤트에 응답하는 핸들러
- 타입: `SessionStart`, `PreToolUse`, `Stop`
- `hooks/` 디렉토리에 위치

### MCP Integration (.mcp.json)

- Model Context Protocol 서버 설정
- 외부 도구/API 연동

---

## 5. 공유 방법 (Distribution)

### 방법 1: 마켓플레이스 호스팅

```bash
# 마켓플레이스 추가
/plugin marketplace add user-or-org/repo-name

# 플러그인 메뉴에서 설치
/plugin
```

**요구사항:** `.claude-plugin/marketplace.json` 파일이 있는 Git/GitHub 저장소

### 방법 2: 직접 GitHub 설치

```bash
/plugin install github:user/repo-name
```

### 방법 3: 프로젝트 설정 파일

`.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "plugin-name@marketplace": true
  },
  "extraKnownMarketplaces": {
    "my-marketplace": {
      "source": "github",
      "repo": "user/repo-name"
    }
  }
}
```

### 방법 4: 로컬 설치

```bash
/plugin install /path/to/local/plugin
```

---

## 6. 업데이트 방법

- 플러그인은 Git 저장소 기반이므로 **저장소의 버전 태깅**으로 관리
- `plugin.json` 또는 `marketplace.json`의 `version` 필드 업데이트
- 사용자는 `/plugin` 명령어로 최신 버전 확인 및 업데이트

---

## 7. 공식 마켓플레이스 제출

**저장소:** [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)

### 구조

```
claude-plugins-official/
├── /plugins              # Internal plugins (Anthropic 개발)
├── /external_plugins     # Third-party plugins (커뮤니티/파트너)
├── .claude-plugin/
│   └── marketplace.json
└── .github/workflows     # CI/CD 자동화
```

### 제출 요건

- **Internal Plugins**: Anthropic 팀 개발
- **External Plugins**: 커뮤니티/파트너 제출
  - 품질 및 보안 검토 필요
  - 표준 플러그인 구조 준수
  - README.md 문서 포함

### 보안 주의사항

> ⚠️ 플러그인을 설치, 업데이트, 사용하기 전에 신뢰할 수 있는지 확인하세요.
> Anthropic은 플러그인에 포함된 MCP 서버, 파일 또는 기타 소프트웨어를
> 제어하지 않으며 의도한 대로 작동하거나 변경되지 않을 것이라고 보장할 수 없습니다.

---

## 8. SKILL.md 작성법

```markdown
| Field | Value |
|-------|-------|
| name | skill-name |
| description | 스킬 설명 및 Claude가 언제 사용해야 하는지 |

# 스킬 제목

## 개요
스킬의 목적과 사용 시기

## 지침
Claude가 따라야 할 구체적인 지침

## 예제
사용 예제 및 출력 형식
```

---

## 9. 참고 링크

- [Create plugins - Claude Code Docs](https://code.claude.com/docs/en/plugins)
- [Plugins reference - Claude Code Docs](https://code.claude.com/docs/en/plugins-reference)
- [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)
- [Claude Code Plugin Template](https://github.com/ivan-magda/claude-code-plugin-template)
- [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)
- [Customize Claude Code with plugins | Claude Blog](https://claude.com/blog/claude-code-plugins)
