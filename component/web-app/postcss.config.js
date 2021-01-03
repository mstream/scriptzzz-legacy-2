const postcssElmCssTailwind = require("postcss-elm-css-tailwind");
const tailwindcss = require("tailwindcss");

const {
  getPath,
  layout,
} = require("./paths");


module.exports = {
  plugins: [
    tailwindcss("./tailwind.config.js"),
    postcssElmCssTailwind({
      baseTailwindCSS: getPath(layout.assets.browserClient.tailwindCss),
      rootModule: "Tailwind",
      rootOutputDir: getPath(layout.gen.browserClient),
    }),
  ],
};
