require 'json'
require 'ostruct'
require 'rest-client'
require 'forwardable'
require 'singleton'

class Geoname < OpenStruct
  URL = "http://api.geonames.org/searchJSON"

  def self.configure(&block)
    Config.instance.tap(&block)
  end

  def self.search(coords, zoom)
    Query.prepare(Config.instance, coords, zoom)
  end

  class Config
    include Singleton
    attr_accessor :username
  end

  class Query
    extend Forwardable
    attr_accessor :username, :coords, :zoom, :results
    delegate [:map, :each, :any?] => :execute

    def self.prepare(config, coords, zoom)
      new.tap do |query|
        query.username = config.username
        query.coords = coords
        query.zoom = zoom
      end
    end

    private
    def execute
      @results ||= raw.collect { |data| Geoname.new(data) }
    end

    def raw
      RestClient.get(url, params: params) { |data| JSON[data]['geonames'] }
    end

    def params
      { username: username, featureCode: level }.merge(coords)
    end

    def url
      Geoname::URL
    end

    def level
      case
      when zoom > 10
        'adm2'
      when zoom > 5
        'adm1'
      else
        'pcli'
      end
    end
  end
end
