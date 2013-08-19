f='raw.csv'
set datafile separator ','
plot f u 1:3 w l lw 4 t '', f u 4:6 w l lw 4 t '', f u 7:9 w l lw 4 t '', f u 10:12 w l lw 4 t '', f u 13:15  w l lw 4 t '', f u 16:18 w l lw 4 t '', f u 19:21 w l lw 4 t '', f u 22:24 w l lw 4 t '', f u 25:27 w l lw 4 t '', f u 28:30 w l lw 4 t '', f u 31:33 w l lw 4 t '', f u 34:36 w l lw 4 t '' 
set yrange [0.001:1.2]
set xrange [0:4500]
set xlabel 'Time (s)'
set ylabel 'Voltage (V)'
set grid
set xtics (0,750,1500,2250,3000,3750,4500)
set terminal postscript color size 8,5 solid font "Helvetica,20"
set output 'discharge.eps'
replot
set terminal wxt