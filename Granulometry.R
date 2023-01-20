# Data Anlaysis of the Experimentation 
## Date: 24/02/2022


# Load Libraries
library(tidyverse)
library(here)
library(kableExtra)
library(ggpubr)

## Ggplot Theme setting
theme_set(theme_bw(base_size = 16, base_family = "Palatino")) 
options(digits = 4)


# Data Loading ----
## Loading the paths
files <-
   here("Granulometry", "data") %>% 
   dir( recursive=TRUE, full.names=TRUE, pattern="\\.csv$")


## Creating the Nested dataframe ----
Granulometry <- files %>%  map( ~ read.csv(.))
Granulometry <- Granulometry %>%   set_names(files) %>%   enframe("Type", "Data")


## Organising the dataframe
Granulometry <- 
   Granulometry %>%  
   separate(Type, 
            sep = "/",
            into = c(c(LETTERS[1:12]), c("Sample"))
   ) %>% 
   select(-c(LETTERS[1:9]), J, -c("K", "L"), "Sample", "Data")

# Changing the names
colnames(Granulometry) <- c("Material", "Sample", "Data")


## Adusting the Table
Granulometry <- 
   Granulometry %>%  
   separate(Sample, 
            sep = "_",
            into = c(c(LETTERS[1:7]))
            )

# Granulometry$F %>% as.factor() %>% levels()

# Histograph

# Unnesting the total dataframe for graphics
Granulometry <- Granulometry %>% unnest(Data)

# Organizing Factors
Granulometry$D <- factor(Granulometry$D, levels = c("700", "1400", "2100", "3000"))
Granulometry$D %>% as.factor() %>% levels()

Granulometry %>%
   ggplot( aes(x = Area, fill=F)) +
   geom_density() +
   #geom_histogram(binwidth=1 ) +
   facet_grid( D ~ .) +
   theme_minimal() 

ggsave(here("Figures","Granulometry", "Plot.jpg"), 
       width=1500, height=800, dpi = 130, 
       units = "px")


s



