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

function invokeSorter(action, target, value) {
    document.getElementById(action + "." + target).value = value
    var notEmpty = true

    const elements = document.getElementById(action).elements
    for (var i = 0; i < elements.length; i++) {
        const item = elements.item(i)

        if (item.value == null || item.value.length <= 0) {
            notEmpty = false
            break
        }
    }

    if (notEmpty) {
        document.getElementById(action).submit();
    }
}