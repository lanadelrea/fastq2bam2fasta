// enable dsl2
nextflow.enable.dsl=2

// import modules
include { minimap2 } from './modules/01-minimap2.nf'
include { samtools_fixmate } from './modules/02-samtools.nf'
include { samtools_sort } from './modules/02-samtools.nf'
include { samtools_markdup } from './modules/02-samtools.nf'
include { samtools_view } from './modules/02-samtools.nf'
include { samtools_consensus } from './modules/02-samtools.nf'

workflow {

        ch_fastq = Channel
                            .fromPath("${params.in_dir}/**.fastq{.gz,}", type: 'file')
                            .ifEmpty { error "Cannot find any fastq files on ${params.in_dir}"}

        main:
             ch_fastq.map { fastqPath -> tuple(fastqPath) } // Input fastq files in the channel

             minimap2( ch_fastq, params.reference )
             samtools_fixmate( minimap2.out.sam )
             samtools_sort( samtools_fixmate.out.bam_fixmate )
             samtools_markdup( samtools_sort.out.bam_sort )
             samtools_view( samtools_markdup.out.bam_markdup )
             samtools_consensus( samtools_view.out.bam )
}