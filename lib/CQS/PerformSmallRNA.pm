#!/usr/bin/perl
package CQS::PerformSmallRNA;

use strict;
use warnings;
use Pipeline::SmallRNA;
use Pipeline::SmallRNAUtils;
use Hash::Merge qw( merge );

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [
    qw(hg19_genome hg19_3utr hg38_genome mm10_genome mm10_3utr rn5_genome cel235_genome performSmallRNA_hg19 performSmallRNATask_hg19 performSmallRNA_hg20 performSmallRNATask_hg20 performSmallRNA_mm10 performSmallRNATask_mm10 performSmallRNA_rn5 performSmallRNATask_rn5 performSmallRNA_cel235 performSmallRNATask_cel235)
  ]
);

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

my $mirBase20 = "/data/cqs/shengq1/reference/miRBase20/bowtie_index_1.1.1/mature.dna";
my $mirBase21 = "/data/cqs/shengq1/reference/miRBase21/bowtie_index_1.1.1/mature.dna";

sub supplement_genome {
  return {
    bowtie1_miRBase_index => $mirBase21,
    bowtie1_tRNA_index            => "/scratch/cqs/zhaos/vickers/reference/tRna/bowtie_index_1.1.2/trna",
    bowtie1_rRNAS_index           => "/scratch/cqs/zhaos/vickers/reference/rRna/SILVA_123_SSURef_Nr99_tax_silva",
    bowtie1_rRNAL_index           => "/scratch/cqs/zhaos/vickers/reference/rRna/SILVA_123_LSURef_tax_silva",
    bowtie1_bacteria_group1_index => "/scratch/cqs/zhaos/vickers/reference/bacteria/group1/bacteriaDatabaseGroup1",
    bacteria_group1_log           => "/scratch/cqs/zhaos/vickers/reference/bacteria/group1/20150902.log",
    bowtie1_bacteria_group2_index => "/scratch/cqs/zhaos/vickers/reference/bacteria/group2/bacteriaDatabaseGroup2",
    bacteria_group2_log           => "/scratch/cqs/zhaos/vickers/reference/bacteria/group2/20150902.log",
  };
}

#for miRBase analysis, we use the most recent version (corresponding to hg38) since the coordinates are not used in analysis.
sub hg19_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option  => "-p hsa",
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/hg19_miRBase20_ucsc-tRNA_ensembl75.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/hg19_miRBase20_ucsc-tRNA_ensembl75.bed.fa",
      bowtie1_index         => "/scratch/cqs/shengq1/references/hg19_16569_MT/bowtie_index_1.1.2/hg19_16569_MT",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/hg19_16569_MT/gsnap_index_k14_2015-06-23/",
      gsnap_index_name      => "hg19_16569_MT",
      star_index_directory  => "/scratch/cqs/shengq1/references/hg19_16569_MT/STAR_index_v37.75_2.4.2a_sjdb49"
    }
  );
}

sub hg19_3utr {
  return {
    search_3utr   => 1,
    bowtie1_index => hg19_genome()->{bowtie1_index},
    fasta_file    => "/scratch/cqs/shengq1/references/hg19_16569_MT/hg19_16569_MT.fa",
    utr3_db       => "/scratch/cqs/shengq1/references/3utr/20151218_ucsc_hg19_refgene_3utr.bed",
    refgene_file  => "/scratch/cqs/shengq1/references/3utr/20151218_ucsc_hg19_refgene.tsv",
  };
}

sub hg38_genome {
  return merge(
    supplement_genome(),
    {

      #genome database
      mirbase_count_option  => "-p hsa",
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/hg20_miRBase21_ucsc-tRNA_ensembl78.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/hg20_miRBase21_ucsc-tRNA_ensembl78.bed.fa",
      bowtie1_index         => "/scratch/cqs/shengq1/references/hg38_MT/bowtie_index_1.1.2/hg38_MT",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/hg38_MT/gsnap_index_k14_2015-06-23/",
      gsnap_index_name      => "hg38_MT",
      star_index_directory  => "/scratch/cqs/shengq1/references/hg38_MT/STAR_index_v38.81_2.4.2a_sjdb49"
    }
  );
}

sub hg38_3utr {
  return {
    search_3utr   => 1,
    bowtie1_index => hg38_genome()->{bowtie1_index},
    fasta_file    => "/scratch/cqs/shengq1/references/hg38_MT/hg38_MT.fa",
    utr3_db       => "/scratch/cqs/shengq1/references/3utr/20151218_ucsc_hg38_refgene_3utr.bed",
    refgene_file  => "/scratch/cqs/shengq1/references/3utr/20151218_ucsc_hg38_refgene.tsv",
  };
}

