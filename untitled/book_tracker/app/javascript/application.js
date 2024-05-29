const Rails = require("@rails/ujs")
Rails.start()

const Turbo = require("@hotwired/turbo-rails")
window.Turbo = Turbo

require("controllers")

document.addEventListener('DOMContentLoaded', () => {
    console.log('Rails UJS loaded:', Rails);
    console.log('Turbo loaded:', Turbo);
});


