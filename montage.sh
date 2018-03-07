#! /bin/bash
## Take a list of image files as arguments and combine them into a vertical montage
## Alternately take a list of image URLs. Query args mess with it.

montage() {
  width=0
  for img in $*; do
    iwidth=$(convert ${img} -ping -format "%w" info:)
    [[ ${iwidth} -gt ${width} ]] && width=${iwidth}
  done
  convert $* -resize ${width} -append output.png
}

lazy_memer() {
  width=0
  mkdir -p /tmp/dank
  meme=1
  for img in $*; do
    wget -O /tmp/dank/${meme}-${img##*/} ${img}
    ((meme++))
  done
  for meme in $(ls /tmp/dank/) ; do
    iwidth=$(convert ${img} -ping -format "%w" info:)
    [[ ${iwidth} -gt ${width} ]] && width=${iwidth}
  done
  convert /tmp/dank/* -resize ${width} -append output.png
  rm -rf /tmp/dank/
}
