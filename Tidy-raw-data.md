Tidy raw data
================

license\_type
=============

In terms of the license type, we delete three types: “Dog Lifetime
Duplicate”, “Dog Out of County Transfer - Lifetime”, “Dog Inter County
Transfer - Lifetime”.

We mainly focus on the remaining four types of licenses with male and
female numbers combined together.

Since the Neutered Male and Spayed Female could be classified into one
situation, then we use “N/S” to denote the Neutered Male and Spayed
Female.

    tidy_data = 
     tidy_data %>% 
     filter(!(license_type %in% c("Dog Lifetime Duplicate", "Dog Out of County Transfer - Lifetime", "Dog Inter County Transfer - Lifetime"))) %>% 
      mutate(
        license_type = str_replace(license_type, "Male", ""),
        license_type = str_replace(license_type, "Female", ""),
        license_type = str_replace(license_type, "Neutered", "N/S"),
        license_type = str_replace(license_type, "Spayed", "N/S")
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

Validdate
=========

We remained the years of the data and convert the specific time to AM
and PM:

    validdate = tidy_data %>% 
      drop_na(valid_date)  

    validdate_df =  as.character(validdate$valid_date) 
    validdate_df =  tibble(validdate_df)

    tidy_validdata_df =
      validdate_df %>%
      separate(validdate_df, into = c("Date","Time"), sep = 11)

    tidy_year = 
      tidy_validdata_df %>%
      select(Date) %>%
      separate(Date, into = c("Year", "Month_Day"), sep = 4) %>%
      select(Year)

    time_PM = 
      tidy_validdata_df %>%
      separate(Time, into = c("Time","min_sec"), sep = 2) %>%
      select(Time) %>%
      filter(Time>12) %>%  
      filter(Time != "00")

    time_AM = 
      tidy_validdata_df %>%
      separate(Time, into = c("Time","min_sec"), sep = 2) %>%
      select(Time) %>%
      filter(Time<12) %>%  
      filter(Time != "00")

    time_NA = 
      tidy_validdata_df %>%
      separate(Time, into = c("Time","min_sec"), sep = 2) %>%
      select(Time) %>%
      filter(Time=="00")
