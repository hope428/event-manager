puts 'Event Manager Initialized!'
require 'csv'
require 'google/apis/civicinfo_v2'



def clean_zipcode(zipcode)
    # converts zipcode to string, uses rjust to ensure 5 characters, uses [0..4] to display only first 5 characters
    zipcode.to_s.rjust(5, '0')[0..4]
end

def display_legislators(zipcode)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

    begin
        legislators = civic_info.representative_info_by_address(
            address: zipcode,
            levels: 'country',
            roles: ['legislatorUpperBody', 'legislatorLowerBody']
        )
        legislators = legislators.officials
        legislators_names = legislators.map(&:name).join(", ")
    rescue => exception
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
end


contents = CSV.open('../event_attendees.csv', headers: true, header_converters: :symbol)
contents.each do |row|
    name = row[:first_name]
    zipcode = clean_zipcode(row[:zipcode])

    legislators_names = display_legislators(zipcode)
    

    puts "#{name} #{zipcode} #{legislators_names}"
end