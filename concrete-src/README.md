# Concrete sim — source

The Concrete beam-test simulation, copied from `v4/` in the concrete repo (plus the 10 images it
uses from that repo's shared `public/`). It is a Vite + React app with a build step:

    npm install        # once
    npm run build      # writes the static site into ../concrete/  →  sim.ssp.org/concrete/
    npm run dev        # local dev server (open the /concrete/ URL it prints)

Commit both this folder and the rebuilt `../concrete/`. GitHub Pages serves `../concrete/` as plain
static files; nothing builds on the server.

## Updating from the concrete repo

    npm run sync       # copies concrete/v4 + images from ../../concrete, then rebuilds ../concrete/

(`CONCRETE_REPO=/path/to/concrete npm run sync` if the repo lives elsewhere.) The sync copies the
concrete repo's working tree, including uncommitted edits. Edits made here directly will be
overwritten by the next sync — make them in the concrete repo.

## Notes

- `base: '/concrete/'` in vite.config.js must match the folder the site is served from; images
  are referenced as `/concrete/Pusher.png` etc.
- Strength calibration (break-force table and its sources) is documented in the concrete repo's
  README.md; developer docs in its CLAUDE.md.
