puts 'Event Manager Initialized!'
require 'csv'

def clean_zipcode(zipcode)
    if zipcode == nil
        zipcode = "00000"
    elsif zipcode.length < 5
        until zipcode.length == 5
            zipcode.prepend("0")
        end
    elsif zipcode.length > 5
        zipcode = zipcode[0...4]
    end

    zipcode
end


contents = CSV.open('../event_attendees.csv', headers: true, header_converters: :symbol)
contents.each do |row|
    name = row[:first_name]
    zipcode = clean_zipcode(row[:zipcode])

    puts "#{name} #{zipcode}"
end