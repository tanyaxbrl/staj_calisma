---
title: "RNAseq Çalışması"
author: "Nursena Kocatürk"

---

# Giriş

Bu döküman, tez kapsamında hazırlanmış olup; RNA dizileme analizi çalışması için bir pilot projedir. Bu çalışmanın sonunda gen bölgelerine karşılık gelen RNA miktarları belirlenecektir. 

## Programların kurulumu

Conda ile programları aşağıdaki gibi kurabilirsiniz.

```bash
conda env create --file envs/rnaseq.yaml
```

Daha sonra çevreyi aktive edin:

```bash
conda activate rnaseq
```

Eğer Conda çevrenizi güncellemek isterseniz:

```bash
conda env update --file envs/rnaseq.yaml

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


# Bizim RNASeq analiz protokolümüz

Öncelikle bu git deposunu klonlayın ve klasör içerisine girin:

```bash
git clone 
cd rnaseq
```

## DNA okumalarını indirme

Bu çalışma kapsamında örnek bir veri seti oluşturulmuştur. Elde edilen DNA okumalarını Kırdök Lab Google Drive klasöründen indirebilirsiniz. Daha sonra `data/ref` isminde bir klasör oluşturun ve bu `fastq.gz` dosyalarını oluştruduğunuz klasör içerisinde kaydediniz:

```bash
mkdir -p data/raw
```

## Kullanılacak Referans genomu indirme

Referans genomu indirmek için aşağıdaki bağlantıları kullanabiliriz. 

Kullanılacak referans genom ve genom anotasyon dosyalarını aşağıdaki gibi indirebiliriz:

Önce veri klasörlerimizi oluşturalım:

```bash

mkdir -p data/ref
cd data/ref

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/007/565/GCA_000007565.2_ASM756v2/GCA_000007565.2_ASM756v2_genomic.fna.gz

gunzip GCA_000007565.2_ASM756v2_genomic.fna.gz

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/007/565/GCA_000007565.2_ASM756v2/GCA_000007565.2_ASM756v2_genomic.gff.gz

gunzip GCA_000007565.2_ASM756v2_genomic.gff.gz

