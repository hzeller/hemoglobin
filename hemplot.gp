set terminal svg size 800,480
set output "hemplot.svg"

set palette defined (380 "black", 400 "dark-violet", 440 "blue", 490 '#00b0c0', 530 "green", 560 "yellow", 620 "red", 780 "black")

set samples 1000
unset colorbox

set multiplot

#-- spectrum
# hand-fudging until it matches up with text
set origin 0.184, 0.145
set size 0.545, 0.1
unset tics
plot [380:780] '+' u 1:(1):1 w impulse lc palette lw 1 notitle


# -- the actual data plot
unset origin
unset size
set label "<--- Ultraviolett" right at 380, 150
set label "Infrarot -->"      left at 780, 150

set tics axis
set xlabel "Wellenlänge λ (lambda) in nm (Nanometer = 10^{-9} Meter)"
set ylabel "Absorption (log)"
set key left top

set logscale y
set format y ""

set arrow from 660,200 to 660,100000 nohead
set arrow from 940,200 to 940,100000 nohead
set label "Bei λ=660nm (Rot)\nHb absorbiert deutlich (10x)\nmehr Licht als HbO₂" center at 660, 300000
set label "HbO₂ sieht \"röter\" aus." left at 670, 60000
set label "Bei λ=940nm (Infrarot) umgekehrt:\nhier absorbiert HbO₂ mehr als Hb (x1.75)" right at 990, 300000

# A little bit annotation.
#set label "↕ x10\nmehr Licht absorbiert\nvon Hb" left at 665, 1300
#set label "↕ x1.75" left at 940, 900

# Show the following either or.
# -- TODO: is there a way to pass an option and make some sort if if-else ?

#set label "Bei voller Sättigung\nist 940nm 3.8x mehr absorbiert\nals bei 660nm\n" right at 550, 1000
#set arrow from 500, 319  to 660, 319  lc rgb "red"
#set arrow from 500, 1214 to 940, 1214 lc rgb "red"
#set arrow from 560, 350 to 560, 1000

#set label "Ohne O₂\nist 940nm 0.21x absorbiert\nals bei 660nm\n" right at 550, 2200
#set arrow from 500, 3226  to 660, 3226  lc rgb "#aa00ff"
#set arrow from 500, 693  to  940, 693  lc rgb "#aa00ff"
#set arrow from 560, 2800 to 560, 780

# Source of data
set label "Raw data measured by\nW. B. Gratzer, Med. Res. Council Labs, Holly Hill, London\nN. Kollias, Wellman Laboratories, Harvard Medical School, Boston\ncompiled by Scott Prahl <https://omlc.org/spectra/hemoglobin/>\nPlot <https://github.com/hzeller/hemoglobin>\n" left at 250, 50 font "Helvetica,7"

set key autotitle columnhead  # extract title from first line in data.
set grid xtics                # Just xtics sufficient, y would be too noisy.

plot [250:1000] \
  "hem.data" using 1:($2 * 1.0) with lines lw 3 lc rgb "red", \
  ""         using 1:($3 * 1.0) with lines lw 3 lc rgb "#aa00ff"
