import * as elm from "./elm";
import pino from "pino";

try {
  const logger = pino();
  try {
    elm.init({
      logger,
      window,
    });
  } catch (error) {
    logger.error("Unhandled application error", error);
  }
} catch (error) {
  console.error("Could not initialize the logger", error);
}
