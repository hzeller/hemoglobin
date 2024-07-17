set terminal svg size 800,480
set output "pulse.svg"

unset tics
set key bottom right

PI=3.1415926;

P1=PI/2
set arrow from P1, sin(P1) + 4 + 0.5 to P1, 3.8*(sin(P1) + 4) - 0.5
set label "3.8x" at P1+0.1, ((3.8 - 1)/2*(sin(P1) + 4)) + (sin(P1) + 4)

P1=1.5*PI
set arrow from P1, sin(P1) + 4 + 0.5 to P1, 3.8*(sin(P1) + 4) - 0.5
set label "3.8x" at P1+0.1, ((3.8 - 1)/2*(sin(P1) + 4)) + (sin(P1) + 4)
plot [0:15] [0:] sin(x) + 4 lw 3 lc rgb "black" title "940nm Messung", 3.8*(sin(x) + 4) lw 3 lc rgb "red" title "660nm Messung"