require 'awesome_print'
require 'terminal-table'

class Gemsi
  class << self
    def main
      strings = parse_gemfile
      gems_strings = descriptions_hash(strings)
      print_description_table(gems_strings)

      puts
      puts "Gemsi generator tool, https://github.com/phlowerteam/gemsi, MIT License, (c) 2014 PhlowerTeam"
      puts
    end

    private

    def parse_gemfile(path=nil)
      gemfile = path ? path : 'Gemfile'
      IO.read(gemfile).split("\n").map do |string|
        string.match(/^\s*(gem|group|ruby)/) ? {text: string, is_parsed: true} : {text: string, is_parsed: false}
      end
    end

    def descriptions_hash(strings=[])
      results = []
      strings.each do |string|
        substrings = string[:text].match(/^\s*gem\s*\'([-_\w\d]*)\'/)
        gem_name = substrings ? substrings[1] : nil
        if substrings && gem_name
          begin
            raise if gem_name.match(/(swagger|directory|ads|shop|activeadmin)/)

            spec = Gem::Specification::find_by_name(gem_name)
            if spec
              results << get_description(gem_name, spec).merge({is_parsed: string[:is_parsed]})
            end
          rescue
            results << string
          ensure
          end
        else
          results << string
        end
      end
      results
    end

    def get_description(gem_name, spec)
      result = {
        gem_name:      gem_name,
        version:       spec.version.to_s,
        summary:       spec.summary,
        description:   spec.description,
        homepage:      spec.homepage,
        github_search: "https://github.com/search?q=#{gem_name}&ref=cmdform"
      }

      result[:full_description] = if result[:description] == result[:summary]
         result[:description]
      else
         "#{result[:description]} #{result[:summary]}"
      end
      result[:github_search] = result[:homepage].match(/github/) ? " ": "https://github.com/search?q=#{gem_name}&ref=cmdform"
      result
    end

    def print_description_table(strings, short=false)
      table = Terminal::Table.new
      strings.each do |str|
        if str[:is_parsed] && str[:text].to_s != ''
          ap str[:text]
          puts table unless table.rows.empty?
          table = Terminal::Table.new
        elsif str[:is_parsed]
          if short
            table.add_row ["#{str[:gem_name]} #{str[:version]}", str[:summary].scan(/.{0,80}/).join("\n")]
          else
            table.add_row ["#{str[:gem_name]} #{str[:version]}", str[:full_description].scan(/.{0,80}/).join("\n") + "#{str[:homepage]}\n#{str[:github_search]}\n\n"]
            table.add_row [" ", " "]
          end
        end
      end
      puts table unless table.rows.empty?
    end
  end
end

Gemsi.main