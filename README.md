---
title: "RNAseq Çalışması"
author: "Nursena Kocatürk, Tanya Beril Korkmaz, Emrah Kırdök"

---

# Giriş

Bu döküman, tez kapsamında hazırlanmış olup; RNA dizileme analizi çalışması için bir pilot projedir. Bu çalışmanın sonunda gen bölgelerine karşılık gelen RNA miktarları belirlenecektir. 

# RNAseq

RNA dizileme analizi, gen ekspresyon seviyelerinin analizinde kullanılan bir yöntemdir. 

RNA dizileme teknolojisi sayesinde transkriptomu oluşturan RNA dizilerinin hassas bir şekilde haritası oluşturulur. RNA dizileme analizi, hücrede bulunan hangi genlerin ifade edilip edilmediğini ve hangi genlerin daha çok hangilerinin daha az ifade edildiğini belirler.

Canlıdaki gen anlatımı tespit edilir ve başka örneklerle karşılaştırılır. 

RNA Seq (RNA dizilimi), kodlama yapan ve kodlamayan RNA ekspresyonunu incelemek için kullanılan bir metodolojidir. Her aşamasında çeşitli yazılım araçları kullanılmaktadır. 

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

# Ön Hazırlık

## Git Deposunun Klonlanması

Bu protokolde kullanılmak üzere hazırlanan dosyaları ve betikleri öncelikle kendi bilgisayarımıza almalıyız.

1. Verilen linke gidiniz: https://github.com/nursenakocaturk/rnaseq
2. Sayfada "Code" yazan yeşil kutucuğa tıklayınız ve karşınıza çıkan https bağlantısını kopyalayınız
3. Terminalinizde oluşturduğunuz proje klasörünün içerisine giriniz ve bu linki 

```bash
git clone https://github.com/nursenakocaturk/rnaseq
```
şeklinde terminale alınız.

Kullanacağımız ham DNA okumaları ve referans genom bilgileri proje klasörü içerisindeki `data` içerisinde yer almalıdır. İşlenmiş DNA okumaları, ve diğer çıktı dosyaları ise yine proje klasörü içerisindeki `results` klasörü içinde yer alacaktır. Bunları protokolde ilerledikçe oluşturacağız. Biz hala proje klasörünün içerisindeyiz.

## Conda Kurulumu ve Programların Aktifleştirilmesi (Eğer sisteminizde conda kurulu değilse)

Bu linkten işletim sisteminize uygun olan Conda programını (Miniconda kullanacağız) seçin:  https://docs.conda.io/projects/conda/en/stable/user-guide/install/download.html

