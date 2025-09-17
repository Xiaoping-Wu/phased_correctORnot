
library(data.table)
library(dplyr)

geno <- fread("results/trio10.vcf.gz")
trio <- as.data.frame(fread("results/trio10.txt",header=F))
sample <- fread("results/chr22_region.psam")


id <- c(trio[,1],trio[,2])
id <- as.data.frame(c(id,trio[,3]))
id <- merge(id,sample,by.x = 1,by.y=2)
names(id) <- c("IID","FID","PAT","MAT","SEX")
newid <- id
id$newid <- paste(id$FID,id$IID,sep =":")


for (i in 1:nrow(trio)){
  child_id <- id[id$IID==trio[i,1],"newid"]
  mor_id <- id[id$IID==trio[i,2],"newid"]
  far_id <- id[id$IID==trio[i,3],"newid"]
  
  
  # Extract genotypes
  df <- as.data.frame(geno$ID)
  df <- cbind(df,geno[[child_id]])
  df <- cbind(df,geno[[mor_id]])
  df <- cbind(df, geno[[far_id]])
  names(df) <- c("ID","child","mor","far")
  
  df <- df %>%
    filter(child %in% c("0|1","1|0")) %>%
    filter((mor %in% c("0|1","1|0","0|0","1|1"))) %>%       # remove .|.
    filter((far %in% c("0|1","1|0","0|0","1|1"))) %>%
    filter(!(mor=="1|1" & far=="1|1")) %>%
    filter(!(mor=="0|0" & far=="0|0")) %>%
    filter(!(mor=="0|1" & far=="0|1")) %>%
    filter(!(mor=="0|1" & far=="1|0")) %>%
    filter(!(mor=="1|0" & far=="0|1")) %>%
    filter(!(mor=="1|0" & far=="1|0")) 
  
  
  ## define new variable L as the left side of |, it should be consistent for either "mother" or "father"
  out <- df %>%
    mutate(L=case_when(mor=="0|1" & far=="0|0" & child=="0|1" ~ "f",       #means 0 for child is inherited from father
                       mor=="0|1" & far=="0|0" & child=="1|0" ~ "m",       #means 1 for child is inherited from mother
                       mor=="0|1" & far=="1|1" & child=="0|1" ~ "m",
                       mor=="0|1" & far=="1|1" & child=="1|0" ~ "f",
                       mor=="1|0" & far=="0|0" & child=="0|1" ~ "f",
                       mor=="1|0" & far=="0|0" & child=="1|0" ~ "m",
                       mor=="1|0" & far=="1|1" & child=="0|1" ~ "m",
                       mor=="1|0" & far=="1|1" & child=="1|0" ~ "f",
                       mor=="1|1" & far=="0|0" & child=="0|1" ~ "f",
                       mor=="1|1" & far=="0|0" & child=="1|0" ~ "m",
                       mor=="1|1" & far=="0|1" & child=="0|1" ~ "f",
                       mor=="1|1" & far=="0|1" & child=="1|0" ~ "m",
                       mor=="1|1" & far=="1|0" & child=="0|1" ~ "f",
                       mor=="1|1" & far=="1|0" & child=="1|0" ~ "m",
                       mor=="0|0" & far=="0|1" & child=="0|1" ~ "m",
                       mor=="0|0" & far=="0|1" & child=="1|0" ~ "f",
                       mor=="0|0" & far=="1|0" & child=="0|1" ~ "m",
                       mor=="0|0" & far=="1|0" & child=="1|0" ~ "f",
                       mor=="0|0" & far=="1|1" & child=="0|1" ~ "m",
                       mor=="0|0" & far=="1|1" & child=="1|0" ~ "f",
                       TRUE ~ NA 
    )
    )
  
  print(trio[i,])
  print(table(out$L))
}

