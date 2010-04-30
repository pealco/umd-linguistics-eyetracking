#!/usr/bin/perl -w
######################################################################
# Program:     Convert to EyeTrack format
# Authors:     Frank Keller
# Institution: Univ. of Edinburgh
# Status:      Internal
# Version:     0.0
# Time-stamp:  <2005-09-26 15:02:57 keller> 
# 
# File:        eyetrack.pl
# Language:    Perl 5
# Function:    main file
######################################################################


# This script takes a stimulus file as output by lexicalization.pl and 
# converts into the format required by the UMass EyeTrack software.
#
# usage: eyetrack.pl -t < stimuli.out > stimuli.eyetrack
#
# A header file called `header' has to be present.
#
# The `-t' option is to be used when the experimenter wishes to
# test experiments, using EyeTrack's "Test Experiment" option.
# This option makes the maximum display time quite short (<1s),
# making it possible for the experimenter to quickly advance to
# the next experimental item.
#


use Getopt::Std;

%options=();
getopts("t", \%options);

if( defined $options{t} ) {
    $max_time = 8000;
} else {
    $max_time = 60000;
}

system "cat header";
print "\n";

while ($line = <>) {

    chop($line);

    if (!($line eq "")) {

	$question = "";
	$answer = "";

	# question
	if ($line =~ /(E|P|F)\.(\d\d).(\d\d)\.(.)\.(.)\. (.+)/) {

	    $type = $1;
            $item_no = $2;
            $cond_no = $3;
	    $question = $4;
	    $answer = $5;
            $item = $6;

	    # remove leading zeros (bug in EyeTrack)
	    $item_no =~ s/0(.)/$1/g;
	    $cond_no =~ s/0(.)/$1/g;

	    print "trial ".$type.$cond_no."I".$item_no."D1\n";

	    # correct answer for question
	    if ($answer eq "R") {
		print "  button =           rightTrigger\n";
	    }
	    else {
		print "  button =           leftTrigger\n";
	    }

	    print "  gc_rect =          (0 0 0 0)\n";
	    print "  inline =           |".$item."\n";
	    print "  max_display_time = $max_time\n";
	    print "  trial_type =       Question\n";
	    print "end ".$type.$cond_no."I".$item_no."D1\n\n";

	    # sequence information
	    print "sequence S".$type.$cond_no."I".$item_no."\n";
	    print "  ".$type.$cond_no."I".$item_no."D0\n";
	    print "  ".$type.$cond_no."I".$item_no."D1\n";
	    print "end S".$type.$cond_no."I".$item_no."\n\n";

	} 
	# regular item
	elsif ($line =~ /(E|P|F)\.(\d\d).(\d\d). (.+)/) {

	    $type = $1;
            $item_no = $2;
            $cond_no = $3;
            $item = $4;

	    # remove leading zeros (bug in EyeTrack)
	    $item_no =~ s/0(.)/$1/g;
	    $cond_no =~ s/0(.)/$1/g;

	    print "trial ".$type.$cond_no."I".$item_no."D0\n";

	    print "  gc_rect =          (0 0 0 0)\n";
	    print "  inline =           |".$item."\n";
	    print "  max_display_time = $max_time\n";
	    print "  trial_type =       Reading\n";
	    print "end ".$type.$cond_no."I".$item_no."D0\n\n";

	}
        ##### MESSAGE
	elsif ($line =~ /(F)\.(\d\d).(\d\d).M\. (.+)/) {

	    $type = $1;
            $item_no = $2;
            $cond_no = $3;
            $item = $4;

	    # remove leading zeros (bug in EyeTrack)
	    $item_no =~ s/0(.)/$1/g;
	    $cond_no =~ s/0(.)/$1/g;

	    print "trial ".$type.$cond_no."I".$item_no."D0\n";

	    print "  gc_rect =          (0 0 0 0)\n";
	    print "  inline =           |".$item."\n";
	    print "  max_display_time = $max_time\n";
	    print "  trial_type =       Message\n";
	    print "end ".$type.$cond_no."I".$item_no."D0\n\n";

	}

    }

}