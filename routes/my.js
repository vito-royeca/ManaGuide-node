const fs = require('fs')

exports.updateCardImageUrls = function(card) {
    let new_id = card.new_id
    let faces = card.faces
    card.image_uris = buildCardImageUrls(new_id, faces)

    if (card.component_parts != undefined) {
        for (var i=0; i<card.component_parts.length; i++) {
            const newData = card.component_parts[i].card
            new_id = newData.new_id
            faces = newData.faces
            newData.image_uris = buildCardImageUrls(new_id, faces)
        }
    }

    if (card.variations != undefined) {
        for (var i=0; i<card.variations.length; i++) {
            const newData = card.variations[i]
            new_id = newData.new_id
            faces = newData.faces
            newData.image_uris = buildCardImageUrls(new_id, faces)
        }
    }

    return card
}

function buildCardImageUrls(new_id, faces) {
    let imageUris = []
    let artCropUrl = "/images/cards/" + new_id.replaceAll("_", "/") + "/art_crop.jpg"
    let normalUrl  = "/images/cards/" + new_id.replaceAll("_", "/") + "/normal.jpg"
    let pngUrl     = "/images/cards/" + new_id.replaceAll("_", "/") + "/png.png"

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
                artCropUrl = "/images/cards/" + faces[i].new_id.replaceAll("_", "/") + "/art_crop.jpg"
                normalUrl  = "/images/cards/" + faces[i].new_id.replaceAll("_", "/") + "/normal.jpg"
                pngUrl     = "/images/cards/" + faces[i].new_id.replaceAll("_", "/") + "/png.png"

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