library(ggplot2)
library(data.table)
data_in = fread('Kinase_NES_data.txt')

ggplot(data_in,aes(x=reorder(Kinase,NES),y=NES,fill=Type))+
    scale_fill_manual(values=colour)+
    geom_bar(stat="identity",width=0.6)+
    labs(x="Kinase",y="Kinase activity score")+
    # Positive的NES数值
    geom_text(aes(label=c(data_in[Type=="Positive",NES_label],rep("",data_in[Type=="Negative",.N]))),color='gray30',hjust=-0.2,size=4)+
    # Negative的NES数值
    geom_text(aes(label=c(rep("",data_in[Type=="Positive",.N]),data_in[Type=="Negative",NES_label])),color='gray30',hjust=1.2,size=4)+
    scale_y_continuous(expand = c(0,0),limits=coord_range)+
    geom_hline(yintercept =0)+
    coord_flip()+
    theme_classic()+
    theme(axis.text=element_text(size=15,color='grey30'),
          axis.title=element_text(size=18,color='black',face='bold'),
          plot.margin=unit(c(0.5,1,0.5,0.5),units='cm'),
          axis.line.y=element_blank(),
          axis.ticks.y=element_blank())

  # 规定图片尺寸并存储
  ggsave('Figure4C.pdf',height=(data_in[,.N]*0.25+2),width=8)
  ggsave('Figure4C.png',height=(data_in[,.N]*0.25+2),width=8)