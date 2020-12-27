const distDir = "dist";
const srcDir = "src";

const elmDist = distDir + "/elm.js";
const elmSrc = srcDir + "/Main.elm";
const pageDist = distDir + "/index.html"

const elmMakeOpts = "--debug --output=" + elmDist;

module.exports = {
  scripts: {
    assets: {
      copy: ["mkdir -p", distDir, "&& cp assets/*", distDir].join(" ")
    },
    check: {
      types: "hegel"
    },
    debug: ["elm-live", elmSrc, "--dir", distDir, "--hot --open --pushstate", "--", elmMakeOpts].join(" "),
    generate: {
      css: "postcss -o /dev/null ./assets/tailwind.css"
    },
    make: {
      debug: "elm make " + elmSrc + " " + elmMakeOpts
    }
  }
};
