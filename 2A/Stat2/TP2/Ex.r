data=read.table("DataTP.txt", header=TRUE)

# Dataframe for the data related to Aix
dataAix=data[data$STATION=="Aix",]

# calculate the basic statistics of O3o
print(summary(dataAix$O3o))
print(summary(dataAix$O3p))

# draw histogram of O3o distribution in Aix and O3p distribution in Aix
split.screen(c(1, 2))
screen(1)
hist(dataAix$O3o, col="red", main="O3o in Aix", xlab="O3o")
screen(2)
hist(dataAix$O3p, col="blue", main="O3p in Aix", xlab="O3p")
close.screen(all=TRUE)

# use var.test and t.test to compare the mean of O3o in Aix and O3p in Aix
print(var.test(dataAix$O3o, dataAix$O3p))
print(t.test(dataAix$O3o, dataAix$O3p, paired=TRUE))

# Esimate the correlation between O3o and O3p in Aix
print(cor(dataAix$O3o, dataAix$O3p))

# Make a regression model to predict O3o from O3p in Aix with a linear model : O3o = beta0 + beta1*O3p + e
model=lm(O3o~O3p, data=dataAix)

# Print the summary of the model
print(summary(model))

# Draw the scatter plot of O3o and O3p in Aix and the regression line
plot(dataAix$O3p, dataAix$O3o, col="blue", main="O3o vs O3p in Aix", xlab="O3p", ylab="O3o")
abline(model, col="red")
close.screen(all=TRUE)

# Draw the chronological 03o (black dot) and O3p (blue x) in Aix and the regression line (red line)
plot(dataAix$O3o, type="l", main="O3o vs O3p in Aix", xlab="Date", ylab="O3o")
points(dataAix$O3p, col="blue", pch=4)
points(predict(model), col="red", pch=4)
close.screen(all=TRUE)

# Quatitative Regression (on data)

# In the same screen, draw the histogram of every variable
split.screen(c(2, 3))
screen(1)
hist(data$O3o, col="red", main="O3o", xlab="O3o")
screen(2)
hist(data$O3p, col="red", main="O3p", xlab="O3p")
screen(3)
hist(data$TEMPE, col="red", main="TEMPE", xlab="TEMPE")
screen(4)
hist(data$RMH2O, col="red", main="RMH2O", xlab="RMH2O")
screen(5)
hist(data$NO2, col="red", main="NO2", xlab="NO2")
screen(6)
hist(data$FF, col="red", main="FF", xlab="FF")
close.screen(all=TRUE)

pairs(data[,c(-1, -7)])

regmult=lm(O3o~O3p+TEMPE+RMH2O+log(NO2)+FF,data)
print(summary(regmult))
print(model.matrix(regmult)[1:5,])

split.screen(c(2, 3))
screen(1)
plot(fitted(regmult),residuals(regmult))
abline(h=0)
screen(2)
hist(residuals(regmult))
screen(3)
qqnorm(residuals(regmult))
screen(4)
acf(residuals(regmult))
screen(5)
plot(fitted(regmult),data$O3o)