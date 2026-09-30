# lite-site-tools — maintainer notes

This repo is both a Claude Code plugin marketplace and the one plugin it lists.

- `.claude-plugin/marketplace.json`: the marketplace. Users add it with
  `/plugin marketplace add dariomac/lite-site-tools`.
- `plugins/lite-site-tools/`: the plugin itself.
  - `.claude-plugin/plugin.json`: plugin manifest. **Bump `version` on every
    release.** Users with an unchanged version number can stay on the cached copy.
  - `skills/<name>/SKILL.md`: one folder per slash command.
  - `template/`: the starter Jekyll site that `/setup-site` copies into the user's repo.

## Audience

The end user is a non-developer on macOS or Windows. Command output must:
- be in plain English, with no git jargon unless it's explained
- tell the user what happened and what to do next
- ask before anything that publishes, deletes or touches their accounts

Commands with side effects (pushing, creating repos) set `disable-model-invocation: true`
so they run only when the user types them.

## Site conventions (the template and every command must agree)

- Jekyll, built by GitHub Pages with no local build step
- Posts live in `_posts/YYYY-MM-DD-slug.md` and are served at `/blog/slug/`
- Repo name: `<github-username>.github.io`

## Local testing

```
/plugin marketplace add ./
/plugin install lite-site-tools@lite-site-tools
```
