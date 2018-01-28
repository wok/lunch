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
    items.each do |item|
      rows = item.inner_html.split('<br>')
      day = rows[0]
      next unless day.include?(today)
      rows[1..-1].each do |row|
        row = row.gsub(/\(.*/, '').strip
        next if row == ''
        @menus.push(row)
      end
    end
  end
  
  def rss(restaurant_id)
    "https://www.fazer.fi/api/location/menurss/current?pageId=#{restaurant_id}&language=fi"
  end
  
end
