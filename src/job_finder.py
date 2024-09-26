from selenium import webdriver
# selenium required as indeed would not allow Requests request


def scrape_indeed():
    keywords = 'data'
    location = 'aberdeen'
    URL = f"https://uk.indeed.com/jobs?q={keywords}&l={location}"
        
    # Set up Firefox driver
    driver = webdriver.Firefox()  # Use Firefox, Chrome, etc.

    # Navigate to the page
    driver.get(URL)
    print(driver)

    # Close the driver
    driver.quit()

scrape_indeed()