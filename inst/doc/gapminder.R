## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  out.width = "100%",
  dpi = 300
)

## so jittered figs don't always appear to be changed
set.seed(1)

## ----eval = FALSE-------------------------------------------------------------
#  install.packages("gapminder")

## ----test-drive, message = FALSE, warning = FALSE, out.width = "60%"----------
library(gapminder)
library(dplyr)
library(ggplot2)

aggregate(lifeExp ~ continent, gapminder, median)

gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarise(lifeExp = median(lifeExp))

ggplot(gapminder, aes(x = continent, y = lifeExp)) +
  geom_boxplot(outlier.colour = "hotpink") +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1 / 4)

## -----------------------------------------------------------------------------
head(country_colors, 4)
head(continent_colors)

## ----echo = FALSE-------------------------------------------------------------
knitr::include_graphics("../man/figures/gapminder-color-scheme-ggplot2.png")

## ----scale-color-manual, eval = FALSE-----------------------------------------
#  ... + scale_color_manual(values = country_colors) + ...

## ----demo-country-colors-ggplot2----------------------------------------------
library("ggplot2")

ggplot(
  subset(gapminder, continent != "Oceania"),
  aes(x = year, y = lifeExp, group = country, color = country)
) +
  geom_line(linewidth = 0.8, show.legend = FALSE) +
  facet_wrap(~continent) +
  scale_color_manual(values = country_colors) +
  theme_bw() +
  theme(
    strip.text = element_text(size = rel(0.8)),
    axis.text.x = element_text(angle = 45, hjust=1)
  )

## ----demo-country-colors-base-------------------------------------------------
# for convenience, integrate the country colors into the data.frame
gap_with_colors <-data.frame(
  gapminder,
  cc = I(country_colors[match(gapminder$country, names(country_colors))])
)

# bubble plot, focus just on Africa and Europe in 2007
keepers <- with(
  gap_with_colors,
  continent %in% c("Africa", "Europe") & year == 2007
)
plot(lifeExp ~ gdpPercap, gap_with_colors,
  subset = keepers, log = "x", pch = 21,
  cex = sqrt(gap_with_colors$pop[keepers] / pi) / 1500,
  bg = gap_with_colors$cc[keepers]
)

## ----message = FALSE----------------------------------------------------------
library(dplyr)

gapminder %>%
  filter(year == 2007, country %in% c("Kenya", "Peru", "Syria")) %>%
  select(country, continent) %>%
  left_join(country_codes)

## -----------------------------------------------------------------------------
gap_tsv <- system.file("extdata", "gapminder.tsv", package = "gapminder")
gap_tsv <- read.delim(gap_tsv)
str(gap_tsv)
gap_tsv %>% # Bhutan did not make the cut because data for only 8 years :(
  filter(country == "Bhutan")

gap_bigger_tsv <-
  system.file("extdata", "gapminder-unfiltered.tsv", package = "gapminder")
gap_bigger_tsv <- read.delim(gap_bigger_tsv)
str(gap_bigger_tsv)
gap_bigger_tsv %>% # Bhutan IS here though! :)
  filter(country == "Bhutan")

read.delim(
  system.file("extdata", "continent-colors.tsv", package = "gapminder")
)

head(
  read.delim(
    system.file("extdata", "country-colors.tsv", package = "gapminder")
  )
)

## ----warning = FALSE----------------------------------------------------------
citation("gapminder")

