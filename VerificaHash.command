#!/bin/bash

clear

title="✅ VERIFICADOR DE INTEGRIDADE - SHA256 - macOS"
line_length=51 
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

hash_file=$(find . -maxdepth 1 -type f -name "*_SHA256SUMS.txt" | head -n 1)
check_file="controle.txt"

if [ ! -f "$hash_file" ]; then
  echo "❌ Arquivo de hash não encontrado. Abortando."
  exit 1
fi

hash_errors=()
missing_files=()

clear

title="✅ VERIFICADOR DE INTEGRIDADE - SHA256 - macOS"
line_length=51 
title_length=${#title}
side_length=$(( (line_length - title_length) / 2 ))
padding=$(printf '%*s' "$side_length" '' | tr ' ' '=')

echo "${padding}${title}${padding}"

[ $(( (line_length - title_length) % 2 )) -ne 0 ] && echo "="

echo ""
echo "🔍 Usando arquivo de hash: $hash_file"
echo ""

while IFS= read -r line; do
  expected_hash=$(echo "$line" | awk '{print $1}')
  file_path=$(echo "$line" | cut -d' ' -f3-)

  if [ ! -f "$file_path" ]; then
    echo "❌ Não encontrado: $file_path"
    missing_files+=("$file_path")
    continue
  fi

  actual_hash=$(shasum -a 256 "$file_path" | awk '{print $1}')
  if [ "$expected_hash" == "$actual_hash" ]; then
    echo "✅ OK: $file_path"
  else
    echo "⚠️ HASH diferente: $file_path"
    hash_errors+=("$file_path")
  fi

done < "$hash_file"

echo ""
echo "------------------------------------------"
echo "✅ Verificação concluída."
echo "📜 Registro salvo em $check_file"

timestamp=$(date +"%d/%m/%Y - %H:%M")
if [ ${#hash_errors[@]} -eq 0 ] && [ ${#missing_files[@]} -eq 0 ]; then
  echo "$timestamp - Verificação ok" >> "$check_file"
elif [ ${#hash_errors[@]} -ne 0 ]; then
  echo "$timestamp - Falha no(s) arquivo(s): ${hash_errors[*]}" >> "$check_file"
fi

if [ ${#missing_files[@]} -ne 0 ]; then
  echo "$timestamp - Arquivo(s) não localizado(s): ${missing_files[*]}" >> "$check_file"
fi

read -p "Pressione Enter para sair..." && exit
