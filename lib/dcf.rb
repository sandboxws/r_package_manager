require "yaml"
# Parser for Debian Control Files (http://www.debian.org/doc/debian-policy/ch-controlfields.html)
# Piggybacks on the stdlib YAML parser, so this only works as long as there is a
# space after the field names (this is a stated DCF convention). You'll encounter problems if
# there are unescaped colons in the values.
#
# I've also built a full Treetop grammar for DCF: http://github.com/Chrononaut/treetop-dcf

module Dcf
  # Returns an array of { attr => val } hashes
  def self.parse(input)
    input.split("\n\n").collect { |p| YAML.load(p) }
  end
end
