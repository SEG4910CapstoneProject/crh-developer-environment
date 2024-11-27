from bs4 import BeautifulSoup
import html 
import requests
import pandas as pd
from bs4.element import Comment


def get_raw_page(url):
    """
    Get raw web scrap page for given url
    :param url: the url of the page to web scrap
    :return: web scrap page in unicode
    """
    page = requests.get(url, timeout=60)
    if page.status_code != 200:
        print("\tWeb scrapping failed")
        raise Exception("Web scrapping failed (status " + str(page.status_code) + "):" + url)

    # page.text is the content of the response in Unicode
    # page.content is the content of the response in bytes
    return page.text

def html_escape(html_content):
     # convert to HTML-safe sequence
    res = html.escape(html_content, quote=True)
    return res

# return if a html tag contains visible data (useful article content)
def tag_visible(element):
    if element.parent.name in ['style', 'script', 'head', 'title', 'meta', '[document]']:
        return False
    if isinstance(element, Comment):
        return False
    return True

# get only the article content from the html web scraped information 
def get_article_content(body):
    soup = BeautifulSoup(body, 'html.parser')
    texts = soup.findAll(string=True)
    visible_texts = filter(tag_visible, texts)  
    return u" ".join(t.strip() for t in visible_texts)

# get the page content from the URL 
def get_page_content(url):
    print(url)
    try:
        page = get_raw_page(url)
        page = get_article_content(page)
        page = html_escape(page)
        page = page.replace("\n", "")
        page = page.strip()
    except:
        return '""'
    return '"' + page + '"'

# main
# Setup configuration (Modify as needed)
filename_input  = 'daily_report_summary.csv'   # Input CSV file containing the initial dataset with article links (without the web-scraped article body)
link_col_name   = 'Link'                       # Column name in the dataset that contains the article URLs (for web scraping)
filename_output = 'dataset.csv'                # Output file name for the updated dataset (including the web-scraped article body)
body_col_name   = 'body'                       # Column name for the new article body column that will store the web-scraped content

# Open file
df = pd.read_csv(filename_input, encoding='unicode_escape')

# Add a new body column
df[body_col_name] = '""'

# Populate the new body column with the web-scraped article content
num_rows = len(df)
for index, row in df.iterrows():
    print(index+1, "/", num_rows)
    row[body_col_name] = get_page_content(row[link_col_name])

# Write the updated DataFrame to a CSV file
df.to_csv(filename_output, index=False)