Programı seçtikten sonra indirme bağlantı linkini kopyalayın ve 

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```
gibi görünecek şekilde kodu yazın. Unutmayın, bu bir örnektir. Siz sizin kullandığınız işletim sistemine uygun olanı seçeceksiniz.

Terminal üzerinde yüklemeyi yönlendirildiğiniz şekilde tamamlayın.

Şimdi conda çevrelerini kurup aktive edeceğiz. Bu ççevrelerde, yapmak istediğimiz işe uygun olan paketler bir aradadır. Yapmak istediğimiz işe uygun olan çevrede işlerimizi yürütmeliyiz.

RNAseq çevremizi kuralım;

```bash
conda env create --file envs/rnaseq.yaml
```
ve çevreyi aktive edelim:

```bash
conda activate rnaseq
```
Gen sayı matrixini elde etmek için kullanacağımız araçlardan biri olan HTSeq kurulumunu yapalım. HTSeq, phyton3 ile çalışmaktdır. Bunun öncesinde phyton'a sahip olduğunuzdan ve bu sürümün güncel olduğundan emin olun. HTSeq'i rnaseq çevresine kuracağız ve programı burada çalıştıracağız.

```bash
pip install HTSeq
```
Çevremizi aktive ettikten sonra komut satırımızın başında aktif olan çevrenin adı parantez içinde gösterilecektir.

Eğer Conda çevrenizi güncellemek isterseniz:

```bash
conda env update --file envs/rnaseq.yaml
```

Protokolün ilerleyen aşamalarında R da kullanacağız. Şimdiden çevremizi kuralım:

```bash
conda env create --file envs/r.yaml
```

Zamanı geldiğinde aktive etmek için 

```bash
conda activate r
```

yazacağız. 

Ama şu an için rnaseq çevresi içerisinde olmalıyız.

## Referansların ve Okumaların Alınması

Bu çalışma kapsamında örnek bir veri seti oluşturulmuştur. Klonladığımız klasörün içerisinde 'data_ena.txt' isimli metin dosyasının içerisinde raw/ham okumaların, bu okumalara ait bilgilerin ve indirme linklerinin bir listesi yer almaktadır. Yine bu klasörde 'data.txt' isimlii metin dosyasının içerisinde, bir öndeki metin dosyasından seçilmiş dört adet örnek yer almaktadır.

Proje klasörümüzün içerisine ham okumaları ve referansımızı alacağımız iki ayrı klasör oluşturalım. 'raw' isimli klasörde ham okumalar, 'ref' isimli klasörümüzde ise referansımız olsun.

```bash
mkdir -p data/raw
mkdir -p data/ref
```

### Ham Okumaların Alınması

Klasörlerimiz hazır, şimdi önce ham okumalarımızı alalım. Tüm ham okumaların yer aldığı listede hem çift yönlü, hem de tek yönlü okumalar yer almaktadır. Protokolün devamında bu iki okumalar da birbirlerinden farklı işleneceklerinden yine klasör bazında ayrımlarını yapmalıyız. Bu yüzden raw klasörünün içerisinde 'pe' ve 'se' isimli iki ayrı klasör oluşturun.

'data.txt' dosyasını incelerseniz, seçilen okumaların hepsinin tek yönlü olduklarını göreceksiniz. 

Tek yönlü okumaları alacağımız klasöre gidelim:

```bash
cd data/raw/se
```

Ve 'data_ena.txt' dosyası içerisinden inceleyeceğimiz okumanın linkini kopyalayalım. Okumayı indirmek için kopyaladığımız linkle birlikte kodumuz şu şekilde görünecek şekilde düzenlenmelidir ('ftp://' ön takısını siz eklemelisiniz):

```bash
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR702/005/SRR7029605/SRR7029605.fastq.gz
```

Diğer 3 okuma için de bu kodu oluşturup ayrı ayrı çalıştıralım. 'se' klasörünüzün içine okumalara ait toplamda 4 adet fastq.gz uzantılı dosya gelmiş olmalıdır.

### Referansın alınması

```bash
cd data/ref
```
 ile referansımız için hazırladığımız klasöre girelim ve referans dosyalarını alıp gunzip komutu ile açalım.


```bash
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/007/565/GCA_000007565.2_ASM756v2/GCA_000007565.2_ASM756v2_genomic.fna.gz

gunzip GCA_000007565.2_ASM756v2_genomic.fna.gz

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/007/565/GCA_000007565.2_ASM756v2/GCA_000007565.2_ASM756v2_genomic.gff.gz

gunzip GCA_000007565.2_ASM756v2_genomic.gff.gz

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/007/565/GCA_000007565.2_ASM756v2/GCA_000007565.2_ASM756v2_genomic.gtf.gz

gunzip GCA_000007565.2_ASM756v2_genomic.gtf.gz
```

İndirdiğimiz referans genom dosyasını gunzip ile açmalıyız. Yoksa indeksleme işlemi düzgün bir şekilde gerçekleşmez.

# Adım 1: Yeni Nesil Dizileme Verilerinin Kalite Kontrol Adımı

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
./part1.sh data.txt
```

