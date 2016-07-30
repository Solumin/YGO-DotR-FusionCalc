## Yu-Gi-Oh! Duelists of the Roses Fusion Calculator

This project is based on my [Fusion
Calculator](https://solumin.github.io/YGO-FM-FusionCalc/) for Yu-Gi-Oh!
Forbidden Memories. It serves the same purpose: allowing players to easily
discover which fusions they have available.

The calculator is hosted [as a GithHub
Page](https://solumin.github.io/YGO-DotR-FusionCalc/).

### Contributing

Feel free to fork and send in pull requests. There are many fusions that were
included in the database without being tested. Feel free to open an issue to
confirm any of the fusions.

### Project Notes

The `data` directory contains the databases used by the app.

- `fusions_raw.txt` is a raw dump of the
[Fusion FAQ](https://www.gamefaqs.com/ps2/589455-yu-gi-oh-the-duelists-of-the-roses/faqs/22087)
by Steve Kalynuik.  It should not be used directly, and only exists as a base for
creating the CSVs used to build the actual databases. It has been edited and
proofread for misspelled card names, poorly formatted entries, and other such
errors.
- `cards.csv`, `fusions.csv` and `equips.csv` list the cards, fusions and
  equipment fusions in the game. They are semicolon-separated values, not
strictly CSVs. This helps avoid ambiguity when processing the files.
- The files prefixed with `ygo_dotr_` are the databases created from the CSV
  files. The `.json` files are formatted as arrays of JSON objects, and the
`.js` files load these arrays into TaffyDB objects for use in scripts.

There are a few important scripts in the `scripts` directory:
- `make_carddb.rb` reads the `cards.csv` and produces the
  `ygo_dotr_cardDB.js[on]` files.
- `make_fusiondb.rb` and `make_equipdb.rb` do the same for the fusion and equip
  DBs.
- `make_fusion_from_raw.rb` creates the JS, JSON and CSV files from
  `fusions_raw.txt` and **should not be used unless necessary**. You're better
off rolling back whatever commit broke the databases.

## Special Thanks:

- Steve Kalynuik for the [Fusion
  FAQ](https://www.gamefaqs.com/ps2/589455-yu-gi-oh-the-duelists-of-the-roses/faqs/22087), an invaluable resource
- The Yu-Gi-Oh! Wikia, for the list of cards that I turned into the card
  database

