library(gginteractive)
library(gapminder)

p1 <- (ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)) +
  geom_point()  + scale_x_log10()) %>% mesh_blank()

class(p1)

p1
p1 %>% unmesh()
