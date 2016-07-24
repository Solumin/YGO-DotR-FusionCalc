require "json"

cards = []

File.readlines("data/cards.csv").each do |line|
    fields = line.strip.split ";"
    props = {
        :number => fields[0],
        :name => fields[1],
        :deckcost => fields[2],
        :cardtype => fields[3],
    }
    if props[:cardtype] == "Monster"
        props[:attribute] = fields[4]
        props[:type] = fields[5]
        props[:level] = fields[6].to_i
        props[:attack] = fields[7].to_i
        props[:defense] = fields[8].to_i
        props[:effect] = fields[9] || "" # may be empty
    else
        props[:effect] = fields[4]
    end
    cards << props
end

puts "Processed #{cards.count} cards"

File.open("data/ygo_dotr_cardDB.js", "w") {|file|
    file.write("var cardDB = TAFFY(#{JSON.pretty_generate(cards)})")
}

File.open("data/ygo_dotr_cardDB.json", "w") {|file|
    file.write(JSON.pretty_generate(cards))
}

puts "Wrote JS and JSON files"
