// enable dsl2
nextflow.enable.dsl=2

// import modules
include { minimap2PE } from '../modules/01-minimap2.nf'
include { samtools_fixmate } from '../modules/02-samtools.nf'
include { samtools_sort } from '../modules/02-samtools.nf'
include { samtools_markdup } from '../modules/02-samtools.nf'
include { samtools_view } from '../modules/02-samtools.nf'
include { samtools_consensus } from '../modules/02-samtools.nf'
include { renamefasta } from '../modules/03-seqkit.nf'

workflow illumina {

    ch_fastq = Channel
                    .fromFilePairs("${params.in_dir}/*_{R1,R2,1,2}{,_001}.{fastq,fq}{,.gz}", flat: true)
                    .ifEmpty { error "Cannot find any fastq files on ${params.in_dir}"}

        main:
             ch_fastq.map { fastqPath -> tuple(fastqPath) } // Input fastq files in the channel

             minimap2PE( ch_fastq, params.reference )
             samtools_fixmate( minimap2PE.out.sam_pe )
             samtools_sort( samtools_fixmate.out.bam_fixmate )
             samtools_markdup( samtools_sort.out.bam_sort )
             samtools_view( samtools_markdup.out.bam_markdup )
             samtools_consensus( samtools_view.out.bam )
             renamefasta( samtools_consensus.out.fasta )
}