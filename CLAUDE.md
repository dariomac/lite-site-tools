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
