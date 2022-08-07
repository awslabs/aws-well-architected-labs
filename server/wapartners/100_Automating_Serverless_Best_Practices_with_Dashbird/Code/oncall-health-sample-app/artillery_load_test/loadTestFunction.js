'use strict'
// Sets a bounding box around an area in Virginia, USA
const bounds = {
    latMax: 38.735083,
    latMin: 40.898677,
    lngMax: -77.109339,
    lngMin: -81.587841
}

const generateRandomData = (userContext, events, done) => {
    const randomLat = ((bounds.latMax-bounds.latMin) * Math.random()) + bounds.latMin
    const randomLng = ((bounds.lngMax-bounds.lngMin) * Math.random()) + bounds.lngMin

    const id = parseInt(Math.random()*1000000)+1  //random 0-1000000
    const rating = parseInt(Math.random()*5)+1    //returns 1-5

    userContext.vars.lat = randomLat.toFixed(7)
    userContext.vars.lng = randomLng.toFixed(7)
    userContext.vars.id = id
    userContext.vars.rating = rating

    return done()
}

module.exports = {
    generateRandomData
}
