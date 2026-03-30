import { type Config } from "prettier";

const config: Config = {
  plugins: ["@prettier/plugin-xml"],
  xmlWhitespaceSensitivity: "ignore",
};

export default config;
