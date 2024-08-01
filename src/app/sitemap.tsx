import type { MetadataRoute } from "next";

export default function sitemap(): MetadataRoute.Sitemap {
  return [
    {
      url: "https://arane.uniproject-tech.net/",
      priority: 1,
    },
    {
      url: "https://arane.uniproject-tech.net/about",
      priority: 0.8,
    },
    {
      url: "https://arane.uniproject-tech.net/license",
      priority: 0.5,
    },
    {
      url: "https://arane.uniproject-tech.net/download",
      priority: 0.8,
    },
    {
      url: "https://arane.uniproject-tech.net/contact",
      priority: 0.5,
    },
  ];
}
