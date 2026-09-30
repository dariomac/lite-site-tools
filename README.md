# lite-site-tools

A Claude Code plugin for building a personal website with a blog on GitHub Pages,
using your own domain. You don't need to know git: each step is a slash command.

## What you need

- A GitHub account
- A paid Claude plan (Pro or Max) and Claude Code. The Code tab in the Claude
  desktop app is the easiest way to use it.
- A domain name, if you want your own address. You can add it later.

`/setup-site` installs and signs in to everything else (git and the GitHub CLI) for you.

## Install

In Claude Code, run:

```
/plugin marketplace add dariomac/lite-site-tools
/plugin install lite-site-tools@lite-site-tools
```

To get new commands when they're released, open `/plugin`, choose the
`lite-site-tools` marketplace and turn on auto-update. You can also run
`/plugin marketplace update lite-site-tools` whenever you're told there's a new version.

## Commands

| Command | What it does |
|---|---|
| `/setup-site` | One-time setup: checks your tools, signs you in to GitHub, creates your site and turns it on |
| `/new-post <title>` | Creates a new blog post, ready to write |
| `/publish-site` | Publishes your changes to the live site |
| `/connect-domain <domain>` | Connects your own domain and tells you exactly what to set at your registrar |
| `/site-status` | Shows whether the latest publish worked and where your site is live |

_Commands are being added one at a time. This table lists the planned set._
