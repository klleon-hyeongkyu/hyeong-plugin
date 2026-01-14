# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

이 저장소는 Claude Code 스킬 마켓플레이스입니다. Office 문서, 디자인, 웹 개발, 생산성 도구 등 20개 이상의 스킬을 포함합니다.

**구조 타입**: Flat Marketplace Structure (마켓플레이스용 플랫 구조)
- 개별 플러그인 구조와 다름 (commands/, agents/, hooks/ 없음)
- marketplace.json으로 여러 스킬을 번들로 배포
- 각 스킬은 독립된 디렉토리에 SKILL.md 포함

## Repository Architecture

### Plugin vs Marketplace Structure

이 저장소는 **Marketplace Structure**를 사용합니다:

**Standard Plugin Structure** (단일 플러그인):
```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # 플러그인 메타데이터
├── commands/                # 슬래시 명령어 (/command)
├── agents/                  # 특화 에이전트
├── skills/                  # 에이전트 스킬
├── hooks/                   # 이벤트 핸들러
└── .mcp.json               # MCP 서버 설정
```

**Marketplace Structure** (여러 스킬 번들):
```
marketplace-repo/
├── .claude-plugin/
│   └── marketplace.json    # 마켓플레이스 정의
├── skill-1/
│   └── SKILL.md
├── skill-2/
│   └── SKILL.md
└── README.md
```

**주요 차이점**:
- Marketplace는 commands/, agents/, hooks/ 디렉토리 없음
- 각 스킬이 독립된 디렉토리에 SKILL.md로 정의
- marketplace.json이 여러 스킬을 하나의 번들로 관리
- 사용자는 마켓플레이스에서 원하는 스킬만 선택 설치 가능

### Marketplace Structure

```
hyeong-plugin/
├── .claude-plugin/
│   └── marketplace.json       # 마켓플레이스 메타데이터, 모든 스킬 정의
├── [skill-name]/              # 각 스킬 디렉토리
│   ├── SKILL.md              # 필수: YAML frontmatter + 설명
│   ├── scripts/              # 선택: 실행 가능한 코드
│   ├── references/           # 선택: 참조 문서 (컨텍스트에 로드됨)
│   └── assets/               # 선택: 출력용 파일 (컨텍스트 미로드)
└── skill-creator/             # 스킬 생성 도구
    └── scripts/
        ├── init_skill.py     # 새 스킬 초기화
        └── package_skill.py  # 스킬 검증 및 패키징
```

### Skill Categories

- **Office**: docx, xlsx, pptx, pdf
- **Design**: algorithmic-art, brand-guidelines, canvas-design, theme-factory, web-artifacts-builder
- **Web**: web-tailwind-patterns, web-tanstack-form-patterns, web-tanstack-query-patterns, webapp-testing
- **Dev**: mcp-builder, skill-creator, mcp-add
- **Productivity**: doc-coauthoring, internal-comms, slack-gif-creator

## Common Commands

### Skill Development

```bash
# 새 스킬 초기화
python skill-creator/scripts/init_skill.py <skill-name> --path <output-dir>

# 스킬 검증 및 패키징 (.skill 파일 생성)
python skill-creator/scripts/package_skill.py <path/to/skill-folder>

# 출력 디렉토리 지정
python skill-creator/scripts/package_skill.py <path/to/skill-folder> ./dist
```

### Git Workflow

```bash
# 변경사항 확인
git status
git diff

# 커밋 (커밋 메시지는 한국어로)
git add .
git commit -m "feat: 새 스킬 추가"

# 브랜치 확인
git branch
```

## Skill Design Principles

### 1. Progressive Disclosure

스킬은 3단계 로딩 시스템을 사용:
1. **Metadata** (name + description): 항상 컨텍스트에 있음 (~100 words)
2. **SKILL.md body**: 스킬이 트리거될 때 로드 (<5k words, <500 lines)
3. **Bundled resources**: Claude가 필요할 때 로드

### 2. SKILL.md Structure

#### Frontmatter (YAML)
```yaml
---
name: skill-name
description: "스킬이 무엇을 하는지 + 언제 사용해야 하는지 명확히 기술. 이것이 주요 트리거 메커니즘."
---
```

