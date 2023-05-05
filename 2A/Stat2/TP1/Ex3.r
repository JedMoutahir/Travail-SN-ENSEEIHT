data(iris)

print(summary(iris))

# iris2 will only contain the versicolor species of iris
iris2 <- iris[iris$Species == "versicolor", ]

# sort iris2 by decreasing sepal length
iris2 <- iris2[order(iris2$Sepal.Length, decreasing = TRUE), ]

# print the first 10 rows of iris2
print(head(iris2, 10))