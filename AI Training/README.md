# AI Training

This directory contains files useful for training a Machine Learning (ML) model for article type classification.

## Files Included

### `model_example_training.csv`
This file contains an example of how the initial training dataset might look. It was used to train the example model included in the Database repository. Note that it contains only 28 articles, so we **strongly recommend** training a new ML model based on a dataset containing articles that are representative of your organization's typical use cases or interests.

The file has three columns:

- **Title**: The article's title.
- **Link**: The URL of the article.
- **Type**: The classification of the article (ex. Vulnerability, Data Breach, Ransomware, etc.).

### `web_scrap_csv.py`
This Python script takes a CSV file (similar to `model_example_training.csv`), web scrapes article content using the links provided, and generates a new CSV file with the web scraped content.

You can customize the following parameters within the script:

| Parameter         | Description                                                                                     | Default Value             |
|-------------------|-------------------------------------------------------------------------------------------------|---------------------------|
| `filename_input`  | Input CSV file containing the initial dataset with article links (without the web-scraped body). | `daily_report_summary.csv`|
| `link_col_name`   | The column name in the dataset that contains the article URLs for web scraping.                 | `Link`                    |
| `filename_output` | Output CSV file containing the updated dataset, including the web-scraped article body.         | `dataset.csv`             |
| `body_col_name`   | The column name for the new article body column where the web-scraped content will be stored.    | `body`                    |

### `Train_ML_model.ipynb`
This Jupyter Notebook contains Python code to train an ML model for article type classification. The input dataset (CSV file) should include the following columns:

- **Type**: The classification label for each article.
- **Body**: The web-scraped body content of the article.
- **Title**: The article title. This will be used as a fallback if the body content is empty.

The notebook outputs:

- A **pickle** file containing the trained ML model.
- A **JSON** file containing the trained ML model that can be added to the database repository and inserted into MongoDB.
