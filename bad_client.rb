class BadClient < FoodClient
  
  URL = 'https://europe-west1-luncher-7cf76.cloudfunctions.net/api/v1/week/a3618404-0e77-4e6a-bacb-125a4661dad5/active'

  def initialize(date = Date.today)
    @date = date
    @restaurant_name = "Bad Säteri 6"
    @restaurant_url = 'https://bad-ravintolat.fi/sateri6'
  end
  
  def load_menus
    @menus = []
    days = JSON.parse(RestClient.get(URL).body).dig('data', 'week', 'days')
    today = days.find { |day| DateTime.parse(day['date']).to_date == date }
    if today
      today.dig('lunches').each do |lunch|
        type = lunch['lunchType']
        next unless %['Lautanen', 'BAD Bowl', 'Kotiruoka'].include?(type)
        @menus.push("#{lunch.dig('title', 'fi')} (#{type})")
      end
    end
  end
end