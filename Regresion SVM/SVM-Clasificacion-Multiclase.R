# SVM para clasificación multiclase

# Para este ejemplo, trabajaremos con el dataset clásico, Iris data.
library("e1071")
data(iris)
 attach(iris)
## classification mode
# default with factor response:
model <- svm(Species ~ ., data = iris)

# alternatively the traditional interface:
x <- subset(iris, select = -Species)
y <- Species
model <- svm(x, y)
print(model)