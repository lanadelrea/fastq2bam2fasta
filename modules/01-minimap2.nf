#!/usr/bin/env nextflow

process minimap2 {
    cpus 1
    container 'staphb/minimap2:latest'
    tag "Aligning reads to SARS-CoV-2 reference"

    publishDir (
        path: "${params.out_dir}",
        mode: 'copy',
        overwrite: 'true',
    )

    input:
    path fastq
    path reference

    output:
    path ('*.sam'), emit: sam

    script:
    """
    minimap2 -t 8 -a -x sr ${reference} ${fastq} -o ${fastq.baseName}.sam
    """    
}

process minimap2PE {
    cpus 1
    container 'staphb/minimap2:latest'
    tag "Aligning reads to SARS-CoV-2 reference"

    publishDir(
        path: "${params.out_dir}",
        mode: 'copy',
        overwrite: 'true',
    )

    input:
    tuple val(sample), path(forward), path(reverse)
    path (reference)

    output:
    path ('*.sam'), emit: sam_pe

    script:
    """
    minimap2 -t 8 -a -x sr ${reference} ${forward} ${reverse} -o ${sample}.sam
    """
}