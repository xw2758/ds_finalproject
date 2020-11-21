Tidy raw data
================

# license\_type

In terms of the license type, we delete three types: “Dog Lifetime
Duplicate”, “Dog Out of County Transfer - Lifetime”, “Dog Inter County
Transfer - Lifetime”. We mainly focus on the remaining four types of
licenses with male and female numbers combined together.

``` r
tidy_data = 
 tidy_data %>% 
 filter(!(license_type %in% c("Dog Lifetime Duplicate", "Dog Out of County Transfer - Lifetime", "Dog Inter County Transfer - Lifetime"))) %>% 
  mutate(
    license_type = str_replace(license_type, "Male", ""),
    license_type = str_replace(license_type, "Female", "")
  )
```

# zipcode

There is some zipcode that are not in Allegheny County, such as 16229,
46845 and so on. We only select zipcode of cities that belong to
Allegheny County

``` r
tidy_zip_data = tidy_data %>% 
  filter(owner_zip < 16000)
```
