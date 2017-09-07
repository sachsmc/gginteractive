library(gginteractive)
library(gapminder)

p1 <- (ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)) +
  geom_point()  + scale_x_log10()) %>% mesh_alpha(geom = "point", variable = "year", on = radio)

class(p1)

p1
p1 %>% unmesh()



p1 <- (ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)) +
         geom_point()  + scale_x_log10()) %>% mesh_alpha(geom = "point", variable = "continent", on = radio)

class(p1)

p1
p1 %>% unmesh()
