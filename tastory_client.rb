require 'json'

class TastoryClient < FoodClient
  
  def initialize(restaurant, date = Date.today)
    restaurants = {
      q4a: 215599
    }
    @restaurant_id = restaurants[restaurant.to_sym]
    @date = date
  end

  def load_menus
    response = RestClient.get(url(@restaurant_id, @date))
    data = JSON.parse(response.body)
    page = Nokogiri::HTML(data['LunchMenu']['Html'].gsub('&nbsp;', ' '))
    @menus = []
    page.xpath('//p').each do |item|
      next if item.content.strip == '' || item.content == local_weekday
      @menus.push(item.content)
    end
  end
  
  def url(restaurant_id, date)
    "http://www.tastory.fi/api/restaurant/menu/day?date=#{date}&language=fi&restaurantPageId=#{restaurant_id}"
  end
  
  def clean_name(name)
    name.gsub(/(\(.*\))/, '').strip
  end
  
end
