#to run: 
# Rscript ssrpie.r  "ssrStatistcafile.sat2" title sufx pct_T|F

Args <- commandArgs(TRUE);      # retrieve args
f <- c(Args[1]); 
titlenam <- c(Args[2]); 
sufx <-c(Args[3]) 
pct <- c(Args[4])
pietag <- c(Args[5]);

shat<- read.table(f,sep="\t",header=T)
attach(shat)
dfinput<-as.data.frame(shat)
x<-dfinput[,1] # 1st column, name
y<-dfinput[,2] # 2nd column
z<-NULL

x<- paste(x,sufx, sep="") #ad suffix content
if(pct=="T"){
	z<-dfinput[,3] # 3rd column, percent
	x <- paste(x,round(z,digit=1)) # ad percent value, spaced
	x <- paste(x,"%", sep="") #ad percent sign
}
outfile <- paste(c(pietag,".jpg"), collapse="")
totalcolors=20
n<-length(y)
if(n<20){totalcolors<- n}
mycolors=rainbow(totalcolors)
par(mar=c(2.1,2.1,2.1,2.1))
jpeg(filename = outfile, width = 480, height = 480,res=300,pointsize = 4,quality = 90) # output image in jpeg format
pie(y, col=mycolors,main=titlenam, labels=x,radius=1)
graphics.off()


