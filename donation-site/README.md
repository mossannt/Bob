# Moussa Natite Donation Website

A responsive, dependency-free donation landing page for **Moussa Natite**, an independent developer. The page is built with semantic HTML, custom CSS, and a small JavaScript file for the copy-to-clipboard interaction.

## Files

| File | Purpose |
|---|---|
| `index.html` | Page content, donation options, FAQ, and metadata |
| `styles.css` | Responsive visual design, layout, animation, and accessibility states |
| `script.js` | Current year, smooth scrolling, and payment-ID copy behavior |

## Customize payment destinations

Before publishing, replace the placeholder links in `index.html`:

- Update the Ko-fi URL in the first donation card.
- Update the Patreon URL in the second donation card.
- Replace `YOUR-PAYMENT-USERNAME` in both `index.html` and `script.js` with the correct payment username or identifier.

The page does not process payments itself. Use only payment links and account details that Moussa Natite controls and has verified.

## Run locally

Open `index.html` directly in a browser, or serve the folder with any static web server:

```bash
python3 -m http.server 8000 --directory donation-site
```

Then visit `http://localhost:8000`.

## Publish

The `donation-site` directory can be published by GitHub Pages, Netlify, Vercel, or any other static hosting provider. Set the publish directory to `donation-site` when the host asks for the site root.
