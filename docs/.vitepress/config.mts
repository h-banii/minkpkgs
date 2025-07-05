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
        items: [
          { text: "Introduction", link: "/pages/introduction" },
          { text: "Nix", link: "/pages/nix" },
        ],
      },
      {
        text: "ISO Image",
        items: [
          { text: "LiveCD", link: "/pages/livecd" },
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
  srcDir: 'src',
});
