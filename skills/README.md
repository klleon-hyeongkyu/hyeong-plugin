# Skills 설명서

## 개요
**스킬(Skills)**은 Claude의 기능을 확장하는 마크다운 파일입니다.
사용자 요청이 스킬 설명과 일치하면 **자동으로 활성화**됩니다.

## 폴더 구조

Skills는 **유일하게 하위 구조를 지원**합니다.

### 패턴 1: 단일 참조 파일
```
skills/
└── greeting/
    ├── SKILL.md           # 필수
    ├── REFERENCE.md       # 단일 참조 파일
    ├── examples.md        # 예제 파일
    └── scripts/
        └── helper.py      # 유틸리티 스크립트
```

### 패턴 2: 다중 참조 폴더
```
skills/
└── code-check/
    ├── SKILL.md           # 필수
    ├── references/        # 참조 폴더
    │   ├── security.md
    │   ├── performance.md
    │   └── patterns.md
    └── examples/          # 예제 폴더
        ├── good.md
        └── bad.md
```

## SKILL.md 형식

### Frontmatter 옵션

```yaml
---
name: skill-name
description: 스킬 설명. 트리거 키워드 포함.
allowed-tools: Read, Grep, Glob
model: claude-sonnet-4-20250514
---
```

| 옵션 | 필수 | 설명 |
|------|------|------|
| `name` | O | 스킬 고유 이름 (lowercase + hyphen) |
| `description` | O | 스킬 용도 (Claude가 자동 활성화 판단) |
| `allowed-tools` | X | 사용 가능한 도구 제한 |
| `model` | X | 특정 모델 지정 |

## Progressive Disclosure 패턴

### 원칙
- **SKILL.md는 500줄 이하** 유지
- 상세 내용은 별도 파일로 분리
- Claude가 필요할 때만 참조 파일 로드

### 참조 방법
```markdown
자세한 내용은 [REFERENCE.md](REFERENCE.md) 참조.
보안 패턴은 [references/security.md](references/security.md) 참조.
```

### 1단계 깊이 규칙
- SKILL.md에서 **직접 링크**만 권장
- 중첩 참조 (A→B→C) 지양
- 깊은 중첩은 부분 로드 문제 발생

## scripts/ 폴더

- 실행 가능한 유틸리티 스크립트
- **내용을 읽지 않고 실행만** 함
- 컨텍스트 비용 절약

```markdown
## 유틸리티
```bash
python scripts/helper.py input.txt
```
```

## 자동 활성화

`description`에 트리거 키워드 포함:
- "PDF 파일 작업 시 사용"
- "인사할 때 활성화"
- "코드 검사 시 자동 사용"

## 참고
- 공식 문서: https://code.claude.com/docs/en/skills.md
