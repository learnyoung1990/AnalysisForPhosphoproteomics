rm(list = ls())
library(gplots)
library(RColorBrewer)

#####diff protein/site sample heatmap
LP.all <- read.table("LPST_Protein_information_ratio_Pvalue.txt",header = T,check.names = F,sep = "\t",quote = "",stringsAsFactors = F)
rownames(LP.all) <- paste(LP.all$`Protein accession`,LP.all$Position,sep="-")
group <- read.table("C9253.repeat_list1",sep="\t",quote = "",stringsAsFactors = F)
group$spl <- strsplit(group$V1,split="_")
group$number <- apply(group,1,function(x){as.numeric(as.roman(unlist(x$spl)[length(x$spl)]))})
group$sample <- paste(group$V2,group$number,sep="_")
group$V2 <- factor(group$V2,levels=c("HC","SLE_S","SLE_A","RA"))
group <- group[order(group$V2,group$number),]

LP <- LP.all[LP.all$`SLE_S/HC P value`<0.05 | LP.all$`SLE_A/HC P value`<0.05,]
LP <- LP[,group$V1]
LP <- log2(LP)

pdf("LP_diff_heatmap_sample_cluster.pdf",height = 22,width = 15)
heatmap.2(as.matrix(LP),reorderfun = function(d, w) reorder(d, -w),Rowv = T,Colv = T,na.color = "white",dendrogram = "both",
          breaks = seq(-2,2,length.out = 101),col = colorRampPalette(rev(brewer.pal(5,"RdBu")))(100),
          key = T,symkey = T,density.info = "none",trace = "none",labRow = "",srtCol = 90,lhei = c(1,10),ColSideColors=rep(c("red","blue","yellow","green"),table(group$V2)))
dev.off()
