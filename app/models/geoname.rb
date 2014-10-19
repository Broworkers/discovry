require 'json'
require 'ostruct'
require 'rest-client'
require 'forwardable'

class Geoname < OpenStruct
  URL = "http://api.geonames.org/searchJSON"

  def self.configure(username)
    @username = username
  end

  def self.search(coords, zoom)
    Query.prepare(@username, coords, zoom)
  end

  class Query
    extend Forwardable
    attr_accessor :username, :coords, :zoom, :results
    delegate [:map, :each, :any?] => :execute

    def self.prepare(username, coords, zoom)
      new.tap do |query|
        query.username = username
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
        'adm1'
      when zoom > 5
        'adm2'
      else
        'pcli'
      end
    end
  end
end
