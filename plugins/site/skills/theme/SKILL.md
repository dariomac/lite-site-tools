---
name: theme
description: List the available looks (themes) for the user's personal website, or switch to one. Use when the user types /site:theme, or asks to change how their site looks, try a different design, or see which themes exist.
argument-hint: <theme name>
allowed-tools:
  - Bash(ls ${CLAUDE_PLUGIN_ROOT}/themes)
  - Bash(cmp:*)
  - Bash(diff:*)
  - Bash(cp ${CLAUDE_PLUGIN_ROOT}/themes/*/theme.css assets/css/theme.css)
---

# Change how the site looks

You are helping someone who is **not a developer** pick a look for their website.
Keep it short and visual: they choose from screenshots, not descriptions of CSS.

This command only changes two files on their computer: `assets/css/theme.css` and
`theme_name` in `_config.yml`. Their posts, pages and `assets/css/custom.css` are
never touched. Nothing goes live until they run `/site:publish`.

The theme they asked for: `$ARGUMENTS`

Previews of every theme are on GitHub:
https://github.com/dariomac/lite-site-tools/blob/main/THEMES.md
Each theme has its own section, e.g. `…/THEMES.md#editorial`.

## 1. Check this is their website folder

The current folder must contain `_config.yml` and `assets/css/theme.css`.

- No `_config.yml`: tell them to open their website folder in Claude Code, or run
  `/site:setup` if they haven't created their site yet. Stop.
- `_config.yml` but no `assets/css/theme.css`: the site was created before themes
  existed and needs a one-time update that this command doesn't do yet. Say so
  plainly, and suggest they ask whoever gave them the plugin. Stop.

## 2. Find the themes

- Available themes: `ls ${CLAUDE_PLUGIN_ROOT}/themes`. Each folder is one theme.
  Its one-line description is the second line of the comment at the top of its
  `theme.css`.
- Current theme: `theme_name` in `_config.yml` (treat a missing value as `clean`).

## 3. No theme named, or an unknown one

List the themes, one line each: the name, its description, and "(current)" next
to the one they use. Then give the preview link above and ask which one they'd
like. If they asked for a name that doesn't exist, say so first. Stop and wait
for their answer.

Only accept a name that exactly matches one of the folders listed (ignore
capitals and surrounding spaces). Never build a path from anything else.

If they name the theme they already use, say it's already their theme and stop.

## 4. Check for changes made directly to the theme

Compare their theme file with the plugin's copy of their current theme:

```
cmp assets/css/theme.css ${CLAUDE_PLUGIN_ROOT}/themes/<current>/theme.css
```

If they differ, look at `diff` between the two:

- **Looks like their own tweaks** (a changed color, font size, spacing): switching
  would lose them. Explain this and offer to move those changes into `custom.css`
  first, so they keep working with the new theme. Only continue once they've
  decided.
- **Looks like an older version of the theme** (the plugin's theme was improved
  since): nothing of theirs is lost. Continue.
- **Not sure:** ask them.

## 5. Confirm

> Switch your site from **<current>** to **<new>**? Your posts, pages and your own
> style changes stay exactly as they are; only the look changes. You can switch
> back any time with `/site:theme <current>`.

Add one line when it applies:
- `warm`, with no `avatar:` set in `_config.yml`: it looks best with a photo on
  the home page, and you can help them add one.
- `terminal`: it's always dark, even for visitors whose device is in light mode.
- `custom.css` changes colors or fonts: those changes will apply on top of the new
  theme too, which may look different than they expect.

Wait for a clear yes.

## 6. Switch

```
cp ${CLAUDE_PLUGIN_ROOT}/themes/<new>/theme.css assets/css/theme.css
```

Then set `theme_name: <new>` in `_config.yml`. Change only that line.

## 7. Finish

Tell them:
- The look changed on their computer, and `/site:publish` puts it live.
- They can see what it will look like at `…/THEMES.md#<new>` in the meantime.
- `/site:theme <old>` switches back.
