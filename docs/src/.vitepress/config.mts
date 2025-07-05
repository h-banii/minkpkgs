import { defineConfig } from "vitepress";

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "MikanOS",
  description: "Documentation",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [{ text: "Home", link: "/" }],

    sidebar: [
      {
        items: [
          { text: "Introduction", link: "/pages/introduction/index.md" },
          { text: "Nix", link: "/pages/nix/index.md" },
        ],
      },
      {
        text: "ISO Image",
        items: [
          { text: "LiveCD", link: "/pages/livecd/index.md" },
          { text: "Installer", link: "/pages/installer/index.md" },
        ],
      },
    ],

    socialLinks: [
      { icon: "github", link: "https://github.com/vuejs/vitepress" },
    ],
  },
});
