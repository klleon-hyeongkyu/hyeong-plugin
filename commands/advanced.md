---
description: 모든 frontmatter 옵션을 보여주는 고급 커맨드
allowed-tools: Bash(git:*), Read, Write, Grep, Glob
argument-hint: [name] [option]
model: claude-sonnet-4-20250514
disable-model-invocation: false
---

# Advanced Command

이 커맨드는 모든 가능한 옵션을 보여줍니다.

## 인자 처리

- 전체 인자: $ARGUMENTS
- 첫 번째 인자: $1
- 두 번째 인자: $2

## Bash 실행 결과 포함

현재 Git 상태:
!`git status --short`

최근 5개 커밋:
!`git log --oneline -5`

## 파일 참조

@README.md 파일의 내용을 분석하세요.

## 작업 지침

1. 위의 정보를 분석
2. 사용자 인자에 맞게 응답
3. 필요시 추가 정보 제공
