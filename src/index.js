const { Elm } = require('./Main.elm')
const bulma =   require('bulma')

var app = Elm.Main.init({
  node: document.getElementById('elm')
});
