
all: hemplot.svg hemplot.png pulse.svg pulse.png

%.svg : hemplot.gp hem.data
	gnuplot $<

%.png : %.svg
	inkscape $< -b white --export-type=png --export-filename=$@ -w 2400 -h 1440
