#!/bin/sh -xe

# .i3/config
# for_window[title="^Gnuplot"] floating enable

# http://users.softlab.ntua.gr/~ttsiod/gnuplotStreaming.html
test -x driveGnuPlots.pl || wget http://users.softlab.ntua.gr/~ttsiod/driveGnuPlots.pl && chmod 755 driveGnuPlots.pl

width=600
file=$1

test -z "$file" && file=`ls -t log/*.log | head -1`

echo "# using $width points from file $file"

Xephyr -screen 1920x1080 :1 &
sleep 1
export DISPLAY=:1


#tail -f `ls -t log/*.log | head -1` \
cat $file \
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
| ./driveGnuPlots.pl 22 \
$width $width $width \
$width $width \
$width $width $width $width $width $width \
$width $width $width $width $width $width \
$width $width $width $width $width \
V mA mAh \
temp Vinput, \
v1 v2 v3 v4 v5 v6, \
r1 r2 r3 r4 r5 r6, \
Rbat Rwire Z AA AB \
2>/dev/null

# leave empty line above this one

