Tidy raw data
================

license\_type
=============

In terms of the license type, we delete three types: “Dog Lifetime
Duplicate”, “Dog Out of County Transfer - Lifetime”, “Dog Inter County
Transfer - Lifetime”. We mainly focus on the remaining four types of
licenses with male and female numbers combined together.

    tidy_data = 
     tidy_data %>% 
     filter(!(license_type %in% c("Dog Lifetime Duplicate", "Dog Out of County Transfer - Lifetime", "Dog Inter County Transfer - Lifetime"))) %>% 
      mutate(
        license_type = str_replace(license_type, "Male", ""),
        license_type = str_replace(license_type, "Female", "")
      )

breed
=====

We separate the breed into two types, mixed and pure. All the breeds
whose name contains “mix” are belong to mixed. Others are pure.

    tidy_data = tidy_data %>% 
      mutate(
        breed_type = ifelse(str_detect(breed, "MIX"), "MIXED", "PURE")
      )

Color
=====

Due to the large quantity of the dataset, the number of “.” and “OTHER”
is comparatively less so we decide to delete them. Values of “BLACK WITH
WHITE” sounds equal to the value of “WHITE/BLACK”, hence, we recode them
to be the same. Since there are various color types, we are able to look
for the TOP 5\~10 colors as well as proportion of the number of colors.
In this case, we suggest that “MULTI”, “TRI-COLOR” and other specific 3
colors to be having 3+ colors then we create a new variable “ncolor” to
reserve these information.

    tidy_data = tidy_data %>% 
      drop_na(color) %>% 
      filter(color != "." & color != "OTHER") %>% 
      mutate(color = recode(color, `BLACK WITH WHITE` = "WHITE/BLACK", 
                            `MULTI` = "MULTI//", `TRI-COLOR` = "TRI-COLOR//"),
        ncolor = str_count(color, pattern = "/") + 1,
        ncolor = as.character(ncolor),
        ncolor = recode(ncolor, `3` = "3+"))

zipcode
=======

There is some zipcode that are not in Allegheny County, such as 16229,
46845 and so on. We only select zipcode of cities that belong to
Allegheny County

    tidy_data = tidy_data %>% 
      filter(owner_zip < 16000)