**중요**: `description`은 스킬 트리거의 주요 메커니즘입니다:
- 스킬이 무엇을 하는지 포함
- 언제 사용해야 하는지 구체적으로 명시
- "When to Use" 정보는 body가 아닌 여기에 포함 (body는 트리거 후에만 로드됨)

#### Body

- 간결하게 작성 (Claude는 이미 매우 똑똑함)
- 500줄 미만 유지
- 버전별/도메인별로 분리된 경우 references/ 파일로 분할
- 명확한 워크플로우와 예시 제공

### 3. Resource Organization

**scripts/**: 반복적으로 재작성되거나 결정론적 신뢰성이 필요한 코드
- 예: `pdf/scripts/rotate_pdf.py`
- 실행 전 테스트 필수

**references/**: Claude가 작업 중 참조할 문서
- 예: API 문서, 스키마, 정책, 상세 가이드
- SKILL.md를 간결하게 유지하기 위해 사용
- 10k+ words인 경우 SKILL.md에 grep 패턴 포함

**assets/**: 출력에 사용될 파일 (컨텍스트에 로드되지 않음)
- 예: 템플릿, 이미지, 아이콘, 보일러플레이트
- 복사하거나 수정하여 사용

### 4. Content Split Patterns

**버전/프레임워크별 분할**:
```
web-tailwind-patterns/
├── SKILL.md (공통 패턴 + 버전 선택 가이드)
└── references/
    ├── v3.md
    └── v4.md
```

**도메인별 분할**:
```
bigquery-skill/
├── SKILL.md (개요 + 네비게이션)
└── references/
    ├── finance.md
    ├── sales.md
    └── product.md
```

## Editing Guidelines

### Adding a New Skill

1. 구체적인 사용 예시로 스킬 이해
2. 재사용 가능한 리소스 계획 (scripts, references, assets)
3. `python skill-creator/scripts/init_skill.py <skill-name> --path .`
4. SKILL.md frontmatter 작성 (특히 description)
5. 리소스 구현 (scripts는 테스트 필수)
6. SKILL.md body 작성
7. `python skill-creator/scripts/package_skill.py <skill-name>`
8. 실제 사용으로 반복 개선

### Editing marketplace.json

새 스킬 추가 시 `.claude-plugin/marketplace.json`에 항목 추가:

```json
{
  "name": "skill-name",
  "description": "한 줄 설명",
  "source": "./skill-name",
  "category": "development"
}
```

#### marketplace.json 공식 스키마

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
      "version": "1.0.0",           // 선택
      "author": {                   // 선택
        "name": "Author",
        "email": "author@example.com"
      },
      "source": "./skill-name",     // 필수: 상대 경로 또는 GitHub URL
      "category": "development",    // 필수
      "homepage": "https://...",    // 선택
      "tags": ["community-managed"] // 선택
    }
  ]
}
```

#### 공식 카테고리

| 카테고리 | 설명 | 현재 사용 |
|----------|------|----------|
| `development` | 개발 도구, 언어 서버 | mcp-builder, skill-creator, mcp-add, web-artifacts-builder |
| `productivity-organization` | 생산성, 문서 관리 | docx, xlsx, pptx, pdf, doc-coauthoring |
| `communication-writing` | 커뮤니케이션, 작문 | internal-comms |
| `creative-media` | 디자인, 미디어 | algorithmic-art, brand-guidelines, canvas-design, theme-factory, slack-gif-creator |
| `testing` | 테스트 자동화 | webapp-testing |
| `security` | 보안 도구 | - |
| `database` | 데이터베이스 통합 | - |
| `deployment` | 배포 플랫폼 | - |
| `monitoring` | 모니터링, 에러 추적 | - |
| `business-marketing` | 비즈니스, 마케팅 | - |

### Code Style

- 간결한 코드 작성
- 불필요한 print 문 지양
- 명확하고 짧은 변수명

## Architecture Notes

### Skill Loading Mechanism

Claude Code는 다음 순서로 스킬을 로드합니다:

1. **Discovery**: 모든 스킬의 `name`과 `description` 읽기
2. **Triggering**: 사용자 요청에 맞는 스킬 선택
3. **Loading**: 선택된 스킬의 SKILL.md body 로드
4. **Execution**: 필요시 bundled resources 로드/실행

### mcp-add Special Case

`mcp-add`는 명령어 기반 스킬로 SKILL.md 대신 `.md` 파일 사용:
- `local.md`: /mcp-add:local
- `global.md`: /mcp-add:global
- `shared.md`: /mcp-add:shared

각 파일은 `claude mcp add` 명령어 래퍼입니다.

## Distribution & Installation

### 마켓플레이스 설치 (권장)

```bash
# 마켓플레이스 추가
/plugin marketplace add klleon-hyeongkyu/hyeong-plugin

# 플러그인 메뉴에서 개별 스킬 선택 설치
/plugin
```

**요구사항**: `.claude-plugin/marketplace.json` 파일이 있는 GitHub 저장소

### 기타 설치 방법

```bash
# GitHub 직접 설치
/plugin install github:klleon-hyeongkyu/hyeong-plugin

# 로컬 설치 (개발용)
/plugin install /path/to/hyeong-plugin

# 프로젝트별 설정 (.claude/settings.json)
{
  "enabledPlugins": {
    "hyeong-plugin@marketplace": true
  },
  "extraKnownMarketplaces": {
    "hyeong": {
      "source": "github",
      "repo": "klleon-hyeongkyu/hyeong-plugin"
    }
  }
}
```

## Version Management

### 버전 업데이트 프로세스

1. **코드 변경**: 스킬 수정 또는 새 스킬 추가
2. **버전 업데이트**: `.claude-plugin/marketplace.json`의 `version` 필드 수정
   - Semantic Versioning 사용: `MAJOR.MINOR.PATCH`
   - 예: 새 스킬 추가 → MINOR 증가 (1.0.0 → 1.1.0)
3. **Git 태깅**: 버전과 일치하는 Git 태그 생성
   ```bash
   git tag v1.1.0
   git push origin v1.1.0
   ```
4. **배포**: 사용자는 `/plugin` 명령어로 업데이트 확인 및 설치

### 버전 관리 정책

- Git 저장소 기반 버전 관리
- 각 버전은 Git 태그로 표시
- marketplace.json의 version 필드와 Git 태그 동기화 유지

## Security & Compliance

### ⚠️ 보안 주의사항

> 플러그인을 설치, 업데이트, 사용하기 전에 신뢰할 수 있는지 확인하세요.
> Anthropic은 플러그인에 포함된 MCP 서버, 파일 또는 기타 소프트웨어를 제어하지 않으며
> 의도한 대로 작동하거나 변경되지 않을 것이라고 보장할 수 없습니다.

### 스크립트 보안 검토

- 모든 `scripts/` 디렉토리의 Python 코드는 실행 전 검토 필요
- 외부 패키지 의존성 최소화
- 민감한 정보 (API 키, 토큰) 하드코딩 금지

### 공식 마켓플레이스 제출

**저장소**: [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)

- **Internal Plugins**: Anthropic 팀 개발
- **External Plugins**: 커뮤니티/파트너 제출
  - 품질 및 보안 검토 필요
  - 표준 플러그인 구조 준수
  - README.md 문서 포함

## Key Files

- `.claude-plugin/marketplace.json`: 모든 스킬 메타데이터
- `skill-creator/SKILL.md`: 스킬 생성 가이드 (357줄)
- `skill-creator/scripts/init_skill.py`: 스킬 초기화 스크립트
- `skill-creator/scripts/package_skill.py`: 검증 및 패키징 스크립트
- `docs/plugin-reference.md`: 공식 문서 정리본
- `README.md`: 사용자 대면 문서

## References

### Official Documentation

- [Create plugins - Claude Code Docs](https://code.claude.com/docs/en/plugins)
- [Plugins reference - Claude Code Docs](https://code.claude.com/docs/en/plugins-reference)
- [Customize Claude Code with plugins - Claude Blog](https://claude.com/blog/claude-code-plugins)
- [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) - 공식 플러그인 저장소

### Community Resources

- [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) - 커뮤니티 스킬 모음
- [Claude Code Plugin Template](https://github.com/ivan-magda/claude-code-plugin-template) - 플러그인 템플릿

### Internal Docs

- `docs/plugin-reference.md`: Anthropic 공식 문서 정리 (2025-01-14 조사)
- `skill-creator/references/`: 스킬 디자인 패턴 가이드
  - `workflows.md`: 다단계 프로세스 패턴
  - `output-patterns.md`: 출력 형식 및 품질 표준
