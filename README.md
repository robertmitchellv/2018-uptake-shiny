# 2018 Uptake `shiny` workshop

We will use this repository to ensure we all start with the same basic `shiny` app structure as we add the components to our dashboard! 

# Data

I found some data on the Chicago Data Portal on [affordable housing](https://data.cityofchicago.org/Community-Economic-Development/Affordable-Housing-Units-by-Community-Area/yvj4-y3fb) to use for building this dashboard.

This data is _not_ very interesting (on purpose!); the goal is to work on building `shiny` components rather than getting lost in an analysis.

# Dependencies

For different kinds of software to run on your machine, bits and pieces depend on others in order for them to work. Like in `tidyverse`, if you want to write an `R` script that uses the `read_csv()` function from the `readr` package, you load the package and its functions into the work you're doing in your `R` script so that it can access everything in `readr`. Like your `R` script, `readr` does the same thing too! It loads other works from other authors to create the functions we _depend_ on for our functions to work. It's practically ~~turtles~~ dependencies all the way down.

Some `R` code depends on other `R` code, but other `R` code can depend on `C++`, which means you'll need some way to install these. Many people use package managers for this, e.g. `homebrew` on macOS, `chocolatey` on Windows, or many of the distro specific ones for Linux (`apt`, `yum`, etc.).

Getting all of your software dependencies to work can sometimes be the worst kind of hell. Usually it's because we all don't care sometimes about what we're downloading because we just _need_ it for a present and pressing use case.

## For building dashboards and visualizations

This will enable you to build a _ton_ of wonderful dashboards

name | version | note
--- | --- | ---
`git` | | just get the latest release--`hub` if you're more familiar already 
`R` | | the latest is 3.5.1; older versions of R _should_ be fine as well
RStudio | | you can grab the latest release, `preview`, or `daily` version
`tidyverse` | `>= 1.2.1` | this is the latest release
`shiny` | `>= 1.1.0` | this is a big new release with async support
`shinydashboard` | GitHub version | the version on GitHub has support for newer `shiny` features 
`plotly` | GitHub version | this version has _tons_ of features and asynchronous support as well
`shinyjs` | | _optional_ if you're comfortable with js, you can write your own js functions to use within `shiny`

You don't _need_ to get the most recent updates. However, doing so will enable you to use `async`

## For the geo data

If you want to use geo data, you will have additional dependencies to worry about, I'll put install instructions from the `sf` GitHub repo here to try and make it easier

name | version | note
--- | --- | ---
`GEOS` | | you'll need to download this through a package manager
`GDAL` | | you'll need to download this through a package manager
`PROJ.4` | | you'll need to download this through a package manager
`sf` | | GitHub version

# How to install

## macOS

One way to install the dependencies is using sudo; the other is using homebrew. For the latter, see e.g. here. Homebrew commands might be:

```
brew unlink gdal
brew tap osgeo/osgeo4mac && brew tap --repair
brew install proj
brew install geos
brew install udunits
brew install gdal2 --with-armadillo --with-complete --with-libkml --with-unsupported
brew link --force gdal2
```

after that, you should be able to install `sf` as a source package.

For macOS Sierra, see [these](https://stat.ethz.ch/pipermail/r-sig-mac/2017-June/012429.html) instruction, using kyngchaos frameworks.

## Linux

For Unix-alikes, `GDAL (>= 2.0.0)`, `GEOS (>= 3.3.0)` and `Proj.4 (>= 4.8.0)` are required.

__Ubuntu__

To install the dependencies on Ubuntu, either add [ubuntugis-unstable](http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu/) to the package repositories:

```
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install libudunits2-dev libgdal-dev libgeos-dev libproj-dev 
```

or install dependencies from source; see e.g. an older travis config file for hints.

__Fedora__

The following command installs all required dependencies:

```
sudo dnf install gdal-devel proj-devel proj-epsg proj-nad geos-devel udunits2-devel
```

__Arch__

Get gdal, proj and geos from the main repos and udunits from the AUR:

```
pacman -S gdal proj geos
pacaur/yaourt/whatever -S udunits
```

__Other__

To install on Debian, the [rocker geospatial](https://github.com/rocker-org/geospatial) Dockerfiles may be helpful. Ubuntu Dockerfiles are found [here](https://github.com/r-spatial/sf/tree/master/inst/docker).

## Windows

Installing sf from source works under windows when Rtools is installed. This downloads the system requirements from [rwinlib](https://github.com/rwinlib/).
