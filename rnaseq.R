library("Rsamtools")
filenames <- dir(".", pattern = "sorted.bam", full.names = T)
filenames

bamfiles <- BamFileList(filenames, yieldSize=2000000)
bamfiles

seqinfo(bamfiles[1])

library("GenomicFeatures")
gtffile <- dir(".", pattern = "gtf", full.names = T)
gtffile
txdb <-  makeTxDbFromGFF("https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/412/675/GCF_000412675.1_ASM41267v1/GCF_000412675.1_ASM41267v1_genomic.gff.gz", format="gff")

ebg <- exonsBy(txdb, by="gene")
ebg

library("GenomicAlignments")
library("BiocParallel")

register(MulticoreParam(2))

se <- summarizeOverlaps(features=ebg,
                        reads=bamfiles,
                        mode="Union",
                        singleEnd=FALSE,
                        ignore.strand=TRUE,
                        fragments=TRUE )

se

head( assay(se))

dim(se)

nrow(se)

ncol(se)

rowRanges(se)

length(rowRanges(se))

rowRanges(se)[[1]]

str(metadata(rowRanges(se)))

colData(se)

colnames(se)

bamfiles
