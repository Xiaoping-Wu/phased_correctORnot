## get trio id
library(data.table)
library(dplyr)

child <- fread("/mnt/work/p1724/v12/linkage_Child_PDB1724.csv") %>%
  select(PREG_ID_1724,SENTRIX_ID) %>%
  rename(IID_child=SENTRIX_ID)
mor <- fread("/mnt/work/p1724/v12/linkage_Mother_PDB1724.csv") %>%
  select(M_ID_1724,SENTRIX_ID) %>%
  rename(IID_mor=SENTRIX_ID)

far <- fread("/mnt/work/p1724/v12/linkage_Father_PDB1724.csv") %>%
  select(F_ID_1724,SENTRIX_ID) %>%
  rename(IID_far=SENTRIX_ID)

parental <- fread("/mnt/work/p1724/v12/parental_ID_to_PREG_ID.csv")
genoID <- fread("/mnt/archive/moba/geno/HDGB-MoBaGenetics/2025.01.30_beta/moba_genotypes_2025.01.30_common.psam")

df <- parental %>%
  inner_join(child,by="PREG_ID_1724") %>%
  inner_join(mor,by="M_ID_1724",relationship = "many-to-many") %>%
  inner_join(far,by="F_ID_1724",relationship = "many-to-many") %>%
  select(IID_child,IID_mor,IID_far) %>%            
  filter((IID_child %in% genoID$IID) & (IID_mor %in% genoID$IID) & (IID_far %in% genoID$IID))  

## some duplicated IID_child because some samples has been genotyped twice

fwrite(df,"/home/xiaoping.wu/scratch/xiaoping/moba2025release_check/results/trio_id.tsv",sep="\t")

## extract id 
keep <- genoID %>%
  filter(IID %in% c(df$IID_child,df$IID_mor,df$IID_far))

fwrite(keep[,1:2],"/home/xiaoping.wu/scratch/xiaoping/moba2025release_check/results/keepid.txt",col.names = F,sep="\t")






