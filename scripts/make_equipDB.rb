require "json"

def make_entry(fields)
    raise ArgumentError, "Expected 4 fields #{fields}" unless fields.count == 4
    {
        :left => fields[0],
        :right => fields[1],
        :type => fields[2],
        :untested => if fields[3] == "true" then true else false end
    }
end

equips = File.readlines("data/equips.csv").map do |line|
    make_entry(line.strip.split(";"))
end

puts "Processed #{equips.count} equips"

File.open("data/ygo_dotr_equipDB.js", "w") {|file|
    file.write("var equipDB = TAFFY(#{JSON.pretty_generate(equips)})")
}

File.open("data/ygo_dotr_equipDB.json", "w") {|file|
    file.write(JSON.pretty_generate equips)
}

puts "Wrote JSON and JS files"
