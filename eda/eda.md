Wine Quality EDA
================

#### Load libraries

``` r
library(tidyverse)
```

    ## -- Attaching packages ---------------------------------------------------------------------------------------------------------------------------------------------------- tidyverse 1.2.1 --

    ## v ggplot2 3.1.0     v purrr   0.2.5
    ## v tibble  1.4.2     v dplyr   0.7.7
    ## v tidyr   0.8.2     v stringr 1.3.1
    ## v readr   1.1.1     v forcats 0.3.0

    ## -- Conflicts ------------------------------------------------------------------------------------------------------------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

#### Import data

``` r
tmp <- read_csv('data/winequality-red.csv')
```

    ## Parsed with column specification:
    ## cols(
    ##   `fixed acidity` = col_double(),
    ##   `volatile acidity` = col_double(),
    ##   `citric acid` = col_double(),
    ##   `residual sugar` = col_double(),
    ##   chlorides = col_double(),
    ##   `free sulfur dioxide` = col_double(),
    ##   `total sulfur dioxide` = col_double(),
    ##   density = col_double(),
    ##   pH = col_double(),
    ##   sulphates = col_double(),
    ##   alcohol = col_double(),
    ##   quality = col_integer()
    ## )

``` r
head(tmp)
```

    ## # A tibble: 6 x 12
    ##   `fixed acidity` `volatile acidi~ `citric acid` `residual sugar` chlorides
    ##             <dbl>            <dbl>         <dbl>            <dbl>     <dbl>
    ## 1             7.4             0.7           0                 1.9     0.076
    ## 2             7.8             0.88          0                 2.6     0.098
    ## 3             7.8             0.76          0.04              2.3     0.092
    ## 4            11.2             0.28          0.56              1.9     0.075
    ## 5             7.4             0.7           0                 1.9     0.076
    ## 6             7.4             0.66          0                 1.8     0.075
    ## # ... with 7 more variables: `free sulfur dioxide` <dbl>, `total sulfur
    ## #   dioxide` <dbl>, density <dbl>, pH <dbl>, sulphates <dbl>,
    ## #   alcohol <dbl>, quality <int>

#### EDA with all classes

Using `alcohol` as our feature of interest.

``` r
# Check for unique values
unique(tmp$quality)
```

    ## [1] 5 6 7 4 8 3

``` r
# Re-encode target for simplicity
test <- tmp %>%
  mutate(quality_ = case_when(
    quality == 3 ~ 1,
    quality == 4 ~ 2,
    quality == 5 ~ 3,
    quality == 6 ~ 4,
    quality == 7 ~ 5,
    quality == 8 ~ 6,
    TRUE ~ NA_real_
  ))

# Check amount of data for each value
test %>%
  group_by(quality_) %>%
  summarise(
    n = n()
  )
```

    ## # A tibble: 6 x 2
    ##   quality_     n
    ##      <dbl> <int>
    ## 1        1    10
    ## 2        2    53
    ## 3        3   681
    ## 4        4   638
    ## 5        5   199
    ## 6        6    18

``` r
# Create violin plot
ggplot(test, aes(x = factor(x = quality_), alcohol)) +
  geom_violin(fill = "#f8766d", alpha = 0.5) +
  geom_jitter(width = 0.4, alpha = 0.5, size = 0.75) +
  labs(x = "Quality (re-encoded)",
       y = "Alcohol (%)") +
  theme_bw()
```

![](eda_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

As you can see from our visualization, we have some issues with the
amount of data we have in certain categories. I would suggest that we
consider re-encoding the data so that we only have two categories…
something like “Poor” and “Good” — which will be my placeholders for
now\!

#### EDA with two classes

Using `alcohol` as our feature of interest.

``` r
# Re-encode for two classes
test <- tmp %>%
  mutate(quality_ = case_when(
    quality == 3 ~ 1,
    quality == 4 ~ 2,
    quality == 5 ~ 3,
    quality == 6 ~ 4,
    quality == 7 ~ 5,
    quality == 8 ~ 6,
    TRUE ~ NA_real_
  )) %>%
  mutate(quality_ = if_else(quality_ <= 3, "Poor", "Good"))

# Check amount of data for each class
test %>%
  group_by(quality_) %>%
  summarise(
    n = n()
  )
```

    ## # A tibble: 2 x 2
    ##   quality_     n
    ##   <chr>    <int>
    ## 1 Good       855
    ## 2 Poor       744

``` r
# Create a violin plot
ggplot(test, aes(x = factor(x = quality_), alcohol)) +
  geom_violin(fill = "#f8766d", alpha = 0.5) +
  geom_jitter(width = 0.4, alpha = 0.5, size = 1) +
  labs(x = "Quality (re-encoded)",
       y = "Alcohol (%)") +
  theme_bw()
```

![](eda_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

The distribution of the data is much more balanced when we take the
above approach. Now, let’s expand our exploration to include all
features.

``` r
### Explore all variables

test2 <- test %>%
  select(-quality) %>%
  gather(key = "characteristic", value = "value", -quality_)

ggplot(test2, aes(x = factor(x = quality_), value)) +
  geom_violin(fill = "#f8766d", alpha = 0.5) +
  scale_x_discrete(limits = c("Poor", "Good")) +
  facet_wrap(~characteristic, scales = "free") +
  labs(x = "Quality (re-encoded)",
       y = "") +
  theme_bw()
```

![](eda_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

> To be continued…
