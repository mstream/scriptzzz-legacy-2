const {
  concurrent,
  mkdirp,
  rimraf,
  series,
} = require("nps-utils");

const {
  getPath,
  layout,
} = require("./paths");

const cmd = (...segments) => segments.join(" ");

const cleanDir = path => series(
  rimraf(path),
  mkdirp(path),
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
        "clean.browserClient"
      ),
    },
    dev: {
      browserClient: parcel(
        "serve",
        getPath(layout.dist.browserClient),
        "browser",
        getPath(layout.assets.browserClient.indexHtml),
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
  }
};
