---
name: upgrade
description: Bring a website created with an older version of the plugin up to the current site structure, keeping the user's content and style changes.
disable-model-invocation: true
allowed-tools:
  - Bash(git status:*)
  - Bash(diff:*)
  - Bash(cmp:*)
  - Bash(ls:*)
---

# Upgrade the website structure

You are helping someone who is **not a developer** update their website after the
plugin gained new features. Keep it short. They don't need to know which files
change unless they ask; they need to know their site will look and work the same,
and what they gain.

Hard rules:
- Never change or remove their posts, pages, images or settings values.
- Show the summary in step 3 and wait for a yes before changing anything.
- Nothing goes live until they run `/site:publish`.

The current site format is **2**. Original files from older formats are kept in
`${CLAUDE_PLUGIN_ROOT}/upgrades/format-<n>/` so you can tell the owner's changes
apart from what the plugin created.

## 1. Check this is their website folder

The current folder must contain `_config.yml`. If not, tell them to open their
website folder in Claude Code. Stop.

If `git status` shows unpublished changes, that's fine: the upgrade only adds to
them. Mention that `/site:publish` will publish both together.

## 2. Find the site's format

Read `site_format` from `_config.yml`.

- **2:** already up to date. Say so and stop.
- **Missing, and `assets/css/style.css` exists without `assets/css/theme.css`:**
  format 1. Go to step 3.
- **Anything else** (for example, missing but the files don't match format 1):
  don't guess. Explain that the site doesn't look like a version you know how to
  upgrade, list what you found, and stop.

## 3. Format 1 → 2: explain and confirm

Before asking, check two things so the summary is accurate:

- **Their own style changes:** `diff ${CLAUDE_PLUGIN_ROOT}/upgrades/format-1/style.css assets/css/style.css`.
  Anything different is a change they (or Claude for them) made.
- **Edited files:** compare `_layouts/default.html` and `CLAUDE.md` with the
  copies in `${CLAUDE_PLUGIN_ROOT}/upgrades/format-1/` (`cmp`).

Then tell them:

> Your site was created before themes existed. I can update it so you can switch
> between looks with `/site:theme` and add a photo to your home page. It will look
> exactly the same as now until you choose a new theme.
>
> <If they have style changes:> Your own style changes (<describe them in plain
> words, e.g. "green links">) will be kept and keep working with every theme.
>
> Shall I go ahead?

Wait for a clear yes.

## 4. Format 1 → 2: make the changes

Do these in order:

1. **Theme:** copy `${CLAUDE_PLUGIN_ROOT}/themes/clean/theme.css` to
   `assets/css/theme.css`.
2. **Their changes:** copy `${CLAUDE_PLUGIN_ROOT}/template/assets/css/custom.css`
   to `assets/css/custom.css`. If step 3 found style changes, add them at the end
   of `custom.css` as CSS rules that override the theme, under a comment
   `/* Moved from style.css during the upgrade */`. Prefer setting theme
   variables (`--accent`, `--bg`, `--font-body`, …) when the change was to one of
   those values.
3. **Old stylesheet:** delete `assets/css/style.css`. It's replaced by the two
   files above, and git keeps its history.
4. **Page layout:** in `_layouts/default.html`, replace the line that links
   `/assets/css/style.css` with these two lines, keeping the indentation:
   ```html
   <link rel="stylesheet" href="{{ '/assets/css/theme.css' | relative_url }}">
   <link rel="stylesheet" href="{{ '/assets/css/custom.css' | relative_url }}">
   ```
   Change nothing else in that file.
5. **Home layout:** copy `${CLAUDE_PLUGIN_ROOT}/template/_layouts/home.html` to
   `_layouts/home.html`. If one already exists, stop and ask.
6. **Home page:** in `index.md`, add `layout: home` to the front matter, unless
   it already sets a `layout:`. Don't change the page's text.
7. **Settings:** in `_config.yml`, change nothing that's already there. Add, in
   the same places and with the same comments as in
   `${CLAUDE_PLUGIN_ROOT}/template/_config.yml`:
   - `site_format: 2` with its comment, after the first comment line
   - `theme_name: clean` and `avatar: ""` with their comments, after `baseurl`
8. **Instructions for Claude:** if `CLAUDE.md` matches the format-1 copy, replace
   it with `${CLAUDE_PLUGIN_ROOT}/template/CLAUDE.md`. If they edited it, keep
   their version and add the template's *Changing how the site looks* section
   after *Where things live*, and update the `_layouts/` line in *Where things
   live* to the template's three lines.

## 5. Check

- `assets/css/theme.css`, `assets/css/custom.css` and `_layouts/home.html` exist,
  and `assets/css/style.css` doesn't.
- `_layouts/default.html` links `theme.css` and `custom.css`, and nothing links
  `style.css` anywhere (`grep -r style.css` over the `.html` and `.md` files,
  excluding `_site/`).
- `_config.yml` has `site_format: 2`.

If anything is off, fix it or explain.

## 6. Finish

Tell them:
- Their site is updated and will look the same.
- `/site:theme` now shows the looks they can choose from.
- `/site:publish` puts the update live (it's a good idea to publish before
  switching themes, so each change is easy to undo).
