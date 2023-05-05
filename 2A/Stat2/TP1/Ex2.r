# Generate 1000 random vectors of dimension 12 from a uniform distribution on [0,1].

L = matrix(runif(12000, 0, 1), nrow = 1000, ncol = 12)

# Graph a histogram of the data.

hist(L)

# Compute the mean of the 1000 vectors.

mean(L)

# Graph a histogram of the means.

hist(apply(L, 1, mean))