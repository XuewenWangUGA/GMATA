#to run: 
# Rscript ssrfigxy.r  "ssrtable1.txt" title xlabdirection1_2 ylabcontent
Args <- commandArgs(TRUE);      # retrieve args
f <- c(Args[1]); # g
titlenam <- c(Args[2]); #tile name of an fig
xlabdir <- c(Args[3]); #direction of x axis label, value 1 or 2
ylabcontent <- c(Args[4]); #label of y axis, "total Counts"
xlabcontent<- c(Args[5]);
figtag<- c(Args[6]);
shat<- read.table(f,sep="\t",header=T)
attach(shat)
dfinput<-as.data.frame(shat)
x<-dfinput[,2] # 2nd collumn
y<-dfinput[,3] # 3rd collumn
z<-dfinput[,1]
outfile <- paste(c(figtag,".jpg"), collapse="")
jpeg(filename = outfile,width = 480, height = 480, res=300,pointsize = 4,quality = 90) # output image in jpeg format
par(mar=c(4.1,4.1,2.1,2.1))
mybar=plot(x,y, pch=16,xlab=xlabcontent,ylab=ylabcontent,main=titlenam,xpd=FALSE, col="red") #plot xy
abline(lm(y ~ x), col="green")
text(x,(y-1000),z,pos=1,col = "gray60")
graphics.off()


