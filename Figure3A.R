library(TCseq)
library(ggplot2)
library(ggpubr)
library(dplyr)
library(reshape2)
library(pheatmap)
library(RColorBrewer)

subdata = read.table('data.txt',header=T,sep='\t')
set.seed(123)
tca <- timeclust(as.matrix(subdata), algo = "cm", k = 5,standardize = TRUE)
tcadata=reshape2::melt(clustData(tca))
cluster1 <- as.data.frame(clustCluster(tca))
colnames(cluster1)="Cluster"
cluster1$Cluster=paste("Cluster",cluster1$Cluster,sep="")
tcadata=merge(tcadata,cluster1,by.x="Var1",by.y="row.names")
tcadata$ID=paste(tcadata$Var1,tcadata$Cluster,sep="-")
tcamemb=reshape2::melt(clustMembership(tca))
rownames(tcamemb)=paste(tcamemb$Var1,paste("Cluster",tcamemb$Var2,sep=""),sep="-")
tcamemb=subset(tcamemb,select="value")
colnames(tcamemb)="Membership"
tcadata=merge(tcadata,tcamemb,by.x="ID",by.y="row.names")
tcadata=merge(tcadata,as.data.frame(table(cluster1)),by.x="Cluster",by.y="cluster1")
tcadata$Cluster=paste(tcadata$Cluster,tcadata$Freq,sep="\nn=")

mylinecol=colorRampPalette(rev(brewer.pal(11,color.name)))(255)
p1=ggplot(tcadata,aes(x=Var2,y=value,color=Membership,group=reorder(Var1,Membership)))+geom_line()+
  facet_grid(Cluster~.,switch = "y")+scale_color_gradientn(colors=mylinecol)+theme_logo()+
  scale_x_discrete(expand = c(0.05,0.05))+ylab("Expression")+scale_y_continuous(expand = c(0,0))+
  theme(legend.position = "top",strip.text.y = element_text(face = 'bold',angle = 180),
        axis.text.x=element_text(angle = angle,hjust=hjust,vjust = 1),
        axis.title.x=element_blank(),axis.text.y=element_blank(),axis.title.y=element_blank(),
        panel.border = element_rect(color="black",fill = NA,size=0.5),
        legend.key.size = unit(0.8,units = "cm"))+
  guides(color=guide_colorbar(title.position = "top",title.hjust = 0.5))

myheatcol=colorRampPalette(rev(brewer.pal(5,color.name)))(255)
p2=ggplot(tcadata,aes(x=Var2,fill=value,y=reorder(Var1,Membership)))+geom_tile()+
  facet_grid(Cluster~.,scales = 'free',switch = "y")+scale_fill_gradientn(colors=myheatcol)+theme_logo()+
  scale_x_discrete(expand = c(0,0))+
  theme(legend.position = "top",
        panel.border = element_rect(color="black",fill = NA,size=0.5),
        axis.text.y=element_blank(),axis.title =element_blank(),
        strip.text = element_blank(),legend.key.size = unit(0.8,units = "cm"),
        axis.text.x=element_text(angle = angle,hjust=hjust,vjust = 1))+
  guides(fill=guide_colorbar(title.position = "top",title="Expression",title.hjust = 0.5))
  
