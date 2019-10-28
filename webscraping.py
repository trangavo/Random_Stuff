from selenium import webdriver
from bs4 import BeautifulSoup
import requests
import json
# set up
chrome_path = r"/Users/trangnguyenvn1398/Desktop/chromedriver 2"
driver = webdriver.Chrome(chrome_path)
link = "https://www.sourcewell-mn.gov/cooperative-purchasing/022217-wex#tab-contract-documents"
driver.get(link)
html_doc = requests.get(link).content
soup = BeautifulSoup(html_doc, 'html.parser')

# get contract basic info
contract_header = soup.find("div", {"class": "vendor-contract-header__content"})
header_info = [x.get_text().strip()
               for x in contract_header.find_all('p')]
# get title, expiration and contract number
title = header_info[0]
expiration = header_info[1][-10:]
contract_number = header_info[1][:11]
# contract files
file_link = soup.find("span", {"class": "file-link"})
for a in file_link.find_all("a", href=True, text=True):
    link_text = a["href"]
files = [{"contract-forms": link_text}]

# get contract vendor basic info
# name of vendor
name = contract_header.find("h1").get_text().strip()
contact_info = soup.find("div", {"class": "inline-user"})
# name of vendor contact
contact_name = contact_info.find("strong").get_text().strip()
# phone and email
contact_info_list = [x.get_text().strip() for x in contact_info.find_all('div', {"class": "field--item"})]
contacts = [{"name": contact_name, "phone": contact_info_list[0], "email": contact_info_list[1]}]
# vendor all info
vendor = {"name": name, "contacts": contacts}

# dictionary of all info
key_contract_info = {
    "title": title,
    "expiration": expiration,
    "contract_number": contract_number,
    "files": files,
    "vendor": {
        "name": name,
        "contacts": contacts
    }
}

# convert to json file
json_file = json.dumps(key_contract_info, indent=4)
print(json_file)
