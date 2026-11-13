
library(dada2)

# merge seqtabs across runs
s1 <- readRDS("../../LIB_ITSP1/dada2/ITSP1_cutadapt_seqtab.RDS")
s2 <- readRDS("../../LIB_ITSP2/dada2/ITSP2_cutadapt_seqtab.RDS")
s3 <- readRDS("../../LIB_ITSP3/dada2/ITSP3_cutadapt_seqtab.RDS")
s4 <- readRDS("../../LIB_ITSP4/dada2/ITSP4_cutadapt_seqtab.RDS")
s5 <- readRDS("../../LIB_ITSP5/dada2/ITSP5_cutadapt_seqtab.RDS")
s6 <- readRDS("../../LIB_ITSP6/dada2/ITSP6_cutadapt_seqtab.RDS")
s7 <- readRDS("../../LIB_ITSP7/dada2/ITSP7_cutadapt_seqtab.RDS")
s8 <- readRDS("../../LIB_ITSP8/dada2/ITS1P8_cutadapt_seqtab.RDS")
s9 <- readRDS("../../LIB_ITSP9/dada2/ITS1P9_cutadapt_seqtab.RDS")
s10 <- readRDS("../../LIB_ITSP10/dada2/ITSP10_cutadapt_seqtab.RDS")
s11 <- readRDS("../../LIB_ITSP11/dada2/ITSP11_cutadapt_seqtab.RDS")
s12 <- readRDS("../../LIB_ITSP12/dada2/ITSP12_cutadapt_seqtab.RDS")
s13 <- readRDS("../../LIB_ITSP13/dada2/ITSP13_cutadapt_seqtab.RDS")
s14 <- readRDS("../../LIB_ITSP14/dada2/ITSP14_cutadapt_seqtab.RDS")
s15 <- readRDS("../../LIB_ITSP15/dada2/ITSP15_cutadapt_seqtab.RDS")
s16 <- readRDS("../../LIB_ITSP16/dada2/ITSP16_cutadapt_seqtab.RDS")
s17 <- readRDS("../../LIB_ITSP17/dada2/ITSP17_cutadapt_seqtab.RDS")
s18 <- readRDS("../../LIB_ITSP18/dada2/ITSP18_cutadapt_seqtab.RDS")
s19 <- readRDS("../../LIB_ITSP19/dada2/ITSP19_cutadapt_seqtab.RDS")
s20 <- readRDS("../../LIB_ITSP20/dada2/ITSP20_cutadapt_seqtab.RDS")
s21 <- readRDS("../../LIB_ITSP21/dada2/ITSP21_cutadapt_seqtab.RDS")
s22 <- readRDS("../../LIB_ITSP22/dada2/ITSP22_cutadapt_seqtab.RDS")
s23 <- readRDS("../../LIB_ITSP23/dada2/ITSP23_cutadapt_seqtab.RDS")
s24 <- readRDS("../../LIB_ITSP24/dada2/ITSP24_cutadapt_seqtab.RDS")
st.all <- mergeSequenceTables(s1,s2,s3,s4,s5,s6,s7, 
s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,
s22,s23,s24)


# Remove chimeras
seqtab <- removeBimeraDenovo(st.all, method="consensus", multithread=TRUE, verbose=TRUE)
saveRDS(seqtab, "ESF_ITS1_P1to24_seqtab.RDS") 

# Assign taxonomy with NBC
tax <- assignTaxonomy(seqtab, "../../UNITE/UNITE_public_19.02.2025.fasta", multithread=TRUE)
saveRDS(tax, "ESF_ITS1_P1toP24_taxonomy_UNITEspp.RDS")
write.csv(tax, "ESF_ITS1_P1toP24_taxonomy_UNITEspp.RDS")

tax <- assignTaxonomy(seqtab, "../../UNITE/sh_general_release_dynamic_19.02.2025_dev.fasta", multithread=TRUE, strand="both")
saveRDS(tax, "ESF_ITS1_P1toP24_taxonomy_UNITEfull.RDS")
write.csv(tax, "ESF_ITS1_P1toP24_taxonomy_UNITEfull.csv")



