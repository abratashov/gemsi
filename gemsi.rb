# frozen_string_literal: true

class Gemsi
  GEM_LINE_PATTERN = /^\s*(gem|group|ruby)/.freeze
  GEM_NAME_PATTERN = /^\s*gem\s*[\'\"]([-_\w\d]*)[\'\"]/.freeze

  class << self
    def main
      gems = parsed_gems
      gem_names_arr = []
      gems.each do |gem|
        next if !gem[:is_parsed] || gem[:name].nil?

        gem_names_arr << gem[:name]
        gem[:spec] = gems_descriptions.detect { |description| description[:name] == gem[:name] }
      end
      name_size = gem_names_arr.max_by(&:length).size
      print_descriptions(gems, name_size)

      puts
      puts "Gemsi generator tool, https://github.com/phlowerteam/gemsi, MIT License, (c) 2020 PhlowerTeam"
      puts
    end

    private

    def parsed_gems(path = nil)
      gemfile = path || 'Gemfile'
      IO.read(gemfile).split("\n").map do |string|
        is_parsed = string.match(GEM_LINE_PATTERN) ? true : false
        name = is_parsed ? string.match(GEM_NAME_PATTERN)&.send(:[], 1) : nil
        { text: string, name: name, is_parsed: true }
      end
    end

    def gems_descriptions
      @gems_descriptions ||= Gem::Specification.all.map { |spec| build_description(spec) }
    end

    def build_description(spec)
      result = {
        name: spec.name,
        version: spec.version.to_s,
        summary: spec.summary,
        description: spec.description,
        homepage: spec.homepage,
        github_search: "https://github.com/search?q=#{spec.name}&ref=cmdform"
      }

      result[:full_description] = if result[:description] == result[:summary]
                                    result[:description]
                                  else
                                    "#{result[:description]} #{result[:summary]}"
      end
      result[:github_search] = result[:homepage]&.match(/github/) ? ' ' : "https://github.com/search?q=#{spec.name}&ref=cmdform"
      result
    end

    def print_descriptions(gems, name_size = 20)
      gems.each do |gem|
        next unless gem[:is_parsed]

        puts gem[:name].ljust(name_size).to_s if gem[:name]
        if gem[:spec].nil?
          gem[:text].scan(/.{0,80}/).each do |part|
            puts "#{' ' * name_size}#{part}"
          end
        else
          puts "#{' ' * name_size}#{gem[:spec][:version]} "
          gem[:spec][:full_description].scan(/.{0,80}/).each do |part|
            puts "#{' ' * name_size}#{part}"
          end
          if gem[:spec][:homepage]
            puts "#{' ' * name_size}#{gem[:spec][:homepage]}\n"
            puts "#{' ' * name_size}#{gem[:spec][:github_search]}\n"
          end
        end
      end
    end
  end
end

Gemsi.main
