# lite-site-tools

A Claude Code plugin for building a personal website with a blog on GitHub Pages,
using your own domain. You don't need to know git: each step is a slash command.

## What you need

- A GitHub account
- A Claude plan that includes Claude Code: Pro or Max. The free plan doesn't
  include it. A Team or Enterprise seat from work, or an Anthropic Console
  (pay-as-you-go API) account, also works.
- Claude Code itself. The Code tab in the Claude desktop app is the easiest way
  to use it.
- A domain name, if you want your own address. You can add it later.

`/site:setup` installs and signs in to everything else (git and the GitHub CLI) for you.
On Windows it may ask you to restart Claude Code once, after installing Git.

## Get started

1. Create a new, empty folder for your website, for example `my-website` in your
   home folder.
2. Open that folder in Claude Code.
3. Add this plugin's marketplace:
   ```
   /plugin marketplace add dariomac/lite-site-tools
   ```
4. Install the plugin **for this folder only**:
   ```
   /plugin install site@lite-site-tools
   ```
   When asked where to install it, choose this project.
5. Run:
   ```
   /site:setup
   ```

Always open your website folder in Claude Code when you want to work on your
site. If the `/site:` commands don't show up, check you opened the right folder.

## Commands

Type `/site` to see them all.

| Command | What it does |
|---|---|
| `/site:setup` | One-time setup: checks your tools, signs you in to GitHub, creates your site and puts it live |
| `/site:new-post <title>` | Creates a new blog post, ready to write |
| `/site:publish` | Publishes your changes to the live site |
| `/site:connect-domain <domain>` | Connects your own domain and tells you exactly what to set at your registrar |
| `/site:status` | Shows whether the latest publish worked and where your site is live |
| `/site:theme <name>` | Changes how your site looks. Run it without a name to see the choices |

## Themes

Your site starts with the **clean** look. See all the themes in
[THEMES.md](THEMES.md) and switch with `/site:theme <name>`. Switching never
touches your posts, your pages or your own style changes.

## Getting new commands

Open `/plugin`, choose the `lite-site-tools` marketplace and turn on auto-update.
You can also run `/plugin marketplace update lite-site-tools` whenever you're told
there's a new version.

## Working on another computer

Your site's settings remember the plugin, but each computer needs it installed
once. Open your website folder there and repeat steps 3 and 4.
