library(gginteractive)
library(gapminder)
library(magrittr)

p1 <- (ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)) +
  geom_point()  + scale_x_log10()) %>% mesh_alpha(geom = "point", variable = "year", on = radio)

class(p1)

p1
p1 %>% unmesh()



p1 <- (ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)) +
         geom_point()  + scale_x_log10()) %>%
  mesh_alpha(geom = "point", variable = "continent", on = radio)

class(p1)

p1
p1 %>% unmesh()


(ggplot(mtcars, aes(x = wt, y = mpg, col = as.factor(cyl))) + geom_point() + stat_smooth(se = FALSE, method = "lm") + stat_smooth(se = FALSE)) %>% mesh_blank()

(ggplot(mtcars, aes(x = wt, y = mpg, color = cyl2)) + geom_point()) %>%
  mesh_alpha(geom = "point", variable = "cyl2", on = radio)
knit_print(p2)

mtcars$cyl2 <- paste(mtcars$cyl)
(ggplot(mtcars, aes(x = wt, y = mpg, color = cyl2)) + geom_bar(stat = "identity")) %>%
  mesh_alpha(geom = "bar", variable = "cyl2", on = radio)

p3 <- ggplot(mtcars, aes(x = wt, y = mpg, color = cyl2)) + geom_line()



p4 <- ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  stat_smooth(se = FALSE) + stat_smooth(method = "lm", se = FALSE) + stat_smooth(span = .5, se = FALSE)

p4 %>% mesh_geom(geom = "smooth", attr = "opacity",
          control = radio(c(loess = 1, lm = 2, "loess span .5" = 3, none = 0)))

