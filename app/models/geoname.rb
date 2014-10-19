require 'json'
require 'ostruct'
require 'rest-client'

class Geoname < OpenStruct
  USERNAME = ENV['GEONAMES_USERNAME']
  module ClassMethods
    alias_method :configure, :tap

    def search(coords, zoom)
      search = Search.prepare(coords, zoom)
      search.execute
    end
  end

  extend ClassMethods

  class Search
    attr_accessor :coords, :zoom

    def self.prepare(coords, zoom)
      new.tap do |search|
        search.coords = coords
        search.zoom = zoom
      end
    end

    def execute
      query = Query.prepare(coords, zoom)
      query.execute
    end
  end

  class Query
    attr_accessor :coords, :zoom

    def self.prepare(coords, zoom)
      new.tap do |query|
        query.coords= coords
        query.zoom = zoom
      end
    end

    def execute
      resolver.execute
    end

    def resolver
      case level
      when :wiki
        Wiki.prepare(coords)
      else
        Point.prepare(coords, level)
      end
    end

    def level
      case
      when zoom > 15
        :wiki
      when zoom > 10
        :locality
      when zoom > 6
        :region
      else
        :country
      end
    end
  end

  class Fetcher
    attr_accessor :url, :query

    def self.prepare(url, query)
      new.tap do |fetcher|
        fetcher.query = query
        fetcher.url = url
      end
    end

    def execute
      RestClient.get(url, params: params) { |data| JSON[data] }
    end

    def params
      { username: Geoname::USERNAME }.merge(query)
    end
  end

  class Wiki
    attr_accessor :coords

    def self.prepare(coords)
      new.tap do |query|
        query.coords= coords
      end
    end

    def execute
      fetch = Fetcher.prepare(url, coords)
      parse fetch.execute
    end

    def parse(data)
      Geoname.new(data['geonames'].sort { |d| d['rank'] }.first)
    end

    def url
      "api.geonames.org/findNearbyWikipediaJSON"
    end
  end

  class Point
    attr_accessor :coords, :level

    def self.prepare(coords, level)
      new.tap do |query|
        query.coords= coords
        query.level = level
      end
    end

    def execute
      fetch = Fetcher.prepare(url, coords)
      parse fetch.execute
    end

    def parse(data)
      coords = {lat: data['geonames'][0]['lat'], lng: data['geonames'][0]['lng'] }
      wiki = Wiki.prepare(coords)
      wiki.execute
    end

    def params
      feature(zoom).merge(coords)
    end

    def feature
      case level
      when :locality
        { featureCode: 'ADM2' }
      when :region
        { featureCode: 'ADM1' }
      when :country
        { featureCode: 'PCLI' }
      end
    end

    def url
      "api.geonames.org/findNearbyJSON"
    end
  end
end
