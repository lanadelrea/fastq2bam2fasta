// enable dsl2
nextflow.enable.dsl=2

// Help message
def helpMessage = """
Simple pipeline for getting consensus fasta from fastq
                 
    To run the pipeline, do:
    nextflow run fastq2bam2fasta --in_dir <input directory> --out_dir <output directory> --sequence <pe OR se>
                   
    Required arguments:
                 
        --in_dir             Input directory containing FASTA, FASTQ, BAM, and BAM index files
        --out_dir            Output directory for results
        --sequence           Choose from 'pe' (for paired-end) OR 'se' (for single-end)

    Optional arguments:
        --bammix_thresh      Set the bammix threshold for the proportion of the major allele
                                                    Default: 0.8
        -profile             Can be docker or conda
        -resume              To resume the pipeline
        -w                   The NextFlow work directory. Delete this directory once the process is finished
                                Default: ${workDir} 
        --help               To view this help message
"""

// Import subworkflows
include { illumina } from './workflows/illumina.nf'
include { ont } from './workflows/ont.nf'

workflow {
    main:
        if (params.sequence == 'pe') {
            illumina()
        }
        else if (params.sequence == 'se'){
            ont()
        }
        else {
            println helpMessage
        }
}