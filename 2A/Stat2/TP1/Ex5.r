# load CLIM.txt in data
data <- read.table("TP1/CLIM.txt", header = TRUE, sep = ";")

# add two variables of type numeric, AN and MOIS, to data using the variable DATE
data$AN <- as.numeric(substr(data$DATE, 1, 4))
data$MOIS <- as.numeric(substr(data$DATE, 5, 6))

# extract the data from the two stations "toul" and "agen" in two data frames toul (POSTE begins wit 31) and agen (POSTE begins with 47)
toul <- data[data$POSTE >= 31000000 & data$POSTE < 32000000, ]
agen <- subset(data, POSTE >= 47000000 & POSTE < 48000000)

# print the min vuale of TX for both stations and the associated date
print(toul[toul$TX == max(toul$TX), c("DATE", "TX")])
print(agen[agen$TX == max(agen$TX), c("DATE", "TX")])

# make TX numeric
toul$TX <- as.numeric(toul$TX)
agen$TX <- as.numeric(agen$TX)


# print first 10 rows of toul and agen
print(head(toul, 10))
print(head(agen, 10))

# Graph in the same window the histograms of TX for both stations add titles and legends use two different colors impose amplitude classes of 2 degrees between -9 and 41 degrees
split.screen(c(1, 2))
screen(1)
hist(toul$TX, breaks = seq(-9, 41, 2), col = "red", main = "Toul", xlab = "TX")
screen(2)
hist(agen$TX, breaks = seq(-9, 41, 2), col = "blue", main = "Agen", xlab = "TX")

# function that take a data frame and returns a matrix of dimension (n,13) : 
# - the first 12 columns are the monthly averages
# - the last column is the annual average
averages = function(df) {
    # create a matrix of dimension (n,13) filled with 0
    res <- matrix(0, nrow = 1, ncol = 13)
    # fill the first 12 columns with the monthly averages
    for (i in 1:12) {
        # get the rows of df where MOIS == i
        tmp <- df[df$MOIS == i, ]
        # calculate the average of TX for the rows where MOIS == i
        avr <- mean(tmp$TX)
        # fill the ith column of res with the average
        res[, i] <- avr
    }
    # fill the last column with the annual average
    res[, 13] <- apply(res[, 1:12], 1, mean)
    # return the matrix
    return(res)
}

# apply the function to both stations and print the results
print(averages(toul))
print(averages(agen))