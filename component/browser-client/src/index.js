import {
  Elm
} from "./Main.elm";


const isValidPortMsg = val => {
  if (val === null || val === undefined) {
    return false;
  }

  if (typeof val !== "object" && !val instanceof Object) {
    return false;
  }

  if (val.type === null || val.type === undefined) {
    return false;
  }

  if (typeof val !== "string" && !val instanceof String) {
    return false;
  }

  return true;
}

const handleLog = text => console.log("Elm: " + text)

const portMsgHandlers = {
  "LOG": handleLog,
}

const handlePortMsg = val => {
  if (!isValidPortMsg(val)) {
    console.error("Invalid port msg received: " + val);
    return;
  }

  const {
    type,
    body,
  } = val;

  const handler = portMsgHandlers[type];

  if (handler === null || handler === undefined) {
    console.error("Unsupprted port message type: " + type);
    return;
  }

  handler(body);
}

const app = Elm.Main.init({
  flags: {
    authToken: null,
    githubOauthClientId: "0fb88880559f1b82f5b9",
  },
});

app.ports.outgoing.subscribe(handlePortMsg);

const reportWindowScroll = () => app.ports.incoming.send({
  type: "WINDOW_SCROLLED",
});

window.addEventListener("scroll", reportWindowScroll);
