#!/bin/bash

shopt -s nocaseglob nullglob

EXTENSIONS=("mp4" "mkv" "avi" "mov")
FILES=()
for ext in "${EXTENSIONS[@]}"; do
  for f in *.$ext; do
    [ -e "$f" ] && FILES+=("$f")
  done
done

TOTAL=${#FILES[@]}
if [ "$TOTAL" -eq 0 ]; then
  echo "No video files found to convert."
  exit 1
fi

mkdir -p result
echo "Found $TOTAL video files to convert."

COUNT=1
for file in "${FILES[@]}"; do
  base="${file%.*}"
  outfile="result/${base}.mov"

  echo "[$COUNT/$TOTAL] Converting '$file' -> '$outfile' ..."

  ffmpeg -y \
    -hwaccel vaapi -vaapi_device /dev/dri/renderD128 \
    -i "$file" \
    -c:v prores_ks -profile:v 1 \
    -c:a pcm_s16le \
    "$outfile"

  if [ $? -eq 0 ]; then
    echo "[$COUNT/$TOTAL] Success: '$outfile'"
  else
    echo "[$COUNT/$TOTAL] Error converting '$file'"
  fi

  COUNT=$((COUNT + 1))
done

echo "All conversions complete."

shopt -u nocaseglob nullglob
