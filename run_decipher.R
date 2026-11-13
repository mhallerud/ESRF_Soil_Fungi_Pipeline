# assign taxonomy with DECIPHER
library(DECIPHER)


print("Reading in sequences........")
# read in dada2 seqtab
#library(dada2)
#seqtab <- load(ESF_ITS1_P1to24_seqtab.RDS) #ASVs from dada2
#dna <- dada2::DNAStringSet(getSequences(seqtab)) # Create a DNAStringSet from the ASVs

# read in OTUs
otus <- DECIPHER::readDNAStringSet("ESRF_IT1_P1toP24_OTUs.fasta")

# load training dataset (this will load a 'trainingSet' object)
load("UNITE_v2025.RData")

# run classification
ids <- IdTaxa(dna, trainingSet, strand="top", processors=NULL, verbose=FALSE) # use all processors
ids <- IdTaxa(seqs,
	      trainingSet,
	      strand="both", # or "top" if same as trainingSet
	      threshold=60, # 60 (cautious) or 50 (sensible)
              processors=NULL) # use all available processors
ranks <- c("kingdown","domain", "phylum", "class", "order", "family", "genus", "species") # ranks of interest

# Convert the output object of class "Taxa" to a matrix analogous to the output from assignTaxonomy
taxid <- t(sapply(ids, function(x){
        m <- match(ranks, x$rank)
        taxa <- x$taxon[m]
        taxa[startsWith(taxa, "unclassified_")] <- NA
        taxa
}))

# clean up and export
colnames(taxid) <- ranks; 
#rownames(taxid) <- getSequences(seqtab.nochim)
saveRDS(taxid, "ESF_ITS1_P1toP24_taxonomy_DECIPHER.RDS")
write.csv(taxid, "ESF_ITS1_P1oP24_taxonomy_DECIPHER.csv")
