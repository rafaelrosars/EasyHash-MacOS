#!/bin/bash

clear

title="✅ GERADOR DE HASH - SHA256 - macOS"
line_length=52
title_length=${#title}
side_length=$(( (line_length - title_length) / 2 ))
padding=$(printf '%*s' "$side_length" '' | tr ' ' '=')

echo "${padding}${title}${padding}"

[ $(( (line_length - title_length) % 2 )) -ne 0 ] && echo "="

echo ""

read -p "🟨 Arraste a pasta do projeto para esta janela e pressione [Enter]: " folder

if [ ! -d "$folder" ]; then
  echo "❌ Caminho inválido. Abortando."
  exit 1
fi

cd "$folder" || exit
folder_name=$(basename "$folder")
sanitized_name=$(echo "$folder_name" | tr ' ' '_' | tr -d '\n')
hash_file="${sanitized_name}_SHA256SUMS.txt"
check_file="controle.txt"

clear

title="✅ GERADOR DE HASH - SHA256 - macOS"
line_length=52
title_length=${#title}
side_length=$(( (line_length - title_length) / 2 ))
padding=$(printf '%*s' "$side_length" '' | tr ' ' '=')

echo "${padding}${title}${padding}"

[ $(( (line_length - title_length) % 2 )) -ne 0 ] && echo "="

echo ""

echo ""
echo "💾 Salvando como: $hash_file"
echo ""

find . -type f \
  ! -name "$hash_file" \
  ! -name "$check_file" \
  ! -name ".DS_Store" \
  ! -path "*/.DS_Store" \
  -print0 | while IFS= read -r -d '' file; do
    hash=$(shasum -a 256 "$file" | awk '{print $1}')
    echo "$hash  $file" >> "$hash_file"
    echo "✅  Hash gerado para: $file"
done

registro_data=$(date +"%d/%m/%Y - %H:%M")
echo "$registro_data - hash criado" >> "$check_file"

echo ""
echo "------------------------------------------"
echo "✅ Hash SHA256 gerado com sucesso!"
echo "📜 Registro salvo em $check_file"
echo ""
read -p "Pressione Enter para sair..." && exit