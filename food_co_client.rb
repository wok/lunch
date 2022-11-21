class FoodCoClient < FoodClient
  
  def initialize(restaurant, date = Date.today)
    restaurants = {
      quartetto_plus: {
        id: 262191,
        url: 'https://www.foodandco.fi/ravintolat/Ravintolat-kaupungeittain/espoo/quartetto-plus/',
        name: 'Quartetto Plus'
      }
    }
    @restaurant_id = restaurants[restaurant.to_sym][:id]
    @restaurant_name = restaurants[restaurant.to_sym][:name]
    @restaurant_url = restaurants[restaurant.to_sym][:url]
    @date = date
  end

  def load_menus
    response = RestClient.get(url(@restaurant_id, @date))
    data = JSON.parse(response.body)
    puts date.strftime('%d.%m.%Y')

    day_menus = data.dig('LunchMenus').find { |day| day['Date'] == date.strftime('%d.%m.%Y')}
    return unless day_menus

    @menus = []
    menu_types = [
      'Vegaaninen kasvislounas',
      'Lounasbuffet',
      'Grillistä',
      'Fresh buffet-salaatti',
      'Jälkiruoka'
    ]

    day_menus['SetMenus'].each do |menu|
      next unless menu['Name']
      items = menu['Meals'].map{ |item| item['Name'] }
      @menus.push(items.join(', '))
    end
  end

  def url(restaurant_id, date)
    "https://www.foodandco.fi/api/restaurant/menu/week?language=fi&restaurantPageId=262191&weekDate=#{date}"
  end

  def clean_name(name)
    name.gsub(/(\(.*\))/, '').strip
  end
end
