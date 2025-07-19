#!/bin/bash

clear

start_time=$(date +%s)

# Título centralizado
title="✅ VERIFICAÇÃO DE MÍDIA - FFMPEG - macOS"
line_length=51 
title_length=${#title}
side_length=$(( (line_length - title_length) / 2 ))
padding=$(printf '%*s' "$side_length" '' | tr ' ' '=')

echo "${padding}${title}${padding}"
[ $(( (line_length - title_length) % 2 )) -ne 0 ] && echo "="
echo ""
echo "⚠️ Este processo irá decodificar cada arquivo de mídia para verificação. Pode ser demorado dependendo da quantidade e tamanho dos arquivos."
echo ""
read -p "🟨 Arraste a pasta do projeto para esta janela e pressione [Enter]: " folder

if [ ! -d "$folder" ]; then
  echo "❌ Caminho inválido. Abortando."
  exit 1
fi

cd "$folder" || exit
folder_name=$(basename "$folder")
check_file="controle.txt"
log_file="log_midia.txt"
> "$log_file"

clear

echo "${padding}${title}${padding}"
[ $(( (line_length - title_length) % 2 )) -ne 0 ] && echo "="
echo ""
echo "🔍 Verificando arquivos de áudio e vídeo em: $folder_name"
echo ""

# Lista de extensões a verificar
extensoes=(".mp4" ".mov" ".avi" ".mkv" ".wav" ".mp3" ".flac")
erros=()

# Coleta e ordena os arquivos por tamanho (modo compatível com macOS)
IFS=$'\n' read -d '' -r -a arquivos < <(find . -type f \( -iname "*.mp4" -o -iname "*.mov" -o -iname "*.avi" -o -iname "*.mkv" -o -iname "*.wav" -o -iname "*.mp3" -o -iname "*.flac" \) -exec du -k {} + | sort -n | cut -f2- && printf '\0')

total="${#arquivos[@]}"

for i in "${!arquivos[@]}"; do
  file="${arquivos[$i]}"
  clean_path="$(echo "$file" | tr -d '\r')"
  filename=$(basename "$clean_path")

  current=$((i+1))
  printf "\r%-80s" "⏳ Verificando: $filename ($current/$total)"

  if [ ! -f "$clean_path" ]; then
    printf "\r%-80s\n" "❌ Arquivo não encontrado: $clean_path ($current/$total)"
    erros+=("$filename")
    echo "$(date +"%d/%m/%Y - %H:%M") - $filename | Arquivo não encontrado" >> "$log_file"
    continue
  fi

  ffmpeg_output=$(ffmpeg -v error -i "$clean_path" -f null - 2>&1)
  if [ $? -eq 0 ]; then
    printf "\r%-80s\n" "✅ OK: $clean_path ($current/$total)"
  else
    printf "\r%-80s\n" "❌ Erro ao processar: $clean_path ($current/$total)"
    erros+=("$filename")
    erro_amigavel=$(echo "$ffmpeg_output" | head -n 1)
    echo "$(date +"%d/%m/%Y - %H:%M") - $filename | $erro_amigavel" >> "$log_file"
  fi

done

# Quebra a linha após a última verificação
echo ""
echo ""
echo "------------------------------------------"
echo "✅ Verificação de mídia concluída."
echo "📜 Registro salvo em $log_file e $check_file"
echo ""

# Registrar no controle.txt
timestamp=$(date +"%d/%m/%Y - %H:%M")
if [ ${#erros[@]} -eq 0 ]; then
  echo "$timestamp - Verificação de mídia ok" >> "$check_file"
else
  echo "$timestamp - Verificação de mídia falhou, verificar log_midia.txt" >> "$check_file"
fi

read -p "Pressione Enter para sair..." && exit