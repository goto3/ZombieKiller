# ZombieKiller

A top-down zombie survival shooter game built with Kha framework and Haxe.

## Prerequisites

- [Node.js](https://nodejs.org/) (version 14 or higher)
- [Git](https://git-scm.com/)
- Python 3.x (for running local HTTP server)

## Setup

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd ZombieKiller
   ```

2. **Install Kha framework:**
   ```bash
   git clone --recursive https://github.com/Kode/Kha.git
   ```

## Building the Game

### HTML5 Build (Recommended)

1. **Build the project:**
   ```bash
   node Kha/make html5
   ```

2. **Run the game:**
   ```bash
   cd build/html5
   python -m http.server 8080
   ```

3. **Play the game:**
   Open your browser and navigate to `http://localhost:8080`

### Windows Build

1. **Build the project:**
   ```bash
   node Kha/make windows
   ```

2. **Compile (requires Visual Studio):**
   - Open `build/windows-build/New-Project.sln` in Visual Studio
   - Build the solution (F7 or Build → Build Solution)
   - Run the executable from `build/windows/Release/`

## Development

### Project Structure

- `Sources/` - Main game source code
  - `Main.hx` - Entry point
  - `entity/` - Game entities (player, enemies, weapons, etc.)
  - `models/` - Game data models
  - `states/` - Game states and levels
  - `customCollisionEngine/` - Custom collision detection system
  - `helpers/` - Utility functions

- `Assets/` - Game assets (maps, sprites, sounds)
- `khawy/` - Game engine framework
- `Libraries/` - External libraries (tiled map support)

### Making Changes

1. Edit source files in `Sources/` directory
2. Rebuild the project using `node Kha/make html5` or `node Kha/make windows`
3. Test your changes

### Common Build Targets

- `html5` - Web browser (easiest for testing)
- `windows` - Windows desktop application
- `windows-hl` - Windows with HashLink VM
- `linux` - Linux desktop application
- `android` - Android mobile app

## Assets Credits

### Graphics
- http://www.clker.com/clipart-ak47-assault-rifle.html
- https://animalroyale.fandom.com/wiki/File:Gun-silenced-pistol_orange.png
- https://animalroyale.fandom.com/wiki/File:Melee_knife-resources.assets-4120.png
- https://animalroyale.fandom.com/wiki/File:Gun-shotgun_orange.png
- https://opengameart.org/content/house-tileset-blackguard
- https://opengameart.org/content/dungeon-crawl-32x32-tiles

### Sounds
- https://www.youtube.com/watch?v=lXiLreNunv4
- https://www.youtube.com/watch?v=lI-MuemiaQQ
- https://www.youtube.com/watch?v=ozMFBUeCr3I
- https://freesound.org/

## Troubleshooting

### Build Errors

If you encounter compilation errors:
1. Make sure Kha is properly cloned with `--recursive` flag
2. Check that Node.js is installed: `node --version`
3. Try cleaning the build: delete the `build/` directory and rebuild

### Game Won't Run

- For HTML5: Make sure you're running a local web server (not opening index.html directly)
- For Windows: Ensure Visual Studio is installed with C++ development tools

## License

See individual asset credits above for licensing information.
