const path = require("path");

const PATH = Symbol("path");

exports.getPath = node => {
  if (node === undefined || node === null) {
    throw new Error("node is required");
  }
  return node[PATH];
};

exports.layout = {
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
    [PATH]: path.join("src"),
  },
};
