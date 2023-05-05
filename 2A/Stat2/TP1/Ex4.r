# load the data in ozone.txt into a data frame called data
data <- read.table("TP1/ozone.txt", header = TRUE)

print(summary(data))

# print tht max03 associated to values of T15 greater than 30
print((data[data$T15 > 30, ]$maxO3))

# create data2 which contains only the rows of data where pluie = "Sec"
data2 <- data[data$pluie == "Sec", ]

# sort data2 by decreasing T12
data2 <- data2[order(data2$T12, decreasing = TRUE), ]

# Graph in the same window the histograms and boxplot of Ne9 using data.frame data
split.screen(c(1, 2))
screen(1) # histogram
hist(data$Ne9)
screen(2) # boxplot
boxplot(data$Ne9)
close.screen(all = TRUE)

# print quantiles of maxO3
print(quantile(data$maxO3))

