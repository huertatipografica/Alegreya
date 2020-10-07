#!/bin/bash
set -e

# Go the sources directory to run commands
SOURCE="${BASH_SOURCE[0]}"
DIR=$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)
cd $DIR
echo $(pwd)

rm -rf ../fonts

# Activate environment
if [ -d "../venv" ]; then
    . ../venv/bin/activate
fi

echo "Converting to designspace"
mkdir -p ../temp
glyphs2ufo Alegreya.glyphs -m ../temp/
glyphs2ufo Alegreya_Italic.glyphs -m ../temp/

echo "Generating Static fonts"
mkdir -p ../fonts
fontmake -m ../temp/Alegreya.designspace -i -o ttf --output-dir ../fonts/ttf/
fontmake -m ../temp/Alegreya_Italic.designspace -i -o ttf --output-dir ../fonts/ttf/
fontmake -m ../temp/Alegreya.designspace -i -o otf --output-dir ../fonts/otf/
fontmake -m ../temp/Alegreya_Italic.designspace -i -o otf --output-dir ../fonts/otf/

echo "Generating VFs"
mkdir -p ../fonts/variable
fontmake -m ../temp/Alegreya.designspace -o variable --output-path "../fonts/variable/Alegreya[wght].ttf"
fontmake -m ../temp/Alegreya_Italic.designspace -o variable --output-path "../fonts/variable/Alegreya-Italic[wght].ttf"

echo "Generate SC VFs"
vfs=$(ls ../fonts/variable/*.ttf)
for vf in $vfs; do
    scvf=$(echo $vf | sed 's/Alegreya/AlegreyaSC/')
    python -m opentype_feature_freezer.cli -S -U SC -f smcp $vf $scvf
    pyftsubset --recalc-bounds --recalc-average-width --glyph-names --layout-features="*" --name-IDs="*" --unicodes="*" --output-file=$scvf.temp $scvf
    mv $scvf.temp $scvf
done

echo "Generate SC static fonts"
ttfs=$(ls ../fonts/*tf/*.*tf)
for ttf in $ttfs; do
    scttf=$(echo $ttf | sed 's/Alegreya/AlegreyaSC/')
    python -m opentype_feature_freezer.cli -S -U SC -f smcp $ttf $scttf
    pyftsubset --recalc-bounds --recalc-average-width --glyph-names --layout-features="*" --name-IDs="*" --unicodes="*" --output-file=$scttf.temp $scttf
    mv $scttf.temp $scttf
done

echo "Post processing"
ttfs=$(ls ../fonts/*tf/*.*tf)
for ttf in $ttfs; do
    gftools fix-dsig -f $ttf
done

echo "Fix Hinting"
ttfs=$(ls ../fonts/ttf/*.ttf)
for ttf in $ttfs; do
    python -m ttfautohint $ttf "$ttf.fix"
    mv "$ttf.fix" $ttf
    gftools fix-hinting $ttf
    mv "$ttf.fix" $ttf
done

vfs=$(ls ../fonts/variable/*\[wght\].ttf)

echo "Post processing VFs"
for vf in $vfs; do
    gftools fix-dsig -f $vf
    # ttfautohint-vf --stem-width-mode nnn $vf "$vf.fix";
    # mv "$vf.fix" $vf;
done

echo "Fixing VF Meta"
gftools fix-vf-meta ../fonts/variable/Alegreya{,-Italic}\[wght\].ttf
gftools fix-vf-meta ../fonts/variable/AlegreyaSC{,-Italic}\[wght\].ttf

echo "Dropping MVAR"
for vf in $vfs; do
    mv "$vf.fix" $vf
    ttx -f -x "MVAR" $vf # Drop MVAR. Table has issue in DW
    rtrip=$(basename -s .ttf $vf)
    new_file=../fonts/variable/$rtrip.ttx
    rm $vf
    ttx $new_file
    rm $new_file
done

echo "Fixing Non Hinting"
for vf in $vfs; do
    gftools fix-nonhinting $vf $vf
done
rm ../fonts/variable/*prep-gasp.ttf
