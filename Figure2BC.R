library(pheatmap)
library(reshape2)

data <- read.table('input.txt',header = T,check.names = F,sep = '\t',quote = '')
data <- data[,-5]
subdata <- dcast(data,Pathway~Compare+Regulation,value.var = 'P_value')
colnames(subdata) <- gsub(' ','',colnames(subdata))
write.table(subdata,'KEGG_test.fpkm',sep = '\t',quote = F,row.names = F,na = '1')

data = read.table('KEGG_all.fpkm', header=T, comment.char='', sep="\t", row.names=1, quote = "")

sample_annot = read.table('TMP_c', header=T, comment.char='', sep="\t", row.names=1, quote = "")


# 聚类热图和legend顺序一致
sample_annot[,"Sample"] <- factor(sample_annot[,"Sample"],levels=unique(sample_annot[,"Sample"]))
# legend先展示Up后展示Down
if(setequal(sample_annot[,"Regulation"],c("Up","Down")))
  sample_annot[,"Regulation"] <- factor(sample_annot[,"Regulation"],levels=c("Up","Down"))

data = as.matrix(data)
data = -log10(data)
title='KEGG Pathway Enrichment'
file1=paste(title,'png',sep='.')
file2=paste(title,'pdf',sep='.')

# 图height(如果结果过少,自定义图片height配合margin可以使legend显示完全)
if(dim(data)[1] < 20){
  height <- 8
}else{
  height <- NA
}
	
# 单元格宽度	
cellw=40;
if(ncol(data)<4){
	cellw=50
}

# 是否对行进行聚类
is_cluster_rows <- ifelse(nrow(data) > 1,T,F)

pheatmap(data,scale='row',cluster_rows=is_cluster_rows,cluster_col=F,annotation_col=sample_annot,
         annotation_names_col=F,file=file1,cellheight=20,cellwidth=cellw,treeheight_row=0,main=title,
         show_colnames=F,height=height,margin=0.1)
pheatmap(data,scale='row',cluster_rows=is_cluster_rows,cluster_col=F,annotation_col=sample_annot,
         annotation_names_col=F,file=file2,cellheight=20,cellwidth=cellw,treeheight_row=0,main=title,
         show_colnames=F,height=height,margin=0.1)
