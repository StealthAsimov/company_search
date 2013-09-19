# encoding: utf-8
require 'open-uri'
require 'nokogiri'

protocol = 'http'
host = 'localhost'
port = 3000
path = '/companies/org_number'
company = 'company'

ARGV.each do |a|
  url = "#{protocol}://#{host}:#{port}#{path}?#{company}=#{a.gsub(' ', '+')}"
  puts url
  doc = Nokogiri::HTML(open(url))
  org_number = doc.at_css('body').text.match(/"([0-9]+\-[0-9ORX]+)"/)
  puts org_number
end
