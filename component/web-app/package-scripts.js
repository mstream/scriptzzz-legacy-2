const {
  concurrent,
  copy,
  mkdirp,
  rimraf,
  series,
} = require("nps-utils");

const os = require("os");

const {
  getPath,
  getTmpFilePath,
  layout,
} = require("./paths");

const cmd = (...segments) => segments.join(" ");

const withAnswers = (cmd, ...answers) =>
  "printf '" +
  answers.map(answer => answer + os.EOL).join("") +
  "' | " +
  cmd;

const cleanDir = dirPath => series(
  rimraf(dirPath),
  mkdirp(dirPath),
);

const elmInstallPkg = pkg =>
  withAnswers(cmd("elm", "install", pkg), "Y");

const updateJson = (filePath, fieldPath, value) =>
  series(
    cmd(
      "jq",
      "'" + fieldPath + " = " + value + "'",
      filePath,
      ">",
      getTmpFilePath(filePath),
    ),
    copy("'" + getTmpFilePath(filePath) + "' " + "'" + getPath(layout) + "'")
  );

const parcel = (command, outDir, target, input) => {
  const validCommands = ["build", "serve", "watch"];
  const validTargets = ["browser", "node"];
  if (!validCommands.includes(command)) {
    throw new Error(
      "Invalid parcel command: '" +
      command +
      "'. Supported: " +
      validCommands
    );
  }
  if (!validTargets.includes(target)) {
    throw new Error(
      "Invalid parcel target: '" +
      target +
      "'. Supported: " +
      validTargets
    );
  }
  return cmd(
    "parcel",
    command,
    "--out-dir",
    outDir,
    "--target",
    target,
    input,
  );
}

module.exports = {
  scripts: {
    build: {
      api: series(
        concurrent.nps(
          "clean.api.dist",
          "generate.api",
        ),
        cmd(
          "find",
          getPath(layout.src.api),
          "-name '*.js'",
          "-exec",
          parcel(
            "build",
            getPath(layout.dist.api),
            "node",
            "{}"
          ),
          "\\;",
        ),
      ),
      browserClient: series(
        concurrent.nps(
          "clean.browserClient.dist",
          "generate.browserClient",
        ),
        parcel(
          "build",
          getPath(layout.dist.browserClient),
          "browser",
          getPath(layout.assets.browserClient.indexHtml),
        )
      ),
      default: concurrent.nps(
        "build.api",
        "build.browserClient",
      ),
    },
    clean: {
      api: {
        default: concurrent.nps(
          "clean.api.dist",
          "clean.api.gen",
        ),
        dist: cleanDir(getPath(layout.dist.api)),
        gen: cleanDir(getPath(layout.gen.api)),
      },
      browserClient: {
        default: concurrent.nps(
          "clean.browserClient.dist",
          "clean.browserClient.gen"
        ),
        dist: cleanDir(getPath(layout.dist.browserClient)),
        gen: cleanDir(getPath(layout.gen.browserClient)),
      },
      default: concurrent.nps(
        "clean.api",
        "clean.browserClient",
        "clean.tmp",
      ),
      elm: cleanDir(getPath(layout.elmStuff)),
      tmp: cleanDir(getPath(layout.tmp)),
    },
    dev: {
      browserClient: parcel(
        "serve",
        getPath(layout.dist.browserClient),
        "browser",
        getPath(layout.assets.browserClient.indexHtml),
      )
    },
    elm: {
      addDeps: series(
        elmInstallPkg("elm/browser"),
        elmInstallPkg("elm/core"),
        elmInstallPkg("elm/html"),
        elmInstallPkg("elm/http"),
        elmInstallPkg("elm/json"),
        elmInstallPkg("elm/time"),
        elmInstallPkg("elm/url"),
        elmInstallPkg("elm-explorations/test"),
        elmInstallPkg("mdgriffith/elm-ui"),
      ),
      addSrcs: updateJson(
        "elm.json",
        ".[\"source-directories\"]",
        JSON.stringify([
          getPath(layout.src.api),
          getPath(layout.src.browserClient),
          getPath(layout.src.core),
          getPath(layout.src.test),
        ])
      ),
      default: series.nps(
        "clean.tmp",
        "elm.init",
        "elm.addDeps",
        "elm.addSrcs"
      ),
      init: series(
        rimraf("elm.json"),
        withAnswers(cmd("elm", "init"), "Y"),
      )
    },
    generate: {
      api: {
        default: "echo 'Nothing to generate'",
      },
      browserClient: {
        default: series.nps(
          "clean.browserClient.gen",
          "generate.browserClient.css",
        ),
        css: cmd(
          "postcss",
          "--output",
          "/dev/null",
          getPath(layout.assets.browserClient.tailwindCss)
        ),
      },
      default: series.nps("generate.browserClient"),
    },
    show: {
      ciChanges: cmd(
        "git",
        "diff",
        "--quiet",
        "HEAD~1 HEAD",
        "--",
        ".",
        ":!nix",
        ":!shell.nix"
      ),
    },
    test: cmd("elm-test"),
    watch: {
      browserClient: parcel(
        "watch",
        getPath(layout.dist.browserClient),
        "browser",
        getPath(layout.assets.browserClient.indexHtml),
      )
    },
  },
};
