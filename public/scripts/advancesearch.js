let i = 0; // query fields sentinel

function addFilter(label, value) {
    let queryFields = document.getElementById("queryFields")
    let id = "Filter_" + i

    let field = document.createElement("div")
    field.setAttribute("class", "field")
    field.setAttribute("id", id)
    queryFields.appendChild(field)

    let fields = document.createElement("div")
    fields.setAttribute("class", "fields")
    field.appendChild(fields)

    let wideField = document.createElement("div")
    wideField.setAttribute("class", "twelve wide field")
    fields.appendChild(wideField)

    let filter = document.createElement("input")
    filter.setAttribute("type", "text")
    filter.setAttribute("Placeholder", label + "_" + i)
    filter.setAttribute("id", label + "_" + i)
    wideField.appendChild(filter)

    wideField = document.createElement("div")
    wideField.setAttribute("class", "four wide field")
    fields.appendChild(wideField)

    let button = document.createElement("input")
    button.setAttribute("class", "ui button")
    button.setAttribute("type", "button")
    button.setAttribute("value", "Remove")
    button.setAttribute("onclick", "removeFilter('" + id + "')")
    wideField.appendChild(button)

    i++;
}

function removeFilter(id) {
    let queryFields = document.getElementById("queryFields")
    let child = document.getElementById(id)

    //queryFields.removeChild(child)


    for (var i=0; i<child.children.length; i++) {
        child.children[i].remove()
    }
    child.remove()
}