const genColorPalette = require("@ky-is/tailwind-color-palette");

const colors = genColorPalette('#1293d8', {
  colorPalette: [100, 300, 500, 700, 900],
  grayscale: true,
  grayscaleMix: 0,
});

module.exports = {
  plugins: [],
  theme: {
    colors,
  },
  variants: {},
};
