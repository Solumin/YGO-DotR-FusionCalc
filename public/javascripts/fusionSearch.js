var nameInput = document.getElementById("cardname");

var outputMonster = document.getElementById("outputarealeft");
var outputGeneral = document.getElementById("outputarearight");
var outputCard = document.getElementById("outputcard");

// Initialize awesomplete
var cardNameCompletion = new Awesomplete(nameInput,
        {
            list: cardDB().get().map(c => c.name),  // list is all the cards in the DB
            autoFirst: true,                        // The first item in the list is selected
            filter: Awesomplete.FILTER_STARTSWITH   // case insensitive from start of word
        });
$("#cardname").on("change", function() {
    cardNameCompletion.select(); // select the currently highlighted item, e.g. if user tabs
    resultsClear();
    searchByName();
});
$("#cardname").on("awesomplete-selectcomplete", function() {
    resultsClear();
    searchByName();
});

function fusesToHTML(fuselist) {
    return fuselist.map(function(fusion) {
        var res = "<div class='result-div'>Left Input: " + fusion.left + "<br>Right Input: " + fusion.right;
        if (fusion.type === "Monster") {
            res += "<br>Output: " + fusion.output;
            res += " (" + fusion.attack + "/" + fusion.defense + ")";
        } else if  (fusion.type !== "Equippable") {
            res += "<br>Output: " + fusion.output + " (" + fusion.type + ")";
        } // Equippable fusions (from equipDB) have no output, just left and right

        if (fusion.untested) {
            res += "<br><div class='untested-fusion'>UNTESTED</div>";
        }
        return res + "<br><br></div>";
    }).join("\n");
}

function searchByName() {
    resultsClear();

    if (nameInput.value === "") {
        console.log("Please enter a search term");
        $("#search-msg").html("Please enter a search term");
        return;
    }

    var card = cardDB({name:{isnocase:nameInput.value}}).first();
    if (!card) {
        console.log(nameInput.value + " is an invalid name");
        $("#search-msg").html("No card for '" + nameInput.value + "' found");
        return;
    } else {
        if (card.cardtype === "Monster") {
            // Display card beside search bar
            outputCard.innerHTML = "<div class='result-div'>" + "Name: " +
                card.name + "<br>" + "ATK/DEF: " + card.attack + "/" +
                card.defense + "<br>" + "Attribute: " + card.attribute +
                "<br>" + card.effect + "</div>";
        } else {
            outputCard.innerHTML = "<div class='result-div'>" + "Name: " +
                card.name + "<br>" + "Type: " + card.cardtype +
                "<br>" + card.effect + "</div>";
        }
    }

    // Get the list of monster-to-monster fusions
    var monfuses = fusionDB({left:{isnocase:card.name}});
    var equips = equipDB([{left:{isnocase:card.name}}, {right:{isnocase:card.name}}]);

    if (monfuses.count() > 0) {
        outputMonster.innerHTML = "<h2 class='center'>Monster Fuses:</h2>";
        outputMonster.innerHTML += fusesToHTML(monfuses.get());
    }
    if (equips.count() > 0) {
        outputGeneral.innerHTML = "<h2 class='center'>General Fuses:</h2>";
        outputGeneral.innerHTML += fusesToHTML(equips.get());
    }
}

document.getElementById("searchNameBtn").onclick = function() {
    $("#search-msg").html("");
    cardNameCompletion.select(); // select the currently highlighted item
    resultsClear();
    searchByName();
}

// runs search function on every keypress in #cardname input field
// $("#cardname").keyup(function (){
//     searchDB();
// });

document.getElementById("resetBtn").onclick = function() {
    nameInput.value = "";
    outputMonster.innerHTML = "";
    outputGeneral.innerHTML = "";
    $("#search-msg").html("");
}

function resultsClear(){
    outputMonster.innerHTML = "";
    outputGeneral.innerHTML = "";
}
