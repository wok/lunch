#! /usr/bin/env ruby

require 'bundler/setup'
Bundler.require

require_relative 'food_client'
require_relative 'amica_client'

%i(quartetto_plus gongi).each do |restaurant|
  AmicaClient.new(restaurant).post_to_slack
end

