class FazerClient < FoodClient
  
  def initialize(restaurant_id, date = Date.today)
    restaurants = {
      q4a: { id: 184703, code: 'ravintola-q4a', name: 'Fazer Q4A' }
    }
    restaurant = restaurants[restaurant_id.to_sym]
    @restaurant_id = restaurant[:id]
    @restaurant_url = "https://www.fazer.fi/kahvilat-ja-leipomot/ravintolat/byfazer/#{restaurant[:code]}"
    @restaurant_name = restaurant[:name]
    @date = date
  end

  def load_menus
    response = RestClient.get(rss(@restaurant_id))
    doc = Nokogiri::XML(response.body)
    content = doc.xpath('(//item//description)[1]').text
    return unless content
    doc = Nokogiri::HTML(content)
    items = doc.css('p')
    today = local_weekday
    @menus = []
    items.each_with_index do |item, index|
      if item.css('strong') && item.css('strong').text.include?(today)
        actual_menus = items[index+1].inner_html.split('<br>')[1..-1]
        actual_menus.each do |menu|
          menu = menu.strip
          next if menu == '' || menu.include?('strong')
          menu = menu.gsub(/ \(.*\)/, '')
          @menus.push(menu)
        end
      end
    end
  end
  
  def rss(restaurant_id)
    "https://www.fazer.fi/api/location/menurss/current?pageId=#{restaurant_id}&language=fi"
  end
  
end
