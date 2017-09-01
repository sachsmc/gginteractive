library(gginteractive)

p1 <- ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point()
class(p1) <- c("ggmesh", class(p1))
p1
