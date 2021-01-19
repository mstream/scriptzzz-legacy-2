import {
  Elm
} from "./Scriptzzz/Browser/Client/Main.elm";

const isValidPortMessage = value => {
  if (value === null || value === undefined) {
    return false;
  }

  if (typeof value !== "object" && !value instanceof Object) {
    return false;
  }

  if (value.type === null || value.type === undefined) {
    return false;
  }

  if (typeof value !== "string" && !value instanceof String) {
    return false;
  }

  return true;
}

const handleLog = ({
  logger
}, {
  level,
  text
}) => logger[level](text);

const portMessageHandlers = {
  "LOG": handleLog,
}


const handlePortMessage = ({
  logger
}, message) => {
  if (!isValidPortMessage(message)) {
    logger.error("Invalid port msg received", message);
    return;
  }

  const {
    type,
    body,
  } = message;

  const handler = portMessageHandlers[type];

  if (handler === null || handler === undefined) {
    logger.error("Unsupprted port message type", type);
    return;
  }

  handler({
    logger
  }, body);
}

const initPorts = ({
  app,
  logger,
  window
}) => {

  app.ports.elmToJs.subscribe(message => handlePortMessage({
    logger
  }, message));

  const reportWindowScroll = () => app.ports.jsToElm.send({
    type: "WINDOW_SCROLLED",
  });

  window.addEventListener("scroll", reportWindowScroll);
};


const init = ({
  logger,
  window
}) => {
  const app = Elm.Scriptzzz.Browser.Client.Main.init({
    flags: {
      now: Date.now(),
      timeUpdateInterval: 1000,
    },
  });

  initPorts({
    app,
    logger,
    window
  });
};

exports.init = init;