sub mm10_genome {
  return merge(
    supplement_genome(),
    {

      #genome database
      mirbase_count_option  => "-p mmu",
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/mm10_miRBase21_ucsc-tRNA_ensembl78.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/mm10_miRBase21_ucsc-tRNA_ensembl78.bed.fa",
      bowtie1_index         => "/scratch/cqs/shengq1/references/mm10_sorted_M/bowtie_index_1.1.2/mm10",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/mm10_sorted_M/gsnap_index_k14_2015-06-23/",
      gsnap_index_name      => "mm10",
      star_index_directory  => "/scratch/cqs/shengq1/references/mm10_sorted_M/STAR_index_v38.78_2.5.0b_sjdb49"
    }
  );
}

sub mm10_3utr {
  return {
    search_3utr   => 1,
    bowtie1_index => mm10_genome()->{bowtie1_index},
    fasta_file    => "/scratch/cqs/shengq1/references/mm10/mm10.fa",
    utr3_db       => "/scratch/cqs/shengq1/references/3utr/20151218_ucsc_mm10_refgene_3utr.bed",
    refgene_file  => "/scratch/cqs/shengq1/references/3utr/20151218_ucsc_mm10_refgene.tsv",
  };
}

sub rn5_genome {
  return merge(
    supplement_genome(),
    {

      #genome database
      mirbase_count_option  => "-p rno",
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/rn5_miRBase21_ucsc-tRNA_ensembl78.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/rn5_miRBase21_ucsc-tRNA_ensembl78.bed.fa",
      bowtie1_index         => "/scratch/cqs/shengq1/references/rn5/bowtie_index_1.1.2/rn5",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/rn5/gsnap_index_k14_2015-06-23/",
      gsnap_index_name      => "rn5",
      star_index_directory  => "/scratch/cqs/shengq1/references/rn5/STAR_index_v79_2.4.2a_sjdb49"
    }
  );
}

sub cel235_genome {
  return merge(
    supplement_genome(),
    {

      #genome database
      mirbase_count_option  => "-p cel",
      coordinate            => "/scratch/cqs/shengq1/references/smallrna/cel235_miRBase21_ensembl78.bed",
      coordinate_fasta      => "/scratch/cqs/shengq1/references/smallrna/cel235_miRBase21_ensembl78.bed.fa",
      bowtie1_index         => "/scratch/cqs/zhangp2/reference/wormbase/bowtie_index_1.1.0/Caenorhabditis_elegans.WBcel235.dna.toplevel",
      gsnap_index_directory => "/scratch/cqs/shengq1/references/cel235/gsnap_index_k14_2015-06-23/",
      gsnap_index_name      => "cel235",
      star_index_directory  => "/scratch/cqs/shengq1/references/cel235/STAR_index_v78_2.4.2a_sjdb49"
    }
  );
}

sub cfa3_genome {
  return merge(
    supplement_genome(),
    {
      #genome database
      mirbase_count_option  => "-p cfa",
      coordinate            => "/scratch/cqs/zhaos/vickers/reference/Canis_lupus_familiaris/cfa3_miRBase21_ucsc-tRNA_ensembl83.bed",
      coordinate_fasta      => "/scratch/cqs/zhaos/vickers/reference/Canis_lupus_familiaris/cfa3_miRBase21_ucsc-tRNA_ensembl83.bed.fa",
      
      bowtie1_index         => "/scratch/cqs/zhaos/vickers/reference/Canis_lupus_familiaris/bowtie_index_1.1.0/canFam3",
      gsnap_index_directory => "/scratch/cqs/zhaos/vickers/reference/Canis_lupus_familiaris/gsnap_index_k14_2015-06-23",
      gsnap_index_name      => "canFam3",
      
#      star_index_directory  => "/scratch/cqs/shengq1/references/cel235/STAR_index_v78_2.4.2a_sjdb49"
    }
  );
}

sub performSmallRNA_hg19 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg19_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_hg19 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg19_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_hg20 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg20_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_hg20 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, hg20_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_mm10 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, mm10_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_mm10 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, mm10_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_rn5 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, rn5_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_rn5 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, rn5_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_cel235 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, cel235_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_cel235 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, cel235_genome() );

  performSmallRNATask( $def, $task );
}

sub performSmallRNA_cfa3 {
  my ( $userdef, $perform ) = @_;
  my $def = getSmallRNADefinition( $userdef, cfa3_genome() );

  my $config = performSmallRNA( $def, $perform );
  return $config;
}

sub performSmallRNATask_cfa3 {
  my ( $userdef, $task ) = @_;
  my $def = getSmallRNADefinition( $userdef, cfa3_genome() );

  performSmallRNATask( $def, $task );
}

1;
