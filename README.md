Basic instructions for working with SIBES
================
Léon Serre-Fredj and Allert Bijleveld
30/07/2024

<!-- README.md is generated from README.Rmd. Please edit that file -->

# SIBES

SIBES stands for Synoptic Intertidal BEnthic Survey. The goal of the
*SIBES*-package is to conveniently load, process, and explore SIBES-data
on abundance, biomass, median grain size and mud content. The basic
workflow is covered in this readme document and illustrated with this
![flowchart](/man/figures/flow_chart_SIBES.png):

# Installation

You can install the latest version of SIBES from
[GitHub](https://github.com/) with:

``` r
## install.packages("devtools")
devtools::install_github("https://github.com/allertbijleveld/SIBES", build_vignettes = TRUE)
```

# Download the data

Data will be available via open access after publication of the
accompanying data paper. Now, the data can be downloaded here:
<https://doi.org/10.25850/nioz/7b.b.ug>

Data are available after a three-year embargo or earlier upon request.
The data come in three ‘csv’ files containing (1) metadata of sampling
stations and sediment characteristics (‘samples.csv’), (2) species found
on the mudflats of the Dutch Wadden Sea (‘species.csv’), and (3) biomass
and abundance per species per sample station (‘biota.csv’).

# Loading the package and data

All three SIBES csv-files can be conveniently loaded with the function
*sibes_load*. By providing the folder containing the three csv-files,
this function loads the SIBES data into a list containing three data
frames (‘biota’,‘species’,‘samples’). If the names of the downloaded
csv-files have been modified, these can be provided with arguments.

``` r
library(SIBES)

## load the three SIBES-csv files from a folder
    # data_list <- sibes_load(directory_path = '')

## for convenience, load the example dataset provided within the package
    data_list <- get('SIBES_dataset')
```

# Species exploration

To conveniently search for species, *sibes_species_search* allows either
to browse the species based on part of a species name or id.

``` r
## browse the list of species available
    sibes_species_search(data_list[["species"]], Key='39')          # using sibes_id
    sibes_species_search(data_list[["species"]], Key='57|34|67')    # multiple ids
    sibes_species_search(data_list[["species"]], Key='aren')        # using part of the name    
```

# Species selection

``` r
## data can be selected with the search function, which could be convenient for selecting multiple species
    # data_list[['biota']] <- sibes_species_search(
    #                           data_list[['biota']], 
    #                           Key='39') # also includes sibes_id 339

## select only one species 
    data_list[['biota']] <- sibes_select(
                            data = data_list[['biota']], 
                            filters = "sibes_id == 45" 
                            )
```

# Aggregating data per sampling station

If more than one species is present within biota, it needs to be
aggregated per sampling station.

``` r
## aggregate the species data into biota
    data_list[['biota']] <- data_list[['biota']] %>%
                            group_by(sample_id)  %>%
                            summarize(
                                abundance_m2 =  sum(abundance_m2), 
                                afdm_m2 =  sum(afdm_m2)
                                )
```

# Merge ‘biota’ and ‘samples’

The biota tibble only contains data for sampling stations that had
animals. To also include sampling stations where the selected species
(or species group) was not found, the data ‘biota’ and ‘samples’ need to
be merged. The function *sibes_merge* will merge (left_join) the data
frames ‘samples’ and ‘biota’ contained in the list obtained with
*sibes_load*. The list entry ‘samples’ is necessary for running this
function.

``` r
    data_m <- sibes_merge(Inputdata = data_list)
```

# Data exploration

Here, we provide a few examples exploring the data. First, select a
subset of data. Second, explore the numbers of samples in the data set.
Third, expolore changes over time in a trend plot. Fourth, map the
distribution of biomass, abundance, etc.

## Spatiotemporal selection

Subset the merged dataset for a particular area, time period, and/or
year.

``` r
## select data for particular tidal basins 
    data_selected_1 <- sibes_select(
                            data = data_m, 
                            filters = c(
                                "tidal_basin_name %in% c(\"Eierlandse Gat\",\"Vlie\")" 
                                        )
                                    )

## select data for a sampling time period
    data_selected_2 <- sibes_select(
                            data = data_m, 
                            filters = c(
                                    "between(
                                        date,
                                        as.Date(\"2010-01-01\",format=\"%Y-%m-%d\"),
                                        as.Date(\"2020-08-11\",format=\"%Y-%m-%d\")
                                            )" 
                                        ) 
                                    )
                    
## select data for range of sampling station ids and dates
    data_selected_3 <- sibes_select(
                            data = data_m, 
                            filters = c(
                                    "between(sampling_station_id, 320,335)", 
                                    "between(
                                            date,
                                            as.Date(\"2010-01-01\",format=\"%Y-%m-%d\"),
                                            as.Date(\"2020-08-11\",format=\"%Y-%m-%d\")
                                            )"  
                                        ) 
                                    )   
```

## Numbers of samples

``` r
## get the number of samples per year in the selected data
    table(year(data_selected_2$date))
#> 
#> 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 
#> 3966 3846 3849 3839 4176 4137 4168 1585 1702 4203 2366

## get the number of times a station occurs in the selected data
    table(year(data_selected_3$date),data_selected_3$sampling_station_id)
#>       
#>        320 321 322 324 325 326 327 328 329 330 331 332 333 334 335
#>   2010   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
#>   2011   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
#>   2012   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
#>   2013   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
#>   2014   1   1   1   1   1   1   1   1   1   0   0   1   1   1   1
#>   2015   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
#>   2016   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
#>   2017   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1
#>   2019   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
#>   2020   1   1   1   1   0   0   0   0   0   1   0   1   0   1   0
```

## Trend plot

``` r
## First, we need to average values per year
    data_selected_2_per_year <- data_selected_2 %>% 
                                  group_by(year(date)) %>%
                                  summarize(abundance_m2 =  mean(abundance_m2))

## plot the trend
    plot(data_selected_2_per_year$`year(date)`, 
        data_selected_2_per_year$abundance_m2,
        xlab = "year", 
        ylab = "mean abundance", 
        main="trend plot",
        type='o',
        pch=16, 
        cex=2
    )
```

<img src="man/figures/README-Temporal plot-1.png" width="100%" />

## Plot map

The function *sibes_plot_map* can be used for easy mapping.

``` r
## Map distribution across whole SIBES-extent
    
    ## before mapping, we need to average over years (or select one year to plot)
        data_selected_2_per_sampling_station_id <- data_selected_2 %>% 
                                        group_by(sampling_station_id) %>%
                                        summarize(
                                            x = x[1], 
                                            y = y[1],
                                            median_grain_size = mean(median_grain_size),
                                            percentage_mud = mean(percentage_mud),
                                            abundance_m2 = mean(abundance_m2),
                                            afdm_m2 = mean(afdm_m2),
                                            n_years = n()
                                                )

    ## plot the number of years a station was sampled 
        sibes_plot_map(
            Inputdata = data_selected_2_per_sampling_station_id,
            attribute = "n_years",
            ticks = 10,
            cex_map = 0.25
            )
```

<img src="man/figures/README-Map plot-1.png" width="100%" />

``` r
    ## plot median grain size 
        sibes_plot_map(
            Inputdata = data_selected_2_per_sampling_station_id,
            attribute = "median_grain_size",
            ticks = 10,
            cex_map = 0.2
            )
```

<img src="man/figures/README-Map plot-2.png" width="100%" />

``` r
    ## plot afdm  
        sibes_plot_map(
            Inputdata = data_selected_2_per_sampling_station_id,
            attribute = "percentage_mud",
            ticks = 10,
            cex_map = 0.2
            )
```

<img src="man/figures/README-Map plot-3.png" width="100%" />

``` r


## Map distribution on a selection of tidal basins
    ## first the selected data need to be grouped 
        data_selected_1_per_sampling_station_id <- data_selected_1 %>% 
                                        group_by(sampling_station_id) %>%
                                        summarize(
                                            x = x[1], 
                                            y = y[1],
                                            median_grain_size = mean(median_grain_size),
                                            percentage_mud = mean(percentage_mud),
                                            abundance_m2 = mean(abundance_m2),
                                            afdm_m2 = mean(afdm_m2),
                                            n_years = n()
                                                )
                                                
    ## plot biomass
        sibes_plot_map(
                Inputdata = data_selected_1_per_sampling_station_id,
                attribute = "afdm_m2",
                ticks = 10,
                cex_map = 0.5,
                cex_legend_labels = 0.7)
```

<img src="man/figures/README-Map plot-4.png" width="100%" />
