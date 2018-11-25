import css from "../css/app.scss"
import { Pixel } from "./pixel.js";
import "phoenix_html"

// To expose your modules within the browser
// nice for testing, not sure if nice for hacking
// Require("./app.js").App
window.Require = require.context("./", true, /\.js$/);
export var App = (function() {
  return {
    "$": $,
    Pixel: Pixel,
    run: function() {
      this.Pixel.run();
    }
  };
})();

window.addEventListener("load", function() {
  App.run();
});
