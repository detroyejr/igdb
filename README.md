IGBD
================

[![Travis-CI Build Status](https://travis-ci.org/jonathande4/igdb.svg?branch=master)](https://travis-ci.org/jonathande4/igdb)

The IGDB package provides access to the [IGDB API](https://api.igdb.com/) which gives information on video games, developers, reviews, companies, and other related content.

Install
-------

Use devtools to install from Github.

``` r
devtools::install_github("jonathande4/igdb")
```

Usage
-----

At the time of this package was developed, most of the available API endpoints are covered. These include:

-   `igdb_characters`: [Characters](https://igdb.github.io/api/endpoints/character/)
-   `igdb_collections`: [Collections](https://igdb.github.io/api/endpoints/collection/)
-   `igdb_companies`: [Company](https://igdb.github.io/api/endpoints/company/)
-   `igdb_credits`: [Credits](https://igdb.github.io/api/endpoints/credit/)
-   `igdb_franchises`: [Franchise](https://igdb.github.io/api/endpoints/franchise/)
-   `igdb_games`: [Game](https://igdb.github.io/api/endpoints/game/)
-   `igdb_genres`: [Genre](https://igdb.github.io/api/endpoints/genre/)
-   `igdb_keywords`: [Keywords](https://igdb.github.io/api/endpoints/keyword/)
-   `igdb_pages`: [Pages](https://igdb.github.io/api/endpoints/page/)
-   `igdb_platforms`: [Platform](https://igdb.github.io/api/endpoints/platform/)
-   `igdb_pulses`: [Pulse](https://igdb.github.io/api/endpoints/pulse/)
-   `igdb_reviews`: [Reviews](https://igdb.github.io/api/endpoints/review/)

Each function follows a similar format.

-   `search`: title or keyword relating to kinds of results you want to return.
-   `id`: each element in the api has an associated id. If you know the id of the game, review, or company you can pass that as a single number or vector of numbers to retrieve only those elements.
-   `n`: maximum number of results to return.
-   `limit`: maximum number of results per page.
-   `scroll`: an alternative method for pagination which allows you to request more than 10,000 rows ([see pagination](https://igdb.github.io/api/references/pagination/)).
-   `filter`: a method for narrowing search results (e.g `"[created_at][gt]=2017-01-01"`) ([see filters](https://igdb.github.io/api/references/filters/)).
-   `fields`: a vector of columns the api should return.
-   `order`: a string that sets the order of the results (e.g `created_at:asc`, `name:desc`)
-   `api_key`: an API key provided when you sign up.

You can find the full documentation for the API [here](https://igdb.github.io/api/about/welcome/).

API Key
-------

Before you can begin to use the service, [sign up](https://api.igdb.com/signup) and receive an API key. Once you have your key, you can pass it to the function parameter `api_key` or use

    Sys.setenv("IGDB_KEY" = 'YOUR_API_KEY`)

to add it to your environment. The function `igdb_key()` will look in the system environment for a variable with that name.

Examples
--------

### Games

``` r
# Returns games matching "bioshock" but filters games released after 2015.
igdb_games(
  search = "bioshock",
  order = "first_release_date:asc",
  filter = "[first_release_date][lt]=2016-01-01",
  fields = c("id", "name", "first_release_date", "rating", "popularity")
  )
```

    ##       id                                         name   rating popularity
    ## 1     20                                     BioShock 89.14144      13.00
    ## 2     21                                   BioShock 2 81.76016       6.00
    ## 3  44571                  Bioshock 2: Rapture Edition       NA       1.00
    ## 4  47440                   BioShock 2 Special Edition       NA       1.00
    ## 5  14543                    BioShock 2: Minerva’s Den 85.37396       1.75
    ## 6    538                            Bioshock Infinite 84.78717      11.50
    ## 7  41598 Bioshock Infinite: Ultimate Songbird Edition       NA       1.25
    ## 8  20115       BioShock Infinite: Clash in the Clouds       NA       1.25
    ## 9  10047             BioShock Infinite: Burial at Sea 86.10750       2.00
    ## 10 41595      Bioshock Infinite: The Complete Edition       NA       1.25
    ##    first_release_date
    ## 1          2007-08-21
    ## 2          2010-02-09
    ## 3          2010-03-09
    ## 4          2010-03-09
    ## 5          2010-08-31
    ## 6          2013-02-26
    ## 7          2013-04-26
    ## 8          2013-07-30
    ## 9          2014-03-25
    ## 10         2014-12-04

### Companies

``` r
igdb_companies(
  search = "2k",
  order = "start_date:desc",
  fields = c("id", "name", "start_date", "published"),
  n = 20
  )
```

    ##       id                      name          start_date
    ## 1   3957                       M2H 2015-01-08 23:00:00
    ## 2   9111              kChamp Games 2008-12-30 23:00:00
    ## 3    301                  2K Czech 2008-12-30 23:00:00
    ## 4    649                 2K Boston 2007-12-30 23:00:00
    ## 5   2001                   2K Play 2007-09-09 22:00:00
    ## 6     15                  2K Marin 2007-01-01 00:00:00
    ## 7     18                  2K China 2006-03-31 00:00:00
    ## 8      8                  2K Games 2005-01-25 00:00:00
    ## 9   1975                 2K Sports 2005-01-24 23:00:00
    ## 10 10473      F K Digital Pty Ltd. 2004-12-30 23:00:00
    ## 11 13206                  S.K.I.F. 1996-12-30 23:00:00
    ## 12  1334           H2O Interactive 1994-12-30 23:00:00
    ## 13 13413 L&K Logic Korea Co., Ltd.                <NA>
    ## 14  5599               K2 Co. Ltd.                <NA>
    ## 15 12733               O.T.K Games                <NA>
    ## 16 13000               L.K. Avalon                <NA>
    ## 17  9853                    PriitK                <NA>
    ## 18  3337                   2K Asia                <NA>
    ## 19  3341                2K IS Team                <NA>
    ## 20  2325                    K2 LLC                <NA>
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   published
    ## 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           8037, 23993, 8036, 36718, 35904
    ## 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              17904, 34162
    ## 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      NULL
    ## 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      NULL
    ## 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    4057, 4058, 5072, 7976, 7977, 7980, 7978, 13179, 14845
    ## 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      NULL
    ## 7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      NULL
    ## 8  78451, 76420, 53285, 53404, 22192, 25339, 25907, 34293, 34294, 26772, 47990, 39760, 39761, 37060, 3272, 15819, 27858, 27823, 27820, 9932, 3271, 244, 490, 10, 633, 544, 3083, 1318, 3770, 21, 498, 25, 40, 293, 19130, 866, 2846, 4853, 4870, 5894, 5779, 5797, 5932, 5785, 5867, 5838, 6205, 6038, 6046, 6062, 6420, 3179, 59, 1011, 6032, 894, 7975, 1377, 8714, 546, 787, 865, 9021, 9022, 9270, 9275, 9460, 7687, 10047, 10743, 10919, 11492, 10502, 14548, 13915, 13926, 13925, 13924, 13916, 13917, 13923, 538, 19164, 2152, 19335, 4228, 868, 19839, 14543, 21626, 21625, 20757, 21758, 20, 19516
    ## 9                                                                                                                                                                                                                                                                                                        3984, 4993, 4989, 4991, 4992, 4990, 5057, 5068, 4715, 4716, 5009, 5011, 5010, 5056, 5054, 5058, 5070, 5069, 5783, 5233, 5232, 5782, 5966, 5235, 5965, 5295, 5297, 5329, 5483, 5481, 7119, 6941, 6970, 7614, 7063, 7064, 7073, 8836, 8835, 8837, 8838, 5234, 8907, 7846, 11525, 11057, 18819, 31558
    ## 10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     NULL
    ## 11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     NULL
    ## 12                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     NULL
    ## 13                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     NULL
    ## 14                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     NULL
    ## 15                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    28738
    ## 16                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     4639
    ## 17                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     NULL
    ## 18                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     NULL
    ## 19                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     NULL
    ## 20                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     NULL

### Reviews

``` r
igdb_reviews(
  search = "bioshock",
  fields = c("username", "created_at", "title", "game", "views", "platform")
)
```

    ##     id          created_at      username                            title
    ## 1 1473 2015-04-11 14:32:36 abloobudoo009 Bioshock Infinite Written Review
    ## 2 1555 2015-06-03 14:34:22      SlayerZX        Bioshock Infinite Review.
    ##   game views platform
    ## 1  538   336       12
    ## 2  538   357        6

### Characters

``` r
igdb_characters(
  search = "booker dewitt"
)
```

    ##     id          name          created_at          updated_at          slug
    ## 1 1043 Booker DeWitt 2014-08-31 00:14:13 2015-04-22 22:51:02 booker-dewitt
    ## 2 3507   Minor Deity 2015-02-20 17:57:08 2015-02-20 17:57:12   minor-deity
    ##                                             url gender species
    ## 1 https://www.igdb.com/characters/booker-dewitt      0       1
    ## 2   https://www.igdb.com/characters/minor-deity     NA      NA
    ##                       people games
    ## 1                       4129   538
    ## 2 60056, 60060, 60062, 60068  9016
    ##                                                           mug_shot_url
    ## 1 //images.igdb.com/igdb/image/upload/t_thumb/evuimibzq66hyhow3x8t.jpg
    ## 2                                                                 <NA>
    ##   mug_shot_cloudinary_id mug_shot_width mug_shot_height
    ## 1   evuimibzq66hyhow3x8t            210             240
    ## 2                   <NA>             NA              NA

### Filtering Results

To get results for specific games, use the filter options.

``` r
# Filter on slug value.
igdb_games(filter = "[slug][eq] = bioshock-infinite")

# Filter on game id.
igdb_reviews(filter = "[game][eq] = 538")
```

Known Quirks
------------

#### Queries with No Results

In some cases if there are no results, the API will issue a 404 reponse causing a function error.

``` r
igdb_genres(search = "action")
```

    ## Error in igdb_genres(search = "action"): Bad Request (HTTP 400).

#### Scroll Issue

Scrolling may also not work always work as expected with smaller queries. We still get the first 50 results, but not as many as expected. R will issue a warning when this happens. For better results, switch to pagination using offset.

``` r
# Pagination with Scroll.
games <- igdb_games("halo", scroll = TRUE, n = 100)
```

    ## Warning in igdb_games("halo", scroll = TRUE, n = 100): Final query returned
    ## an error.

``` r
NROW(games)
```

    ## [1] 50

``` r
# Pagination with offset.
games <- igdb_games("halo", scroll = FALSE, n = 100)
NROW(games)
```

    ## [1] 100

Contributing
------------

If you find any bugs, you can file an issue or create a pull request. Each function was created using the same basic template. As long as there are no breaking api changes, adding new endpoints should be simple.
