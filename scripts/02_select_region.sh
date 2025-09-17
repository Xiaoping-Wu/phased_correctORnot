 
## select a small region and convert to vcf file
plink2 \
  --pfile /mnt/archive/moba/geno/HDGB-MoBaGenetics/2025.01.30_beta/moba_genotypes_2025.01.30_common \
  --chr 22 \
  --maf 0.05 \
  --keep results/keepid.txt \
  --make-pgen \
  --out results/chr22_region
## vcf file has problem with "Multiple instances of '_' in sample ID", because there are _ in family ID, so use --double_id


#randomly choose 10 trios
awk 'NR>1' results/trio_id.tsv | shuf -n 10  >results/trio10.txt
awk '{print $1}' results/trio10.txt >results/trio10
awk '{print $2}' results/trio10.txt >>results/trio10
awk '{print $3}' results/trio10.txt >>results/trio10

join -1 2 -2 1  <(sort -k2,2 results/chr22_region.psam) <(sort -k1,1 results/trio10) |awk '{print $2,$1}' >results/trio10.tmp
 
plink2 --pfile results/chr22_region --keep results/trio10.tmp --export vcf bgz id-delim=":"  --out results/trio10