`sra-tools` ile conda arasındakı uyumsuzluk nedeniyle, DNA okumlarının indirilmesi adımı şimdilik atlanmıştır.

# Adım 2: Fastq Dosyalarını İşleme Adımı

Bu adım için `part2.sh` veya `trimmomatic.sh` betiğini kullanıyoruz. 

part2.sh betiğinin içersindeki `Cutadapt` programı da, trimmomatic.sh betiği içerisindeki trimmomatic programı da ile fastqc dosyalarının işleme adımları gerçekleştirir. 

Her ikisi de adaptör dizilerini, primerleri ve diğer istenmeyen dizileri yüksek verimli dizileme verilerinden kaldırmak için kullanılan yazılım aracıdır.

Dikkat edelim, bu betiklerin sonunda tekrar fastq aracı ile karşılaşacaksınız. Süreci hızlandırmak için bu araç bu betiklerin içerisine eklenmiştir. Aslında bu komut satırının yaptığı iş `part1.sh` betiği ile tamamen aynıdır. Eğer bu betiklerin içerisine fastq aracı tekrar eklenmeseydi, bu sefer `part1.sh` betiğini tekrar çalıştırmamız, çalıştırmadan önce girdi ve çıktıların dosya konumlarını kod içerisinde tekrar düzenlememiz gerekecekti.

Cutadapt komutları `cutadapt_se.sh` ve `cutadapt_pe.sh` betik dosyalarında; trimmomatic komutları da `trimmomatic_pe.sh` ve `trimmomatic_se.sh` betik dosyalarında yer alır. Bu betik dosyalarına scripts klasöründen ulaşabilirsiniz.

```bash
./part2.sh data.txt
```

veya
 
```bash
./trimmomatic.sh data.txt
```

# Adım 3: İşlenmiş Yeni Nesil Dizileme Verilerinin Referans Genoma Hizalanması

Bu adım için `part3.sh` veya `part4.sh` betiğini kullanıyoruz. 
`part3.sh` betiğinde BWA aracı, `part4.sh` betiğinde de Bowtie2 aracı ile çalışılmaktadır. Her iki araçla da yeni nesil dizileme verilerinin referans genoma hizalanma adımı gerçekleştirilir.
 
Bu araçlar, RNA-seq okumalarını referans genoma hizalayacak ve hizalamaları bir SAM dosyası biçiminde çıkaracaktır. 

Bwa komutları `bwa_se.sh`ve `bwa_pe.sh` betik dosyalarında yer alır. Bowtie2 komutları ise `bowtie_pe.sh` ve `bowtie_se.sh` betikleri içerisindedir. Bu betiklere scripts klasöründen ulaşabilirsiniz.

```bash
./part3.sh data.txt
```

veya

```bash
./part4.sh data.txt
```

Komutuyla bu programı çalıştıralım.

# Adım 4: Hizalanan Verilerle Sayı Matrisi Oluşturulması

Bu adımda `part5.sh` veya `htseq-counts.sh` betiklerini kullanacağız. part5.sh betiğinde part counts aracı, htseq-counts.sh betiğinde ise htseq counts aracı çalıştırılır. İkisinden birini seçebilirsiniz.
 
Bu betiklerin ikisinde de hizalama sonrası elde edilen veriler, artık gen ifadesi düzeyinde gerçekleştirecek olduğumuz analizlerin baş rolü olan gen ifadesi matrisleri oluşturulacaktır. Burada dikkat etmemiz gereken bir nokta var: `part5.sh` betiğini r çerçevesinde, `htseq-counts.sh` betiğini ise rnaseq çerçevesinde çalıştırmalıyız. 
Aşağıda verilen kodlarda, bir önceki hizalama adımında hangi hizalama aracını kullandıysak bunu belirtmeliyiz. Eğer hizalamamızı bwa aracıyla yaptıysak bowtie2 yerine bwa yazmalıyız.

```bash
./part5.sh data.txt bowtie2
```

