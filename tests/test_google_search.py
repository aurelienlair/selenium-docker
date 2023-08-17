import os
import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.firefox.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import NoSuchElementException
import subprocess  # Import subprocess module for running shell commands


@pytest.fixture(scope='module')
def setup(request):
    options = Options()
    options.add_argument('-headless')

    geckodriver_path = subprocess.check_output(
        ['which', 'geckodriver']).strip().decode('utf-8')

    out_directory = os.path.join(os.getcwd(), '.out')
    if not os.path.exists(out_directory):
        os.makedirs(out_directory)

    log_output_path = os.path.join(out_directory, 'geckodriver.log')
    service = Service(executable_path=geckodriver_path,
                      log_output=log_output_path)

    driver = webdriver.Firefox(options=options, service=service)

    driver.implicitly_wait(10)
    driver.maximize_window()

    def teardown():
        driver.quit()

    request.addfinalizer(teardown)
    return driver


def test_google_search(setup):
    driver = setup
    driver.get('https://www.google.co.uk/?hl=en')

    try:
        driver.find_element(
            By.XPATH, "//div[normalize-space()='Reject all']").click()
        print("Cookie banner found!")
    except NoSuchElementException:
        print("Cookie banner not found.")

    search_box = driver.find_element(by=By.NAME, value='q')
    search_box.send_keys('Automation step by step')
    search_box.send_keys(Keys.RETURN)
    wait = WebDriverWait(driver, 10)
    wait.until(EC.title_is("Automation step by step - Google Search"))

    search_results = driver.find_elements(By.XPATH, "//div[@class='tF2Cxc']")
    print(f"Collected {len(search_results)} items:")
    for result in search_results:
        print(result.text)
