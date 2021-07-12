function transformCard(new_id, image1, image2) {
    const img = document.getElementById(new_id)

    if (img.name == image1) {
        img.src = image2
        img.name = image2
    } else {
        img.src = image1
        img.name = image1
    }
}

function flipCard(new_id) {
    const img = document.getElementById(new_id)
    let rotateAngle = Number(img.getAttribute("rotangle")) + 180

    img.style.transition = "all 0.3s ease"
    img.style.transform = "rotate(" + rotateAngle + "deg)"
    img.setAttribute("rotangle", "" + rotateAngle) // save the rotangle attribute
}

function rotateCard(new_id) {
    const img = document.getElementById(new_id)
    let rotateAngle = Number(img.getAttribute("rotangle")) + 90

    img.style.transition = "all 0.3s ease"
    img.style.transform = "rotate(" + rotateAngle + "deg)"
    img.setAttribute("rotangle", "" + rotateAngle) // save the rotangle attribute
}