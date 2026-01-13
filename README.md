# hyeong-plugin

Claude Code 플러그인 모노레포 - 필요한 플러그인만 선택 설치 가능

## 구조

```
hyeong-plugin/
├── plugins/
│   ├── office/       # 문서 생성/편집
│   ├── design/       # 디자인 관련
│   ├── productivity/ # 생산성 도구
│   ├── web/          # Web 개발 패턴
│   └── dev/          # 개발 도구 + MCP 명령어
└── README.md
```

## 플러그인 목록

### office (hyeong-office)
| Skill | 설명 |
|-------|------|
| `docx` | Word 문서 생성/편집 |
| `xlsx` | Excel 스프레드시트 |
| `pptx` | PowerPoint 프레젠테이션 |
| `pdf` | PDF 생성/편집/폼 작성 |

### design (hyeong-design)
| Skill | 설명 |
|-------|------|
| `algorithmic-art` | p5.js 알고리즘 아트 |
| `brand-guidelines` | 브랜드 가이드라인 적용 |
| `canvas-design` | 비주얼 디자인 생성 |
| `theme-factory` | 테마 스타일링 |
| `web-artifacts-builder` | 웹 아티팩트 빌더 |

### productivity (hyeong-productivity)
| Skill | 설명 |
|-------|------|
| `doc-coauthoring` | 문서 공동 작성 워크플로우 |
| `internal-comms` | 내부 커뮤니케이션 문서 |
| `slack-gif-creator` | Slack용 GIF 생성 |

### web (hyeong-web)
| Skill | 설명 |
|-------|------|
| `web-tailwind-patterns` | Tailwind CSS v3/v4 패턴, cn() 유틸리티 |
| `web-tanstack-form-patterns` | TanStack Form 패턴 |
| `web-tanstack-query-patterns` | TanStack Query + Axios 패턴 |
| `webapp-testing` | Playwright 웹앱 테스트 |

### dev (hyeong-dev)
| Skill | 설명 |
|-------|------|
| `mcp-builder` | MCP 서버 구축 가이드 |
| `skill-creator` | 스킬 생성 가이드 |

| Command | 설명 |
|---------|------|
| `/mcp-add:local` | MCP 로컬 설치 (현재 프로젝트) |
| `/mcp-add:global` | MCP 전역 설치 (모든 프로젝트) |
| `/mcp-add:shared` | MCP 프로젝트 설치 (팀 공유) |

## 설치

### 특정 플러그인만 설치

```bash
# Office 플러그인만
claude /install /Users/path/to/hyeong-plugin/plugins/office

# Web 개발 플러그인만
claude /install /Users/path/to/hyeong-plugin/plugins/web

# Dev 도구 플러그인만
claude /install /Users/path/to/hyeong-plugin/plugins/dev
```

### 테스트

```bash
# 특정 플러그인 테스트
claude --plugin-dir /path/to/hyeong-plugin/plugins/web

# 다른 프로젝트에서 테스트
cd my-project
claude --plugin-dir /path/to/hyeong-plugin/plugins/office
```

## 라이선스

- **커스텀 스킬** (web-*): MIT
- **공식 스킬** (anthropics/skills 기반): Apache 2.0
