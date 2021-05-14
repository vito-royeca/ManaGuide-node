const fs = require('fs')

exports.updateCardImageUrls = function(card) {
    let new_id = card.new_id == null ? "" : card.new_id
    let faces = card.faces
    card.image_uris = buildCardImageUrls(new_id, faces)

    if (card.component_parts != undefined) {
        for (var i=0; i<card.component_parts.length; i++) {
            const newData = card.component_parts[i].card
            new_id = newData.new_id == null ? "" : newData.new_id
            faces = newData.faces
            newData.image_uris = buildCardImageUrls(new_id, faces)
        }
    }

    if (card.variations != undefined) {
        for (var i=0; i<card.variations.length; i++) {
            const newData = card.variations[i]
            new_id = newData.new_id == null ? "" : newData.new_id
            faces = newData.faces
            newData.image_uris = buildCardImageUrls(new_id, faces)
        }
    }

    return card
}

function buildCardImageUrls(new_id, faces) {
    let imageUris = []
    let artCropUrl = "/images/cards/" + newId2Path(new_id) + "/art_crop.jpg"
    let normalUrl  = "/images/cards/" + newId2Path(new_id) + "/normal.jpg"
    let pngUrl     = "/images/cards/" + newId2Path(new_id) + "/png.png"
    let soonUrl    = "/images/cards/soon.jpg"

    try {
        if (fs.existsSync("./public/" + artCropUrl) && fs.existsSync("./public/" + normalUrl)) {
            imageUris.push({
                "art_crop" : artCropUrl,
                "normal": normalUrl,
                "png": pngUrl
            })
        } else {
            imageUris.push({
                "art_crop" : soonUrl,
                "normal": soonUrl,
                "png": soonUrl
            })
        }

        if (faces != null && faces.length > 0) {
            for (var i=0; i<faces.length; i++) {
                artCropUrl = "/images/cards/" + newId2Path(faces[i].new_id) + "/art_crop.jpg"
                normalUrl  = "/images/cards/" + newId2Path(faces[i].new_id) + "/normal.jpg"
                pngUrl     = "/images/cards/" + newId2Path(faces[i].new_id) + "/png.png"

                if (fs.existsSync("./public/" + artCropUrl) && fs.existsSync("./public/" + normalUrl)) {
                    imageUris.push({
                        "art_crop" : artCropUrl,
                        "normal": normalUrl,
                        "png": pngUrl
                    })
                } else {
                    imageUris.push({
                        "art_crop" : soonUrl,
                        "normal": soonUrl,
                        "png": soonUrl
                    })
                }
            }
        }
    } catch(err) {
        console.error(err)
    }

    return imageUris
}

function newId2Path(new_id) {
    let path = new_id == null ? "" : new_id

    if (path.length > 0) {
        
        if ((path.match(/_/g) || []).length > 2) {
            path = path.replaceAll("_", "/")
            let index = path.lastIndexOf("/")
            path = path.substring(0, path.lastIndexOf("/")) + "_" + path.substring(index+1)
        } else {
            path = path.replaceAll("_", "/")
        }   
    }

    return path
}