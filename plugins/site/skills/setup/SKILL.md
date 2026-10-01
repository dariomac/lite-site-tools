---
name: setup
description: One-time setup of a personal website with a blog on GitHub Pages, in the current folder. Checks tools, signs in to GitHub, creates the site and publishes it.
disable-model-invocation: true
allowed-tools:
  - Bash(uname:*)
  - Bash(git --version)
  - Bash(gh --version)
  - Bash(gh auth status:*)
  - Bash(gh api user:*)
  - Bash(ls -A:*)
  - Bash(cp -R ${CLAUDE_PLUGIN_ROOT}/template/. .)
  - Bash(cp ${CLAUDE_PLUGIN_ROOT}/themes/clean/theme.css assets/css/theme.css)
---

# Set up the website

You are helping someone who is **not a developer** create their personal website.
They may not know what git, a repository or a terminal is.

How to talk to them:
- Plain English, short messages, one step at a time.
- Say what you're doing and why in a sentence, not a paragraph.
- Never show a raw error without explaining what it means and what happens next.
- When you need them to do something, give the exact thing to click or type.

Hard rules:
- Never delete, overwrite or force-push anything. Never run `gh repo delete`.
- Nothing goes to GitHub until they've seen the summary in step 7 and said yes.
- If a step fails and the fix isn't obvious, stop, explain in plain words, and
  tell them they can run `/site:setup` again once it's sorted. The steps below
  are safe to repeat.

The site is created **in the current folder**. The starter site lives at
`${CLAUDE_PLUGIN_ROOT}/template`.

## Before anything else: Windows needs Git for Windows

Every step below runs in the Bash shell. On Windows, Claude Code only has Bash
when **Git for Windows** is installed; without it, commands run in PowerShell.

If you only have a PowerShell tool and no Bash tool (or `$env:OS` is
`Windows_NT` and `git --version` fails), Git for Windows is missing. Explain that
it's the free tool that lets you save and publish their site, and ask before
installing it:

```
winget install --id Git.Git -e --source winget
```

Then ask them to **quit and reopen Claude Code** in this folder (so it picks up
the new shell) and run `/site:setup` again. Stop here until they do.

## 1. Check the folder

Run `ls -A` in the current folder.

- **Empty, or only `.claude` and `.DS_Store`:** good, continue.
- **Already has `_config.yml` and `_layouts/post.html`:** a previous setup got
  partway. Tell them you'll pick up where it stopped. Skip copying in step 5, and
  skip each later step that's already done (check with `git status`, `git remote -v`,
  `gh repo view`). Recover the repository name from `git remote get-url origin`
  if it's set, or from `baseurl` in `_config.yml` (empty means `<login>.github.io`).
- **Anything else:** stop. Explain that the website needs its own empty folder so
  nothing of theirs gets mixed in or overwritten. Tell them to create a new empty
  folder, open it in Claude Code, and run `/site:setup` there.

## 2. Check the tools

Find the operating system with `uname -s`: `Darwin` is macOS; `MINGW…`, `MSYS…`
or `CYGWIN…` is Windows.

**git** (`git --version`):
- Windows: present once you've reached this step (see "Before anything else").
- macOS, if missing: running `git --version` makes macOS offer to install the
  "Command Line Developer Tools". Tell them to click **Install**, wait for it to
  finish (a few minutes), then run `/site:setup` again.

**GitHub CLI** (`gh --version`). If missing, explain it's GitHub's official tool
that lets you publish for them, and ask before installing:
- macOS with Homebrew (`brew --version` works): `brew install gh`.
- macOS without Homebrew: ask them to download the macOS installer from
  https://cli.github.com, open it and follow the steps, then say "done".
- Windows: `winget install --id GitHub.cli -e --source winget`. After it
  finishes, `gh` may not be found until Claude Code restarts. If so, ask them to
  quit and reopen Claude Code in this folder, then run `/site:setup` again.

## 3. Sign in to GitHub

Run `gh auth status`. If they're signed in to github.com, go to the end of this step.

If not, you can't do this part for them because it needs their browser. Tell them:

> Open a terminal in this folder (in the Claude desktop app, use the Terminal tab;
> otherwise open Terminal on Mac or PowerShell on Windows) and run:
>
> `gh auth login --hostname github.com --git-protocol https --web`
>
> It asks a few things, one at a time:
>
> 1. **"Authenticate Git with your GitHub credentials? (Y/n)"**: press **Enter**
>    (that means yes). It lets me publish your site using this sign-in.
> 2. **"First copy your one-time code: XXXX-XXXX"**: note or copy that code.
> 3. **"Press Enter to open https://github.com/login/device in your browser"**:
>    press **Enter**.
> 4. In the browser: sign in to GitHub if asked, type or paste the code, click
>    **Continue**, then **Authorize GitHub CLI**.
> 5. Back in the terminal you'll see **"✓ Logged in as …"**.
>
> Then come back here and tell me "done".
>
> If it asks anything else, or the browser doesn't open, copy what the terminal
> says and paste it here.

