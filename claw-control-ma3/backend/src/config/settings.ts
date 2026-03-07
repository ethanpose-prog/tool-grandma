export const CONFIG = {
  OSC: {
    IP: "127.0.0.1", // IP locale pour test
    PORT: 8000,
    PREFIX: "/gma3",
    ENABLED: true,
  },
  APP: {
    PORT: 4000,
    SIMULATION_MODE: true, // Sécurité par défaut
  },
  SAFE_COMMANDS: [
    "patch_fixture",
    "select_group",
    "set_dimmer",
    "store_preset",
    "clear_programmer"
  ]
};