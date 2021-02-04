class DylanClient < FoodClient
  
  URL = 'https://europe-west1-luncher-7cf76.cloudfunctions.net/api/v1/week/7e401791-d472-4ddb-bb11-bcdb9191ca92/active'

  def initialize(date = Date.today)
    @date = date
    @restaurant_name = "Dylan"
    @restaurant_url = "https://www.dylan.fi/lepuski"
  end
  
  def load_menus
    @menus = []
    days = JSON.parse(RestClient.get(URL).body).dig('data', 'week', 'days')
    today = days.find { |day| DateTime.parse(day['date']).to_date == date }
    if today
      today.dig('lunches').each do |lunch|
        type = lunch['lunchType']
        @menus.push(lunch.dig('title', 'fi'))
      end
    end
  end
end