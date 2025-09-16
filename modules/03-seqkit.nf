process renamefasta {
    container 'nanozoo/seqkit:latest'
    tag "Renaming consensus fasta sequences"

    publishDir (
    path: "${params.out_dir}",
    mode: 'copy',
    overwrite: 'true',
    )

    input:
    tuple val (sample), path (fasta)

    output:
    path ('*.fasta')

    script:
    """
    seqkit replace -p 'MN908947.3' -r ${sample} ${fasta} > ${sample}_renamed.fasta
    mv ${sample}_renamed.fasta > ${sample}.fasta
    """
}