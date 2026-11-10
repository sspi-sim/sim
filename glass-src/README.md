# Glass sim — source

The Glass simulation (soda-lime glass: Particles and Fields + Bulk Material), copied from
`glass/v4/` in the glass repo. It is a Vite + React app, so unlike the other single-file sims it
has a build step:

    npm install        # once
    npm run build      # writes the static site into ../glass/  →  sim.ssp.org/glass/
    npm run dev        # local dev server (open the /glass/ URL it prints)

Commit both this folder and the rebuilt `../glass/`. GitHub Pages serves `../glass/` as plain
static files; nothing builds on the server.

## Updating from the glass repo

    npm run sync       # copies glass/v4 + icons from ../../glass, then rebuilds ../glass/

(`GLASS_REPO=/path/to/glass npm run sync` if the glass repo lives elsewhere.) Edits made here
directly will be overwritten by the next sync — make them in the glass repo.

## Notes

- `base: '/glass/'` in vite.config.js must match the folder the site is served from; the toolbar
  icons are referenced as `/glass/Turtle.png` etc.
- `candidates.generated.js` (≈4 MB) holds the precomputed Bulk melt states. Regenerate with
  `npm run gen-candidates` after changing the sand melt physics or the particle melt curve.
- Developer docs (physics, calibration, tuning history) live in the glass repo's CLAUDE.md.
- Hidden dev panel: type "dev" on the page.
