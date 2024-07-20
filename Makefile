all: img/hem.png img/saturated-hem.png img/unsaturated-hem.png

img/hem.png: hemplot.gp hem.data
	gnuplot -e "emphasize_factor=0" -e 'outfile="$@"' hemplot.gp

img/saturated-hem.png: hemplot.gp hem.data
	gnuplot -e "emphasize_factor=1" -e 'outfile="$@"' hemplot.gp

img/unsaturated-hem.png: hemplot.gp hem.data
	gnuplot -e "emphasize_factor=2" -e 'outfile="$@"' hemplot.gp

# We want a 3-digit number, but for gnuplot to understand,
animation-%.png:  hemplot.gp hem.data
	gnuplot -e "lerp_basename=\"animation\"" \
	        -e "lerp_percent=`echo $* | sed 's/^0\?0\?//g'`" hemplot.gp;

anim-clean:
	rm -f animation-[0-9][0-9][0-9].png
