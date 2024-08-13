param_datafile="hem.data";
param_outfile = exists("outfile") ? outfile : "hemplot.png"

param_width=2400
param_height=1440

# Make sizes relevant to final size.
param_small_font=param_width / 150
param_lw=param_width / 300

# 0 not, 1=oxi, 2=non-oxi
param_emphasize_factor= exists("emphasize_factor") ? emphasize_factor : 0;

# 0 all, 1=oxi, 2=non-oxi
param_only_show = exists("only_show") ? only_show : 0;

# Animation
param_lerp=exists("lerp_percent") ? (lerp_percent / 100.0) : -1
if (exists("lerp_basename")) {
   param_outfile=sprintf("%s-%03d.png", lerp_basename, lerp_percent);
}

standard_font=sprintf("Helvetica,%d", param_small_font * 1.8)
set terminal pngcairo size param_width, param_height font standard_font

set output param_outfile

# Extracted from the datafile, as we need these to place the arrows
# egrep "^(660|940)" hem.data
oxi_lo_660nm=3226.5
oxi_hi_660nm=319.6
oxi_lo_940nm=693.44
oxi_hi_940nm=1214

# We only really want to show detailed information in the overview graph
param_color_explain=(param_lerp < 0 && param_emphasize_factor == 0 && param_only_show == 0);

set palette defined (380 "black", 400 "dark-violet", 440 "blue", 490 '#00b0c0', 530 "green", 560 "yellow", 620 "red", 780 "black")

set samples 1000
unset colorbox

set multiplot

#-- spectrum
# hand-fudging until it matches up with text
set origin 0.187, 0.145
set size 0.54, 0.1
unset tics
unset key
plot [380:780] '+' u 1:(1):1 w impulse lc palette lw 3 notitle


# -- the actual data plot
unset origin
unset size
set border lw param_lw / 2

set label "<--- Ultraviolett" right at 380, 150
set label "Infrarot -->"      left at 780, 150

set tics axis
set xlabel "Wellenlänge λ (lambda) in nm (Nanometer = 10^{-9} Meter)"
set ylabel "Absorption (log)"
set key left top

set logscale y
set format y ""   # Don't want to distract with absolute numbers

set arrow from 660,200 to 660,100000 nohead lw param_lw / 2
set arrow from 940,200 to 940,100000 nohead lw param_lw / 2

if (param_color_explain) {
  set label "Bei λ=660nm (Rot)\nHHb absorbiert deutlich (10x)\nmehr Licht als O₂Hb" center at 660, 300000
  set label "O₂Hb sieht \"röter\" aus." left at 670, 60000
  set label "Bei λ=940nm (Infrarot) umgekehrt:\nhier absorbiert O₂Hb mehr als HHb (x1.75)" right at 990, 300000
} else {
  set label "λ=660nm (Rot)" center at 660, 150000
  set label "λ=940nm (Infrarot)" center at 940, 150000
}

if (param_emphasize_factor == 1) {
  set label "Bei voller Sättigung\nist 940nm 3.8x mehr absorbiert\nals bei 660nm\n" right at 550, 1000
  set arrow from 500,oxi_hi_660nm to 660,oxi_hi_660nm lw param_lw/3 lc rgb "red"
  set arrow from 500,oxi_hi_940nm to 940,oxi_hi_940nm lw param_lw/3 lc rgb "red"
  set arrow from 560,350 to 560,1000 lw param_lw/3    # indicate direction
}
else if (param_emphasize_factor == 2) {
  set label "Ohne O₂\nist 940nm 0.21x absorbiert\nals bei 660nm\n" right at 550, 2200
  set arrow from 500,oxi_lo_660nm to 660,oxi_lo_660nm lw param_lw/3 lc rgb "#aa00ff"
  set arrow from 500,oxi_lo_940nm to 940,oxi_lo_940nm lw param_lw/3 lc rgb "#aa00ff"
  set arrow from 560,2800 to 560,780 lw param_lw/3 # indicate direction
}

