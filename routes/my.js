const fs = require('fs')

exports.updateCardImageUrls = function(card) {
    let set = card.set.code
    let language = card.language.code
    let id = card.id
    let faces = card.faces
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
    let imageUris = []
    let artCropUrl = "/images/cards/" + set + "/" + language + "/" + id + "/art_crop.jpg"
    let normalUrl  = "/images/cards/" + set + "/" + language + "/" + id + "/normal.jpg"
    let pngUrl     = "/images/cards/" + set + "/" + language + "/" + id + "/png.png"

    try {
        if (fs.existsSync("./public/" + artCropUrl) && fs.existsSync("./public/" + normalUrl)) {
            imageUris.push({
                "art_crop" : artCropUrl,
                "normal": normalUrl,
                "png": pngUrl
            })
        }

        if (faces != null && faces.length > 0) {
            for (var i=0; i<faces.length; i++) {
                artCropUrl = "/images/cards/" + set + "/" + language + "/" + faces[i].id + "/art_crop.jpg"
                normalUrl  = "/images/cards/" + set + "/" + language + "/" + faces[i].id + "/normal.jpg"
                pngUrl     = "/images/cards/" + set + "/" + language + "/" + faces[i].id + "/png.png"

                if (fs.existsSync("./public/" + artCropUrl) && fs.existsSync("./public/" + normalUrl)) {
                    imageUris.push({
                        "art_crop" : artCropUrl,
                        "normal": normalUrl,
                        "png": pngUrl
                    })
                }
            }
        }
    } catch(err) {
        console.error(err)
    }

    return imageUris
}