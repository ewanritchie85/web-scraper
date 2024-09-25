import requests
from bs4 import BeautifulSoup

URL = "https://realpython.github.io/fake-jobs/"
# issues a get request to url
page = requests.get(URL)

# create BS object
soup = BeautifulSoup(page.content, "html.parser")

# finds the HTML within a specific div container ID
results = soup.find(id="ResultsContainer")

# print(results.prettify())

#    find_all returns an iterable from a BS object
job_elements = results.find_all("div", class_="card-content")

# each job_element is also a BS object
for job_element in job_elements:
    title_element = job_element.find("h2", class_="title")
    company_element = job_element.find("h3", class_="company")
    location_element = job_element.find("p", class_="location")
    # .text results in a regular python string, from a BS object with html code removed
    # print(title_element.text.strip())
    # print(company_element.text.strip())
    # print(location_element.text.strip(), "\n")

# the lambda argument gives case insensitivity, rather than just passing a string
python_jobs = results.find_all("h2", string=lambda text: "python" in text.lower())

print(python_jobs)

python_job_elements = [
    # .parent navigates upwards in the HTML heirarchy 
    h2_element.parent.parent.parent for h2_element in python_jobs
]

for python_job in python_job_elements:
    title_element = python_job.find("h2", class_="title")
    company_element = python_job.find("h3", class_="company")
    location_element = python_job.find("p", class_="location")
    print(title_element.text.strip())
    print(company_element.text.strip())
    print(location_element.text.strip(), "\n")