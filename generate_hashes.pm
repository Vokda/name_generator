package gen_hash;
use strict;
use warnings;
use Storable;

our $lf_storable = 'letter.freq';
our $n2a_storable = 'n2a.map';
our $alphabet_size = 26;

sub generate_storable
{
	my %letter_freq;
	my %n2a_map;

	open(LETTER_FREQ_FILE, '<', 'processed_unigrams-en.txt') or die;
	while(my $row = <LETTER_FREQ_FILE>)
	{
		# assuming a double number (.+)
		my ($letter, $freq) = $row =~ /([a-z]) (.+)/;
		$letter_freq{$letter} = $freq;
	}
	store(\%letter_freq, $lf_storable);

	# map numbers and letters
	my @n = (0..$alphabet_size-1);
	my @a = ('a'..'z');

	for(@n)
	{
		my $letter = $a[$_];
		$n2a_map{$_} = $letter;
	}
	store(\%n2a_map, $n2a_storable);
}

1;
