let index = 0 // Track the filters
let submitEnabled = false

function addFilter(label, value) {
    let filterID = value + "_" + index;
    let removeFilterID = filterID + "_remove";
    let filter = createFilter(value, filterID, removeFilterID);
    let submitEnabledStatus = submitEnabled

    if (filter != null) {
        let queryFields = document.getElementById("queryFields");

        let div = document.createElement("div");
        div.setAttribute("class", "field");
        div.setAttribute("id", removeFilterID);
        queryFields.appendChild(div);

        let labelDiv = document.createElement("label");
        labelDiv.innerHTML = label;
        div.appendChild(labelDiv);
        div.appendChild(filter);

        submitEnabled = true
        index++;
    }

    if (submitEnabledStatus != submitEnabled) {
        $('.button-filter').toggleClass('disabled');
    }
}

function createFilter(value, filterID, removeFilterID) {
    let filter = null;
    let subfilter = null;

    switch (value) {
        case "cardName":
            filter = createNameFilter(filterID);
            subfilter = createTextFilterOp(filterID);
            break;
        case "cardType":
            break;
        case "cardText":
            break;
        case "colors":
            break;
        case "manaCost":
            break;
        case "stats":
            break;
        case "format":
            break;
        case "set":
            break;
        case "block":
            break;
        case "rarity":
            break;
        case "artist":
            break;
        case "flavorText":
            break;
        case "language":
            break;
        default:
            break;
    }

    if (filter != null) {
        let queryFields = document.getElementById("queryFields");
        let removeButton = createRemoveButton(removeFilterID);

        let fieldsDiv = document.createElement("div");
        fieldsDiv.setAttribute("class", "fields");

        let div = document.createElement("div");

        if (queryFields.children.length >= 1) {
            let wideAtribute = subfilter != null ? "eight wide field" : "ten wide field";

            div.setAttribute("class", "two wide field");
            div.setAttribute("id", filterID + "_boolean_div");
            div.appendChild(createBooleanFilterOp(filterID + "_boolean"));
            fieldsDiv.appendChild(div);

            if (subfilter != null) {
                div = document.createElement("div");
                div.setAttribute("class", "two wide field");
                div.setAttribute("id", filterID + "_subfilter_div");
                div.appendChild(subfilter);
                fieldsDiv.appendChild(div);
            }

            div = document.createElement("div");
            div.setAttribute("class", wideAtribute);
            div.setAttribute("id", filterID + "_filter_div");
            div.appendChild(filter);
            fieldsDiv.appendChild(div);
        } else {
            div.setAttribute("class", "twelve wide field");
            div.setAttribute("id", filterID + "_filter_div");
            div.appendChild(filter);
            fieldsDiv.appendChild(div);
        }

        div = document.createElement("div");
        div.setAttribute("class", "four wide field");
        div.appendChild(removeButton);
        fieldsDiv.appendChild(div);

        return fieldsDiv;
    } else {
        return null;
    }
}

function createNameFilter(id) {
    let input = document.createElement("input");
    input.setAttribute("type", "text");
    input.setAttribute("Placeholder", "Any word in the Card name");
    input.setAttribute("id", id);

    return input;
}

function removeFilter(id) {
    let child = document.getElementById(id);
    child.remove();

    // check the first filter if there is boolean select dropdown.
    // remove the dropdown and adjust the filter's width
    let queryFields = document.getElementById("queryFields");
    if (queryFields.children.length >= 1) {
        let isFilterDone = false;
        let isBooleanDone = false;
        let isSubfilterDone = false;

        $(function(){
            $('#queryFields *').each(function () {
                let id = $(this).attr('id');

                if (id != undefined) {
                    if (!isFilterDone && id.endsWith("_filter_div")) {
                        child = document.getElementById(id);
                        child.setAttribute("class", "twelve wide field");
                        isFilterDone = true;
                        isBooleanDone = true;
                        isSubfilterDone = true;
                    } else if (!isBooleanDone && id.endsWith("_boolean_div")) {
                        child = document.getElementById(id);
                        child.remove();
                        isBooleanDone = true;
                    } else if (!isSubfilterDone && id.endsWith("_subfilter_div")) {
                        child = document.getElementById(id);
                        child.remove();
                        isSubfilterDone = true;
                    }
                }
            });
        });
    }

    let submitEnabledStatus = submitEnabled;
    submitEnabled = queryFields.children.length >= 1;
    if (submitEnabledStatus != submitEnabled) {
        $('.button-filter').toggleClass('disabled');
    }
}

function createRemoveButton(id) {
    let button = document.createElement("input");
    button.setAttribute("class", "ui button");
    button.setAttribute("type", "button");
    button.setAttribute("value", "Remove");
    button.setAttribute("onclick", "removeFilter('" + id + "')");

    return button;
}

function createBooleanFilterOp(id) {
    let filter = document.createElement("select");
    filter.setAttribute("class", "ui dropdown");
    filter.setAttribute("name", id);
    filter.setAttribute("id", id);

    let option = document.createElement("option");
    option.setAttribute("value", "and");
    option.text= "And";
    filter.appendChild(option);

    option = document.createElement("option");
    option.setAttribute("value", "or");
    option.text= "Or";
    filter.appendChild(option);

    option = document.createElement("option");
    option.setAttribute("value", "not");
    option.text= "Not";
    filter.appendChild(option);

    return filter;
}

function createTextFilterOp(id) {
    let filter = document.createElement("select");
    filter.setAttribute("class", "ui dropdown");
    filter.setAttribute("name", id);
    filter.setAttribute("id", id);

    let option = document.createElement("option");
    option.setAttribute("value", "startsWith");
    option.text= "Starts With";
    filter.appendChild(option);

    option = document.createElement("option");
    option.setAttribute("value", "endsWith");
    option.text= "Ends With";
    filter.appendChild(option);

    option = document.createElement("option");
    option.setAttribute("value", "contains");
    option.text= "Contains";
    filter.appendChild(option);

    return filter;
}

