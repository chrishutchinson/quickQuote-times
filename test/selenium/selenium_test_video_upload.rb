#!/usr/bin/env ruby
=begin
a selenium script to check the video upload user journey.
uploading a sample video `test_video.mp4`
=end

# to run it, rails server needs to be running
# ruby test/selenium/selenium_test_video_upload.rb



# Requires rails enviroment

#!/usr/bin/env ruby
require_relative '../../config/environment.rb'
puts Rails.env

require "selenium-webdriver"
# require File.expand_path('/app/config/environment', __FILE__)

#timer
wait = Selenium::WebDriver::Wait.new(:timeout => 60) # seconds

#Login into your app to save the Google two factor autentication.
# refactor to print out where at int he various stages of the test on console

driver = Selenium::WebDriver.for :firefox

# Navigate to page
driver.navigate.to ENV['LOCAL_DOMAIN']

#Sign up
# gets all the elemnets button
elements = driver.find_elements(:class => 'btn-lg')
# narrows down to first element
element=elements[0]
# check that that btn is the one with the sign up writing
element.text == "SIGN UP"
# clicks on it to move on
element.click

# email
email = driver.find_element(:id => 'Email')
# using a dummy email withouth two factor autentication
email.send_keys ENV['TEST_EMAIL']

next_btn = driver.find_element(:id => 'next')
next_btn.click

# password
wait.until { password = driver.find_element(:id => 'Passwd')}
password = driver.find_element(:id => 'Passwd')
password.send_keys ENV['TEST_EMAIL_PASSWORD']

signin=driver.find_element(:id => "signIn")
signin.click()


# click on vieo uploads in navbar
new_video_uplaod = driver.find_element(:id => "newVideoUpload")
new_video_uplaod.click()

#on video upload page
# setting a variable for video
@video_title = "Test Video - Selenium Script"

#filling in video title details

wait.until { driver.find_element(:id => "video_title")}
video_title_field = driver.find_element(:id => "video_title")
video_title_field.send_keys "Test Video - Selenium Script"

# Uploading video
# @path_to_video_file = Rails.root.join( "test","selenium","test_video.mp4").to_s
video_media_file =driver.find_element(:id => "video_media")
# replace this with absolute path tto video
video_media_file.send_keys Rails.root.join('test', 'selenium', 'test_video.mp4').to_s
# saving

save_btn = driver.find_element(:id => "saveBtn")
save_btn.click

# on video show page ,check video can play
video_player = driver.find_element(:id => "video_player")

# Next step before quitting would be retrieving uid of last video uploaded
# and making API call to delete recording.

driver.quit
