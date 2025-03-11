#!/bin/bash

# Путь к директории с хуками
HOOKS_DIR=".git-hooks"

# Создаем директорию .git-hooks, если её нет
mkdir -p "$HOOKS_DIR"

# Функция для скачивания и настройки хука
setup_hook() {
  local hook_name=$1
  local raw_url=$2

  echo "🔄Скачиваю хук $hook_name..."
  if curl -sSL "$raw_url" -o "$HOOKS_DIR/$hook_name"; then
    chmod +x "$HOOKS_DIR/$hook_name"
    echo "✅Хук $hook_name успешно скачан и сделан исполняемым."
  else
    echo "⛔️Ошибка: не удалось скачать хук $hook_name."
    exit 1
  fi
}

# Скачиваем хуки из репозитория
setup_hook "pre-commit" "https://raw.githubusercontent.com/AkimovEugeney/githook/refs/heads/main/pre-commit"
setup_hook "commit-msg" "https://raw.githubusercontent.com/AkimovEugeney/githook/refs/heads/main/commit-msg"
setup_hook "pre-push" "https://raw.githubusercontent.com/AkimovEugeney/githook/refs/heads/main/pre-push"

# Проверяем, существует ли уже команда prepare в package.json
if ! grep -q '"prepare":' package.json; then
  # Добавляем команду prepare в раздел scripts
  jq '.scripts.prepare = "git config core.hooksPath .git-hooks || echo \"Not in a git repo\""' package.json > temp.json && mv temp.json package.json
  echo "💡Команда 'prepare' добавлена в package.json."
else
  echo "🔗Команда 'prepare' уже существует в package.json."
fi

echo "✅Git хуки успешно настроены!"
