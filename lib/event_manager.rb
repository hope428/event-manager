puts 'Event Manager Initialized!'
require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter



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
        ).officials
    rescue => exception
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
end

def save_thank_you_letter(id, form_letter)
    Dir.mkdir('output') unless Dir.exist?('output')
    filename = "output/thanks_#{id}.html"

    File.open(filename, 'w') do |file|
        file.puts form_letter
    end
end

def clean_phone(phone_number)
    if phone_number < 10
        nil
    elsif phone_number
end

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)
contents.each do |row|
    id = row[0]
    name = row[:first_name]
    zipcode = clean_zipcode(row[:zipcode])
    phone = row[:homephone]

    legislators = display_legislators(zipcode)
    
    form_letter = erb_template.result(binding)

    puts phone
    save_thank_you_letter(id, form_letter)
end