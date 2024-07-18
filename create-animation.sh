#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <basename>"
    exit 1
fi

BASENAME=$1
for p in `seq 0 100`; do
    gnuplot -e "lerp_basename=\"$BASENAME\"" -e "lerp_percent=$p" hemplot.gp;
done

# inkscape is broken as it can't run in parallel with some dbus error. So
# make that sequential.
for f in $(seq -f "%03.0f" 0 100); do
    make "${BASENAME}-$f.png"
done

# Create a Loop. Go backwards
for f in $(seq 0 99); do
    FROM=$(printf "${BASENAME}-%03d.png" $((99 - $f)))
    TO=$(printf "${BASENAME}-%03d.png" $(($f + 101)))
    ln -s "$FROM" "$TO"
done

ffmpeg -framerate 30 -y -i "${BASENAME}-%03d.png" ${BASENAME}.mp4

rm "${BASENAME}"-[0-9][0-9][0-9].{svg,png}
