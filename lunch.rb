#! /usr/bin/env ruby

require 'bundler/setup'
Bundler.require

require_relative 'food_client'
require_relative 'food_co_client'
require_relative 'dylan_client'
require_relative 'tastory_client'
require_relative 'compass_client'

clients = [
  CompassClient.new('q4a'),
  DylanClient.new,
  CompassClient.new('quartetto_plus')
]

clients.each do |client|
  client.load_menus_with_rescue
  client.post_to_slack
end
