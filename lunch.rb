#! /usr/bin/env ruby

require 'bundler/setup'
Bundler.require

require_relative 'food_client'
require_relative 'amica_client'
require_relative 'dylan_client'

DylanClient.new('lepuski').post_to_slack

%i(quartetto_plus gongi).each do |restaurant|
  AmicaClient.new(restaurant).post_to_slack
end

