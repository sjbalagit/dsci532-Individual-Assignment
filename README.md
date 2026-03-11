# California Housing Dashboard (1990) - Individual Assignment

## Overview

The application is a 'Shiny for R' interactive dashboard that visualizes California housing data from 1990. The data is block level census data. Link to the group project: [DSCI-532_2026_5_california_housing](https://github.com/UBC-MDS/DSCI-532_2026_5_california_housing)

## Installation

### Requirements

- R 3.6+
- The following R packages (see `requirements_r.txt`):
  - shiny
  - ggplot2
  - dplyr
  - tidyr
  - plotly
  - bslib

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

1. **Install R packages**:

Option A: Using R console

```r
install.packages(c(
  "shiny",
  "ggplot2",
  "dplyr",
  "tidyr",
  "plotly",
  "bslib"
))
```

Option B: Using RStudio

Open `src/app.r` in RStudio and install any missing packages when prompted.

## Running the Application

### From Terminal

```bash
cd dsci532-Individual-Assignment
Rscript -e "shiny::runApp('src/app.r')"
```

The app will start and typically open at `http://127.0.0.1:XXXX` (the port will be displayed in the console).

### From RStudio

1. Open `src/app.r` in RStudio
2. Click the **"Run App"** button at the top of the editor

## Attribution

Generative AI tools (Google Gemini, OpenAI ChatGPT, and GitHub Copilot) were used to assist with code generation and documentation drafting. All generated content was reviewed and edited by the author to ensure accuracy and quality.
