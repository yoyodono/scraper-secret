require "selenium-webdriver"
require "watir-webdriver"
require "headless"

headless = Headless.new
headless.start

#profile = Selenium::WebDriver::Chrome::Profile.new
#profile['download.prompt_for_download'] = false
#profile['download.default_directory'] = File.join(File.absolute_path('../..', File.dirname(__FILE__)),"browsers/chromedriver.exe")
#@browser = Watir::Browser.new :chrome, :profile => profile
#Selenium::WebDriver::Chrome.path = "/home/dono/Project/scrapper/chromedriver"
driver_path = File.join(File.absolute_path('./','geckodriver'))
Selenium::WebDriver::Firefox.driver_path = driver_path

driver = Selenium::WebDriver.for :firefox

wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

puts "----------------------- Navigating to Lion Air ----------------------------"
puts
driver.navigate.to "http://lionair.co.id"

@departure_city = "Surabaya"
@arrival_city = "Jakarta"
@date_0 = "01/12/2016"
@date_1 = "05/12/2016"

puts "-------------------- Setting up the requirements --------------------------"
puts

# DEPARTURE
departCity_input = driver.find_element(:id, "departCity")
departCity_input.click

selected_departCity = driver.find_element(:xpath, ".//li[contains(., '#{@departure_city}')]")
departCityName = selected_departCity.attribute('innerHTML').to_s
departCityName =~ /.*\((.*)\)/
depart_CityCode = $1
driver.execute_script("document.getElementById('departCity').value = '#{departCityName}'" )
driver.execute_script("document.getElementsByName('depCity')[0].value = '#{depart_CityCode}'" )
#selected_departCity.click
#puts "#{driver.title} title"

# END OF DEPARTURE

# ARRIVAL
arrivalCity_input = driver.find_element(:id, "arrivalCity")
arrivalCity_input.click

selected_arrivalCity = driver.find_element(:xpath, ".//li[contains(., '#{@arrival_city}')]")
arrival_CityName = selected_arrivalCity.attribute('innerHTML').to_s
arrival_CityName =~ /.*\((.*)\)/
arrival_CityCode = $1
#sleep 10
#puts "#{driver.title} title"
driver.execute_script("document.getElementById('arrivalCity').value = '#{arrival_CityName}'" )
driver.execute_script("document.getElementsByName('arrCity')[0].value = '#{arrival_CityCode}'" )
# END OF ARRIVAL

date_depart = driver.find_element(:id, 'date_0')
date_depart.send_keys "#{@date_0}"

date_return = driver.find_element(:id, 'date_1')
date_return.send_keys "#{@date_1}"

#puts "#{driver.page_source} html"
driver.find_element(:id => 'btnSubmit').click

puts "------------------------------ Awaiting for Prices --------------------------------"
puts

wait_for_redirected_to_result = Selenium::WebDriver::Wait.new(:timeout => 200)
wait_for_redirected_to_result.until { driver.find_element(:class, "flight-matrix-container").displayed? }

departure_table = driver.find_element(:id, "ctl00_mainContent_tblOutFlightBlocks")

puts "------------------------ Giving the departure Results -----------------------------"
puts

puts departure_table.attribute("innerHTML")
headless.destroy
