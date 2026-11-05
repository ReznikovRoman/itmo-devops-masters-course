#!/usr/bin/env bash
set -euo pipefail

step() { printf '\n\033[1;36m=== %s ===\033[0m\n' "$*"; }

WORK=$(mktemp -d)
echo "Рабочая папка: $WORK"
cd "$WORK"

git init -q --bare -b main origin.git

setup_clone() {  # $1 = имя папки, $2 = имя автора
  git clone -q origin.git "$1" 2>/dev/null
  git -C "$1" config user.name "$2"
  git -C "$1" config user.email "$2@example.com"
}

setup_clone dev Dev
setup_clone colleague Colleague

step "0. Исходное состояние main (общий репозиторий)"
cd dev
git checkout -q -b main 2>/dev/null || true
cat > requirements.txt <<'REQ'
fastapi==0.110.0
uvicorn==0.29.0
REQ
cat > app.py <<'APP'
def discount(price, percent):
    return price * (100 - percent) / 100
APP
git add .
git commit -qm "chore: initial service"
git push -q -u origin main
git log --oneline

step "1. Dev делает feature-ветку и открывает 'PR'"
git checkout -q -b feature/discount-validation
sed 's/fastapi==0.110.0/fastapi==0.111.0/' requirements.txt > requirements.txt.tmp && mv requirements.txt.tmp requirements.txt
cat > app.py <<'APP'
def discount(price, percent):
    if not 0 <= percent <= 100:
        raise ValueError("percent must be between 0 and 100")
    return price * (100 - percent) / 100
APP
git commit -qam "feat: validate discount percent"
git push -q -u origin feature/discount-validation
git log --oneline --graph --all

step "2. Пока идёт ревью, коллега обновляет ту же зависимость в main"
cd ../colleague
git pull -q origin main
sed 's/fastapi==0.110.0/fastapi==0.115.6/' requirements.txt > requirements.txt.tmp && mv requirements.txt.tmp requirements.txt
git commit -qam "chore: bump fastapi (security fix)"
git push -q origin main
git log --oneline

step "3. Dev смотрит, что произошло: ветка отстала от main"
cd ../dev
git fetch -q origin
echo "Коммитов (только в origin/main | только в моей ветке):"
git rev-list --left-right --count origin/main...HEAD
git log --oneline --graph --all

step "4. Актуализируем ветку: git rebase origin/main -> конфликт"
set +e
git rebase origin/main
set -e
echo
echo "--- git status ---"
git status --short
echo
echo "--- requirements.txt с маркерами конфликта ---"
cat requirements.txt

step "5. Решаем конфликт осознанно: берём более новую версию из main, не свою"
cat > requirements.txt <<'REQ'
fastapi==0.115.6
uvicorn==0.29.0
REQ
git add requirements.txt
GIT_EDITOR=true git rebase --continue

step "6. Ветка снова линейна поверх main; публикуем безопасно"
# --force-with-lease: перезаписывает только свою ветку и только если на сервере
# нет чужих коммитов, которых мы не видели (в отличие от голого --force).
git push -q --force-with-lease origin feature/discount-validation
git log --oneline --graph --all
echo "Готово: история линейная, PR можно мержить, конфликта нет."