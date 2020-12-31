const postcssElmCssTailwind = require("postcss-elm-css-tailwind");
const tailwindcss = require("tailwindcss");

module.exports = {
  plugins: [
    tailwindcss("./tailwind.config.js"),
    postcssElmCssTailwind({
      baseTailwindCSS: "./assets/tailwind.css",
      rootOutputDir: "./gen",
      rootModule: "Tailwind",
    }),
  ],
};
