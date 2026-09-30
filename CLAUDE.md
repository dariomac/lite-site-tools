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

Installed plugins live in `~/.claude/plugins/cache/`, whatever the install scope,
so skills must never assume the plugin is inside the user's project.

## Audience

The end user is a non-developer on macOS or Windows. Command output must:
- be in plain English, with no git jargon unless it's explained
- tell the user what happened and what to do next
- ask before anything that publishes, deletes or touches their accounts

Every command sets `disable-model-invocation: true`, so it runs only when the user
types it.

## Site conventions (the template and every command must agree)

- Jekyll, built by GitHub Pages with no local build step
- The site lives in the folder the user opens in Claude Code; the plugin is
  installed there with project scope
- Posts live in `_posts/YYYY-MM-DD-slug.md` and are served at `/blog/slug/`
- Repo name: `<github-username>.github.io`, public

## Previewing the template

`.claude/launch.json` defines `template-preview`, which builds `plugins/site/template`
in Docker with the `github-pages` gem (the same build GitHub runs) at
http://localhost:4000.

## Local testing of the plugin

From a scratch folder:

```
/plugin marketplace add /path/to/lite-site-tools
/plugin install site@lite-site-tools
```
