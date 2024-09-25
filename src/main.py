import requests
URL = "https://realpython.github.io/fake-jobs/"
# issues a get request to url
page = requests.get(URL)

# prints html script of page
print(page.text)

