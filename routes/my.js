const fs = require('fs')

exports.updateCardImageUrls = function(card, isMobile) {
    let new_id = card.new_id == null ? "" : card.new_id
    let faces = card.faces

    trimImageUrls(new_id, card, faces, isMobile)

    if (card.component_parts != undefined) {
        for (var i=0; i<card.component_parts.length; i++) {
            const newData = card.component_parts[i].card
            new_id = newData.new_id == null ? "" : newData.new_id
            faces = newData.faces
            trimImageUrls(new_id, newData, faces, isMobile)
        }
    }

    if (card.variations != undefined) {
        for (var i=0; i<card.variations.length; i++) {
            const newData = card.variations[i]
            new_id = newData.new_id == null ? "" : newData.new_id
            faces = newData.faces
            trimImageUrls(new_id, newData, faces, isMobile)
        }
    }

    if (card.other_languages != undefined) {
        for (var i=0; i<card.other_languages.length; i++) {
            const newData = card.other_languages[i]
            new_id = newData.new_id == null ? "" : newData.new_id
            faces = newData.faces
            trimImageUrls(new_id, newData, faces, isMobile)
        }
    }

    if (card.other_printings != undefined) {
        for (var i=0; i<card.other_printings.length; i++) {
            const newData = card.other_printings[i]
            new_id = newData.new_id == null ? "" : newData.new_id
            faces = newData.faces
            trimImageUrls(new_id, newData, faces, isMobile)
        }
    }

    return card
}

function trimImageUrls(new_id, card, faces, isMobile) {
    if (isMobile) {
        if (faces != null && faces.length > 0) {
            for (var i=0; i<faces.length; i++) {
                if (faces[i].art_crop_url == null || faces[i].art_crop_url == undefined) {
                    faces[i].art_crop_url = card.art_crop_url
                }

                if (faces[i].normal_url == null || faces[i].normal_url == undefined) {
                    faces[i].normal_url = card.normal_url
                }

                if (faces[i].png_url == null || faces[i].png_url == undefined) {
                    faces[i].png_url = card.png_url
                }
            } 

            delete card.art_crop_url
            delete card.normal_url
            delete card.png_url
        }

    } else {
        if (faces != null && faces.length > 0) {
            // remove properties
            delete card.art_crop_url
            delete card.normal_url
            delete card.png_url

            replaceCardImageUrls(card, faces)
        } else {
            replaceCardImageUrls(card, [card])
        }            
    }
}

function replaceCardImageUrls(card, faces) {
    let artCropUrl = ""
    let normalUrl  = ""
    let pngUrl     = ""
    let soonUrl    = "/images/cards/soon.jpg"

    try {
        if (faces != null && faces.length > 0) {
            for (var i=0; i<faces.length; i++) {
                artCropUrlOrig = "/images/cards/" + newId2Path(card.new_id) + "/art_crop.jpg"
                normalUrlOrig  = "/images/cards/" + newId2Path(card.new_id) + "/normal.jpg"
                pngUrlOrig     = "/images/cards/" + newId2Path(card.new_id) + "/png.png"

                artCropUrl = "/images/cards/" + newId2Path(faces[i].new_id) + "/art_crop.jpg"
                normalUrl  = "/images/cards/" + newId2Path(faces[i].new_id) + "/normal.jpg"
                pngUrl     = "/images/cards/" + newId2Path(faces[i].new_id) + "/png.png"

                if (fs.existsSync("./public/" + artCropUrlOrig)) {
                    faces[i].art_crop_url = artCropUrlOrig
                } else if (fs.existsSync("./public/" + artCropUrl)) {
                    faces[i].art_crop_url = artCropUrl
                } else {
                    faces[i].art_crop_url = soonUrl
                }

                if (fs.existsSync("./public/" + normalUrlOrig)) {
                    faces[i].normal_url = normalUrlOrig
                } else if (fs.existsSync("./public/" + normalUrl)) {
                    faces[i].normal_url = normalUrl
                } else {
                    faces[i].normal_url = soonUrl
                }

                if (fs.existsSync("./public/" + pngUrlOrig)) {
                    faces[i].png_url = pngUrlOrig
                } else if (fs.existsSync("./public/" + pngUrl)) {
                    faces[i].png_url = pngUrl
                } else {
                    faces[i].png_url = soonUrl
                }
            }            
        }
    } catch(err) {
        console.error(err)
    }

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
