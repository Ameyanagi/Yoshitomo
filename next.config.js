/**
 * Run `build` or `dev` with `SKIP_ENV_VALIDATION` to skip env validation. This is especially useful
 * for Docker builds.
 */
import "./src/env.js";

/** @type {import("next").NextConfig} */
const config = {
  // Standalone output for Docker deployment
  output: "standalone",

  // Allow cross-origin requests from production domain
  allowedDevOrigins: ["https://yoshitomo.rxx.jp"],
};

export default config;
