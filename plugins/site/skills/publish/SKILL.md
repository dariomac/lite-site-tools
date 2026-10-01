---
name: publish
description: Publish the changes in the user's website folder to their live GitHub Pages site.
disable-model-invocation: true
allowed-tools:
  - Bash(git status:*)
  - Bash(git diff:*)
  - Bash(git log:*)
  - Bash(git remote:*)
  - Bash(git branch:*)
  - Bash(git rev-parse:*)
  - Bash(git fetch:*)
  - Bash(git add -A)
  - Bash(git commit -m:*)
  - Bash(git pull --rebase:*)
  - Bash(git rebase --abort)
  - Bash(git push origin main)
  - Bash(gh api repos/:*)
---

# Publish the website

You are helping someone who is **not a developer** put their website changes live.
Keep messages short and plain, and don't use git terms without explaining them.

Hard rules:
- Never force-push, reset, or delete anything.
- Nothing is pushed until they've seen the summary in step 4 and said yes.
- If something goes wrong and the fix isn't obvious, stop and explain. Their
  changes are safe on their computer either way.

## 1. Check this is their website folder

The current folder must contain `_config.yml`, and `git remote get-url origin`
must point to a GitHub repository. If not, tell them to open their website folder
in Claude Code, or run `/site:setup` if they haven't set up their site yet. Stop.

The branch must be `main` (`git branch --show-current`). If it isn't, explain
that their site publishes from `main` and stop.

## 2. See what changed

Run `git status --porcelain` and `git log origin/main..HEAD --oneline`.

- **Nothing changed and nothing waiting:** tell them there's nothing new to
  publish, and remind them where the site is live. Stop.
- **Nothing changed, but saved versions are waiting** (an earlier publish didn't
  finish): skip to step 5 and push those.

Otherwise, describe the changes in everyday words, grouped like this:
- New posts: by title (read it from the front matter)
- Edited posts or pages: by title or page name
- New images or other files
- **Deleted files: list each one explicitly** and make sure they meant it

## 3. Check before publishing

Look at the changed files and mention anything you find. Only the first two
block publishing; the rest are reminders they can ignore.

- **Blocks: private-looking files.** Anything like `.env`, `*.key`, `*.pem`,
  password or credential files, or documents that look personal. Everything
  published is public. Ask what they want to do with them.
- **Blocks: broken posts.** A file in `_posts/` whose name isn't
  `YYYY-MM-DD-slug.md`, or with no `title:` or `date:` in its front matter.
  It wouldn't appear on the site. Offer to fix it.
- **Reminder: very large files** (over 10 MB). They make the site slow; offer to
  help shrink images. Files over 100 MB can't be published at all.
- **Reminder: a post without a `description:`.**
- **Reminder: starter text still in place.** "Your Name" in `_config.yml`, or the
  "Write a few lines about yourself" text in `about.md`.

## 4. Confirm

Write a short save message describing the change in plain words, such as
`Add post: What I learned about Git` or `Update about page`. Then show:

> Ready to publish:
> - <the change summary from step 2>
>
> This goes live on your public site. Go ahead?

Wait for a clear yes.

## 5. Publish

```
git add -A
git commit -m "<message>"
git pull --rebase origin main
git push origin main
```

(Skip `add` and `commit` if you came here from "saved versions are waiting".)

`git pull --rebase` brings in anything changed directly on GitHub first. If it
reports a conflict, run `git rebase --abort`, which puts everything back the way
it was, and explain: the same file was changed both on GitHub and on this
computer, and they'll need to decide which version to keep. Offer to walk them
through it. Don't push.

## 6. Wait for the site to update

Get the published version with `git rev-parse HEAD`. GitHub rebuilds the site;
check every 15 seconds, for up to 5 minutes:

```
gh api repos/<owner>/<repo>/pages/builds/latest --jq '.commit + " " + .status'
```

(`<owner>/<repo>` comes from `git remote get-url origin`.) Wait until the commit
matches the one you pushed, then:

- `built`: done.
- `errored`: get the reason with `--jq .error.message` and explain it plainly.
- Still going after 5 minutes: tell them it's taking longer than usual and should
  appear soon.

## 7. Finish

Tell them it's live, with links to the site (`<url><baseurl>/`, from `url` and
`baseurl` in `_config.yml`) and to each new post (`<url><baseurl>/blog/<slug>/`, where the slug is the post's file name without
the date and `.md`). Mention the browser may show the old version for a minute;
refreshing fixes it.
