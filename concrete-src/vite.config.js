import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// Concrete sim (from the concrete repo's v4/). `npm run build` writes the static site into
// ../concrete/, which GitHub Pages serves at sim.ssp.org/concrete/ — base must stay '/concrete/'
// (the images are referenced as /concrete/Pusher.png etc.).
export default defineConfig({
  plugins: [react()],
  base: '/concrete/',
  build: {
    outDir: '../concrete',
    emptyOutDir: true,   // outDir is outside this folder, so Vite needs explicit permission to clear it
  },
})
