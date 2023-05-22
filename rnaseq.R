library("Rsamtools")

filenames <- dir("results/star/", pattern = "sorted.bam", full.names = T, recursive = T)

bamfiles <- BamFileList(filenames, yieldSize=2000000)

library("GenomicFeatures")

gtffile <- dir(".", pattern = "gtf", full.names = T)

txdb <-  makeTxDbFromGFF("https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/412/675/GCF_000412675.1_ASM41267v1/GCF_000412675.1_ASM41267v1_genomic.gff.gz", format="gff")

ebg <- exonsBy(txdb, by="gene")

library("GenomicAlignments")

library("BiocParallel")

register(MulticoreParam(2))

se <- summarizeOverlaps(features=ebg,
                        reads=bamfiles,
                        mode="Union",
                        singleEnd=FALSE,
                        ignore.strand=TRUE,
                        fragments=TRUE )
                        
se <- as.data.frame(se)

write.table(x = se, file = "counts.txt", col.names = T, row.names = T, quote = F)

countData <- read.csv('counts.txt', header = TRUE, sep = ",")

metaData <- read.csv('data.txt', header = TRUE, sep = ",")

dds <- DESeqDataSetFromMatrix(countData=countData, 
                              colData=metaData, 
                              design=~dex, tidy = TRUE)

countData <- as.matrix(read.csv("counts.", row.names = 1))

