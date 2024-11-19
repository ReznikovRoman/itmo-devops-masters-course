from rest_framework.exceptions import ValidationError


def add(x: int, y: str) -> int:
    result = x + y
    return result

def divide(x: int, y: int) -> float:
    if y == 0:
        raise ValueError("Cannot divide by zero")
    return x / y


def main():
    print(add(1, 3))


if __name__ == '__main__':
    main()
