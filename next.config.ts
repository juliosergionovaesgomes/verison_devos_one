import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "export",
  basePath: "/verison-devos-one",
  assetPrefix: "/verison-devos-one",
  trailingSlash: true,
  images: {
    unoptimized: true,
  },
};

export default nextConfig;
