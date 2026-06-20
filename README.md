# SSPI Chemistry Simulations — field-test hosting

Four standalone client-side sims, served as subfolders under one custom domain:

  /nucleus/          (also contains the master Table of Contents at /nucleus/#all)
  /fission/
  /chain-reaction/
  /fusion/
  /index.html        root redirect -> /nucleus/  (TOC stays unlisted)
  /CNAME             custom domain for GitHub Pages  <-- EDIT THIS

## What was changed from BSCS's originals
- Inter-sim navigation + Table-of-Contents links were rewritten from absolute
  `https://ghostoutfit.github.io/<sim>/` to ROOT-RELATIVE `/<sim>/`.
  Result: links stay on your domain and keep working no matter which subdomain
  you pick (so you are not locked to sim.ssp.org).
- Dropped dev-only files (.github workflow, CLAUDE.md). Web assets only.

## ONE DECISION LEFT — the in-sim "bug report" button
All four sims still POST the student's sim state to a BSCS endpoint:
  https://ghostoutfit.github.io/protons/dev/bug-report.html?sim=<name>&...
(4 occurrences, one per sim/index.html). This was NOT in Joe's four repos.
Choose one:
  (a) LEAVE IT  — bug reports flow to BSCS. Likely what they want during the
      field test. No action needed.
  (b) REPOINT   — change the URL to an SSPI-controlled endpoint.
  (c) STRIP     — remove the button if you don't want student state leaving.

## Push (after you create the org + empty repo)
    cd sims
    git init
    git add .
    git commit -m "Initial: four chemistry sims, links rehosted"
    git branch -M main
    git remote add origin https://github.com/<ORG>/<REPO>.git
    git push -u origin main
