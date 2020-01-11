function manaSymbol(manaCost) {
    if (manaCost == null) {
        return null
    }

    var cleanString = manaCost.replace("{", "")
    var array = cleanString.split("}")
    var urlArray = []

    for (var i = 0; i < array.length; i++) {
        var cleanMana =  array[i].replace("}", "")

        if (cleanMana.toLowerCase() == "chaos") {
            cleanMana = "Chaos"
        }

        var url = "/images/mana/" + cleanMana + ".svg"
        urlArray[i] = url
    }

    return urlArray
}
