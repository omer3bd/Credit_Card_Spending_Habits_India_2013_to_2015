from bs4 import BeautifulSoup
import requests
import pandas as pd
from datetime import datetime


headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0 Safari/537.36",
    "Accept-Language": "en-US,en;q=0.9"
}

# Function to scrape holidays
def scrape_holidays(url):

    # ------------ Initialize lists to store data ------------
    global column_headers, table_content_data
    column_headers = []
    table_content_data = []


    # ------------ Fetch the HTML content ------------
    try:
        response = requests.get(url, headers=headers)
        soup = BeautifulSoup(response.text, 'html.parser')
    except Exception as e:
        print(f"Error fetching the URL: {e}")
        return


    # ------------ Extract table headers and data ------------
    try:
        headings = soup.find_all('th')
        for h in headings:
            column_headers.append(h.text.strip())
        column_headers[1] = 'Days' # there is a null space in the second header
    except Exception as e:
        print(f"Error extracting headers: {e}")
        return


    # ------------ Extract table data ------------
    try:
        table_content = soup.find_all('td')
        for d in table_content:
            table_content_data.append(d.text.strip())
    except Exception as e:
        print(f"Error extracting table data: {e}")
        return



def html_to_csv(year):

    # ------------ Adding year to dates ------------
    dates = []
    raw_dates = column_headers[4:]
    for i in raw_dates:
        dates_with_year = f"{i} {year}"
        date_obj = datetime.strptime(dates_with_year, "%d %b %Y")
        formatted_date = date_obj.strftime("%d-%b-%y").lower()
        dates.append(formatted_date)


    # ------------ Convert to CSV ------------
    try:
        days = table_content_data[0::3]
        name = table_content_data[1::3]
        holiday_type = table_content_data[2::3]

        data = {
            column_headers[0]: dates,
            column_headers[1]: days,
            column_headers[2]: name,
            column_headers[3]: holiday_type
        }

        df = pd.DataFrame(data)

        df.to_csv(f"indian_holidays_{year}.csv", index=False)
        print(f"CSV file created successfully for year {year}.")
    except Exception as e:
        print(f"Error converting to CSV: {e}")


# ------------ Main Execution Loop for years 2013 to 2015 ------------
def run():
    for year in range(2013, 2016):
        print(f"\ninitializing for year: {year}")
        url = f"https://www.timeanddate.com/holidays/india/{year}"

        scrape_holidays(url)
        html_to_csv(year)







if __name__ == "__main__":
    run()