# Source of data
set label "Raw data measured by\n * W. B. Gratzer, Med. Res. Council Labs, Holly Hill, London\n * N. Kollias, Wellman Laboratories, Harvard Medical School, Boston\nCompiled by Scott Prahl <https://omlc.org/spectra/hemoglobin/>\nPlot CC-BY-SA H. Zeller <https://github.com/hzeller/hemoglobin>\n" left at 250, 50 font sprintf("Helvetica,%d", param_small_font)

set key autotitle columnhead    # extract title from first line in data.
set grid xtics lw param_lw / 4  # Just xtics sufficient, y would be too noisy.

# Show qualitative view of how 'strong' the light is coming through
if (param_lerp >= 0) {
  circle_r=40
  circle_660nm_x=660+circle_r+20
  circle_940nm_x=940-circle_r-20

  set label "Lichtdurchlass" at (940 + 660) / 2, 80000 center font sprintf("Helvetica Bold,%d", 2 * param_small_font)

  # Rot durchlass
  y_660nm = oxi_lo_660nm + (oxi_hi_660nm - oxi_lo_660nm) * param_lerp
  set arrow from 660, y_660nm to circle_660nm_x,8000 nohead
  set arrow from circle_660nm_x,8000 to circle_660nm_x,11000 nohead

  # Infrarot durchlass
  y_940nm = oxi_lo_940nm + (oxi_hi_940nm - oxi_lo_940nm) * param_lerp
  set arrow from 940, y_940nm to circle_940nm_x,8000 nohead
  set arrow from circle_940nm_x,8000 to circle_940nm_x,11000 nohead

  set style fill solid 1
  set object circle at circle_660nm_x,30000 size circle_r + 2 lw 0 fc rgb "black"
  set object circle at circle_940nm_x,30000 size circle_r + 2 lw 0 fc rgb "black"

  red_fraction=0.5 + (param_lerp * 0.5)
  red_lerp=sprintf("#%02x0000", 255 * red_fraction);

  set object circle at circle_660nm_x,30000 size circle_r lw 0 fc rgb red_lerp

  ir_fraction=0.3 + ((1-param_lerp) * 0.6)
  ir_hex_value=255 * ir_fraction
  ir_lerp=sprintf("#%02x%02x%02x", ir_hex_value, ir_hex_value, ir_hex_value)
  set object circle at circle_940nm_x,30000 size circle_r lw 0 fc rgb ir_lerp
}

set y2range [0:0]  # not using y2range

if (param_lerp < 0) {
  # Depending on the hightlight, we want the colorful graph last to be on top
  if (param_emphasize_factor == 1) {
    plot [250:1000] [100:1000000] \
      param_datafile using 1:($3 * 1.0) with lines lw param_lw lc rgb "gray", \
      param_datafile using 1:($2 * 1.0) with lines lw param_lw lc rgb "red"
  } else if (param_emphasize_factor == 2) {
    plot [250:1000] [100:1000000] \
      param_datafile using 1:($2 * 1.0) with lines lw param_lw lc rgb "gray", \
      param_datafile using 1:($3 * 1.0) with lines lw param_lw lc rgb "#aa00ff"
  } else if (param_only_show == 1) {
    plot [250:1000] [100:1000000] \
      param_datafile using 1:($2 * 1.0) with lines lw param_lw lc rgb "red"
  } else if (param_only_show == 2) {
    plot [250:1000] [100:1000000] \
      param_datafile  using 1:($3 * 1.0) with lines lw param_lw lc rgb "#aa00ff"
  } else {  # only_show == 0, i.e .all
    plot [250:1000] [100:1000000] \
      param_datafile using 1:($2 * 1.0) with lines lw param_lw lc rgb "red", \
      param_datafile using 1:($3 * 1.0) with lines lw param_lw lc rgb "#aa00ff"
  }
} else {
  key_font=sprintf(",%d", 3 * param_small_font)
  set key font key_font   # for some reason, this can't be given in-place
  set key right top
  plot [250:1000] [100:1000000] \
    param_datafile \
    using 1:(($2 * param_lerp) + ($3 * (1-param_lerp))) \
    with lines lw param_lw lc rgb "black" title sprintf("Hb SpO₂ %3d%%", param_lerp * 100)
}