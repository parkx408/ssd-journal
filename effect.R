#!/usr/bin/Rscript --verbose
args<-commandArgs(TRUE);

if (length(args)!=2) {
	print("No argument supplied. inp and outp must be defined.");
	q(save=FALSE, status=1, runlast=FALSE);
} 

inp<-args[[1]];
outp<-args[[2]];

input<-read.table(inp, header=T);
result<-read.table(outp, header=T)[-2];

mean<-aggregate(result, by=list(result$run), mean)[-c(1, 2)];
#names(mean)<-paste("mean.", names(mean), sep="");
exp<-cbind(input, mean);
var<-aggregate(result, by=list(result$run), var)[-c(1, 2)];
names(var)<-paste("var.", names(var), sep="");
exp<-cbind(exp, var);

nruns<-nrow(exp);
library("FrF2");
pb<-pb(nruns, randomize=FALSE);
pb<-matrix(as.integer(as.matrix(pb)), nruns, nruns-1);


factor.names<-c(names(input), rep(NA,nruns-1-ncol(input)));
eff.f<-function(x,y)(sum(x*y)/(nruns/2));
effect<-apply(mean, 2, function(x)(apply(pb, 2, eff.f, x)));
rownames(effect)<-factor.names;
effect<-effect[!is.na(rownames(effect)),];
effect.norm<-apply(abs(effect), 2, function(x)(x/sum(x)));
print (effect.norm);

fstat.f<-function(x,y)(max(var(y[x==1]), var(y[x==-1]))/min(var(y[x==1]),var(y[x==-1])));
fstat<-apply(var, 2, function(x)(apply(pb, 2, fstat.f, x)));
rownames(fstat)<-factor.names;
fstat<-fstat[!is.na(rownames(fstat)),];

png(paste(outp,".png", sep=""), width=1000);
par(xpd=T, mar=par()$mar+c(0,0,0,10));
#matplot(t(effect.norm), type="b", lty=1:nrow(effect), pch=1:nrow(effect));
#barplot(matrix(c(sort(effect.norm[, "mean.tps"]), sort(effect.norm[, "mean.create_tps"])),9, 2), col=heat.colors(9), beside=TRUE);
barplot(effect.norm, col=rainbow(ncol(input)), beside=TRUE, ylab="normalized effect", xlab="dependent variables", cex.axis=1.3, cex.names=1.3, cex.lab=1.3);
legend(110, max(effect.norm), legend=rownames(effect.norm), fill=rainbow(ncol(input)), cex=1.3);
dev.off();

effect.sort<-apply(effect.norm, 2, sort, decreasing=TRUE);
cum.sort<-apply(effect.sort, 2, cumsum);
need.effect<-apply(cum.sort, 2, function(x)(which.max(x>0.5)));
rank<-apply(-effect.norm, 2, rank);
param50<-apply (effect.norm, 2, function(x)(which(rank(-x)<=(which.max(cumsum(sort(x, decreasing=TRUE))>0.5)))));
effect50<-apply(effect.norm, 2, function(x)(sum(x[which(rank(-x)<=(which.max(cumsum(sort(x, decreasing=TRUE))>0.5)))])));
print (param50);
print (effect50);

