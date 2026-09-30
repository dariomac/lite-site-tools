---
name: connect-domain
description: Connect the user's own domain (like yourname.com) to their GitHub Pages website, and turn on HTTPS once it's ready.
disable-model-invocation: true
argument-hint: <domain, e.g. yourname.com>
allowed-tools:
  - Bash(git remote:*)
  - Bash(git status:*)
  - Bash(git pull --rebase origin main)
  - Bash(git add CNAME _config.yml)
  - Bash(git commit -m "Use my own domain")
  - Bash(git push origin main)
  - Bash(gh api repos/:*)
  - Bash(nslookup:*)
---

# Connect a custom domain

You are helping someone who is **not a developer** point their own domain at their
website. DNS is the confusing part: be concrete, name the exact fields to fill in,
and reassure them that DNS changes can take a while and that's normal.

The domain they gave: `$ARGUMENTS`

This command is safe to run again. Each run checks what's already done and picks up
from there, so they can come back later to finish HTTPS.

## 1. Check the site is ready

- The current folder must contain `_config.yml`, and `git remote get-url origin`
  must point to GitHub. Take `<owner>/<repo>` from it.
- `gh api repos/<owner>/<repo>/pages` must succeed. If it doesn't, their site
  isn't published yet: tell them to run `/site:setup` first, and stop.

Note the current `cname` and `https_enforced` from that response.

## 2. Work out the domain

- If no domain was given and `cname` is already set, they're coming back to finish:
  use `cname` and skip to step 6.
- If no domain was given and none is set, ask which domain they want to use. If
  they haven't bought one yet, explain they can buy one from any domain registrar
  (for example Cloudflare, Porkbun or Namecheap) for about US$10–15 a year, then
  run this command again. Stop.
- Clean up what they typed: lowercase, and remove `http://`, `https://`, any path
  and any trailing `/` or `.`.

Decide which kind it is:
- **Root domain** (`yourname.com`, `yourname.dev`, `yourname.com.uy`): the site
  will answer at both `yourname.com` and `www.yourname.com`.
- **Subdomain** (`blog.yourname.com`, or `www.yourname.com` given on purpose): the
  site will answer only at that name.

If you can't tell (for example, unusual country endings), ask them.

## 3. Verify the domain with GitHub

This stops anyone else from ever using their domain for a GitHub site. It's done in
the browser, so tell them:

> 1. Open https://github.com/settings/pages
> 2. Click **Add a domain**, type `<root domain>` and click **Add domain**.
> 3. GitHub shows a **TXT record**: a name starting with `_github-pages-challenge-`
>    and a value. Keep that page open; you'll add it in the next step along with
>    the others.

Always verify the **root** domain, even when connecting a subdomain.

## 4. Add the DNS records

Explain that they need to sign in to the company where they bought the domain, find
the **DNS** settings for it, and add these records. Show them as a table.

**Root domain:**

| Type | Name / Host | Value / Points to |
|---|---|---|
| TXT | the `_github-pages-challenge-…` name from GitHub | the value from GitHub |
| A | `@` | `185.199.108.153` |
| A | `@` | `185.199.109.153` |
| A | `@` | `185.199.110.153` |
| A | `@` | `185.199.111.153` |
| CNAME | `www` | `<login>.github.io` |

Optional, for IPv6: four `AAAA` records on `@` with `2606:50c0:8000::153`,
`2606:50c0:8001::153`, `2606:50c0:8002::153` and `2606:50c0:8003::153`.

**Subdomain** (`<sub>.<root>`):

| Type | Name / Host | Value / Points to |
|---|---|---|
| TXT | the `_github-pages-challenge-…` name from GitHub | the value from GitHub |
| CNAME | `<sub>` | `<login>.github.io` |

Tips to include:
- If the registrar already has `A` or `CNAME` records on the same name (often a
  "parking" page or "URL forwarding"), delete those first, or the site won't load.
- Some registrars want the full name (`www.yourname.com`) instead of `www`, and `@`
  means the domain itself.
- On Cloudflare, set each record to **DNS only** (grey cloud), not Proxied.
- Changes usually work within minutes, but can take up to 24 hours.

Ask them to say "done" when the records are saved, then go back to the GitHub page
from step 3 and click **Verify**. It's fine if verification doesn't pass right away.

## 5. Point the site at the domain

Show what you're about to do and get a yes: set the domain on GitHub and update the
site's address in `_config.yml`, which goes live.

Then:

```
gh api -X PUT repos/<owner>/<repo>/pages -f cname=<domain>
```

GitHub adds a file called `CNAME` to their repository when you do this. Bring it
down with `git pull --rebase origin main`. If `CNAME` still doesn't exist in the
folder afterwards, create it containing just `<domain>`.

Set `url` in `_config.yml` to `https://<domain>`, then publish this change the same
way `/site:publish` does, but only these two files:

```
git add CNAME _config.yml
git commit -m "Use my own domain"
git push origin main
```

They've already said yes, so don't ask again. If they have other unpublished
changes, leave those alone and mention `/site:publish` at the end.

## 6. Check the DNS

```
gh api repos/<owner>/<repo>/pages/health
```

If it returns an empty or "still checking" response (HTTP 202), wait 15 seconds
and try again, up to 4 times.

- **DNS looks right:** tell them the domain is connected.
- **Not yet:** run `nslookup <domain>` (and `nslookup www.<domain>` for root
  domains) and compare with the table from step 4. Tell them in plain words which
  record is missing or wrong. If everything matches, it's just DNS taking time:
  tell them to run `/site:connect-domain` again in an hour or so.

## 7. Turn on HTTPS

Once DNS is right, GitHub issues a free security certificate. That can take from a
few minutes to about an hour. Try:

```
gh api -X PUT repos/<owner>/<repo>/pages -F https_enforced=true
```

- **Works:** HTTPS is on.
- **Fails because the certificate isn't ready:** that's normal. Tell them to run
  `/site:connect-domain` again later to finish this step; nothing else is needed.

## 8. Finish

Tell them where things stand, in one or two sentences:
- **All done:** their site is live at `https://<domain>`, and the old
  `<login>.github.io` address now forwards there automatically.
- **Waiting on DNS or HTTPS:** what's pending, and to run `/site:connect-domain`
  again later. `/site:status` also shows progress.
