#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use Getopt::Long;
use Bio::SeqIO;

sub run_command {
  my $command = shift;
  print "$command \n";
  `$command `;
}

my $usage = "
Merge sequences in fasta format by id, then by sequence

Synopsis:

perl remove_duplicate_sequence.pl -f fastaFile

Options:

  -i|--input {fastaFile}       Fasta format sequence file
  -o|--output {fastaFile}      Output file
  -h|--help                    This page.
";

Getopt::Long::Configure('bundling');

my $inputFile;
my $outputFile;
my $help;

GetOptions(
  'h|help'     => \$help,
  'i|input=s'  => \$inputFile,
  'o|output=s' => \$outputFile,
);

if ( defined $help ) {
  print $usage;
  exit(1);
}

die "Input file not exists: " . $inputFile       if ( !-e $inputFile );
die "Output file already exists: " . $outputFile if ( -e $outputFile );

my $seqio = Bio::SeqIO->new( -file => $inputFile, -format => 'fasta' );

my $seqnames      = {};
my $totalcount    = 0;
my $uniqueidcount = 0;

while ( my $seq = $seqio->next_seq ) {
  $totalcount++;
  if ( !exists $seqnames->{ $seq->id } ) {
    $seqnames->{ $seq->id } = $seq->seq;
    $uniqueidcount++;
  }
}

my $sequences      = {};
my $uniqueseqcount = 0;
for my $id ( keys %{$seqnames} ) {
  my $seq = $seqnames->{$id};
  if ( !exists $sequences->{$seq} ) {
    $sequences->{$seq} = $id;
    $uniqueseqcount++;
  }
  else {
    $sequences->{$seq} = $sequences->{$seq} . ";" . $id;
  }
}

open( my $info, ">${outputFile}.info" ) or die "Cannot create ${outputFile}.info";
print $info "Total entries\t$totalcount
Unique id\t$uniqueidcount
Unique sequence\t$uniqueseqcount
";
close($info);

system("cat ${outputFile}.info");

open( my $fasta, ">$outputFile" ) or die "Cannot create $outputFile";
for my $seq ( keys %{$sequences} ) {
  my $id = $sequences->{$seq};
  print $fasta ">$id
$seq
";
}
close($fasta);
1;