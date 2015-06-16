require "rebay"
require 'CSV'

Rebay::Api.configure do |rebay|
  rebay.app_id='gabeleit-8e5e-4fb6-9e88-96aa43460047'
end

finder=Rebay::Finding.new
print "enter keyword: "
keyword=gets.chomp.to_s
print "How Many Entries DO You Want(in 100s): "
pages=gets.chomp.to_i

responses=[]
volume=0

pages.times do |page_number|
  current_response=finder.find_items_by_keywords({:keywords => keyword, 'paginationInput.pageNumber' => page_number+1})
  volume = current_response.response["paginationOutput"]["totalEntries"].to_i
  responses=responses+(current_response.response["searchResult"]["item"])
end
puts responses.inspect

puts "\n\n\n"
puts responses.length

price=[]
sum=0
responses.length.times do |i|
  price_search=responses[i]["sellingStatus"]["convertedCurrentPrice"]["__value__"]
  price.push(price_search)
  sum+=price_search.to_f
end

average_price=sum/responses.length.to_f
puts"\n\n\n"
puts time = Time.now
puts average_price.to_i
puts volume.to_i

all_data=[time, average_price, volume]

f=File.new("colection_of_data.csv","a")
f.write(all_data.join(', ') + "\n")
f.close

