#!/bin/sh -xe

# .i3/config
# for_window[title="^Gnuplot"] floating enable

# 

width=300

#tail -f cheali.log \
cat cheali.log \
| grep '$1' | cut -d\; -f \
4,5,6,\
10,11,\
12,13,14,15,16,17,\
18,19,20,21,22,23,\
24,25,26,27,28 \
| sed \
-e 's/^/0:/' \
-e 's/;/\n1:/' \
-e 's/;/\n2:/' \
-e 's/;/\n3:/' \
-e 's/;/\n4:/' \
-e 's/;/\n5:/' \
-e 's/;/\n6:/' \
-e 's/;/\n7:/' \
-e 's/;/\n8:/' \
-e 's/;/\n9:/' \
-e 's/;/\n10:/' \
-e 's/;/\n11:/' \
-e 's/;/\n12:/' \
-e 's/;/\n13:/' \
-e 's/;/\n14:/' \
-e 's/;/\n15:/' \
-e 's/;/\n16:/' \
-e 's/;/\n17:/' \
-e 's/;/\n18:/' \
-e 's/;/\n19:/' \
-e 's/;/\n20:/' \
-e 's/;/\n21:/' \
-e 's/;/\n22:/' \
| \
./driveGnuPlots.pl 22 \
$width $width $width \
$width $width \
$width $width $width $width $width $width \
$width $width $width $width $width $width \
$width $width $width $width $width \
V mA mAh \
temp Vinput \
v1 v2 v3 v4 v5 v6 \
r1 r2 r3 r4 r5 r6 \
Rbat Rwire Z AA AB \
320x200+1200+500 \
320x200+1200+850 \
320x200+1200+1200 \
320x200+1550+500 \
320x200+1550+850 \
400x175+1900+450 \
400x175+1900+650 \
400x175+1900+850 \
400x175+1900+1050 \
400x100+1900+1250 \
400x100+1900+1400 \
400x175+2300+450 \
400x175+2300+650 \
400x175+2300+850 \
400x175+2300+1050 \
400x100+2300+1250 \
400x100+2300+1400 \
400x175+2700+450 \
400x175+2700+650 \
400x175+2700+850 \
400x175+2700+1050 \
400x175+2700+1250 \

# leave empty line bove this one

#320x300+1600+1200 \
