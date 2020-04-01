let rp = require('request-promise')

const publicID   = 'A49D81FB-5A76-4634-9152-E1FB5A657720'
const privateKey = 'C018EF82-2A4D-4F7A-A785-04ADEBF2A8E5'
const apiVersion = 'v1.36.0'

let TCGPlayer = {
    token: null,

    authenticate: function () {
        const url = 'https://api.tcgplayer.com/token'
        const method = 'POST'
        const headers = {
            'Content-Type': 'application/x-www-form-urlencoded'
        }
        const body = 'grant_type=client_credentials&client_id=' + publicID + '&client_secret=' + privateKey

        const options = {
            method: method,
            uri: url,
            body: body,
            resolveWithFullResponse: true
        }

        return rp(options)
            .then(function (response) {
                this.token = response.body
            }).catch((err) => {
                console.log(err)
            })
    }
};


/*
    fetchPrices: function (productIds) {
        return new Promise(function (resolve, reject) {
            fetch('http://api.tcgplayer.com/' + apiVersion + '/pricing/product/83461,202297', {
                method: 'POST',
                headers: {'Authorization': 'Bearer Token'},
                body: null
            }).then(response => {
                resolve(response.json())
            }).catch(err => {
                reject(err)
            })
        })
    },

    checkStatus: function (res) {
        return new Promise(function (resolve, reject) {
            if (res.status >= 200 && res.status < 300) {
                resolve(res)
            } else {
                let err = new Error(res.statusText)
                reject(err)
            }
        })
    }
}
*/
// or

//Promise.all([authenticate(), fetchPrices()]).then(function() {
//    console.log("Done.")
//})
