#!/usr/bin/env bash

# First, create all the percent images.
BASENAME=animation
ANIM_TARGETS=$(for p in `seq -f"%03.f" 0 100`; do echo "$BASENAME-$p.png"; done)

make -j $(shell nproc) $ANIM_TARGETS

# Now, let's create a symbolic link set of images that reflect how it should
# show up in the film. For instance, we want to start and end with 100%, so
# we craete symbolic links in that sequence
for i in $(seq 0 100); do
    show_percent=$((100 - $i))
    FROM=$(printf "${BASENAME}-%03d.png" $show_percent)

    # The same image shows up in two places in the animation as we create a loop
    TO1=$(printf "anim-seq-%03d.png" $i)
    ln -sf "$FROM" "$TO1"
    TO2=$(printf "anim-seq-%03d.png" $((201 - $i)))
    ln -sf "$FROM" "$TO2"
done

ffmpeg -framerate 30 -y -i "anim-seq-%03d.png" ${BASENAME}.mp4

rm anim-seq-*.png
