#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <basename>"
    exit 1
fi

# First, create all the percent images.
BASENAME=$1
for p in `seq 0 100`; do
    gnuplot -e "lerp_basename=\"anim-$BASENAME\"" \
	    -e "lerp_percent=$p" hemplot.gp;
done

# inkscape is broken as it can't run in parallel with some dbus error. So
# make that sequential.
for f in $(seq -f "%03.0f" 0 100); do
    make "anim-${BASENAME}-$f.png"
done

# Now, let's create a symbolic link set of images that reflect how it should
# show up in the film. For instance, we want to start and end with 100%, so
# we craete symbolic links in that sequence
for i in $(seq 0 100); do
    show_percent=$((100 - $i))
    FROM=$(printf "anim-${BASENAME}-%03d.png" $show_percent)

    # The same image shows up in two places in the animation as we create a loop
    TO1=$(printf "anim-seq-${BASENAME}-%03d.png" $i)
    ln -s "$FROM" "$TO1"
    TO2=$(printf "anim-seq-${BASENAME}-%03d.png" $((201 - $i)))
    ln -s "$FROM" "$TO2"
done

ffmpeg -framerate 30 -y -i "anim-seq-${BASENAME}-%03d.png" ${BASENAME}.mp4

rm "anim-${BASENAME}"-[0-9][0-9][0-9].{svg,png} "anim-seq-${BASENAME}"*.png
