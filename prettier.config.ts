import { type Config } from "prettier";

const config: Config = {
  plugins: ["@prettier/plugin-xml"],
  xmlWhitespaceSensitivity: "preserve",
  overrides: [
    {
      files: "*.xsd",
      options: {
        tabWidth: 4,
      },
    },
  ],
};

export default config;
