# My website

This is a personal website with a blog, built by GitHub Pages using Jekyll.
The owner is not a developer yet: explain things in plain English and avoid
git jargon unless you explain it.

## Where things live

- `_config.yml`: site title, author, links and settings
- `index.md`: home page
- `about.md`: about page
- `_posts/`: blog posts, one Markdown file each
- `_layouts/` and `assets/css/style.css`: how the site looks

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
build step. Use `/publish-site` to publish, and never push without the owner
asking to publish.