cd ../..
```

İndirdiğimiz referans genom dosyasını gunzip ile açmalıyız. Yoksa indeksleme işlemi düzgün bir şekilde gerçekleşmez.

## Yeni nesil dizileme verisi indirme ve kalite kontrol adımı

Bu adım için `part1.sh` betiğini kullanıyoruz. Bu betik, ilk olarak `sra-tools` paketinde bulunan programları ile, istenen fastq dosyalarını indirerek, `fastqc` programı ile kalite kontrol adımlarını gerçekleştirir.

Fastqc programı yüksek verimli DNA dizileme işlem hatlarından gelen ham dizi verileri üzerinde bazı kalite kontrolleri yapmak için kullanılan bir araçtır.

Fastqc komutları `fastqc_se.sh’` ve `fastqc_pe.sh` betik dosyalarında yer alır.

Bu kısmı çalıştırmak için ilk olarak `fastq` dosyalarının SRA kodlarının bulunduğu `data.txt` dosyasını oluşturmamız gerekir. Bu dosya içerisinde, indirilecek `fastq` dosyasının SRA kodu ve hangi uçlardan dizilendiği (tek yönlü, single end, se veya çift yönlü, paired end, pe) bilgisini içeren ve boşluk karakteri ile ayrılmış iki sütün olmalıdır:

```
ERR10671864 pe
ERR10671865 pe
```

Bu adımı çalıştırmak için aşağıdaki komut yazılır:

```bash
./part1.sh
```

## Fastq dosyalarının işleme adımı (Kısım 2)

Bu adım için `part2.sh` betiğini kullanıyoruz. Bu betikte, ilk olarak `data` klasörü içerisinde işlenmiş fastq dosyaların kaydedileceği `processed` isimli bir klasör oluşturmalıyız. Bu klasör içerisinde de tek yönlü (se) ve çift yönlü (pe) okumaların olduğu iki farklı klasör oluşturmalıyız. 

`Cutadapt` programı ile fastqc dosyalarının işleme adımları gerçekleştirilir. 

Cutadapt, adaptör dizilerini, primerleri ve diğer istenmeyen dizileri yüksek verimli dizileme verilerinden kaldırmak için kullanılan yazılım aracıdır. 

Cutadapt komutları `cutadapt_se.sh’`ve `cutadapt_pe.sh` betik dosyalarında yer alır.

## Yeni nesil dizileme verilerinin referans genoma hizalanması

### BWA ile hizalama

Bu adım için `part3.sh` betiğini kullanıyoruz. Bu betikte, ilk olarak elde edilen çıktıların kaydedilmesi için `results` klasörü altında `aligment` klasörünü oluşturmalıyız. Bu klasör içerisinde de tek yönlü (se) ve çift yönlü (pe) okumaların olduğu iki farklı klasör oluşturulur.

`BWA` programı ile yeni nesil dizileme verilerinin referans genoma hizalanma adımı gerçekleştirilir.

BWA, DNA dizilerini bir referans genoma hizalamak için kullanılan bir yazılım aracıdır. 

Bu, RNA-seq okumalarını referans genoma hizalayacak ve hizalamaları bir SAM dosyası biçiminde çıkaracaktır. 

Bwa komutları `bwa_se.sh`ve `bwa_pe.sh` betik dosyalarında yer alır.

Hizalamaları daha fazla işlemek ve analiz etmek için `Samtools` gibi araçlar kullanılır.

Sonraki adımda ise `bcftools` programı kullanılarak varyant çağırma işlemi gerçekleştirilir.

### STAR ile hizalama

Bu adım için `part4.sh` betiğini kullanıyoruz. Bu betikte, ilk olarak elde edilen çıktıların kaydedilmesi için `results` klasörü altında `star` klasörünü oluşturmalıyız. Bu klasör içerisinde de tek yönlü (se) ve çift yönlü (pe) okumaların olduğu iki farklı klasör oluşturulur.

STAR, BWA aracı gibi DNA dizilerini referans genoma hizalamak için kullanılan bir araçtır. Özelliklerinde ve uygulamalarında bazı farklılıklar vardır.

Varyant çağırma veya genotipleme için kısa okunan sıralama verilerini analiz ederken, BWA daha iyi bir seçimdir. Gen ifadesi analizi ve alternatif ekleme için RNA-seq verileri analiz ediliyorsa, STAR daha uygun bir araç olacaktır.

Genel olarak, BWA ve STAR arasındaki seçim, sıralama verilerinin türüne ve analiz hedeflerine bağlıdır. 

STAR komutları `star_se.sh`ve `star_pe.sh` betik dosyalarında yer alır.

#### `gff` Dosyası İndirme

İstenilen `gff` dosyası, [şu bağlantıdan](https://www.ncbi.nlm.nih.gov/genome/?term=txid303[orgn]) indirilir.

Bu sayfa içerisinde **GFF** bağlantısına tıklayarak dosyayı indirebilirsiniz.

#### Cufflinks 

Conda ile `cufflinks` programını aşağıdaki gibi kurabilirsiniz.

```bash

conda env create --file envs/cufflinks.yaml

```

Daha sonra çevreyi aktive edin:

```bash

conda activate cufflinks
```

Öncelikle `Cufflinks` programı içerisinde bulunan `gffread` programı ile gff dosyasını gtf'e çevirelim. 

`gff` ve `gtf` formatları arasında dönüştürme yapmak için çeşitli araçlar mevcuttur. `

```bash
gffread data/ref/GCF_000412675.1_ASM41267v1_genomic.gff -T -o data/ref/GCF_000412675.1_ASM41267v1_genomic.gtf
```

Şimdi de `STAR` aracı ile referans genomu indeksleyelim:

```
STAR --runMode genomeGenerate --genomeDir data/ref/GenomeDir --genomeFastaFiles data/ref/GCF_000412675.1_ASM41267v1_genomic.fna --runThreadN 8
```

Hizalamayı aşağıdaki şekilde yapmalıyız:

Öncelikle klasörümüz oluşturalım:

