# Bonds — Claude Context

## Project structure

Single-file app: **`index.html`** contains all HTML, CSS, and JS. No build step.  
Served statically. Primary repo: `github.com/ghostoutfit/bonds`.  
Mirror: `github.com/sspi-sim/sim` under `bonds/` (sync manually after each push).

## Two modes

### Bonds mode (`currentMode = 'bonds'`)
Two-atom bond visualizer. Atom A = left (`customZ`, `animParent`, `electrons`, `orb3dShellGroups`, `orb3dShellCounts`). Atom B = right (`atomBZ`, `animParentB`, `electronsB`, `orb3dShellGroupsB`, `orb3dShellCountsB`). Bond configuration lives in `_bondPairConfigs['zA,zB']`.

### Molecules mode (`currentMode = 'molecules'`)
Preset crystal/molecule lattice. Presets: `'co2'`, `'h2o'`, `'nacl'`. State lives in `molSites[]` and `molBondElecs[]`. Initialized by `initMolecule()`.

## Quality modes

| Mode | FPS | `_nB` buckets | Notes |
|---|---|---|---|
| `'hi-res'` | 60 | 32 | Full quality |
| `'detailed'` | 60 | 4 | |
| `'simple'` | 30 | 2 | orbit3D gated by `_orb3dReady` (33 ms timer) |

**Important:** `stepMolBondElecs()` must run OUTSIDE the `_orb3dReady` gate (always at 60 fps). The phase-based bond cycle logic breaks with large `dt` values.

## Rendering tabs (both modes share the same tab bar)

- **Shells** — `drawElectronsShellsFor()`: 2D shell rings + electron dot/glow
- **Trails** — `drawElectronsFor()`: 2D trails following electron positions
- **Orbit 3D** — `_drawOrbit3DCore()` / `drawOrbit3D()`: precessing 3D ellipse trails

## Orbit 3D internals

Shell groups hold the 3D orbit state. Each group has: `count`, `phase`, `phOff[]`, `radPh`, `ax` (axis), `e1` (reference), `rot` (precession axis), `trails[][]`.

- **Atom A:** `orb3dShellGroups[s][]`, synced by `syncOrb3dShellSliders()`
- **Atom B:** `orb3dShellGroupsB[s][]`, synced by `syncOrb3dShellSlidersB()`
- Groups grow/shrink incrementally via `_growOrb3dShellB` / `_shrinkOrb3dShellB`
- **Always call `_clearOrb3dShellB(s)` for all shells before `syncOrb3dShellSlidersB()` in `setAtomBFromZ()`** — otherwise stale `colorOverride` values from a previous atom B bleed into the new atom's inner shells

### Ionic bond special injection (orbit 3D)
After `syncShellDevSliders()` in `_applyBondCombo()`, ionic pairs inject extra colored groups directly onto atom B's outer shell and set `bondTrailLen: 0` to suppress the flat 2D trail:

| Pair | Groups added to Cl/O outer shell |
|---|---|
| Na–Cl | +1 green (restores subtracted), +1 blue `#4488ff` (Na's electron) |
| Na–O | +1 red (restores subtracted), +1 blue `#4488ff` (Na's electron) |
| K–Cl | +1 green (restores subtracted), +1 pink `#ff66cc` (K's electron) |

## Electron colors

```js
const _INNER_E_COLOR = '#777777';          // all inner-shell electrons
ELEMENT_VALENCE_COLORS[1]  = '#aaaaaa';   // H — gray
ELEMENT_VALENCE_COLORS[6]  = '#ff8844';   // C — orange
ELEMENT_VALENCE_COLORS[8]  = '#44ff44';   // O — green
ELEMENT_VALENCE_COLORS[11] = '#4488ff';   // Na — blue
ELEMENT_VALENCE_COLORS[17] = '#44ff44';   // Cl — green
ELEMENT_VALENCE_COLORS[19] = '#ff66cc';   // K — pink
```

`_shellColorForZ(shell, Z, outerShell)` returns valence color for outer shell, `_INNER_E_COLOR` for inner.  
`e.color` overrides per-electron (used for transferred ionic electrons, molecule lone-pair colors, etc.).

## NaCl molecule specifics

- 3×3 lattice, alternating Na/Cl at `sep = 236 * shellBaseR * 0.8`
- Na: `lostOuter = true` → all electrons forced gray (`_INNER_E_COLOR`), ionic radius anchor at 100 pm (L-shell)
- Cl⁻: `extraOuter = 1` → gains 1 outer electron; last outer electron colored `_valenceColorForZ(11)` (blue) to represent Na's transferred electron
- Custom shell radii (`shellR` fn): Na L-shell ×2, Cl K+L shells ×1.5 (M-shell unchanged)
- Ghost-dot fix: `drawElectronsShellsFor` core dot radius must use `shellRFn` (same as glow dot)

## Simple mode inner trail cap

In `stepElectronsShellsFor()`: inner-shell electrons (shell < maxShell) cap trail history at `Math.round(eTrailLen * 0.6)`.

## Bond pair config keys

`_bondPairConfigs['zA,zB']` — always smaller or more-electropositive atom first (matches dropdown `value` format).

## Workflow

1. Edit `index.html` in `/Users/jkremer/Projects/bonds/`
2. Open via file:// or local server to test
3. Commit + push from bonds repo
4. Sync to ssp: `cp index.html /Users/jkremer/projects/ssp/bonds/index.html` then commit + push ssp
5. Bump `Field Test Version X.Y` in the version span before every commit
