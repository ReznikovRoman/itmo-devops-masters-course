#!/usr/bin/env bash
set -euo pipefail

step() { printf '\n\033[1;36m=== %s ===\033[0m\n' "$*"; }

WORK=$(mktemp -d)
echo "Рабочая папка: $WORK"
cd "$WORK"
git init -q -b main repo
cd repo
git config user.name Demo
git config user.email demo@example.com

echo "v1" > app.txt
git add . && git commit -qm "initial"

step "Случай 1: main не менялась, пока шла работа над веткой"
git checkout -q -b feature/a
echo "a1" >> app.txt && git commit -qam "feat: a1"
echo "a2" >> app.txt && git commit -qam "feat: a2"
git checkout -q main
git merge --ff-only feature/a
echo "--- история линейная, merge-коммита нет ---"
git log --oneline --graph

step "Случай 2: пока работали над веткой b, в main появился другой коммит"
git checkout -q -b feature/b
echo "b1" > b.txt && git add b.txt && git commit -qm "feat: b1"
git checkout -q main
echo "hotfix" > hotfix.txt && git add hotfix.txt && git commit -qm "fix: hotfix in main"

echo "--- пробуем fast-forward: Git откажется ---"
set +e
git merge --ff-only feature/b
echo "(код выхода: $?)"
set -e

step "Вариант A: merge-коммит (--no-ff): история сохраняет факт ветвления"
git merge --no-ff -m "Merge feature/b" feature/b
git log --oneline --graph

step "Вариант B: вернуть всё назад и сделать rebase + fast-forward (линейная история)"
git reset -q --hard HEAD~1
git checkout -q feature/b
git rebase main
git checkout -q main
git merge --ff-only feature/b
git log --oneline --graph
