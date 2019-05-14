class FoodCoClient < FoodClient
  
  def initialize(restaurant, date = Date.today)
    restaurants = {
      quartetto_plus: 3114,
      gongi: 3110
    }
    @restaurant_id = restaurants[restaurant.to_sym]
    @date = date
  end

  def load_menus
    response = RestClient.get(url(@restaurant_id, @date))
    data = JSON.parse(response.body)
    @restaurant_name = data['RestaurantName']
    @restaurant_url = data['RestaurantUrl']

    current_menus = data['MenusForDays'].first
    @menus = []
    menu_types = [
      'Vegaaninen kasvislounas',
      'Lounasbuffet',
      'Grillistä',
      'Fresh buffet-salaatti',
      'Jälkiruoka'
    ]
    return unless current_menus['Date'] == "#{@date}T00:00:00"

    current_menus['SetMenus'].each do |menu|
      name = menu['Name']
      next if name != nil && menu_types.include?(name.upcase)

      @menus.push( menu['Components'].map { |dish| clean_name(dish) }.join(', '))
    end
  end

  def url(restaurant_id, date)
    "https://www.fazerfoodco.fi/modules/json/json/Index?costNumber=#{restaurant_id}&firstDay=#{date}&lastDay=#{date}&language=fi"
  end

  def clean_name(name)
    name.gsub(/(\(.*\))/, '').strip
  end
end
