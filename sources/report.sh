#!/bin/sh
set -e


gftools qa -f ../fonts/vf/Alegreya[wght].ttf  -gfb --fontbakery --diffenator -o ../fonts/vf/out_roman

gftools qa -f ../fonts/vf/Alegreya-Italic[wght].ttf  -gfb --fontbakery --diffenator -o ../fonts/vf/out_italic
