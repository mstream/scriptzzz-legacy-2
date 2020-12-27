const postcssElmCssTailwind = require("postcss-elm-css-tailwind");

module.exports = {
  plugins: [
    require("tailwindcss")("./tailwind.config.js"),
    postcssElmCssTailwind({
      baseTailwindCSS: "./assets/tailwind.css",
      rootOutputDir: "./gen", // the generated output directory 
      rootModule: "Tailwind",
    }),
  ],
};
