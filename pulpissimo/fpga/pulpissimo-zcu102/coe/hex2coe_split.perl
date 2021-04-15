#!/usr/bin/perl

open (FH, "<test.hex") or die "ooops: $!";
$lcount=1;
while(<FH>) {
	$lcount++;
}
print $lcount;
close(FH);

open(FH, "<test.hex") or die "ooops: $!";

$private0 = 'private0.coe';
$private1 = 'private1.coe';
$interleaved0 = 'interleaved0.coe';
$interleaved1 = 'interleaved1.coe';
$interleaved2 = 'interleaved2.coe';
$interleaved3 = 'interleaved3.coe';

$count=0;

open(MEM, ">$private0");
print MEM "memory_initialization_radix=16;\n";
print MEM "memory_initialization_vector=\n";
print MEM "00000000\n";

$count=1;
while(<FH>) {
	chomp;
	printf MEM "$_\n";
	$count++;
	if($count==8192) {
		printf MEM ";";
		last;
	}
}
close(MEM);

open(MEM, ">$private1");
print MEM "memory_initialization_radix=16;\n";
print MEM "memory_initialization_vector=\n";

while(<FH>) {
	chomp;
	printf MEM "$_\n";
	$count++;
	if($count==16384) {
		printf MEM ";";
		last;
	}
}
close(MEM);

open(MEM1, ">$interleaved0");
print MEM1 "memory_initialization_radix=16;\n";
print MEM1 "memory_initialization_vector=\n";

open(MEM2, ">$interleaved1");
print MEM2 "memory_initialization_radix=16;\n";
print MEM2 "memory_initialization_vector=\n";

open(MEM3, ">$interleaved2");
print MEM3 "memory_initialization_radix=16;\n";
print MEM3 "memory_initialization_vector=\n";

open(MEM4, ">$interleaved3");
print MEM4 "memory_initialization_radix=16;\n";
print MEM4 "memory_initialization_vector=\n";

while(<FH>) {
	chomp;
	if($count%4==0) {
		printf MEM1 "$_\n";
	}
	elsif($count%4==1) {
		printf MEM2 "$_\n";
	}
	elsif($count%4==2) {
		printf MEM3 "$_\n";
	}
	else {
		printf MEM4 "$_\n";
	}
	$count++;
}

printf MEM1 ";";
printf MEM2 ";";
printf MEM3 ";";
printf MEM4 ";";

close(MEM1);
close(MEM2);
close(MEM3);
close(MEM4);
close(FH);

