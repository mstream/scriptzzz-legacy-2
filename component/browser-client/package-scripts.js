const cmd = (...segments) => segments.join(" ");
const path = (...segments) => segments.join("/");

const assetsDir = path("assets");
const distDir = path("dist");
const srcDir = path("src");
const indexHtml = path(assetsDir, "index.html");


module.exports = {
  scripts: {
    copy: {
      assets: cmd("mkdir -p", distDir, "&& cp assets/*", distDir),
    },
    serve: cmd("parcel serve", indexHtml),
    generate: {
      css: cmd("postcss -o /dev/null ./assets/tailwind.css"),
    },
    build: cmd("parcel build", indexHtml),
  }
};
