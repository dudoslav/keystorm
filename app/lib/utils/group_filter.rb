require 'yaml'

module Utils
  class GroupFilter
    MAP_FILE_PATH = Rails.configuration.keystorm['map_file'].freeze

    def initialize
      load_mapfile
    end

    def run!(groups)
      return groups unless @mapfile

      groups.each_with_object(groups) do |(key, val), hash|
        maped = @mapfile[key]
        hash[key] = val & maped if maped
      end

      groups.delete_if { |_, val| val == [] }
    end

    private

    def load_mapfile
      if MAP_FILE_PATH.present?
        @mapfile = YAML.safe_load(File.read(MAP_FILE_PATH)) if MAP_FILE_PATH
      else
        Rails.logger.warn('No mapfile given') unless MAP_FILE_PATH
      end
    end
  end
end
