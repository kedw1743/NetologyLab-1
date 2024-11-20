#!/bin/zsh

if ! git diff-index --quiet HEAD --; then
    echo "Есть несохранённые изменения. Сохраните их перед переносом."
    exit 1
fi
echo "Переключаюсь на ветку dev..."
git checkout dev
echo "Получаю последние изменения из удалённого репозитория dev..."
git pull origin dev
echo "Переключаюсь на ветку prd..."
git checkout prd
echo "Получаю последние изменения для prd..."
git pull origin prd
echo "Сливаю изменения из dev в prd..."
git merge dev
if [ $? -ne 0 ]; then
    echo "Ошибка при слиянии веток. Проверьте конфликты."
    exit 1
fi
TAG_NAME="release-$(date +'%Y%m%d-%H%M%S')"
echo "Создаю тэг: $TAG_NAME..."
git tag -a "$TAG_NAME" -m "Релиз от $(date +'%Y-%m-%d %H:%M:%S')"
echo "Отправляю изменения в удалённый репозиторий..."
git push origin prd
git push origin "$TAG_NAME"

echo "Ревизия из dev перенесена в prd с тэгом $TAG_NAME."
