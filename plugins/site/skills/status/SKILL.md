---
name: status
description: Show the state of the user's personal website — where it's live, whether the last publish worked, unpublished changes, and custom domain/HTTPS progress. Use when the user types /site:status or asks whether their site is live, updated or working.
allowed-tools:
  - Bash(git status:*)
  - Bash(git log:*)
  - Bash(git fetch:*)
  - Bash(git remote:*)
  - Bash(git branch:*)
  - Bash(gh api repos/:*)
  - Bash(gh auth status:*)
---

# Website status

You are helping someone who is **not a developer** check on their website. This
command only looks; it never changes anything. Keep the answer short.

## 1. Check this is their website folder

The current folder must contain `_config.yml`, and `git remote get-url origin`
must point to GitHub. If not, tell them to open their website folder in Claude Code,
or run `/site:setup` if they haven't set up their site yet. Stop.

Take `<owner>/<repo>` from the remote. If `gh` commands fail because they're signed
out (`gh auth status`), tell them to run `/site:setup` again, which will just sign
them back in.

## 2. Gather the facts

Run these (read-only):

- `gh api repos/<owner>/<repo>/pages`: live address (`html_url`), custom domain
  (`cname`), HTTPS (`https_enforced`).
- `gh api repos/<owner>/<repo>/pages/builds/latest`: last build `status`,
  `created_at`, and `error.message` if it failed.
- `git fetch origin` then `git status --porcelain` and
  `git log --oneline origin/main..HEAD`: unpublished changes on this computer.
- `git log --oneline HEAD..origin/main`: changes made on GitHub that aren't on
  this computer yet.
- If there's a custom domain: `gh api repos/<owner>/<repo>/pages/health`
  (a 202 response means GitHub is still checking; retry once after 15 seconds).

## 3. Report

Answer with up to five short lines, only the ones that apply, in this order:

- **Live at:** the address (custom domain if set, with `https://` only if HTTPS is on).
- **Last publish:** when (in words, like "20 minutes ago"), and whether it worked.
  If it failed, explain the error in plain words and how to fix it.
- **Not published yet:** which files changed, in everyday terms (for example "1 new
  post, about page edited"). Suggest `/site:publish`.
- **Changed on GitHub:** if there are changes on GitHub that aren't here, say so;
  `/site:publish` brings them down automatically next time.
- **Domain:** connected / DNS still pending / HTTPS still pending, and suggest
  `/site:connect-domain` if something's pending.
- **Update available:** if `site_format` in `_config.yml` is missing or lower
  than 2, the site was made with an older version of the plugin. Suggest
  `/site:upgrade` to get the newer features (like themes).

End with the single most useful next step, if there is one.
