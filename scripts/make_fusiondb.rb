require "json"

# The approach here is a simple state machine. There are 4 kinds of lines in the
# file:
# 1) Monster headers: Monster Name (Att/Def) ###
# These can also be equips, traps, etc.: Card Name (Type) ###
# 2) Horizontal lines: Follow immediately after monster headers. Just a bunch of
# hyphens in a row.
# 3) Fusion entries: Monster Name (Att/Def) = Monster Name (Att/Def)
# Some are just "monster can equip this": Card Name (Type)
# Unlike Forbidden Memories, non-monster cards don't have any fusions
# 4) Blank lines. These separate entries and reset the state machine.
# File format is therefore:
#   Monster Header
#   --------------
#   Entries...
#   <blank line>
# And so on.
# The fusion database is as so:
#   (left, right, output, attack, defense, type, # untested)

fusions = []
equips = []
# States: :header, :sep, :entries. Empty line resets.
state = :header
header = ""

def process_entry(line, leftside)
    untested = false
    if line.start_with? "*** " # untested fusion
        line = line[4..-1] # remove that bit
        untested = true
    end

    if line.include? "=" # it's a full fusion
        rightside, output = line.split("=").map(&:strip)
        # We only care about the name of the right input
        rpindex = rightside.rindex " "
        rname = rightside[0..(rpindex-1)]
        # We *do* care about the output's stats, if it has any
        opindex = output.rindex " "
        out_name = output[0..(opindex)].strip

        if output.include? "/" # it's a monster
            stats = (output.match /\((\d+)\/(\d+)\)/)[1,2].map(&:to_i)
            {:left => leftside, :right => rname, :output => out_name, :attack =>
             stats[0], :defense => stats[1], :type => "Monster", :untested => untested}
        else # it's not a monster
            matches = (output.match /\(([^)]+)\)/)
            type = matches[1]
            {:left => leftside, :right => rname, :output => out_name, :attack =>
             0, :defense => 0, :type => type, :untested => untested}
        end
    else # It's just an equipment "fusion"
        pindex = line.rindex " "
        name = line[0..(pindex-1)]

        {:left => leftside, :right => name, :type => "Equippable", :untested => untested}
    end
end

File.open("data/fusions_raw.txt").each do |line|
    line.strip!
    if state == :header
        pindex = line.index "("
        header = line[0..(pindex-2)]
        state = :sep
    elsif state == :sep
        raise "Desyncronized while reading the file" unless line[0] == "-"
        state = :entries
    elsif line == "" # empty line, get ready for next block
        state = :header
    else
        entry = process_entry(line, header)
        if entry[:type] == "Equippable"
            equips << entry
        else
            fusions << entry
        end
    end
end

puts "Processed #{fusions.count} fusions"

File.open("data/ygo_dotr_fusionDB.js", "w") {|file|
    file.write("var fusionDB = TAFFY(#{JSON.pretty_generate(fusions)})")
}

File.open("data/ygo_dotr_fusionDB.json", "w") {|file|
    file.write(JSON.pretty_generate fusions)
}

File.open("data/fusions.csv", "w") {|file|
    file.write(fusions.map{|f| f.values.join ";"}.join "\n")
}

puts "Wrote JSON, JS and CSV files"

puts "Processed #{equips.count} equipment fusions"

File.open("data/ygo_dotr_equipDB.js", "w") {|file|
    file.write("var equipDB = TAFFY(#{JSON.pretty_generate(equips)})")
}

File.open("data/ygo_dotr_equipDB.json", "w") {|file|
    file.write(JSON.pretty_generate equips)
}

File.open("data/equips.csv", "w") {|file|
    file.write(equips.map{|f| f.values.join ";"}.join "\n")
}

puts "Wrote JSON DB js file"
