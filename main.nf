// enable dsl2
nextflow.enable.dsl=2

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