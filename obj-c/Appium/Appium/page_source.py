from sys import argv
from selenium import webdriver

driver = webdriver.Remote(command_executor='http://' + argv[1] + ':' + argv[2] + '/wd/hub',desired_capabilities={'browserName': 'iOS','platform': 'Mac', 'version': '6.0'})
print driver.page_source
driver.quit()