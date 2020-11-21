Tidy raw data
================

# zipcode

There is some zipcode that are not in Allegheny County, such as 16229,
46845 and so on. We only select zipcode of cities that belong to
Allegheny County

``` r
tidy_zip_data = tidy_data %>% 
  filter(owner_zip < 16000)
```
