# hyeong-plugin

Claude Code 스킬 마켓플레이스 - 문서, 디자인, 웹 개발, 생산성 도구

## 설치

```bash
# 마켓플레이스 추가
/plugin marketplace add ppotatoG/hyeong-plugin

# 플러그인 메뉴에서 개별 스킬 선택 설치
/plugin
```

## 스킬 목록

### Office (문서)

| 스킬 | 설명 |
|------|------|
| `docx` | Word 문서 생성/편집 (docx.js 기반) |
| `xlsx` | Excel 스프레드시트 생성/편집 |
| `pptx` | PowerPoint 프레젠테이션 생성 |
| `pdf` | PDF 생성/편집/폼 작성 |

### Design (디자인)

| 스킬 | 설명 |
|------|------|
| `algorithmic-art` | p5.js 기반 알고리즘 아트 생성 |
| `brand-guidelines` | 브랜드 가이드라인 적용 |
| `canvas-design` | 비주얼 디자인 생성 (포스터, 배너 등) |
| `theme-factory` | 10가지 프리셋 테마 스타일링 |
| `web-artifacts-builder` | React/Tailwind 웹 아티팩트 빌더 |

### Web (웹 개발)

| 스킬 | 설명 |
|------|------|
| `web-tailwind-patterns` | Tailwind CSS v3/v4 패턴, cn() 유틸리티 |
| `web-tanstack-form-patterns` | TanStack Form 패턴 |
| `web-tanstack-query-patterns` | TanStack Query + Axios 패턴 |
| `webapp-testing` | Playwright 웹앱 테스트 |

### Dev (개발 도구)

| 스킬 | 설명 |
|------|------|
| `mcp-builder` | MCP 서버 구축 가이드 (Python/TypeScript) |
| `skill-creator` | Claude Code 스킬 생성 가이드 |

| 명령어 | 설명 |
|--------|------|
| `/mcp-add:local` | MCP 로컬 설치 (현재 프로젝트) |
| `/mcp-add:global` | MCP 전역 설치 (모든 프로젝트) |
| `/mcp-add:shared` | MCP 프로젝트 설치 (팀 공유) |

### Productivity (생산성)

| 스킬 | 설명 |
|------|------|
| `doc-coauthoring` | 문서 공동 작성 워크플로우 |
| `internal-comms` | 내부 커뮤니케이션 문서 작성 |
| `slack-gif-creator` | Slack용 GIF 생성 |

## 구조

```
hyeong-plugin/
├── .claude-plugin/
│   └── marketplace.json    # 마켓플레이스 정의
├── docx/                   # 각 스킬 폴더
│   └── SKILL.md
├── pdf/
├── xlsx/
├── pptx/
├── algorithmic-art/
├── brand-guidelines/
├── canvas-design/
├── theme-factory/
├── web-artifacts-builder/
├── web-tailwind-patterns/
├── web-tanstack-form-patterns/
├── web-tanstack-query-patterns/
├── webapp-testing/
├── mcp-builder/
├── skill-creator/
├── mcp-add/                # 명령어
├── doc-coauthoring/
├── internal-comms/
├── slack-gif-creator/
└── README.md
```

## 라이선스

- **커스텀 스킬** (web-*): MIT
- **공식 스킬** (anthropics/skills 기반): Apache 2.0
