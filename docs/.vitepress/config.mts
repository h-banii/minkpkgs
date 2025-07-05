import { defineConfig } from "vitepress";

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "MikanOS",
  description: "Documentation",
  base: "/MikanOS/",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [{ text: "Home", link: "/" }],

    sidebar: [
      {
        items: [{ text: "Introduction", link: "/pages/introduction" }],
      },
      {
        text: "Requirements",
        collapsed: false,
        items: [
          { text: "Install Nix", link: "/pages/requirements/install-nix" },
          { text: "Uninstall Nix", link: "/pages/requirements/uninstall-nix" },
        ],
      },
      {
        text: "ISO Image",
        items: [
          { text: "Live CD", link: "/pages/livecd" },
          { text: "Installer", link: "/pages/installer" },
        ],
      },
    ],

    socialLinks: [
      { icon: "twitch", link: "https://www.twitch.tv/mikanthemink" },
      { icon: "youtube", link: "https://www.youtube.com/@MikanTheMink" },
      { icon: "twitter", link: "https://www.twitter.com/MikanTheMink" },
      { icon: "github", link: "https://github.com/h-banii/MikanOS" },
    ],
  },
  srcDir: "src",
});
