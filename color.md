Color analysis
================

    load("tidy_data.Rdata")

    n_color = 
      tidy_data %>%
      ggplot(aes(x = ncolor, fill = ncolor)) +
      geom_bar() + 
      labs(
      title = "Number of dog colors",
      x = "Number of color",
      y = "Count") + 
      theme(legend.position = 'none')

This barplot shows the distribution of number of dog color in Allegheny
County in PA – the pure color dog have the largest number and mixed of
more than 3 colors have the least.

    color_all = 
      tidy_data %>% 
      count(color) %>% 
      arrange(desc(n)) %>% 
      top_n(10) %>%
      ggplot(aes(x = reorder(color, n), y = n,  fill = n, alpha = 0.8)) +
      geom_bar(stat="identity") +
      coord_flip() +
      labs(
      title = "Top 10 famous dog colors",
      x = "Count",
      y = "Color") + 
      theme(legend.position = 'none')

    ## Selecting by n

    color_1 = 
      tidy_data %>% 
      filter(ncolor == "1") %>% 
      count(color) %>% 
      arrange(desc(n)) %>% 
      top_n(5) %>%
      ggplot(aes(x = reorder(color, n), y = n,  fill = n, alpha = 0.8)) +
      geom_bar(stat="identity") +
      coord_flip() +
      labs(
      title = "Top 5 famous colors for pure color dogs",
      x = "Count",
      y = "Color") + 
      theme(legend.position = 'none')

    ## Selecting by n

    color_2 = 
      tidy_data %>% 
      filter(ncolor == "2") %>% 
      count(color) %>% 
      arrange(desc(n)) %>% 
      top_n(5) %>%
      ggplot(aes(x = reorder(color, n), y = n,  fill = n, alpha = 0.8)) +
      geom_bar(stat="identity") +
      coord_flip() +
      labs(
      title = "Top 5 famous colors for two-color dogs",
      x = "Count",
      y = "Color") + 
      theme(legend.position = 'none')

    ## Selecting by n

    color_3 = 
      tidy_data %>% 
      filter(ncolor == "3+") %>% 
      mutate(color = recode(color, `MULTI//` = "MULTI", `TRI-COLOR//` = "TRI-COLOR")) %>% 
      count(color) %>% 
      arrange(desc(n)) %>% 
      top_n(5) %>%
      ggplot(aes(x = reorder(color, n), y = n, fill = n, alpha = 0.8)) +
      geom_bar(stat="identity") +
      coord_flip() +
      labs(
      title = "Top 5 famous colors for mixed color dogs",
      x = "Count",
      y = "Color") + 
      theme(legend.position = 'none')

    ## Selecting by n

    popular_color = (color_all + color_1) / (color_2 + color_3)

These plots show several famous color in Allegheny County, including
black, brown, white, etc., and the most popular color is black.

    breed_color = 
      tidy_data %>% 
      ggplot(aes(x=ncolor, group = breed_type)) + 
      geom_bar(aes(y = ..prop.., fill = factor(..x..)), stat="count") + 
      scale_y_continuous(labels=scales::percent) +
      geom_text(aes( label = scales::percent(..prop..),
                       y= ..prop.. ), stat= "count", vjust = -.5) +
      facet_grid(. ~ breed_type) + 
      theme(legend.position = 'none') +
      labs(
      title = "Breed type proportion according to ncolor",
      x = "ncolor",
      y = "Proportion")

    license_ncolor = 
      tidy_data %>% 
      ggplot(aes(x=ncolor, group = license_type)) + 
      geom_bar(aes(y = ..prop.., fill = factor(..x..)), stat="count") + 
      scale_y_continuous(labels=scales::percent) +
      geom_text(aes( label = scales::percent(..prop..),
                       y= ..prop.. ), stat= "count", vjust = -.5) +
      facet_grid(. ~ license_type) + 
      theme(legend.position = 'none') +
      labs(
      title = "License type proportion according to ncolor",
      x = "ncolor",
      y = "Proportion")

These graphs indicate that there are no significant correlation between
number of color and license type/breed type of the dog. The
distributions are similar in each group.

    license_color = 
      tidy_data %>% 
      filter(color %in% c("BLACK", "BROWN", "WHITE/BLACK", "BLACK/BROWN", "WHITE",
                          "WHITE/BLACK/BROWN", "WHITE/BROWN", "BRINDLE", "GOLD", "SPOTTED")) %>% 
      ggplot(aes(x=color, group = license_type)) + 
      geom_bar(aes(y = ..prop.., fill = factor(..x..)), stat="count") + 
      scale_y_continuous(labels=scales::percent) +
      geom_text(aes( label = scales::percent(..prop..),
                       y= ..prop.. ), stat= "count", vjust = -.5) +
      facet_grid(. ~ license_type) +
      coord_flip() + 
      theme(legend.position = 'none') +
      labs(
      title = "Distribution of dog license type with top 10 popular colors.",
      x = "ncolor",
      y = "Proportion")

This graph shows the distribution of dog license type with top 10
popular colors. There are no obvious regular pattern.
