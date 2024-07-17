
all: hem.svg hem.png

%.svg : %.data hemplot.gp
	gnuplot hemplot.gp

%.png : %.svg
	inkscape $< -b white --export-type=png --export-filename=$@ -w 2400 -h 1440
