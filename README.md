# rnaseq

Bu döküman, tez kapsamında hazırlanmış olup; RNA seq analizi publine çalışması yapılmaktadır. Bu çalışmanın sonunda gen bölgelerine karşılık gelen RNA miktarları belirlenecektir. 

## Sra-toolkit indirme

Conda içindeki `fasterq-dump` sorun çıkarmakta. O yüzden doğrudan `sra-tools` paketinin son versiyonunu indiriyoruz:

```bash
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.0/sratoolkit.3.0.0-ubuntu64.tar.gz

tar -xzf sratoolkit.3.0.0-ubuntu64.tar.gz
```

RNA Seq(RNA dizilimi), kodlama yapan ve kodlamayan RNA ekspresyonunu incelemek için kullanılan bir metodolojidir. Her aşamasında çeşitli yazılım araçları kullanılmaktadır. 

Bu çalışma aşağıdaki aşamalardan oluşmaktadır:

+ SRA veri tabanı ile raw fastq (ham fastq) indirilerek işlenecektir. 
+ Fastq'lar elde edilecek ve elde edilen Fastq'lar bakteri genomuna hizalanacaktır. 
+ BAM dosyası elde edilecek ve bu dosya kalite kontrolden geçirilecek.
+ Her gen bölgesinde karşılık gelen RNA miktarı ölçülecek ve elimize matris geçmiş olacak. 


Makale:

+ https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6066579/


Referans genome:

+ https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4702867/

+ https://www.ncbi.nlm.nih.gov/assembly/GCA_000007565.2

# Referans Genom İndirme

İstenilen referans genom, [şu bağlantıdan](https://www.ncbi.nlm.nih.gov/assembly/GCA_000007565.2) indirilebilir.

İndirilen fasta format, çalışılan `Projects/rnaseq/data/ref` içerisine aktarılır. Ardından `gunzip` komutu ile bu sıkıştırılmış dosya açılır.  

