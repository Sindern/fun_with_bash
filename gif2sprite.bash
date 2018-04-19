#! /usr/bin/env bash

tempdir="/tmp/gif2sprite"

giffile=$1
spritesize=${2}

# Make sure input file is actually a gif or really good at pretending.
file "${giffile}"
if [[ ! $(file "${giffile}") =~ GIF ]] ; then
  >&2 echo "File is not GIF Filetype. D:"
  exit 1
fi

# 100 < spritesheet size < 9999 || sanity check
until [[ ${spritesize} =~ ^[1-9][0-9]{2,3}$ ]]; do
  read -p "Max Spritesheet Dimensions: (eg: 2048) : " spritesize
done

rm -rf "${tempdir}"
mkdir -p "${tempdir}"
# Convert gif to png files in temp dir.
convert "${giffile}" "${tempdir}/${giffile%.gif}.png"

numframes=$(ls ${tempdir} | wc -l)
echo -e "Number of Frames: \033[1m ${numframes}\033[0m"
iwidth=$(convert "${giffile}" -print "%w" /dev/null)
iheight=$(convert "${giffile}" -print "%h" /dev/null)
echo -e "Width: \033[1m${iwidth}\033[0m  || Height: \033[1m${iheight}\033[0m"

# See which dimension is the biggest.
biggest="${iwidth}"
[[ ${iheight} -gt ${biggest} ]] && biggest=${iheight}
echo -e "Limiting Dimension Size is \033[1m${biggest}\033[0m"

# Fuck rounding up in bash.
# If wider than tall, have more rows, else have more rows.
if [[ ${iwidth} -gt ${iheight} ]] ; then
  ssrows=$(python -c "import math as m; print(int(m.ceil(m.sqrt(${numframes}))))")
  sscols=$(python -c "import math as m; print(int(m.floor(m.sqrt(${numframes}))))")
else
  sscols=$(python -c "import math as m; print(int(m.ceil(m.sqrt(${numframes}))))")
  ssrows=$(python -c "import math as m; print(int(m.floor(m.sqrt(${numframes}))))")
fi
echo -e "New Image will be \033[1m${sscols}\033[0m columns and \033[1m${ssrows}\033[0m rows."

if [[ ${iwidth} -gt ${iheight} ]] ; then
  newwidth=$(python -c "print(${spritesize}/${sscols})")
  newheight=$(python -c "print(int(${newwidth}.0/${iwidth} * ${iheight}))")
else
  newheight=$(python -c "print(${spritesize}/${ssrows})")
  newwidth=$(python -c "print(int(${newheight}.0/${iheight} * ${iwidth}))")
fi

echo -e "Per Image Dimensions: "
echo -e "Height: \033[1m${newheight}\033[0m"
echo -e " Width: \033[1m${newwidth}\033[0m"

echo -e "Spritesheet Dimensions will be: "
echo -e "Height: \033[1m$((${newheight}*${ssrows}))\033[0m"
echo -e " Width: \033[1m$((${newwidth}*${sscols}))\033[0m"

# Combine the images into a spritesheet.
