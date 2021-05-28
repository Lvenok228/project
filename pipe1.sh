#! /bin/bash
cd ~/Desktop/dataset
bcftools concat -Oz -o concatenated.vcf.gz chr19.vcf.gz chr20.vcf.gz chr21.vcf.gz chr22.vcf.gz
bcftools sort -Oz -o concatenated-sorted.vcf.gz concatenated.vcf.gz
bcftools index -tf concatenated-sorted.vcf.gz
bcftools index -tf ceu.vcf.gz
bcftools merge concatenated-sorted.vcf.gz ceu.vcf.gz -Oz -o final.vcf.gz
bcftools index -tf final.vcf.gz
plink --vcf final.vcf.gz --recode --make-bed --memory 1000 --out plink1 > info.log
plink --bfile plink1 --indep-pairwise 50 10 0.5 --make-bed --memory 1000 --out plink2 >> info.log
plink --bfile plink2 --snps-only --make-bed --memory 1000 --out plink3 >> info.log
plink --bfile plink3 --pca --recode --make-bed --memory 1000 --out pca >> info.log
read -d "$EOF" vecs < pca.eigenvec
read -d "$EOF" populations < *.txt
cp ./ceu.vcf.gz ./copied_ceu.vcf.gz
gunzip copied_ceu.vcf.gz
extra_population=`awk 'substr($0,2,5)=="CHROM"{for(i=10; i<=NF; i++) print ($i, "CEU")}' copied_ceu.vcf`
echo -e "$vecs\n#THEEND!"
echo -e "$populations\n#THEEND!"
echo -e "$extra_population\n#THEEND!"
