# Note, inkscape < 1.4 is buggy and crashes when run in parallel. Might need
# to call make -j1

IMG_WIDTH=2400
IMG_HEIGHT=1440

all: img/hem.png img/saturated-hem.png img/unsaturated-hem.png

img/hem.svg: hemplot.gp hem.data
	gnuplot -e "emphasize_factor=0" -e 'outfile="$@"' hemplot.gp

img/saturated-hem.svg: hemplot.gp hem.data
	gnuplot -e "emphasize_factor=1" -e 'outfile="$@"' hemplot.gp

img/unsaturated-hem.svg: hemplot.gp hem.data
	gnuplot -e "emphasize_factor=2" -e 'outfile="$@"' hemplot.gp

%.svg : %.gp
	gnuplot $<

%.png : %.svg
	inkscape $< -b white --export-type=png --export-filename=$@ -w $(IMG_WIDTH) -h $(IMG_HEIGHT)
