const {
  concurrent,
  mkdirp,
  rimraf,
  series,
} = require("nps-utils");

const joinWith = delimiter => (...segments) => segments.join(delimiter);

const cmd = joinWith(" ");
const path = joinWith(require("path").sep);

const assetsDir = path("assets");
const distDir = path("dist");
const genDir = path("gen");
const srcDir = path("src");

const indexHtml = path(assetsDir, "index.html");

const cleanDir = dir => series(rimraf(dir), mkdirp(dir));

module.exports = {
  scripts: {
    build: {
      default: series(
        concurrent.nps("clean.dist", "generate"),
        cmd("parcel build", indexHtml)),
    },
    clean: {
      default: concurrent.nps("clean.dist", "clean.gen"),
      dist: cleanDir(distDir),
      gen: cleanDir(genDir),
    },
    generate: {
      default: series.nps("clean.gen", "generate.css"),
      css: cmd("postcss -o /dev/null", path(assetsDir, "tailwind.css")),
    },
    serve: series(
      concurrent.nps("clean.dist", "generate"),
      cmd("parcel serve", indexHtml),
    ),
    show: {
      ciChanges: cmd(
        "git diff --quiet HEAD^ HEAD -- ../../netlify.toml .",
        ":!nix",
        ":!shell.nix"
      ),
    },
  }
};
