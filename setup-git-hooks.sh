#!/bin/bash

# Путь к директории с хуками
HOOKS_DIR=".git-hooks"

# Создаем директорию .git-hooks, если её нет
mkdir -p "$HOOKS_DIR"

# Копируем хуки в директорию .git-hooks
cp pre-commit "$HOOKS_DIR/"
cp commit-msg "$HOOKS_DIR/"
cp pre-push "$HOOKS_DIR/"

# Делаем хуки исполняемыми
chmod +x "$HOOKS_DIR/pre-commit"
chmod +x "$HOOKS_DIR/commit-msg"
chmod +x "$HOOKS_DIR/pre-push"

# Проверяем, существует ли уже команда prepare в package.json
if ! grep -q '"prepare":' package.json; then
  # Добавляем команду prepare в раздел scripts
  jq '.scripts.prepare = "git config core.hooksPath .git-hooks || echo \"Not in a git repo\""' package.json > temp.json && mv temp.json package.json
  echo "Команда 'prepare' добавлена в package.json."
else
  echo "Команда 'prepare' уже существует в package.json."
fi

echo "Git хуки успешно настроены!"