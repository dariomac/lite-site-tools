# lite-site-tools — maintainer notes

This repo is a Claude Code plugin marketplace (`lite-site-tools`) that lists one
plugin (`site`).

- `.claude-plugin/marketplace.json`: the marketplace. Users add it with
  `/plugin marketplace add dariomac/lite-site-tools`.
- `plugins/site/`: the plugin itself.
  - `.claude-plugin/plugin.json`: plugin manifest. **Bump `version` on every
    release.** Users with an unchanged version number can stay on the cached copy.
  - `skills/<name>/SKILL.md`: one folder per command. Plugin skills are always
    invoked with the plugin prefix: `skills/new-post/` is `/site:new-post`.
  - `template/`: the starter Jekyll site that `/site:setup` copies into the user's
    folder. Skills refer to it as `${CLAUDE_PLUGIN_ROOT}/template`.
  - `themes/<name>/`: one folder per look. `/site:setup` copies
    `themes/clean/theme.css` into the new site; `/site:theme` swaps it.

Installed plugins live in `~/.claude/plugins/cache/`, whatever the install scope,
so skills must never assume the plugin is inside the user's project.

## Audience

The end user is a non-developer on macOS or Windows. Command output must:
- be in plain English, with no git jargon unless it's explained
- tell the user what happened and what to do next
- ask before anything that publishes, deletes or touches their accounts

Commands that publish, install software or touch the user's accounts (`setup`,
`publish`, `connect-domain`) set `disable-model-invocation: true`, so they run
only when the user types them. Commands that only create or read local files
(`new-post`, `status`) leave it off, so plain requests like "start a post about
Docker" use the same conventions.

## Site conventions (the template and every command must agree)

- Jekyll, built by GitHub Pages with no local build step
- The site lives in the folder the user opens in Claude Code; the plugin is
  installed there with project scope
- Posts live in `_posts/YYYY-MM-DD-slug.md` and are served at `/blog/slug/`
- Repo name: `<github-username>.github.io`, public. If that already exists,
  `/site:setup` creates a second site in a repo like `my-website`, served at
  `<username>.github.io/my-website/` with `baseurl: "/my-website"`
- Every link in the template goes through `relative_url`, and every command that
  shows an address uses `url` + `baseurl`, so both kinds of site work.
  `/site:connect-domain` resets `baseurl` to `""`, since a custom domain serves
  the site at its root

## Theme contract

Themes are **CSS only**: a theme is `themes/<name>/theme.css`, copied to the
site's `assets/css/theme.css`. The layouts are shared, so every command works the
same with every theme. A theme must:

- Start with a comment naming the theme, describing it in one line, and saying
  the file is replaced on a theme switch.
- Define these variables on `:root`, with a dark-mode set under
  `@media (prefers-color-scheme: dark)`: `--bg`, `--text`, `--muted`, `--accent`,
  `--border`, `--code-bg`, `--max`, `--font-body`, `--font-heading`, `--font-mono`.
  A theme that's always dark (like `terminal`) repeats the same values in both.
  Users override them in `custom.css`, so the rest of the theme must use them
  instead of hard-coded values.
- Look right with every class the layouts use: `.site-header`, `.site-title`,
  `.site-footer`, `.home`, `.avatar`, `.post`, `.post-date`, `.post-list`, `.back`.
  `.avatar` always needs a size, since the image can be any size.
- Load web fonts, if any, with an `@import` from Google Fonts at the top of the file.
- Work at phone width with no sideways scrolling.
- Ship a `README.md` and two screenshots next to `theme.css`, and get a section
  in the root `THEMES.md`: `screenshot-desktop.jpg` (home page, desktop width,
  light mode) and `screenshot-mobile.jpg` (the "first week learning Git" demo
  post, 375px phone, dark mode). Take them from `dev/preview.sh <theme> serve`
  in the browser pane, and save them as JPEG to keep the plugin small.

The user's own changes live in `assets/css/custom.css`, which loads after the
theme and is never touched by any command. `theme_name` in `_config.yml` records
the current theme.

## Previewing the template

`dev/preview.sh [theme] [build|serve]` assembles the template, a theme and the
demo content in `dev/demo/` (sample posts, avatar, demo name), then builds or
serves it in Docker with the `github-pages` gem, the same build GitHub runs.
`serve` runs at http://localhost:4000. `.claude/launch.json` runs it for the
`clean` theme.

## Local testing of the plugin

From a scratch folder:

```
/plugin marketplace add /path/to/lite-site-tools
/plugin install site@lite-site-tools
```
