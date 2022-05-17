library(pheatmap)
data_in = read.table('pvalue_data_for_heatmap.txt',header=T,sep='\t')
anno_col = read.table('group.txt',header=T,sep='\t')
pheatmap(data_in,annotation_col=anno_col,angle_col=45,scale="row",cluster_rows=T,cluster_cols=F,treeheight_row=0,
        cellheight=15,cellwidth=cellw,height=height,margin=0.1,show_rownames=T,show_colnames=F,file="Figure4B.pdf")
pheatmap(data_in,annotation_col=anno_col,angle_col=45,scale="row",cluster_rows=T,cluster_cols=F,treeheight_row=0,
        cellheight=15,cellwidth=cellw,height=height,margin=0.1,show_rownames=T,show_colnames=F,file="Figure4B.png")
