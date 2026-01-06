#!/usr/bin/env python3
"""
Greeting Helper Script

사용법:
    python helper.py "사용자이름"

이 스크립트는 SKILL.md에서 참조되며,
Claude가 실행만 하고 내용은 읽지 않습니다.
"""

import sys
from datetime import datetime


def get_greeting(name: str) -> str:
    """시간대에 맞는 인사말 생성"""
    hour = datetime.now().hour

    if 6 <= hour < 12:
        time_greeting = "좋은 아침이에요"
    elif 12 <= hour < 18:
        time_greeting = "좋은 오후예요"
    elif 18 <= hour < 22:
        time_greeting = "좋은 저녁이에요"
    else:
        time_greeting = "늦은 시간이네요"

    return f"{time_greeting}, {name}님!"


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("사용법: python helper.py <이름>")
        sys.exit(1)

    name = sys.argv[1]
    print(get_greeting(name))
