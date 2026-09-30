---
name: new-post
description: Start a new blog post on the user's personal website. Use when the user types /site:new-post, or asks to start, create or write a new blog post in their website folder.
argument-hint: <post title>
allowed-tools:
  - Bash(date:*)
  - Bash(ls:*)
---

# Start a new blog post

You are helping someone who is **not a developer** write on their personal
website. Keep messages short and plain. This command only creates a file on their
computer; nothing goes live until they run `/site:publish`.

The title they gave: `$ARGUMENTS`

## 1. Check this is their website folder

The current folder must contain `_config.yml` and a `_posts/` folder. If not, tell
them to open their website folder in Claude Code, or run `/site:setup` if they
haven't created their site yet. Then stop.

## 2. Get the title

If the title above is empty, ask for one. Keep the title exactly as they wrote it,
including capital letters, accents and punctuation.

## 3. Build the file name

- **Slug:** the title in lowercase, with accents removed (á→a, ñ→n, ü→u), every
  run of characters that isn't a letter or digit replaced by one hyphen, and no
  hyphens at the start or end. Trim to about 60 characters at a word boundary.
  Example: "What I learned about Git & GitHub!" → `what-i-learned-about-git-github`.
- **Date:** today on their computer: `date +%Y-%m-%d`.
- **File:** `_posts/<date>-<slug>.md`

The post will live at `/blog/<slug>/`, so the slug must be unique across **all**
dates. Run `ls _posts/` and look for any file ending in `-<slug>.md`. If one
exists, tell them there's already a post with that title (give its date) and ask
whether to open that one instead or pick a different title.

## 4. Ask for a one-line description

Ask for one sentence about the post. It shows in the blog list and in search
results. Tell them they can skip it and add it later.

## 5. Create the file

Write the file with this front matter. Put the title in double quotes and escape
any `"` inside it as `\"`. Leave out the `description` line entirely if they
skipped it.

```markdown
---
title: "<title>"
date: <date>
description: "<description>"
---

Start writing here.
```

## 6. Tell them what's next

- Where the file is (give the path as a link they can click) and that it's a plain
  Markdown file: `**bold**`, `*italic*`, `[link text](https://…)`, `- ` for lists,
  and `## ` for a heading.
- Once it's live, it will be at `<url from _config.yml>/blog/<slug>/`.
- Nothing is public yet. When they're happy with it, `/site:publish` puts it live.
- Offer to help them outline the post or review a draft. Don't write the post for
  them unless they ask: the site is meant to show what *they* know and are learning.
