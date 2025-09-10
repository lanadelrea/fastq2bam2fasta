#!/usr/bin/env nextflow

process samtools_fixmate {
    tag "Samtools fixmate"
    container 'staphb/samtools:latest'

    publishDir (
        path: "${params.out_dir}",
        mode: 'copy',
        overwrite: 'true',
    )

    input:
    path (sam)

    output:
    tuple val (sam.baseName), path ('*.bam'), emit: bam_fixmate

    script:
    """
    samtools fixmate -O bam,level=1 ${sam} ${sam.baseName}.fixmate.bam
    """ 
}

process samtools_sort {
    tag "Samtools sort"
    container 'staphb/samtools:latest'

    publishDir (
        path: "${params.out_dir}",
        mode: 'copy',
        overwrite: 'true',
    )

    input:
    tuple val (sample), path (bam_fixmate)

    output:
    tuple val (sample), path ('*.bam'), emit: bam_sort

    script:
    """
    samtools sort -l 1 -@8 -o ${sample}.pos.srt.bam -T /tmp/${sample} ${bam_fixmate}
    """
}

process samtools_markdup {
    tag "Samtools markdup"
    container 'staphb/samtools:latest'

    publishDir (
        path: "${params.out_dir}",
        mode: 'copy',
        overwrite: 'true',
    )

    input:
    tuple val (sample), path (bam_sort)

    output:
    tuple val (sample), path ('*.bam'), emit: bam_markdup

    script:
    """
    samtools markdup -O bam,level=1 ${bam_sort} ${sample}.markdup.bam
    """
}

process samtools_view {
    tag "Samtools view"
    container 'staphb/samtools:latest'


    publishDir (
        path: "${params.out_dir}",
        mode: 'copy',
        overwrite: 'true',
    )

    input:
    tuple val (sample), path (bam_markdup)

    output:
    tuple val (sample), path ('*.bam'), path ('*.bai'), emit: bam

    script:
    """
    samtools view -@8 ${bam_markdup} -o ${sample}.bam
    samtools index ${sample}.bam
    """
}

process samtools_consensus {
    tag "Creating the consensus fasta"
    container 'staphb/samtools:latest'

    input:
    tuple val (sample), path (bam), path (bai)

    output:
    tuple val (sample), path ('*.fasta'), emit: fasta

    script:
    """
    samtools consensus -f fasta ${bam} -o ${sample}.fasta
    """
}