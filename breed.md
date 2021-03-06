Breed analysis
================

    load("tidy_data.Rdata")

We want to study the breed and the association between breed and license
type: What’s the similarity and difference between mixed and type? Is
there any preference for license type between breeds?

First, we make a bar chart to compare the two breed types: mixed and
pure. From the chart, we can see, the number of license of the pure is a
little more than twice as much the license of the mixed.

Between the two groups, the similarity of the distribution of license is
that the “Dog Lifetime N/S” takes first place at about 80%, followed by
“Dog Senior Lifetime”, “Dog Lifetime” and “Dog Senior Lifetime”. The
difference is that the proportion of “Dog Lifetime” in the pure is much
more than it in the mixed.

Mixed vs Pure
-------------

    breed_type_plot =
     tidy_data %>% 
     ggplot(aes(x = breed_type, fill = license_type)) +
     geom_bar() +
     theme(legend.position = 'right') +
     labs(title = 'Mixed vs Pure ',
           x = '',
           y = 'Number of licenses')

    breed_type_plot

<img src="breed_files/figure-gfm/unnamed-chunk-2-1.png" width="90%" />

We want to find more information about specific breeds. Since there are
so many breeds, we choose the top five breeds of the mixed and the pure,
and make two bar charts respectively. We delete the breed of “mixed”
since it cannot provide specific information about breed. From the
charts we can see LAB MIX and LABRADOR RETRIEVER are the top one in the
mixed and pure respectively, much more than other breeds. The
distribution of license type of the five mixed breeds is similar to the
total mixed. Compared to the total pure, BEAGLE and DOLDENDOODLE have
less proportion of “Dog Lifetime”.

Top 5 mixed breed
-----------------

    mix_rank_df = tidy_data %>% 
      filter(breed_type == "MIXED") %>% 
      filter(breed != "MIXED") %>% 
      count(breed) %>% 
      mutate(rank = min_rank(desc(n))) %>% 
      filter(rank < 6)

    mix_breed_df = 
      tidy_data %>% 
      filter(breed %in% pull(mix_rank_df, breed)) 

    mixed_plot =
    mix_breed_df %>% 
      ggplot(aes(x = breed, fill = license_type)) +
      geom_bar() +
      theme(legend.position = 'right') + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(title = 'Top 5 in mixed ',
           x = '',
           y = 'Number of licenses')

Top 5 pure breed
----------------

    pure_rank_df = tidy_data %>% 
      filter(breed_type == "PURE") %>% 
      count(breed) %>% 
      mutate(rank = min_rank(desc(n))) %>% 
      filter(rank < 6)

    pure_breed_df = 
      tidy_data %>% 
      filter(breed %in% pull(pure_rank_df, breed)) 

    pure_plot = 
    pure_breed_df %>% 
      ggplot(aes(x = breed, fill = license_type)) +
      geom_bar() +
      theme(legend.position = 'right') + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(title = 'Top 5 in pure ',
           x = '',
           y = 'Number of licenses')

    pure_plotly = ggplotly(pure_plot)

Patch them
----------

    mixed_plot + theme(legend.position = 'none') + pure_plot 

<img src="breed_files/figure-gfm/unnamed-chunk-5-1.png" width="90%" />
