const fs = require('fs')

exports.updateCardImageUrls = function(card) {
    var set = card.set.code
    var language = card.language.code
    var id = card.id
    var faces = card.faces
    card.image_uris = buildCardImageUrls(set, language, id, faces)

    if (card.component_parts != undefined) {
        for (var i=0; i<card.component_parts.length; i++) {
            const newData = card.component_parts[i].card
            set = newData.set.code
            language = newData.language.code
            id = newData.id
            faces = newData.faces
            newData.image_uris = buildCardImageUrls(set, language, id, faces)
        }
    }

    if (card.variations != undefined) {
        for (var i=0; i<card.variations.length; i++) {
            const newData = card.variations[i]
            set = newData.set.code
            language = newData.language.code
            id = newData.id
            faces = newData.faces
            newData.image_uris = buildCardImageUrls(set, language, id, faces)
        }
    }

    return card
}

function buildCardImageUrls(set, language, id, faces) {
    var imageUris = []
    var artCropUrl = "/images/cards/" + set + "/" + language + "/" + id + "/art_crop.jpg"
    var normalUrl = "/images/cards/" + set + "/" + language + "/" + id + "/normal.jpg"

    try {
        if (fs.existsSync("./public/" + artCropUrl) && fs.existsSync("./public/" + normalUrl)) {
            imageUris.push({
                "art_crop" : artCropUrl,
                "normal": normalUrl
            })
        }

        if (faces != null && faces.length > 0) {
            for (var i=0; i<faces.length; i++) {
                artCropUrl = "/images/cards/" + set + "/" + language + "/" + faces[i].id + "/art_crop.jpg"
                normalUrl = "/images/cards/" + set + "/" + language + "/" + faces[i].id + "/normal.jpg"

                if (fs.existsSync("./public/" + artCropUrl) && fs.existsSync("./public/" + normalUrl)) {
                    imageUris.push({
                        "art_crop" : artCropUrl,
                        "normal": normalUrl
                    })
                }
            }
        }
    } catch(err) {
        console.error(err)
    }

    return imageUris
}