# California Housing Dashboard (1990) - Individual Assignment

## Overview

The application is a 'Shiny for R' interactive dashboard that visualizes California housing data from 1990. The data is block level census data. Link to the group project: [DSCI-532_2026_5_california_housing](https://github.com/UBC-MDS/DSCI-532_2026_5_california_housing)

Link to deployment: [Dashboard](https://sjbalagit-dsci532-individual-assignment.share.connect.posit.cloud)

## Installation

### Requirements

- R 4.0+
- `renv` package for dependency management

### Setup Instructions

1. **Clone the repository**:

Using SSH:
```bash
git clone git@github.com:sjbalagit/dsci532-Individual-Assignment.git
```

Using HTTPS:
``` bash
git clone https://github.com/sjbalagit/dsci532-Individual-Assignment.git
```

```bash
cd dsci532-Individual-Assignment
```

2. **Install dependencies using renv**:

```r
install.packages("renv")
renv::restore()
```
This will automatically install all required packages from `renv.lock`.

## Running the Application

### From Terminal
```bash
Rscript -e "shiny::runApp('app.R')"
```

### From RStudio
1. Open `app.R` in RStudio
2. Click the **"Run App"** button

## Attribution

Generative AI tools (Anthropic Claude, OpenAI ChatGPT, and GitHub Copilot) were used to assist with code generation and documentation drafting. All generated content was reviewed and edited by the author to ensure accuracy and quality.
