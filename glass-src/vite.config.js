import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// Glass sim (from the glass repo's v4/). `npm run build` writes the static site into ../glass/,
// which GitHub Pages serves at sim.ssp.org/glass/ — base must stay '/glass/' (the icons are
// referenced as /glass/Turtle.png etc.).
export default defineConfig({
  plugins: [react()],
  base: '/glass/',
  build: {
    outDir: '../glass',
    emptyOutDir: true,   // outDir is outside this folder, so Vite needs explicit permission to clear it
  },
})
