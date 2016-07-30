# The goal of this script is to make sure the names in the monster fusion
# database are consistent with those in the card database, since they're from
# two different sources.
# All it needs to do is find differing names, or rather, names that aren't in
# the card database. I'll fix them manually.

# Algorithm: Find all the (unique) names in the fusion database, then search for
# each name in the card database. If the name isn't found, print it out.

require 'set'
require 'json'
# set of names found in the monster fusion database:
names = Set.new

def get_name(line)
    pindex = line.index "("
    if pindex.nil?
        puts line
        exit
    end
    line[0..(pindex-2)]
end

File.open("data/fusions_raw.txt").each do |line|
    line.strip!
    if line.empty? or line[0] == "-"
        next
    end
    if line.start_with? "*** "
        line = line[4..-1]
    end
    if line.include? "="
        left, right = line.split("=").map(&:strip)
        names << get_name(left)
        names << get_name(right)
    else
        names << get_name(line)
    end
end

puts "Found #{names.size} unique names in fusion list"

puts "Loading card database..."
cardnames = JSON.parse(File.read("data/ygo_dotr_cardDB.json")).map{|c| c["name"]}.sort
puts "Loaded #{cardnames.size} cards"

bad_names = []
names.each do |name|
    bad_names << name unless cardnames.include? name
    # if cardnames.bsearch{|c| name.upcase <=> c}.nil?
    #     bad_names << name
    # end
end
puts "\nFound #{bad_names.size} unknown names"
File.open("data/bad_names.txt","w"){|f| f.write(bad_names.sort.join "\n")}
puts "Wrote bad names to data/bad_names.txt"
