#!/usr/bin/perl -w
use strict;

sub usage {
    print "Usage: $0 <options>\n";
    print <<OEF;
where options are (in order):

  NumberOfStreams                         How many streams to plot (windows)
  Stream1_WindowSampleSize <Stream2...>   This many window samples for each stream
  Stream1_Title <Stream2_Title> ...       Title used for each stream
  (Optional) Stream1_geometry <Stream2_geometry>...  X and Y position in pixels from the top left

The last parameters (the optionally provided geometries of the gnuplot windows) 
are of the form: 
  WIDTHxHEIGHT+XOFF+YOFF
OEF
    exit(1);
}

sub Arg {
    if ($#ARGV < $_[0]) {
	print "Expected parameter missing...\n\n";
	usage;
    }
    $ARGV[int($_[0])];
}

my $frames = "/tmp/frames";
my $frame_nr = 1;

sub main {
    my $argIdx = 0;
    my $numberOfStreams = Arg($argIdx++);
    print "Will display $numberOfStreams Streams (in $numberOfStreams windows)...\n";
    my @sampleSizes;
    for(my $i=0; $i<$numberOfStreams; $i++) {
	my $samples = Arg($argIdx++);
	push @sampleSizes, $samples;
	print "Stream ".($i+1)." will use a window of $samples samples\n";
    }
    my @titles;
    for(my $i=0; $i<$numberOfStreams; $i++) {
	my $title = Arg($argIdx++);
	push @titles, $title;
	print "Stream ".($i+1)." will use a title of '$title'\n";
    }
    my @geometries;
    if ($#ARGV >= $argIdx) {
	for(my $i=0; $i<$numberOfStreams; $i++) {
	    my $geometry = Arg($argIdx++);
	    push @geometries, $geometry;
	    print "Stream ".($i+1)." will use a geometry of '$geometry'\n";
	}
    }
    my $terminal = "";
    open GNUPLOT_TERM, "echo 'show terminal;' | gnuplot 2>&1 |";
    while (<GNUPLOT_TERM>) {
	if (m/terminal type is (\w+)/) {
	    $terminal=$1;
	}
    }
    close GNUPLOT_TERM;

    # unfortunately, the wxt terminal type does not support positioning. 
    # hardcode it...
    $terminal  = "x11";

	my $x_start = 1; # 10
	my $y_start = 1; # 30
	my $x_space = 3; # gnuplot needs some space
	my $y_space = 15;
	my $w = 320;
	my $h = 200;
	my $x = $x_start;
	my $y = $y_start;

	my ($x_size, $y_size) = ( 1,1 );
	my $vertical = 1;
	foreach my $title (@titles) {
		if ( $title =~ m/,$/ ) {
			$y_size = $vertical if $vertical > $y_size;
			$vertical = 1;
			$x_size++;
		} else {
			$vertical++;
		}
	}
	$vertical--;
	$y_size = $vertical if $vertical > $y_size;
	print "# grid $x_size x $y_size\n";

	my $info = `xwininfo -root`;
	if ( $info =~ m/-geometry (\d+)x(\d+)/ ) {
		my ( $x_screen, $y_screen ) = ( $1, $2 );
		$w = int( ( $x_screen - ( 2 * $x_start ) - ( ($x_size-1) * $x_space ) ) / $x_size );
		$h = int( ( $y_screen - ( 2 * $y_start ) - ( ($y_size-1) * $y_space ) ) / $y_size );
		print "# graph size $w x $h\n";
	}

	#@sampleSizes = ( $w x $numberOfStreams );

    my @gnuplots;
    my @buffers;
    my @xcounters;
    shift @ARGV; # number of streams
    for(my $i=0; $i<$numberOfStreams; $i++) {
	shift @ARGV; # sample size
	shift @ARGV; # title
	shift @ARGV; # geometry
	local *PIPE;

	my $geometry = "${w}x${h}+${x}+${y}";
	$geometries[$i] = $geometry;
	print "# $i $titles[$i] $geometry\n";
	$geometry = " -geometry $geometry";

	if ( $titles[$i] =~ s/,$// ) {
		$x += $w + $x_space;
		$y  = $y_start;
	} else {
		$y += $h + $y_space;
	}

	open PIPE, "|gnuplot $geometry " || die "Can't initialize gnuplot number ".($i+1)."\n";
	select((select(PIPE), $| = 1)[0]);
	push @gnuplots, *PIPE;
	print PIPE "set xtics\n";
	print PIPE "set ytics\n";
#	print PIPE "set style data linespoints\n";
	print PIPE "set style data lines\n";
	print PIPE "set grid\n";
	if ($numberOfStreams == 1) {
	    print PIPE "set terminal $terminal title '".$titles[0]."' noraise\n";
	} else {
	    print PIPE "set terminal $terminal noraise\n";
	}
	print PIPE "set autoscale\n";
	my @data = [];
	push @buffers, @data;
	push @xcounters, 0;
    }
    my $streamIdx = 0;
    select((select(STDOUT), $| = 1)[0]);
    while(<>) {
	chomp;
	my @parts = split /:/;
	$streamIdx = $parts[0];

	if ( $streamIdx == 0 ) { #&& -e $frames ) {
		system "xwd -root > " . sprintf("%s/%06d.xwd", $frames, $frame_nr);
		$frame_nr++;
	}

	my $buf = $buffers[$streamIdx];
	my $pip = $gnuplots[$streamIdx];
	my $xcounter = $xcounters[$streamIdx];
	my $title = $titles[$streamIdx];

	# data buffering (up to stream sample size)
	push @{$buf}, $parts[1];
	#print "stream $streamIdx: ";
	print $pip "set xrange [".($xcounter-$sampleSizes[$streamIdx]).":".($xcounter+1)."]\n";
	if ($numberOfStreams == 1) {
	    print $pip "plot \"-\"\n";
	} else {
	    print $pip "plot \"-\" title '$title'\n";
	}
	my $cnt = 0;
	for my $elem (reverse @{$buf}) {
	    #print " ".$elem;
	    print $pip ($xcounter-$cnt)." ".$elem."\n";
	    $cnt += 1;
	}
	#print "\n";
	print $pip "e\n";
	if ($cnt>=$sampleSizes[$streamIdx]) {
	    shift @{$buf};
	}
	$xcounters[$streamIdx]++;
    }
    for(my $i=0; $i<$numberOfStreams; $i++) {
	my $pip = $gnuplots[$i];
	print $pip "exit;\n";
	close $pip;
    }
}

main;
