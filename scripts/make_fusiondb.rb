require "json"

def make_entry(fields)
    {
        :left => fields[0],
        :right => fields[1],
        :output => fields[2],
        :attack => fields[3].to_i,
        :defense => fields[4].to_i,
        :type => fields[5],
        :untested => if fields[6] == "true" then true else false end
    }
end

fusions = File.readlines("data/fusions.csv").map do |line|
    make_entry(line.strip.split(";"))
end

puts "Processed #{fusions.count} fusions"

File.open("data/ygo_dotr_fusionDB.js", "w") {|file|
    file.write("var fusionDB = TAFFY(#{JSON.pretty_generate(fusions)})")
}

File.open("data/ygo_dotr_fusionDB.json", "w") {|file|
    file.write(JSON.pretty_generate fusions)
}

puts "Wrote JSON and JS files"
