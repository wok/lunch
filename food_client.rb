class FoodClient

  attr_accessor :restaurant_name
  attr_accessor :restaurant_url
  attr_accessor :menus
  attr_accessor :date
  
  def post_to_slack
    webhook = ENV['FOOD_SLACK_URL']

    if menus.any?
      menu_items = menus.map { |n| "> #{n}" }.join("\n")
    else
      menu_items = '> No menu available'
    end

    if ENV['FOOD_DEBUG']
      puts "#{restaurant_name} #{restaurant_url}\n#{menu_items}"
    else
      data = {
        text: "<#{restaurant_url}|#{restaurant_name}>\n" + menu_items
      }

      RestClient.post webhook, data.to_json, content_type: :json
    end
  end

  def local_weekday
    weekdays = %w[Sunnuntai Maanantai Tiistai Keskiviikko Torstai Perjantai Lauantai]
    weekdays[date.wday]
  end

  def load_menus_with_rescue
    load_menus
  rescue StandardError => e
    puts e.message
    puts e.backtrace
    @menus = [e.message]
  end
  
end