```bash
mkdir -p results/star/pe/ERR10671866/
```

Programı aşağıdaki gibi çalıştırabiliriz:

```bash

STAR --runThreadN 4 \
	--genomeDir data/ref/GenomeDir/ \
	--readFilesIn data/processed/pe/ERR10671866_1.fastq.gz data/processed/pe/ERR10671866_2.fastq.gz \
	--outFileNamePrefix results/star/pe/ERR10671866/ERR10671866- \
	--readFilesCommand zcat
```

#### STAR aracı çıktıları

##### Log.out

Çalıştırma hakkında birçok ayrıntılı bilgi içeren dosya. Bu dosya en çok sorun giderme ve hata ayıklama için kullanışlıdır.

##### Log.progress.out

İşlenen okuma sayısı, eşlenen okumaların vb. gibi iş ilerleme istatistiklerini raporlar. 

##### Log.final.out

Haritalama işi tamamlandıktan sonra özet haritalama istatistikleri, kalite kontrolü için çok faydalıdır. İstatistikler her okuma için (tek veya çift uç) hesaplanır ve ardından tüm okumalar üzerinden toplanır veya ortalaması alınır. 

##### Aligned.out.sam

Standart SAM biçimindeki hizalamalar.

##### SJ.out.tab

Sekmeyle ayrılmış formatta yüksek güvenliğe sahip daraltılmış ekleme bağlantılarını içerir. STAR'ın bağlantı noktası başlangıcını/bitişini intronik bazlar olarak tanımlarken, diğer birçok yazılımın bunları eksonik bazlar olarak tanımladığını unutmayın. Sütunlar şu anlama gelir:

+ Sütun 1: kromozom
+ Sütun 2: intronun ilk tabanı (1 tabanlı)
+ Sütun 3: intronun son tabanı (1 tabanlı)
+ Sütun 4: iplikçik (0: tanımsız, 1: +, 2: -)
+ Sütun 5: intron motifi: 0: kanonik olmayan; 1: GT/AG, 2: CT/AC, 3: GC/AG, 4: CT/GC, 5: AT/AC, 6: GT/AT
+ Sütun 6: 0: açıklamasız, 1: ekleme bağlantıları veri tabanında açıklamalı. 2 geçişli modda, 1. geçişte algılanan bağlantıların, GTF'den açıklamalı bağlantılara ek olarak açıklamalı olarak raporlandığını unutmayın.
+ Sütun 7: bağlantı noktasından geçen benzersiz eşleme okumalarının sayısı
+ Sütun 8: bağlantı noktasından geçen çoklu eşleme okuma sayısı
+ Sütun 9: maksimum eklenmiş hizalama çıkıntısı

### Genom Tarayıcısı

Hizalama adımından sonra genom tarayıcısı adımı yer almaktadır. Okuma hizalamaları (BAM, SAM formatlarında), kullanıcıların bir grafik arayüz kullanarak genomik dizilere ve ek açıklama verilerine göz atmasına, bunları aramasına, almasına ve analiz etmesine olanak tanıyan bir program olan bir genom tarayıcısında görüntülenebilir.

İki tür genom tarayıcısı vardır:

#### Web tabanlı genom tarayıcıları:

+ UCSC Genom Tarayıcısı
+ Ensembl Genom Tarayıcısı
+ NCBI Genom Veri Görüntüleyici

#### Masaüstü uygulamaları (bazıları web tabanlı bir genom tarayıcısı oluşturmak için de kullanılabilir):

+ JBrowse
+ GBrowse
+ IGV

Küçük boyutlu veriler doğrudan genom tarayıcısına yüklenebilirken, büyük dosyalar normalde tarayıcı tarafından erişilebilen bir web sunucusuna yerleştirilir. STAR eşleyici tarafından üretilen BAM dosyalarını keşfetmek için öncelikle dosyaları sıralamamız ve indekslememiz gerekir. Bizim durumumuzda, sıralama zaten STAR tarafından yapılmıştır çünkü hizalamaları koordinatlara göre sıralanmış BAM dosyalarına veririz. 
