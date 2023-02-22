# rnaseq

Bu döküman, tez kapsamında hazırlanmış olup; RNA seq analizi publine çalışması yapılmaktadır. Bu çalışmanın sonunda gen bölgelerine karşılık gelen RNA miktarları belirlenecektir. 

## Sra-toolkit indirme

Conda içindeki `fasterq-dump` sorun çıkarmakta. O yüzden doğrudan `sra-tools` paketinin son versiyonunu indiriyoruz:

```bash
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.0/sratoolkit.3.0.0-ubuntu64.tar.gz

tar -xzf sratoolkit.3.0.0-ubuntu64.tar.gz
```
# Rnaseq

RNA dizileme analizi, gen ekspresyon seviyelerinin analizinde kullanılan bir yöntemdir. 

RNA dizileme teknolojisi sayesinde transkriptomu oluşturan RNA dizilerinin hassas bir şekilde haritası oluşturulur. RNA dizileme analizi, hücrede bulunan hangi genlerin ifade edilip edilmediğini ve hangi genlerin daha çok hangilerinin daha az ifade edildiğini belirler.

Canlıdaki gen anlatımı tespit edilir ve başka örneklerle karşılaştırılır. 

RNA Seq(RNA dizilimi), kodlama yapan ve kodlamayan RNA ekspresyonunu incelemek için kullanılan bir metodolojidir. Her aşamasında çeşitli yazılım araçları kullanılmaktadır. 

Bu çalışma aşağıdaki aşamalardan oluşmaktadır:

+ Biyolojik bir numuneden RNA izolasyonu
+ RNA’nın cDNA’ya dönüştürülmesi
+ cDNA’nın fragmentlerine ayrılması
+ cDNA parçaları kitaplığının hazırlanması
+ Yüksek verimli dizi okuma teknolojisi olan yeni nesil dizileme kullanılarak cDNA kitaplığının dizilenmesi
+ Ham fastq dosyalarının eldesi
+ Dizilerin `cutadapt` ile işlenerek, `fastqc` aracı ile kalite kontrolden geçirilmesi
+ Fastq’ların referans genoma hizalanması ve RNA dizileme verisi eldesi 
+ Gen ekspresyonu belirlenmesi için referans genoma hizalanan dizilerin sayılması
+ Her gene ait olan okumalar sayıldıktan sonra, sağlıklı ve hastalıklı koşulların karşılaştırılması.

## Makale:

+ https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6066579/

# Fastqc 

Yüksek verimli sıralama işlem hatlarından gelen ham dizi verileri üzerinde bazı kalite kontrolleri yapmak için kullanılan bir araçtır.

Fastqc kommutları `fastqc_se.sh’`, `fastqc_pe.sh` script dosyalarında yer alır.

# Cutadapt

Adaptör dizilerini, primerleri ve diğer istenmeyen dizileri yüksek verimli dizileme verilerinden kaldırmak için kullanılan yazılım aracıdır. 

Ham verileri işlemek için biyoinformatik alanında yaygın olarak kullanılmaktadır.

Cutadapt kommutları `cutadapt_se.sh’`, `cutadapt_pe.sh` script dosyalarında yer alır.

# BWA

DNA dizilerini bir referans genoma hizalamak için kullanılan bir yazılım aracıdır. 

Bu, RNA-seq okumalarını referans genoma hizalayacak ve hizalamaları bir SAM dosyası biçiminde çıkaracaktır. 

Bwa kommutları `bwa_se.sh`, `bwa_pe.sh` script dosyalarında yer alır.

Hizalamaları daha fazla işlemek ve analiz etmek için `Samtools` gibi araçlar kullanılır.

Sonraki adımda ise `bcftools` programı kullanılarak varyant çağırma işlemi gerçekleştirilir.

## Referans genome:

+ https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4702867/

+ https://www.ncbi.nlm.nih.gov/assembly/GCA_000007565.2

# Referans Genom İndirme

İstenilen referans genom, [şu bağlantıdan](https://www.ncbi.nlm.nih.gov/genome/?term=txid303[orgn]) indirilebilir.

Bu sayfa içerisinde **Genome** bağlantısına tıklayarak dosyayı sıkıştırılmış halde indirebilirsiniz.

İndirilen dosya, `Projects/rnaseq/data/ref` klasörü içerisine aktarılır ve ardından `gunzip` komutu ile bu sıkıştırılmış dosya açılır.  

