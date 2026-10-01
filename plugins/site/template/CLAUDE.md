# My website

This is a personal website with a blog, built by GitHub Pages using Jekyll.
The owner is not a developer yet: explain things in plain English and avoid
git jargon unless you explain it.

## Where things live

- `_config.yml`: site title, author, links and settings
- `index.md`: home page
- `about.md`: about page
- `_posts/`: blog posts, one Markdown file each
- `_layouts/`: page structure
- `assets/css/theme.css`: the current theme (`theme_name` in `_config.yml`)
- `assets/css/custom.css`: the owner's own style changes

## Changing how the site looks

- To switch to a different look, use `/site:theme`.
- Put every style change the owner asks for ("make the links green", "bigger
  text") in `assets/css/custom.css`. **Never edit `theme.css`**: it's replaced
  when the theme changes, and the owner's changes would be lost.
- Prefer overriding the theme's variables in `custom.css`, e.g.
  `:root { --accent: #c2410c; }`. Every theme defines `--bg`, `--text`,
  `--muted`, `--accent`, `--border`, `--code-bg`, `--max`, `--font-body`,
  `--font-heading` and `--font-mono`.
- For a photo on the home page, put the image in `assets/images/` and set
  `avatar:` in `_config.yml` to its path, e.g. `/assets/images/me.jpg`.

## Blog posts

- File name: `_posts/YYYY-MM-DD-slug.md`, e.g. `_posts/2026-09-29-hello-world.md`.
  The slug is lowercase words joined by hyphens.
- Each post is served at `/blog/slug/`.
- Front matter:

  ```yaml
  ---
  title: The post title
  date: YYYY-MM-DD
  description: One sentence shown in the post list and in search results.
  ---
  ```

- Don't add `layout:`; posts get the post layout automatically.

## Publishing

GitHub builds the site on every push to the main branch. There is no local
build step. Use `/site:publish` to publish, and never push without the owner
asking to publish.
