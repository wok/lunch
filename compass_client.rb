require 'pp'

class CompassClient < FoodClient

  RESTAURANTS = {
    quartetto_plus: {
      id: 3114,
      url: 'https://www.compass-group.fi/ravintolat-ja-ruokalistat/foodco/kaupungit/espoo/quartetto-plus/',
      name: 'Quartetto Plus'
    },
    q4a: {
      id: 3115,
      url: 'https://www.compass-group.fi/ravintolat-ja-ruokalistat/tastory/kaupungit/espoo/q4a/',
      name: 'Tastory'
    }

  }

  def initialize(restaurant, date = Date.today)
    data = RESTAURANTS[restaurant.to_sym]
    @restaurant_id = data[:id]
    @restaurant_name = data[:name]
    @restaurant_url = data[:url]
    @date = date
  end

  def load_menus
    response = RestClient.get(url(@restaurant_id, @date))
    data = JSON.parse(response.body)
    all_menus = data.dig('menus')
    @menus = []
    menus_for_day = find_day_menus(all_menus)
    return unless menus_for_day

    if menus_for_day['isManualMenu']
      process_manual_menus(menus_for_day['html'])
    else
      process_package_menus(menus_for_day['menuPackages'])
    end

  end

  def process_manual_menus(html)
    items = Nokogiri::HTML(html)
    items.search('p,br').each{ |i| i.after("\n")}
    items.text.split("\n").each do |item|
      next if item.strip == ''
      @menus.push(item)
    end
  end
  
  def process_package_menus(menus)
    menus.each do |menu|
      meals = menu['meals']
      next if meals.none?

      description = meals.map{ |meal| meal['name'] }.join(', ')
      @menus.push(description)
    end
  end

  def url(restaurant_id, date)
    "https://www.compass-group.fi/menuapi/week-menus?costCenter=#{restaurant_id}&date=#{date}&language=fi"
  end

  def find_day_menus(data)
    data.find{ |day_data| day_data.dig('date')&.start_with?(date.to_s) }
  end
  
end
