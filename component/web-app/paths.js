const os = require("os");
const path = require("path");

const PATH = Symbol("path");

const layout = {
  assets: {
    api: {
      [PATH]: path.join("assets", "api"),
    },
    browserClient: {
      indexHtml: {
        [PATH]: path.join("assets", "browser-client", "index.html"),
      },
      tailwindCss: {
        [PATH]: path.join("assets", "browser-client", "tailwind.css"),
      },
      [PATH]: path.join("assets", "browser-client"),
    },
    [PATH]: path.join("assets"),
  },
  dist: {
    api: {
      [PATH]: path.join("dist", "api"),
    },
    browserClient: {
      [PATH]: path.join("dist", "browser-client"),
    },
    [PATH]: path.join("dist"),
  },
  elmStuff: {
    [PATH]: path.join("elm-stuff"),
  },
  gen: {
    api: {
      [PATH]: path.join("gen", "api"),
    },
    browserClient: {
      [PATH]: path.join("gen", "browser-client"),
    },
    [PATH]: path.join("gen"),
  },
  src: {
    api: {
      [PATH]: path.join("src", "api"),
    },
    browserClient: {
      [PATH]: path.join("src", "browser-client"),
    },
    core: {
      [PATH]: path.join("src", "core"),
    },
    test: {
      [PATH]: path.join("src", "test"),
    },
    [PATH]: path.join("src"),
  },
  tmp: {
    [PATH]: path.join(os.tmpdir(), "scriptzzz")
  },
  [PATH]: path.join(""),
};


const getPath = node => {
  if (node === undefined || node === null) {
    throw new Error("node is required");
  }
  return node[PATH];
};

const getTmpFilePath = fileName =>
  path.join(getPath(layout.tmp), fileName);

module.exports = {
  getPath,
  getTmpFilePath,
  layout,
};