When they say done, check `gh auth status` again.

Then run `gh auth setup-git`, so publishing uses this sign-in and they never need
a password or SSH key.

## 4. Get their details

Run `gh api user --jq '.login, .id, .name'` to get their GitHub username, numeric
id and display name. Use `<login>` in lowercase from here on.

### Choose where the site lives

Everything after this step uses three values: `<repo>`, `<site-url>` and `<baseurl>`.

**Main site (the normal case).** Check `gh repo view <login>/<login>.github.io`.
If that repository doesn't exist (or this is a resumed setup that created it):

- `<repo>` = `<login>.github.io`
- `<site-url>` = `https://<login>.github.io`
- `<baseurl>` = empty

**Second site (when they already have a main site).** If `<login>.github.io`
already exists and isn't from this setup, don't touch it. Explain in plain words:

> Your GitHub account already has a main website at `<login>.github.io`. I won't
> change it. I can create this site as a second one on the same account, at an
> address like `https://<login>.github.io/my-website/`. What name would you like
> at the end of the address? (Suggestion: `my-website`)

Clean up the name they give: lowercase, spaces become hyphens, only letters,
digits and hyphens. Check `gh repo view <login>/<name>` doesn't exist; if it does,
ask for another name. Then:

- `<repo>` = `<name>`
- `<baseurl>` = `/<name>`
- `<site-url>`: check whether the main site uses a custom domain with
  `gh api repos/<login>/<login>.github.io/pages --jq .cname`. If it returns a
  domain, `<site-url>` is `https://<that domain>`; otherwise
  `https://<login>.github.io`. The full address is `<site-url><baseurl>/`.

### Ask about them

Ask, in one message:
1. Their name as it should appear on the site (suggest their GitHub name if set).
2. One sentence describing the site (suggest: "Notes on what I know and what I'm learning.").
3. Optional: their LinkedIn profile (the part after `linkedin.com/in/`).
4. Optional: an email to show in the footer. Mention it will be public.

## 5. Create the site files

Copy the starter site and its default look (the `clean` theme) into the current
folder:

```
cp -R ${CLAUDE_PLUGIN_ROOT}/template/. .
cp ${CLAUDE_PLUGIN_ROOT}/themes/clean/theme.css assets/css/theme.css
```

Then:
- In `_config.yml`, set `title` and `author` to their name, `description`,
  `url` to `<site-url>`, `baseurl` to `<baseurl>` (in quotes, `""` when empty),
  `social.github` to `<login>`, and `social.linkedin` / `social.email` if given.
  Keep the comments. Quote values that contain `:` or `#`.
- Re-date the sample post in `_posts/`: replace the date at the start of its file
  name with today (`YYYY-MM-DD`), keeping the rest of the name, and set its
  `date:` to today.

## 6. Prepare the first version

Run these, with their name and the no-reply email built from step 4:

```
git init -b main
git config user.name "<their name>"
git config user.email "<id>+<login>@users.noreply.github.com"
git add -A
git commit -m "Create my website"
```

Explain briefly: the no-reply address is GitHub's private email for them, so their
real email never appears in the site's public history.

## 7. Confirm, then publish

Show a short summary and wait for a clear yes:

> Ready to publish. I'll create a **public** repository called `<repo>` on your
> GitHub account and put your site live at `<site-url><baseurl>/`.
> Everything in this folder will be public. Go ahead?

On yes:

```
gh repo create <repo> --public --source . --remote origin --push --description "My personal website"
gh api -X POST repos/<login>/<repo>/pages -f "source[branch]=main" -f "source[path]=/"
```

If the second command says Pages is already enabled (HTTP 409), that's fine.

## 8. Wait for the first build

Tell them GitHub is building the site, which usually takes one to three minutes.
Check every 15 seconds, for up to 5 minutes:

```
gh api repos/<login>/<repo>/pages/builds/latest --jq .status
```

- `built`: the site is live.
- `errored`: run `gh api repos/<login>/<repo>/pages/builds/latest --jq .error.message`
  and explain it in plain words.
- Still building after 5 minutes: tell them this is normal for a brand-new site,
  and to open the address in a few minutes.

## 9. Finish

Tell them:
- Their site is live at `<site-url><baseurl>/` (it can take a minute or two
  more to show up in the browser).
- They only need `/site:setup` once.
- What to do next:
  - Edit `about.md` to tell visitors about themselves.
  - `/site:new-post <title>` starts a new blog post.
  - `/site:publish` puts their changes live.