veya 

```bash
htseq-counts data.txt bowtie2
```
betiği ile bu programı çalıştıralım.

# Bonus: STAR ile hizalama

STAR programı çoğunlukla ökaryotik gen ifadelerinin analizlerinde kullanılan bir araçtır.
Bu adım için `star-part.sh` betiğini kullanıyoruz. Bu betikte, ilk olarak elde edilen çıktıların kaydedilmesi için `results` klasörü altında `star` klasörünü oluşturmalıyız. Bu klasör içerisinde de tek yönlü (se) ve çift yönlü (pe) okumaların olduğu iki farklı klasör oluşturulur.

STAR, BWA aracı gibi DNA dizilerini referans genoma hizalamak için kullanılan bir araçtır. Özelliklerinde ve uygulamalarında bazı farklılıklar vardır.

Varyant çağırma veya genotipleme için kısa okunan sıralama verilerini analiz ederken, BWA daha iyi bir seçimdir. Gen ifadesi analizi ve alternatif ekleme için RNA-seq verileri analiz ediliyorsa, STAR daha uygun bir araç olacaktır.

Genel olarak, BWA ve STAR arasındaki seçim, sıralama verilerinin türüne ve analiz hedeflerine bağlıdır. 

STAR komutları `star_se.sh`ve `star_pe.sh` betik dosyalarında yer alır.

### `gff` Dosyası İndirme

İstenilen `gff` dosyası, [şu bağlantıdan](https://www.ncbi.nlm.nih.gov/genome/?term=txid303[orgn]) indirilir.

Bu sayfa içerisinde **GFF** bağlantısına tıklayarak dosyayı indirebilirsiniz.

### Cufflinks 

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

### STAR aracı çıktıları

#### Log.out

Çalıştırma hakkında birçok ayrıntılı bilgi içeren dosya. Bu dosya en çok sorun giderme ve hata ayıklama için kullanışlıdır.

#### Log.progress.out

İşlenen okuma sayısı, eşlenen okumaların vb. gibi iş ilerleme istatistiklerini raporlar. 

#### Log.final.out

Haritalama işi tamamlandıktan sonra özet haritalama istatistikleri, kalite kontrolü için çok faydalıdır. İstatistikler her okuma için (tek veya çift uç) hesaplanır ve ardından tüm okumalar üzerinden toplanır veya ortalaması alınır. 

#### Aligned.out.sam

Standart SAM biçimindeki hizalamalar.

#### SJ.out.tab

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

## Genom Tarayıcısı

Hizalama adımından sonra genom tarayıcısı adımı yer almaktadır. Okuma hizalamaları (BAM, SAM formatlarında), kullanıcıların bir grafik arayüz kullanarak genomik dizilere ve ek açıklama verilerine göz atmasına, bunları aramasına, almasına ve analiz etmesine olanak tanıyan bir program olan bir genom tarayıcısında görüntülenebilir.

İki tür genom tarayıcısı vardır:

### Web tabanlı genom tarayıcıları:

+ UCSC Genom Tarayıcısı
+ Ensembl Genom Tarayıcısı
+ NCBI Genom Veri Görüntüleyici

### Masaüstü uygulamaları (bazıları web tabanlı bir genom tarayıcısı oluşturmak için de kullanılabilir):

+ JBrowse
+ GBrowse
+ IGV

Küçük boyutlu veriler doğrudan genom tarayıcısına yüklenebilirken, büyük dosyalar normalde tarayıcı tarafından erişilebilen bir web sunucusuna yerleştirilir. STAR eşleyici tarafından üretilen BAM dosyalarını keşfetmek için öncelikle dosyaları sıralamamız ve indekslememiz gerekir. Bizim durumumuzda, sıralama zaten STAR tarafından yapılmıştır çünkü hizalamaları koordinatlara göre sıralanmış BAM dosyalarına veririz. 


