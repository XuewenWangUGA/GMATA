#to run: 
# Rscript ssrfig.r  "ssrtable1.txt" title xlabdirection1_2 ylabcontent percent1|o xlabcontent

Args <- commandArgs(TRUE);     
f <- c(Args[1]); 
titlenam <- c(Args[2]); 
xlabdir <- c(Args[3]); 
ylabcontent <- c(Args[4]); 
addtext <- c(Args[5]); 
xlabcontent <- c(Args[6]);# label of xlabcontent
figtag <- c(Args[7]);


shat<- read.table(f,sep="\t",header=T)
attach(shat)
dfinput<-as.data.frame(shat)
x<-dfinput[,1] # 1st collumn
y<-dfinput[,2] # 2nd collumn
z<- FALSE
if(addtext == 1){
	z<-dfinput[,3]
	z<- round(z, digit=1)
	z<- paste(z,"%",sep="")
	}
outfile <- paste(c(figtag,".jpg"), collapse="")
totalcolors=20
n<-length(y)
if(n<20){totalcolors<- n}
mycolors=rainbow(totalcolors)
jpeg(filename = outfile, width = 480, height = 480,res=300,pointsize = 4,quality = 90) # output image in jpeg format, pointsize for text
par(mar=c(7.1,4.1,4.1,2.1)) #cex=1
mybar=barplot(y, ylab=ylabcontent,xlab=xlabcontent,main=titlenam,xpd=FALSE,col=mycolors,border=NA)
axis(side=1,at=mybar,tick=TRUE,labels=x, las=xlabdir,cex.axis = 1)
axis(side=3,at=mybar,pos=0, tick=FALSE,labels=z, las=2,cex.axis = 1)
box()
graphics.off()


