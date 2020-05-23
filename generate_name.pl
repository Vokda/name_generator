#!/usr/bin/perl
use lib "./";

use strict;
use warnings;
use generate_hashes;
use Storable;
use Data::Dumper;
use List::Util "sum";

my $first_name_length = $ARGV[0] || 5;
my $last_name_length = $ARGV[1] || 5;

gen_hash::generate_storable() unless(
	-e $gen_hash::lf_storable and 
	-e $gen_hash::n2a_storable);
my $lf = retrieve($gen_hash::lf_storable);
my $n2a = retrieve($gen_hash::n2a_storable);
my ($vowel_lf, $consonant_lf, $n2a_v, $n2a_c);

# some preprocessing
my @n = (0..$gen_hash::alphabet_size-1);
for(@n)
{
	my $letter = $n2a->{$_};
	if($letter =~ /[aeouiy]/)
	{
		$vowel_lf->{$letter} = $lf->{$letter};
	}
	else
	{
		$consonant_lf->{$letter} = $lf->{$letter};
	}
}

my $c_n = keys(%{$consonant_lf});
my $v_n = keys(%$vowel_lf);
my $c_p = sum(values(%$consonant_lf));
my $v_p = sum(values(%$vowel_lf));

# actually generate a name


my $full_name = generate_name($first_name_length) . 
' ' . generate_name($last_name_length);

my $n_l = length $full_name;
print "name $full_name\n";
print "length $n_l\n";

sub generate_name
{
	my $l = shift;
	my @name = ();

	push(@name, get_letter());
	for(1..$l-1)
	{
		push(@name, get_letter(\@name));
	}
	return join('', @name);
}

sub get_letter
{
	my $name = shift;
	my $a = '_';

	if(not defined $name) # first letter -> randomize letter
	{
		my $i = int(rand($gen_hash::alphabet_size));
		$a = $n2a->{$i};
	}
	else
	{
		my $x; 

		# print consonant
		my @n_arr = @{$name};
		my $n_s = (scalar @n_arr);
		die unless @n_arr;
		if(is_vowel($n_arr[$n_s-1]))
		{
			$a = get_specific_letter($c_p, $consonant_lf);
		}
		# print vowel
		else
		{
			$a = get_specific_letter($v_p, $vowel_lf);
		}

	}
	return $a;
}

sub get_specific_letter
{
	my $X = shift;
	my $lf = shift;

	my $x = rand($X);
	my $sum = 0;
	my $i = -1;
	for(values(%$lf))
	{
		if($x > $sum)
		{
			$i++;
			$sum += $_;
		}
		else
		{
			last;
		}
	}

	my @as = keys %$lf;
	my $c =  $as[$i];
	die "no specific letter selected\n" unless $c;
	return $c;
}

sub is_vowel
{
	my $c = shift;
	die unless $c;
	return $c =~ /[aeouiy]/;
}
