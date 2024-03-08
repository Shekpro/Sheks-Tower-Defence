// Created 14/8/21 4:30pm Shekinah Pratap 300565138
// Everything is proportional to the screen width and height
// https://stackoverflow.com/questions/401847/circle-rectangle-collision-detection-intersection
// Above equation used to help with calculating collision between circles and rectangles 
// Imports libraries
import java.util.*;
import processing.sound.*;
// Menu music taken from "Bloons Tower Defence 6" and other music and sounds taken from "Bloons Tower Defence 5" by Ninja Kiwi
SoundFile menuMusic; // https://www.youtube.com/watch?v=uJ_mRo-JIRE
SoundFile grassMusic; // https://www.youtube.com/watch?v=K-4SthopN2U
SoundFile bossMusic; // https://www.youtube.com/watch?v=-64rkJ8j-hM
SoundFile sandMusic; // https://www.youtube.com/watch?v=mGvkG2eZXVo
SoundFile concreteMusic; // https://www.youtube.com/watch?v=SazPaLHmjvs&list=PLvmIFMXfvno338LgR9O8y3o-jLD3bvCwp&index=4
SoundFile iceMusic; // https://www.youtube.com/watch?v=82rRlK314Zw&list=PLvmIFMXfvno338LgR9O8y3o-jLD3bvCwp&index=5
SoundFile firstBuy, gameOverSound, maxTower, victory, newGame, // MP3 files
  placeBeam, placeBoat, placeHeli, placeTower, deselect, noPlace, // WAV files
  info, lifeLost, enemyDie, sell, select, upgrade, waveOver, placeBolt; 
String screen = "Intro"; // Current screen user is viewing
float introTime = 0; // Intro effect timer
HashSet<Defence> defences; // Stores defence objects
HashSet<Enemy> enemies; // Stores enemy objects
HashSet<Projectile> projectiles; // Stores projectile objects
HashSet<BoltEffect> bolts; // Stores bolt objects
HashSet<TextPulse> texts; // Stores text objects
HashSet<Projectile> projectilesSpray = new HashSet<Projectile>(); // Sprayed projectiles from boat
HashSet<Enemy> removeE = new HashSet<Enemy>(); // Stores dead enemies which need to be removed
HashSet<Projectile> removeP = new HashSet<Projectile>(); // Stores projectiles which need to be removed
HashSet<TextPulse> removeT = new HashSet<TextPulse>(); // Stores texts which need to be removed
HashSet<Enemy> livesLost = new HashSet<Enemy>(); // Stores enemies have completed the track and need to be removed
HashSet<RotorEffect> rotEffects; // Stores razor rotor effects when colliding with enemies
HashSet<RotorEffect> removeRotEffects = new HashSet<RotorEffect>(); // Stores rotor effects which need to be removed
HashSet<BoltEffect> removeBolt = new HashSet<BoltEffect>(); // Stores bolt effects which need to be removed
ArrayList<MapPiece> mapPieces = new ArrayList<MapPiece>(); // Each piece of the map is stored in a list of map objects
float speed; // Speed of the game 
float trueSpeed = 1; // Speed of game ignoring pause
float projectileDist; // Distance between projectiles
float fireRate; // Firerate of the defences
int wave; // Current wave
int enemiesLeft = 0; // Number of enemies left to destroy for the wave
int enemiesToSpawn = 0; // Number of enemies which need to be spawned
float enemySpawnRate; // Spawn rate for enemies
float timer = 0; // Timer for time passed to help with spawning enemies according to their spawn rate
int money; // Cash the player currently has
String selected = "None"; // Selected thing, could be a placed defence or tower in the hotbar
int selectedCost; // Cost of selected tower in hotbar
float beamSize; // Size of beam 
float boatSize; // Size of boat 
float boltSize; // Size of bolt
float redSize; // Size of red enemy
float yellowSize; // Size of yellow enemy
float greenSize; // Size of green enemy
float selectSize; // Size of selected defence
float beamRange; // Range of beam
float boatRange; // Range of boat
float boltRange; // Range of bolt
float helipadSize; // Size of helipad for helicopter
float heliSize; // Size of helicopter
float scaleHeli = 1; // Scaled size of helipad
float heliRange; // Range of helicopter
Defence selectedDefence; // Defence object for selected defence
String hotBarSelect = "None"; // What the hotbar is currently displaying
float WIDTH, HEIGHT; // Width and height scaled to 16:9 ratio
float enemySpeed; // Speed of enemies moving
int lives; // Lives the player currently has
Boolean startWave = false; // If the wave can be started or not 
Boolean autoStart = false; // Toggle autostart waves
int pause; // If equals 0 game is paused, if equals 1 game is not paused
float barSize; // Size of the green bar
float targetOffset; // Offset for the upgrade selection
Boolean boatCollide = true; // Checks if boat is not touching water
float hotBarTop; // Top of hot bar
Boolean displayStats = false; // Displays tower stats if true
// Randomly generated grass
ArrayList<Float> darkGrassX;
ArrayList<Float> darkGrassY;
ArrayList<Float> lightGrassX;
ArrayList<Float> lightGrassY;
float grassSize;
int grassCount = 200;
// Tutorial booleans
Boolean chooseTower;
Boolean startFirst;
Boolean selectTowerToUpgrade;
Boolean upgradeTower;
String tutorialText;
float hintTime; // Timer for the hints popping up
Boolean bossWave = false; // If wave if a boss wave
int spawnedEnemies; // Number of enemies spawned for that wave
String lag; // Toggle reduce lag
float pausedSize; // Size of paused text for scaling toggle lag button
float baseHp; // Enemy health based on difficulty
String difficulty; // Difficulty of game
Boolean selectDifficulty; // Whether user needs to select difficulty or not
float themeR, themeG, themeB; // Colour theme
float[] trackX, track1X, track2X, track3X, track4X;
float[] trackY, track1Y, track2Y, track3Y, track4Y;
String[] trackDir, track1Dir, track2Dir, track3Dir, track4Dir, mapNames;
float[][] trackWater, waterT1, waterT2, waterT3, waterT4;
float[][] offset; // Offset for spawning enemies
float trackWidth, spacing; // Track dimensions
String mapDifficulty = "BEGINNER";
int selectedTrack; // Selected track for game
Boolean[] defenceInfo; // Whether info has showed or not that game so it doesn't repeat
String showDefenceInfo; // Tower of info showing
String[] showInfo; // Current info showing
// Information for towers
String[] beamInfo = {"BEAM BLASTS PLASMA TOWARDS ENEMIES", "THIS TOWER IS EFFECTIVE EARLY GAME", 
  "THE PLASMA ATTACK DESTROYS ARMOUR", "MAX LEVEL DOES 3X DAMAGE TO BOSSES"};
String[] boatInfo = {"BOAT COMES WITH A POWERFUL CANNON", "THIS TOWER DESTROYS GROUPED ENEMIES", 
  "INITIALLY USELESS AGAINST ARMOUR", "MAX LEVEL BOAT NOW WRECKS ARMOUR"};
String[] heliInfo = {"HELI LASER BLASTS DO MASSIVE DAMAGE", "VERY EXPENSIVE BUT WORTH THE COST", 
  "MANY PREFERENCES FOR FLIGHT PATH", "MAX LEVEL HELI GAINS RAZOR ROTORS"};
String[] boltInfo = {"BOLT STRIKES ENEMIES WITH LIGHTNING", "EFFECTIVE AGAINST STRONG ENEMIES", 
  "EACH CONNECTED CHAIN GETS WEAKER", "MAX LEVEL BOLT STUNS ENEMIES HIT"};
Boolean win; // Checks whether user has won or not
Boolean bossActive; // Whether boss is alive or not for music
Boolean gameOver; // If game is over or not
float volume = 0.5; // Volume of audio
PrintWriter output; // For saving custom maps
int customPages = 0; // Highest page of maps for custom maps
int customMaps = 0; // Highest map for custom maps
int currentCustomPage = 0; // Current custom page being displayed
String[] customMapNames, customMapThemes; // Names and themes for custom maps
float[][] customTrackX, customTrackY; // Stores track positions for map pieces for custom maps
String[][] customTrackDir; // Stores track directions for map pieces for custom maps
float[][][] customTrackWater; // Stores water map pieces for custom maps
float[][] customOffset; // Offset for custom tracks
String[] customMapTheme; // Custom map themes for the 4 or less displayed
// Everything needed for when creating a custom map and will convert to normal array once done
String customCreateName, customCreateTheme;
ArrayList<Float> customCreateTrackX, customCreateTrackY, customCreateOffset;
ArrayList<String> customCreateTrackDir;
ArrayList<float[]> customCreateWater;
String selectedMapPiece; // Currently selected piece of building custom map
float mX, mY, sX, sY; // Pos of track piece relative to mouse and prev piece in custom map creation
MapPiece tempOut, tempIn; // Temporary map pieces to follow mouse
Boolean startTrack; // If the start of the track exists for custom track
Boolean endTrack; // If the end of the track exists for custom track
PVector initCustomWater, finalCustomWater; // Coordinates for water pool in custom map
Boolean createWater; // Checks if water is currently being created in custom map
Typing typeName = new Typing(); // Used for typing custom map name
Boolean setName = false; // If the name needs to be set for custom map
Boolean[] customExists; // Boolean array for which maps exist on the current viewing page for custom maps
int gameTheme; // Theme for game
int lastTheme = 1; // Previous theme looked at in game for changing menu
PFont f; // Font for game

void setup() {
  // Makes it fullscreen and sets framerate to 60
  fullScreen();
  frameRate(60);
  
  // Creates font for game
  f = createFont("Prototype.ttf", 60); // https://www.1001freefonts.com/prototype.font 
  textFont(f);
}

void draw() {
  // Draws the background
  background(0);

  // Forces the width and height into 16:9 ratio
  if (width>height*16/9) {
    WIDTH = height*16/9;
    HEIGHT = height;
  } else {
    WIDTH = width;
    HEIGHT = width*9/16;
  }

  // Calculates the size of the bar for positioning things in the hot bar
  textSize(HEIGHT/30);
  barSize = textWidth("TOWERS"); 

  // Calculates the size of the track using the new height
  trackWidth = HEIGHT/10;
  spacing = trackWidth/5;

  // Creates the maps using x and y positions of the track, direction enemies need to move, and coordinates and size of the water pools
  if (mapDifficulty=="BEGINNER") {
    // Track 1: WALK IN THE PARK
    track1X = new float[] {0, WIDTH*0.4, WIDTH*0.4, WIDTH*0.15, WIDTH*0.15, WIDTH*0.7, WIDTH*0.7, WIDTH*0.85, WIDTH*0.85};
    track1Y = new float[] {HEIGHT*0.15, HEIGHT*0.15, HEIGHT*0.35, HEIGHT*0.35, HEIGHT*0.7, HEIGHT*0.7, HEIGHT*0.15, HEIGHT*0.15, HEIGHT*0.85};
    track1Dir = new String[] {"RIGHT", "DOWN", "LEFT", "DOWN", "RIGHT", "UP", "RIGHT", "DOWN"};
    waterT1 = new float[][] {{WIDTH*0.55, HEIGHT*0.35, WIDTH*0.2, HEIGHT*0.5}};

    // Track 2: 3 TIMES AROUND
    track2X = new float[] {WIDTH*0.43, WIDTH*0.43, WIDTH*0.57, WIDTH*0.57, WIDTH*0.43, WIDTH*0.43, WIDTH*0.57, WIDTH*0.57, WIDTH*0.43, WIDTH*0.43, WIDTH*0.57, WIDTH*0.57, WIDTH*0.43, WIDTH*0.43};
    track2Y = new float[] {0, HEIGHT*0.57, HEIGHT*0.57, HEIGHT*0.33, HEIGHT*0.33, HEIGHT*0.57, HEIGHT*0.57, HEIGHT*0.33, HEIGHT*0.33, HEIGHT*0.57, HEIGHT*0.57, HEIGHT*0.33, HEIGHT*0.33, HEIGHT*0.85};
    track2Dir = new String[] {"DOWN", "RIGHT", "UP", "LEFT", "DOWN", "RIGHT", "UP", "LEFT", "DOWN", "RIGHT", "UP", "LEFT", "DOWN"};
    waterT2 = new float[][] {{WIDTH*0.25, HEIGHT*0.425, WIDTH/5, HEIGHT*0.85}, {WIDTH*0.725, HEIGHT*0.45, WIDTH*0.15, HEIGHT*0.34}};

    // Track 3: THE BIG S
    track3X = new float[] {0, WIDTH-HEIGHT*0.6, WIDTH-HEIGHT*0.6, HEIGHT*0.6, HEIGHT*0.6, WIDTH};
    track3Y = new float[] {HEIGHT/5+WIDTH/4, HEIGHT/5+WIDTH/4, HEIGHT/5+WIDTH/8, HEIGHT/5+WIDTH/8, HEIGHT/5, HEIGHT/5};
    track3Dir = new String[] {"RIGHT", "UP", "LEFT", "UP", "RIGHT"};
    waterT3 = new float[][] {{HEIGHT*0.3, HEIGHT/5+WIDTH/16, HEIGHT*0.3, HEIGHT/5}, {WIDTH-HEIGHT*0.3, HEIGHT/5+WIDTH*3/16, HEIGHT*0.3, HEIGHT/5}};

    // Track 4: FROZEN LAKE
    track4X = new float[] {0, WIDTH*0.7, WIDTH*0.7, WIDTH*0.2, WIDTH*0.2, WIDTH*0.8, WIDTH*0.8, WIDTH};
    track4Y = new float[] {HEIGHT*0.12, HEIGHT*0.12, HEIGHT*0.3, HEIGHT*0.3, HEIGHT*0.7, HEIGHT*0.7, HEIGHT*0.3, HEIGHT*0.3};
    track4Dir = new String[] {"RIGHT", "DOWN", "LEFT", "DOWN", "RIGHT", "UP", "RIGHT"};
    waterT4 = new float[][] {{WIDTH/2, HEIGHT*0.5, WIDTH*0.5, HEIGHT*0.225}};

    // Map names
    mapNames = new String[] {"WALK IN THE PARK", "3 TIMES AROUND", "THE BIG S", "FROZEN LAKE"};

    // Spawn offset
    offset = new float[][] {{-0.5, 0}, {0, -0.5}, {-0.5, 0}, {-0.5, 0}};
  } else if (mapDifficulty=="INTERMEDIATE") {
    // Track 5: SHRUG
    track1X = new float[] {0, WIDTH*0.15, WIDTH*0.15, WIDTH*0.4, WIDTH*0.4, WIDTH*0.6, WIDTH*0.6, WIDTH*0.85, WIDTH*0.85, WIDTH};
    track1Y = new float[] {HEIGHT*0.33, HEIGHT*0.33, HEIGHT*0.63, HEIGHT*0.63, HEIGHT*0.53, HEIGHT*0.53, HEIGHT*0.63, HEIGHT*0.63, HEIGHT*0.33, HEIGHT*0.33};
    track1Dir = new String[] {"RIGHT", "DOWN", "RIGHT", "UP", "RIGHT", "DOWN", "RIGHT", "UP", "RIGHT"};
    waterT1 = new float[][] {{WIDTH/2, HEIGHT*0.3, WIDTH*0.204, WIDTH*0.204}};

    // Track 6: SCOOP
    track2X = new float[] {0, WIDTH/4+HEIGHT/20, WIDTH/4+HEIGHT/20, WIDTH*5/8, WIDTH*5/8, WIDTH};
    track2Y = new float[] {HEIGHT/5, HEIGHT/5, HEIGHT/5+WIDTH/4, HEIGHT/5+WIDTH/4, HEIGHT*0.15+WIDTH/8, HEIGHT*0.15+WIDTH/8};
    track2Dir = new String[] {"RIGHT", "DOWN", "RIGHT", "UP", "RIGHT"};
    waterT2 = new float[][] {{HEIGHT/40+WIDTH*7/16, HEIGHT*0.15+WIDTH/8-(HEIGHT/15)*0.6, WIDTH*3/8-HEIGHT*0.15-(HEIGHT/15)*2.4, WIDTH/4-(HEIGHT/15)*1.2}};

    // Track 7: U-TURN
    track3X = new float[] {HEIGHT/4, HEIGHT/4, WIDTH-HEIGHT/4, WIDTH-HEIGHT/4};
    track3Y = new float[] {0, hotBarTop-HEIGHT/5, hotBarTop-HEIGHT/5, 0};
    track3Dir = new String[] {"DOWN", "RIGHT", "UP"};
    waterT3 = new float[][] {{WIDTH/2, HEIGHT/3, WIDTH/3, HEIGHT/2}};

    // Track 8: FACE
    track4X = new float[] {WIDTH*0.42, WIDTH*0.42, WIDTH*0.25, WIDTH*0.25, WIDTH*0.75, WIDTH*0.75, WIDTH*0.58, WIDTH*0.58};
    track4Y = new float[] {HEIGHT*0.85, HEIGHT*0.72, HEIGHT*0.72, HEIGHT*0.13, HEIGHT*0.13, HEIGHT*0.72, HEIGHT*0.72, HEIGHT*0.85};
    track4Dir = new String[] {"UP", "LEFT", "UP", "RIGHT", "DOWN", "LEFT", "DOWN"};
    waterT4 = new float[][] {{WIDTH/2, HEIGHT*0.52, WIDTH*0.28, HEIGHT/8}, {WIDTH*0.4, HEIGHT*0.33, HEIGHT/8, HEIGHT/8}, {WIDTH*0.6, HEIGHT*0.33, HEIGHT/8, HEIGHT/8}, 
      {WIDTH*0.1864, HEIGHT*0.4, HEIGHT/8, HEIGHT/5}, {WIDTH*0.8136, HEIGHT*0.4, HEIGHT/8, HEIGHT/5}};

    // Map names
    mapNames = new String[] {"SHRUG", "SCOOP", "U-TURN", "FACE"};

    // Spawn offset
    offset = new float[][] {{-0.5, 0}, {-0.5, 0}, {0, -0.5}, {0, 0.5}};
  } else if (mapDifficulty=="ADVANCED") {
    // Track 9: DOUBLE DIP
    track1X = new float[] {0, WIDTH*0.3, WIDTH*0.3, WIDTH*0.4, WIDTH*0.4, WIDTH*0.6, WIDTH*0.6, WIDTH*0.7, WIDTH*0.7, WIDTH};
    track1Y = new float[] {HEIGHT*0.35, HEIGHT*0.35, HEIGHT*0.5, HEIGHT*0.5, HEIGHT*0.35, HEIGHT*0.35, HEIGHT*0.5, HEIGHT*0.5, HEIGHT*0.35, HEIGHT*0.35};
    track1Dir = new String[] {"RIGHT", "DOWN", "RIGHT", "UP", "RIGHT", "DOWN", "RIGHT", "UP", "RIGHT"};
    waterT1 = new float[][] {{WIDTH/2, HEIGHT*0.7, WIDTH, HEIGHT*0.3}};

    // Track 10: WALK THE PLANK
    track2X = new float[] {0, WIDTH*0.7, WIDTH*0.7, 0};
    track2Y = new float[] {HEIGHT*0.35, HEIGHT*0.35, HEIGHT*0.55, HEIGHT*0.55};
    track2Dir = new String[] {"RIGHT", "DOWN", "LEFT"};
    waterT2 = new float[][] {{WIDTH*0.55, HEIGHT*0.15, WIDTH*0.9, HEIGHT*0.3}, {WIDTH*0.55, HEIGHT*0.725, WIDTH*0.9, HEIGHT*0.25}, 
      {WIDTH*0.85+HEIGHT/40, HEIGHT*0.425, WIDTH*0.3-HEIGHT/20, HEIGHT*0.85}};

    // Track 11: ZIG ZAG LANE
    track3X = new float[] {WIDTH*0.45, WIDTH*0.45, WIDTH*0.55, WIDTH*0.55, WIDTH*0.45, WIDTH*0.45, WIDTH*0.55, WIDTH*0.55, WIDTH*0.45, WIDTH*0.45, WIDTH*0.55, WIDTH*0.55, };
    track3Y = new float[] {0, HEIGHT*0.145, HEIGHT*0.145, HEIGHT*0.285, HEIGHT*0.285, HEIGHT*0.425, HEIGHT*0.425, HEIGHT*0.565, HEIGHT*0.565, HEIGHT*0.705, HEIGHT*0.705, HEIGHT*0.85};
    track3Dir = new String[] {"DOWN", "RIGHT", "DOWN", "LEFT", "DOWN", "RIGHT", "DOWN", "LEFT", "DOWN", "RIGHT", "DOWN"};
    waterT3 = new float[][] {{WIDTH*0.225, HEIGHT*0.425, WIDTH/5, HEIGHT*0.85}, {WIDTH*0.775, HEIGHT*0.425, WIDTH/5, HEIGHT*0.85}};

    // Track 12: ICEBERG
    track4X = new float[] {0, WIDTH*0.1, WIDTH*0.1, WIDTH*0.3, WIDTH*0.3, WIDTH*0.5, WIDTH*0.5, WIDTH*0.65, WIDTH*0.65, WIDTH*0.75, WIDTH*0.75};
    track4Y = new float[] {HEIGHT*0.4, HEIGHT*0.4, HEIGHT*0.3, HEIGHT*0.3, HEIGHT*0.2, HEIGHT*0.2, HEIGHT*0.4, HEIGHT*0.4, HEIGHT*0.65, HEIGHT*0.65, HEIGHT*0.85};
    track4Dir = new String[] {"RIGHT", "UP", "RIGHT", "UP", "RIGHT", "DOWN", "RIGHT", "DOWN", "RIGHT", "DOWN"};
    waterT4 = new float[][] {{WIDTH*0.05-HEIGHT/40, HEIGHT*0.2-HEIGHT/40, WIDTH*0.1-HEIGHT/20, HEIGHT*0.4-HEIGHT/20}, //
      {WIDTH*0.2-HEIGHT/20-HEIGHT/40, HEIGHT*0.15-HEIGHT/40, WIDTH*0.2+HEIGHT/20, HEIGHT*0.3-HEIGHT/20}, //
      {WIDTH*0.4-HEIGHT/40, HEIGHT*0.1-HEIGHT/40, WIDTH*0.4, HEIGHT*0.2-HEIGHT/20}, //
      {WIDTH*0.575+HEIGHT/40+HEIGHT/20, HEIGHT*0.2-HEIGHT/40, WIDTH*0.15+HEIGHT/20, HEIGHT*0.4-HEIGHT/20}, //
      {WIDTH*0.7+HEIGHT/10-HEIGHT/40, HEIGHT*0.325-HEIGHT/40, WIDTH*0.1+HEIGHT/20, HEIGHT*0.65-HEIGHT/20}, 
      {WIDTH*0.875+HEIGHT/40, HEIGHT*0.425, WIDTH*0.25-HEIGHT/20, HEIGHT*0.85}}; //

    // Map names
    mapNames = new String[] {"DOUBLE DIP", "WALK THE PLANK", "ZIG ZAG LANE", "ICEBERG"};

    // Spawn offset
    offset = new float[][] {{0, 0}, {-0.5, 0}, {0, -0.5}, {-0.5, 0}};
  } else if (mapDifficulty=="EXTREME") {
    // Track 13: DUCK
    track1X = new float[] {0, WIDTH*0.13, WIDTH*0.13, WIDTH*0.4, WIDTH*0.4, WIDTH*0.3, WIDTH*0.3};
    track1Y = new float[] {HEIGHT*0.4, HEIGHT*0.4, HEIGHT*0.15, HEIGHT*0.15, HEIGHT*0.55, HEIGHT*0.55, HEIGHT*0.85};
    track1Dir = new String[] {"RIGHT", "UP", "RIGHT", "DOWN", "LEFT", "DOWN"};
    waterT1 = new float[][] {{WIDTH*0.553, HEIGHT*0.425, WIDTH/4, HEIGHT/5}, {WIDTH*0.3, HEIGHT*0.3, HEIGHT/10, HEIGHT/10}, {WIDTH/10, HEIGHT*0.65, WIDTH/5, HEIGHT/5}};

    // Track 14: CRACKED
    track2X = new float[] {WIDTH*0.38, WIDTH*0.38, WIDTH*0.5, WIDTH*0.5, WIDTH*0.62, WIDTH*0.62};
    track2Y = new float[] {0, HEIGHT*0.285, HEIGHT*0.285, HEIGHT*0.565, HEIGHT*0.565, HEIGHT*0.85};
    track2Dir = new String[] {"DOWN", "RIGHT", "DOWN", "RIGHT", "DOWN"};
    waterT2 = new float[][] {{WIDTH*0.25, HEIGHT*0.425, HEIGHT/8, HEIGHT*0.85}, {WIDTH*0.75, HEIGHT*0.425, HEIGHT/8, HEIGHT*0.85}, 
      {WIDTH*0.375, HEIGHT*0.85-HEIGHT/16, WIDTH*0.3, HEIGHT/8}, {WIDTH*0.625, HEIGHT/16, WIDTH*0.3, HEIGHT/8}, 
      {WIDTH*0.325, HEIGHT*0.6125, WIDTH*0.175, HEIGHT*0.35}, {WIDTH*0.675, HEIGHT*0.2375, WIDTH*0.175, HEIGHT*0.35}};

    // Track 15: ROAD OF DEATH
    track3X = new float[] {0, WIDTH};
    track3Y = new float[] {HEIGHT*0.45, HEIGHT*0.45};
    track3Dir = new String[] {"RIGHT"};
    waterT3 = new float[][] {{WIDTH/2, HEIGHT*0.275, WIDTH, HEIGHT/10}, {WIDTH/2, HEIGHT*0.625, WIDTH, HEIGHT/10}};

    // Track 16: TAKE THE L
    track4X = new float[] {WIDTH/2, WIDTH/2, WIDTH};
    track4Y = new float[] {0, HEIGHT*0.6, HEIGHT*0.6};
    track4Dir = new String[] {"DOWN", "RIGHT"};
    waterT4 = new float[][] {{WIDTH/3, HEIGHT*0.425, WIDTH/4, WIDTH/2}};

    // Map names
    mapNames = new String[] {"DUCK", "CRACKED", "ROAD OF DEATH", "TAKE THE L"};

    // Spawn offset
    offset = new float[][] {{-0.5, 0}, {0, -0.5}, {-0.5, 0}, {0, -0.5}};
  }
  noStroke();

  // Y position of the top part of the hot bar, so it is technically the bottom of the map
  hotBarTop = HEIGHT*0.85;

  // Displays the current viewing screen
  if (screen=="Intro") {
    // Waits for music to load and lets user know
    textSize(HEIGHT/50);
    textAlign(CENTER, BOTTOM);
    fill(255);
    if (introTime==0) {
      text("Loading music please wait...", WIDTH/2, HEIGHT);
    }

    // Generates a loading screen
    textSize(HEIGHT/10);
    textAlign(LEFT, CENTER);
    if (introTime>510) {
      background(introTime-510);
    }

    // Text displayed for loading, changes by increasing dot count to 3, then starting back at 1 dot
    String load; 
    // Displays loading text depending on the time increments of the intro
    if (introTime%180<60) {
      load = "LOADING.";
    } else if (introTime%180<120) {
      load = "LOADING..";
    } else {
      load = "LOADING...";
    }

    // Displays loading text and sets the colour equivalent to the loading stage
    if (introTime<=255) {
      fill(introTime);
      text(load, WIDTH/2-textWidth("LOADING.")/2, HEIGHT/2-textDescent());
    } else if (introTime<=510) {
      fill(510-introTime);
      text(load, WIDTH/2-textWidth("LOADING.")/2, HEIGHT/2-textDescent());
    }

    if (introTime>510) {
      // Draws cool transition effect for when loaded
      fill(introTime-200);
      rectMode(CENTER);
      for (int i=0; i<(introTime-510)*2; i++) {
        rect(random(0, WIDTH), random(0, HEIGHT), HEIGHT/20, HEIGHT/20);
      }
    }

    // Loads in music & sounds after one frame of draw, so the background is black and text is showing
    if (introTime==4) {
      // MP3 files
      menuMusic = new SoundFile(this, "Music/menuMusic.mp3");
      grassMusic = new SoundFile(this, "Music/grassMusic.mp3");
      sandMusic = new SoundFile(this, "Music/sandMusic.mp3");
      concreteMusic = new SoundFile(this, "Music/concreteMusic.mp3");
      iceMusic = new SoundFile(this, "Music/iceMusic.mp3");
      bossMusic = new SoundFile(this, "Music/bossMusic.mp3");
      firstBuy = new SoundFile(this, "Music/firstBuy.mp3");
      gameOverSound = new SoundFile(this, "Music/gameOver.mp3");
      maxTower = new SoundFile(this, "Music/maxTower.mp3");
      victory = new SoundFile(this, "Music/victory.mp3");
      newGame = new SoundFile(this, "Music/newGame.mp3");
      // WAV files
      placeBeam = new SoundFile(this, "Music/placeBeam.wav");
      placeBoat = new SoundFile(this, "Music/placeBoat.wav");
      placeHeli = new SoundFile(this, "Music/placeHeli.wav");
      placeBolt = new SoundFile(this, "Music/placeBolt.wav");
      placeTower = new SoundFile(this, "Music/placeTower.wav");
      deselect = new SoundFile(this, "Music/deselect.wav");
      noPlace = new SoundFile(this, "Music/noPlace.wav");
      sell = new SoundFile(this, "Music/sell.wav");
      select = new SoundFile(this, "Music/select.wav");
      upgrade = new SoundFile(this, "Music/upgrade.wav");
      waveOver = new SoundFile(this, "Music/waveOver.wav");
      info = new SoundFile(this, "Music/info.wav");
      lifeLost = new SoundFile(this, "Music/lifeLost.wav");
      enemyDie = new SoundFile(this, "Music/enemyDie.wav");
      // Edits bg music
      setMusic(volume);
      // Edits sound effects
      setSound(volume);
      enemyDie.rate(2.5);
    }

    // Plays menu music once loading screen is done
    if (introTime>=765) {
      screen = "Menu";
      menuMusic.loop();
    } else {
      introTime+=4;
    }
  } else if (screen=="Menu") {
    // Draws menu background
    rectMode(CENTER);
    drawMenu();

    // Title
    textAlign(CENTER, TOP);
    textSize(HEIGHT/8);
    fill(100);
    text("SHEK'S TOWER DEFENCE", WIDTH/2, HEIGHT/25+HEIGHT/110);
    fill(255);
    text("SHEK'S TOWER DEFENCE", WIDTH/2, HEIGHT/25);

    // Draws play button
    float buttonW = WIDTH*0.24;
    float buttonH = WIDTH*0.09;
    float buttonSpacing = buttonH/5;
    fill(120, 60, 0);
    rect(WIDTH/2, HEIGHT*0.31, buttonW, buttonH);
    fill(140, 80, 0);
    rect(WIDTH/2, HEIGHT*0.31, buttonW-buttonSpacing, buttonH-buttonSpacing);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(HEIGHT/10);
    text("PLAY", WIDTH/2, HEIGHT*0.31-textDescent()/2);

    // Draws custom button for custom levels
    fill(120, 60, 0);
    rect(WIDTH/2, HEIGHT*0.475, buttonW*0.8, buttonH*0.8);
    fill(140, 80, 0);
    rect(WIDTH/2, HEIGHT*0.475, (buttonW-buttonSpacing)*0.8, (buttonH-buttonSpacing)*0.8);
    fill(255);
    textSize(HEIGHT/15);
    text("CUSTOM", WIDTH/2, HEIGHT*0.475-textDescent()/2);

    // Draws audio toggle
    float audX = WIDTH/20;
    float audY = HEIGHT-audX;
    float audSize = HEIGHT/15;
    fill(200, 150, 0);
    rect(audX, audY, audSize, audSize);
    fill(255, 200, 0);
    rect(audX, audY, audSize*0.8, audSize*0.8);

    // Music note
    fill(255);
    ellipse(audX-audSize/5-WIDTH/1000, audY+audSize/5, audSize/5, audSize/5);
    ellipse(audX+audSize/5-WIDTH/1000, audY+audSize/8, audSize/5, audSize/5);
    stroke(255);
    strokeWeight(HEIGHT/250);
    line(audX-audSize/5+audSize/10-WIDTH/1000, audY+audSize/5, audX-audSize/5+audSize/10-WIDTH/1000, audY-audSize/8);
    line(audX-audSize/5+audSize/10-WIDTH/1000, audY-audSize/8, audX+audSize/5+audSize/10-WIDTH/1000, audY-audSize/4);
    line(audX+audSize/5+audSize/10-WIDTH/1000, audY-audSize/5, audX+audSize/5+audSize/10-WIDTH/1000, audY+audSize/8);
    noStroke();

    // Draws X if muted
    if (volume==0) {
      fill(255, 0, 0);
      text("X", audX, audY-textDescent()/2);
    }

    // Draws exit button
    fill(120, 60, 0);
    rect(WIDTH*0.945, HEIGHT-WIDTH*0.035, WIDTH*0.07, WIDTH*0.03);
    fill(140, 80, 0);
    rect(WIDTH*0.945, HEIGHT-WIDTH*0.035, WIDTH*0.06, WIDTH*0.02);
    fill(255);
    textSize(HEIGHT/40);
    text("EXIT", WIDTH*0.945, HEIGHT-WIDTH*0.035-textDescent()/2);
  } else if (screen=="MapSelect") {
    // Draws background
    rectMode(CENTER);
    fill(100, 50, 0);
    rect(WIDTH/2, HEIGHT/2, WIDTH, HEIGHT);
    fill(200, 100, 0);
    rect(WIDTH/2, HEIGHT/2, WIDTH-HEIGHT/10, HEIGHT*0.9);
    textSize(HEIGHT/13);
    textAlign(CENTER, CENTER);
    fill(255);
    text(mapDifficulty + " MAPS", WIDTH/2, HEIGHT/10);

    // Scales maps for display
    mapPieces = new ArrayList<MapPiece>();
    trackWidth = trackWidth/4;
    spacing = spacing/4;

    // Draws boxes and colours to theme
    fill(0, 190, 0);
    rect(WIDTH*0.31, HEIGHT*0.35, WIDTH*0.3, HEIGHT*0.3);
    fill(220, 180, 70);
    rect(WIDTH*0.69, HEIGHT*0.35, WIDTH*0.3, HEIGHT*0.3);
    fill(138);
    rect(WIDTH*0.31, HEIGHT*0.73, WIDTH*0.3, HEIGHT*0.3);
    fill(147, 217, 250);
    rect(WIDTH*0.69, HEIGHT*0.73, WIDTH*0.3, HEIGHT*0.3);

    // Scales and draws map 1
    trackX = track1X;
    trackY = track1Y;
    trackDir = track1Dir;
    trackWater = waterT1;
    for (int i=0; i<trackX.length; i++) { // Scales it to top left
      trackX[i] = (trackX[i]-WIDTH/2)*0.3+WIDTH*0.31;
      trackY[i] = (trackY[i]-HEIGHT/2)*0.3+HEIGHT*0.35;
    }
    for (int i=0; i<trackWater.length; i++) {
      trackWater[i][0] = (trackWater[i][0]-WIDTH/2)*0.3+WIDTH*0.31;
      trackWater[i][1] = (trackWater[i][1]-HEIGHT/2)*0.3+HEIGHT*0.35;
      trackWater[i][2] = trackWater[i][2]*0.3;
      trackWater[i][3] = trackWater[i][3]*0.3;
    }
    drawMap("Dirt");
    // Scales and draws map 2
    trackX = track2X;
    trackY = track2Y;
    trackDir = track2Dir;
    trackWater = waterT2;
    for (int i=0; i<trackX.length; i++) { // Scales it to top right
      trackX[i] = (trackX[i]-WIDTH/2)*0.3+WIDTH*0.69;
      trackY[i] = (trackY[i]-HEIGHT/2)*0.3+HEIGHT*0.35;
    }
    for (int i=0; i<trackWater.length; i++) {
      trackWater[i][0] = (trackWater[i][0]-WIDTH/2)*0.3+WIDTH*0.69;
      trackWater[i][1] = (trackWater[i][1]-HEIGHT/2)*0.3+HEIGHT*0.35;
      trackWater[i][2] = trackWater[i][2]*0.3;
      trackWater[i][3] = trackWater[i][3]*0.3;
    }
    drawMap("Sand");
    // Scales and draws map 3
    trackX = track3X;
    trackY = track3Y;
    trackDir = track3Dir;
    trackWater = waterT3;
    for (int i=0; i<trackX.length; i++) { // Scales it to bottom left
      trackX[i] = (trackX[i]-WIDTH/2)*0.3+WIDTH*0.31;
      trackY[i] = (trackY[i]-HEIGHT/2)*0.3+HEIGHT*0.73;
    }
    for (int i=0; i<trackWater.length; i++) {
      trackWater[i][0] = (trackWater[i][0]-WIDTH/2)*0.3+WIDTH*0.31;
      trackWater[i][1] = (trackWater[i][1]-HEIGHT/2)*0.3+HEIGHT*0.73;
      trackWater[i][2] = trackWater[i][2]*0.3;
      trackWater[i][3] = trackWater[i][3]*0.3;
    }
    drawMap("Road");
    // Scales and draws map 4
    trackX = track4X;
    trackY = track4Y;
    trackDir = track4Dir;
    trackWater = waterT4;
    for (int i=0; i<trackX.length; i++) { // Scales it to bottom right
      trackX[i] = (trackX[i]-WIDTH/2)*0.3+WIDTH*0.69;
      trackY[i] = (trackY[i]-HEIGHT/2)*0.3+HEIGHT*0.73;
    }
    for (int i=0; i<trackWater.length; i++) {
      trackWater[i][0] = (trackWater[i][0]-WIDTH/2)*0.3+WIDTH*0.69;
      trackWater[i][1] = (trackWater[i][1]-HEIGHT/2)*0.3+HEIGHT*0.73;
      trackWater[i][2] = trackWater[i][2]*0.3;
      trackWater[i][3] = trackWater[i][3]*0.3;
    }
    drawMap("Ice");

    // Draws boxes under text and colours to theme
    fill(0, 160, 0);
    rect(WIDTH*0.31, HEIGHT*0.4775, WIDTH*0.3, HEIGHT*0.045);
    fill(180, 140, 30);
    rect(WIDTH*0.69, HEIGHT*0.4775, WIDTH*0.3, HEIGHT*0.045);
    fill(110);
    rect(WIDTH*0.31, HEIGHT*0.8575, WIDTH*0.3, HEIGHT*0.045);
    fill(117, 167, 220);
    rect(WIDTH*0.69, HEIGHT*0.8575, WIDTH*0.3, HEIGHT*0.045);

    // Draws map text
    fill(255);
    textSize(HEIGHT/30);
    text(mapNames[0], WIDTH*0.31, HEIGHT*0.4725);
    text(mapNames[1], WIDTH*0.69, HEIGHT*0.4725);
    text(mapNames[2], WIDTH*0.31, HEIGHT*0.8525);
    text(mapNames[3], WIDTH*0.69, HEIGHT*0.8525);

    // Draws border
    strokeWeight(HEIGHT/50);
    noFill();
    // Colours border to theme
    stroke(0, 130, 0);
    rect(WIDTH*0.31, HEIGHT*0.35, WIDTH*0.31, HEIGHT*0.31);
    stroke(155, 115, 5);
    rect(WIDTH*0.69, HEIGHT*0.35, WIDTH*0.31, HEIGHT*0.31);
    stroke(95);
    rect(WIDTH*0.31, HEIGHT*0.73, WIDTH*0.31, HEIGHT*0.31);
    stroke(87, 137, 190);
    rect(WIDTH*0.69, HEIGHT*0.73, WIDTH*0.31, HEIGHT*0.31);
    noStroke();

    // Draws left arrow for choosing map
    float col; // Shade of arrow if can press button or not
    if (mapDifficulty=="BEGINNER") {
      col = 0.75;
    } else {
      col = 1;
    }
    fill(255*col);
    rect(WIDTH*0.09, HEIGHT*0.54, HEIGHT*0.11, HEIGHT*0.26);
    fill(220*col, 180*col, 0);
    rect(WIDTH*0.09, HEIGHT*0.54, HEIGHT/10, HEIGHT/4);
    fill(255*col, 255*col, 50*col);
    triangle(WIDTH*0.09+HEIGHT/30, HEIGHT*0.65, WIDTH*0.09+HEIGHT/30, HEIGHT*0.43, WIDTH*0.09-HEIGHT/30, HEIGHT*0.54);

    // Draws right arrow for choosing map
    if (mapDifficulty=="EXTREME") {
      col = 0.75;
    } else {
      col = 1;
    }
    fill(255*col);
    rect(WIDTH*0.91, HEIGHT*0.54, HEIGHT*0.11, HEIGHT*0.26);
    fill(220*col, 180*col, 0);
    rect(WIDTH*0.91, HEIGHT*0.54, HEIGHT/10, HEIGHT/4);
    fill(255*col, 255*col, 50*col);
    triangle(WIDTH*0.91-HEIGHT/30, HEIGHT*0.65, WIDTH*0.91-HEIGHT/30, HEIGHT*0.43, WIDTH*0.91+HEIGHT/30, HEIGHT*0.54);

    // Draws exit button
    fill(200, 0, 0);
    rect(HEIGHT/10, HEIGHT*0.9, HEIGHT/15, HEIGHT/15);
    fill(255, 0, 0);
    rect(HEIGHT/10, HEIGHT*0.9, HEIGHT/20, HEIGHT/20);
    fill(255);
    text("X", HEIGHT/10, HEIGHT*0.9-textDescent()/2);
  } else if (screen=="CustomSelect") { // Custom map screen
    // Draws background
    rectMode(CENTER);
    fill(60, 75, 90);
    rect(WIDTH/2, HEIGHT/2, WIDTH, HEIGHT);
    fill(115, 147, 179);
    rect(WIDTH/2, HEIGHT/2, WIDTH-HEIGHT/10, HEIGHT*0.9);
    textSize(HEIGHT/13);
    textAlign(CENTER, CENTER);
    fill(255);
    text("CUSTOM MAPS", WIDTH/2, HEIGHT/10);

    // Scales maps for display
    mapPieces = new ArrayList<MapPiece>();
    trackWidth = trackWidth/4;
    spacing = spacing/4;

    // Figures out which maps need to be drawn
    int mapView = currentCustomPage*4;
    customExists = new Boolean[] {mapView+1<=customMaps, mapView+2<=customMaps, mapView+3<=customMaps, mapView+4<=customMaps}; 

    // Converts map names, themes, and offsets to an arraylist
    ArrayList<String> customNames = new ArrayList<String>();
    ArrayList<String> customThemes = new ArrayList<String>();
    ArrayList<float[]> customOffsets = new ArrayList<float[]>();
    for (int i=0; i<4; i++) {
      if (customExists[i]) {
        customNames.add(customMapNames[mapView+i]);
        customThemes.add(customMapThemes[mapView+i]);
        customOffsets.add(customOffset[mapView+i]);
      }
    }

    // Converts map names, themes, and spawn offsets to arrays
    mapNames = new String[customNames.size()];
    for (int i =0; i<customNames.size(); i++) {
      mapNames[i] = customNames.get(i);
    }

    customMapTheme = new String[customThemes.size()];
    for (int i =0; i<customThemes.size(); i++) {
      customMapTheme[i] = customThemes.get(i);
    }

    offset = new float[customOffsets.size()][];
    for (int i =0; i<customOffsets.size(); i++) {
      offset[i] = customOffsets.get(i);
    }

    // Draws mini maps
    if (customExists[0]) {
      // Draws themed box
      if (customMapTheme[0].equals("Dirt")) {
        fill(0, 190, 0);
      } else if (customMapTheme[0].equals("Sand")) {
        fill(220, 180, 70);
      } else if (customMapTheme[0].equals("Road")) {
        fill(138);
      } else if (customMapTheme[0].equals("Ice")) {
        fill(147, 217, 250);
      }
      rect(WIDTH*0.31, HEIGHT*0.35, WIDTH*0.3, HEIGHT*0.3);

      // Initializes arrays
      trackX = new float[customTrackX[mapView].length];
      trackY = new float[customTrackY[mapView].length];
      trackDir = new String[customTrackDir[mapView].length];
      trackWater = new float[customTrackWater[mapView].length][4];

      // Scales and draws map 1
      arrayCopy(customTrackX[mapView], trackX);
      arrayCopy(customTrackY[mapView], trackY);
      arrayCopy(customTrackDir[mapView], trackDir);
      for (int i=0; i<customTrackWater[mapView].length; i++) {
        for (int w=0; w<4; w++) {
          trackWater[i][w] = customTrackWater[mapView][i][w];
        }
      }

      // Initializes track arrays
      track1X = new float[customTrackX[mapView].length];
      track1Y = new float[customTrackY[mapView].length];
      track1Dir = new String[customTrackDir[mapView].length];
      waterT1 = new float[customTrackWater[mapView].length][4];

      // Copies map info to track 1
      arrayCopy(customTrackX[mapView], track1X);
      arrayCopy(customTrackY[mapView], track1Y);
      arrayCopy(customTrackDir[mapView], track1Dir);
      for (int i=0; i<customTrackWater[mapView].length; i++) {
        for (int w=0; w<4; w++) {
          waterT1[i][w] = customTrackWater[mapView][i][w];
        }
      }

      for (int i=0; i<trackX.length; i++) { // Scales it to top left
        trackX[i] = (trackX[i]-WIDTH/2)*0.3+WIDTH*0.31;
        trackY[i] = (trackY[i]-HEIGHT/2)*0.3+HEIGHT*0.35;
      }
      for (int i=0; i<trackWater.length; i++) {
        trackWater[i][0] = (trackWater[i][0]-WIDTH/2)*0.3+WIDTH*0.31;
        trackWater[i][1] = (trackWater[i][1]-HEIGHT/2)*0.3+HEIGHT*0.35;
        trackWater[i][2] = trackWater[i][2]*0.3;
        trackWater[i][3] = trackWater[i][3]*0.3;
      }
      drawMap(customMapTheme[0]);
    }

    if (customExists[1]) {
      // Draws themed box
      if (customMapTheme[1].equals("Dirt")) {
        fill(0, 190, 0);
      } else if (customMapTheme[1].equals("Sand")) {
        fill(220, 180, 70);
      } else if (customMapTheme[1].equals("Road")) {
        fill(138);
      } else if (customMapTheme[1].equals("Ice")) {
        fill(147, 217, 250);
      }
      rect(WIDTH*0.69, HEIGHT*0.35, WIDTH*0.3, HEIGHT*0.3);

      // Initializes arrays
      trackX = new float[customTrackX[mapView+1].length];
      trackY = new float[customTrackY[mapView+1].length];
      trackDir = new String[customTrackDir[mapView+1].length];
      trackWater = new float[customTrackWater[mapView+1].length][4];

      // Scales and draws map 2
      arrayCopy(customTrackX[mapView+1], trackX);
      arrayCopy(customTrackY[mapView+1], trackY);
      arrayCopy(customTrackDir[mapView+1], trackDir);
      for (int i=0; i<customTrackWater[mapView+1].length; i++) {
        for (int w=0; w<4; w++) {
          trackWater[i][w] = customTrackWater[mapView+1][i][w];
        }
      }

      // Initializes track arrays
      track2X = new float[customTrackX[mapView+1].length];
      track2Y = new float[customTrackY[mapView+1].length];
      track2Dir = new String[customTrackDir[mapView+1].length];
      waterT2 = new float[customTrackWater[mapView+1].length][4];

      // Copies map info to track 2
      arrayCopy(customTrackX[mapView+1], track2X);
      arrayCopy(customTrackY[mapView+1], track2Y);
      arrayCopy(customTrackDir[mapView+1], track2Dir);
      for (int i=0; i<customTrackWater[mapView+1].length; i++) {
        for (int w=0; w<4; w++) {
          waterT2[i][w] = customTrackWater[mapView+1][i][w];
        }
      }

      for (int i=0; i<trackX.length; i++) { // Scales it to top right
        trackX[i] = (trackX[i]-WIDTH/2)*0.3+WIDTH*0.69;
        trackY[i] = (trackY[i]-HEIGHT/2)*0.3+HEIGHT*0.35;
      }
      for (int i=0; i<trackWater.length; i++) {
        trackWater[i][0] = (trackWater[i][0]-WIDTH/2)*0.3+WIDTH*0.69;
        trackWater[i][1] = (trackWater[i][1]-HEIGHT/2)*0.3+HEIGHT*0.35;
        trackWater[i][2] = trackWater[i][2]*0.3;
        trackWater[i][3] = trackWater[i][3]*0.3;
      }
      drawMap(customMapTheme[1]);
    }

    if (customExists[2]) {
      // Draws themed box
      if (customMapTheme[2].equals("Dirt")) {
        fill(0, 190, 0);
      } else if (customMapTheme[2].equals("Sand")) {
        fill(220, 180, 70);
      } else if (customMapTheme[2].equals("Road")) {
        fill(138);
      } else if (customMapTheme[2].equals("Ice")) {
        fill(117, 167, 220);
      }
      rect(WIDTH*0.31, HEIGHT*0.73, WIDTH*0.3, HEIGHT*0.3);

      // Initializes arrays
      trackX = new float[customTrackX[mapView+2].length];
      trackY = new float[customTrackY[mapView+2].length];
      trackDir = new String[customTrackDir[mapView+2].length];
      trackWater = new float[customTrackWater[mapView+2].length][4];

      // Scales and draws map 3
      arrayCopy(customTrackX[mapView+2], trackX);
      arrayCopy(customTrackY[mapView+2], trackY);
      arrayCopy(customTrackDir[mapView+2], trackDir);
      for (int i=0; i<customTrackWater[mapView+2].length; i++) {
        for (int w=0; w<4; w++) {
          trackWater[i][w] = customTrackWater[mapView+2][i][w];
        }
      }

      // Initializes track arrays
      track3X = new float[customTrackX[mapView+2].length];
      track3Y = new float[customTrackY[mapView+2].length];
      track3Dir = new String[customTrackDir[mapView+2].length];
      waterT3 = new float[customTrackWater[mapView+2].length][4];

      // Copies map info to track 3
      arrayCopy(customTrackX[mapView+2], track3X);
      arrayCopy(customTrackY[mapView+2], track3Y);
      arrayCopy(customTrackDir[mapView+2], track3Dir);
      for (int i=0; i<customTrackWater[mapView+2].length; i++) {
        for (int w=0; w<4; w++) {
          waterT3[i][w] = customTrackWater[mapView+2][i][w];
        }
      }

      for (int i=0; i<trackX.length; i++) { // Scales it to bottom left
        trackX[i] = (trackX[i]-WIDTH/2)*0.3+WIDTH*0.31;
        trackY[i] = (trackY[i]-HEIGHT/2)*0.3+HEIGHT*0.73;
      }
      for (int i=0; i<trackWater.length; i++) {
        trackWater[i][0] = (trackWater[i][0]-WIDTH/2)*0.3+WIDTH*0.31;
        trackWater[i][1] = (trackWater[i][1]-HEIGHT/2)*0.3+HEIGHT*0.73;
        trackWater[i][2] = trackWater[i][2]*0.3;
        trackWater[i][3] = trackWater[i][3]*0.3;
      }
      drawMap(customMapTheme[2]);
    }

    if (customExists[3]) {
      // Draws themed box
      if (customMapTheme[3].equals("Dirt")) {
        fill(0, 190, 0);
      } else if (customMapTheme[3].equals("Sand")) {
        fill(220, 180, 70);
      } else if (customMapTheme[3].equals("Road")) {
        fill(138);
      } else if (customMapTheme[3].equals("Ice")) {
        fill(147, 217, 250);
      }
      rect(WIDTH*0.69, HEIGHT*0.73, WIDTH*0.3, HEIGHT*0.3);

      // Initializes arrays
      trackX = new float[customTrackX[mapView+3].length];
      trackY = new float[customTrackY[mapView+3].length];
      trackDir = new String[customTrackDir[mapView+3].length];
      trackWater = new float[customTrackWater[mapView+3].length][4];

      // Scales and draws map 4
      arrayCopy(customTrackX[mapView+3], trackX);
      arrayCopy(customTrackY[mapView+3], trackY);
      arrayCopy(customTrackDir[mapView+3], trackDir);
      for (int i=0; i<customTrackWater[mapView+3].length; i++) {
        for (int w=0; w<4; w++) {
          trackWater[i][w] = customTrackWater[mapView+3][i][w];
        }
      }

      // Initializes track arrays
      track4X = new float[customTrackX[mapView+3].length];
      track4Y = new float[customTrackY[mapView+3].length];
      track4Dir = new String[customTrackDir[mapView+3].length];
      waterT4 = new float[customTrackWater[mapView+3].length][4];

      // Copies map info to track 4
      arrayCopy(customTrackX[mapView+3], track4X);
      arrayCopy(customTrackY[mapView+3], track4Y);
      arrayCopy(customTrackDir[mapView+3], track4Dir);
      for (int i=0; i<customTrackWater[mapView+3].length; i++) {
        for (int w=0; w<4; w++) {
          waterT4[i][w] = customTrackWater[mapView+3][i][w];
        }
      }

      for (int i=0; i<trackX.length; i++) { // Scales it to bottom right
        trackX[i] = (trackX[i]-WIDTH/2)*0.3+WIDTH*0.69;
        trackY[i] = (trackY[i]-HEIGHT/2)*0.3+HEIGHT*0.73;
      }
      for (int i=0; i<trackWater.length; i++) {
        trackWater[i][0] = (trackWater[i][0]-WIDTH/2)*0.3+WIDTH*0.69;
        trackWater[i][1] = (trackWater[i][1]-HEIGHT/2)*0.3+HEIGHT*0.73;
        trackWater[i][2] = trackWater[i][2]*0.3;
        trackWater[i][3] = trackWater[i][3]*0.3;
      }
      drawMap(customMapTheme[3]);
    }

    // Draws borders, text box, and map names to theme
    if (customExists[0]) {
      // Draws box under text and colours to theme
      if (customMapTheme[0].equals("Dirt")) {
        fill(0, 160, 0);
      } else if (customMapTheme[0].equals("Sand")) {
        fill(180, 140, 30);
      } else if (customMapTheme[0].equals("Road")) {
        fill(110);
      } else if (customMapTheme[0].equals("Ice")) {
        fill(117, 167, 220);
      }
      rect(WIDTH*0.31, HEIGHT*0.4775, WIDTH*0.3, HEIGHT*0.045);

      // Draws map text
      fill(255);
      textSize(HEIGHT/30);
      text(mapNames[0], WIDTH*0.31, HEIGHT*0.4725);

      // Draws border
      strokeWeight(HEIGHT/50);
      noFill();
      // Colours border to theme
      if (customMapTheme[0].equals("Dirt")) {
        stroke(0, 130, 0);
      } else if (customMapTheme[0].equals("Sand")) {
        stroke(155, 115, 5);
      } else if (customMapTheme[0].equals("Road")) {
        stroke(95);
      } else if (customMapTheme[0].equals("Ice")) {
        stroke(87, 137, 190);
      }
      rect(WIDTH*0.31, HEIGHT*0.35, WIDTH*0.31, HEIGHT*0.31);
      noStroke();
    } 
    if (customExists[1]) {
      // Draws box under text and colours to theme
      if (customMapTheme[1].equals("Dirt")) {
        fill(0, 160, 0);
      } else if (customMapTheme[1].equals("Sand")) {
        fill(180, 140, 30);
      } else if (customMapTheme[1].equals("Road")) {
        fill(110);
      } else if (customMapTheme[1].equals("Ice")) {
        fill(117, 167, 220);
      }
      rect(WIDTH*0.69, HEIGHT*0.4775, WIDTH*0.3, HEIGHT*0.045);

      // Draws map text
      fill(255);
      textSize(HEIGHT/30);
      text(mapNames[1], WIDTH*0.69, HEIGHT*0.4725);

      // Draws border
      strokeWeight(HEIGHT/50);
      noFill();
      // Colours border to theme
      if (customMapTheme[1].equals("Dirt")) {
        stroke(0, 130, 0);
      } else if (customMapTheme[1].equals("Sand")) {
        stroke(155, 115, 5);
      } else if (customMapTheme[1].equals("Road")) {
        stroke(95);
      } else if (customMapTheme[1].equals("Ice")) {
        stroke(87, 137, 190);
      }
      rect(WIDTH*0.69, HEIGHT*0.35, WIDTH*0.31, HEIGHT*0.31);
      noStroke();
    } 
    if (customExists[2]) {
      // Draws box under text and colours to theme
      if (customMapTheme[2].equals("Dirt")) {
        fill(0, 160, 0);
      } else if (customMapTheme[2].equals("Sand")) {
        fill(180, 140, 30);
      } else if (customMapTheme[2].equals("Road")) {
        fill(110);
      } else if (customMapTheme[2].equals("Ice")) {
        fill(117, 167, 220);
      }
      rect(WIDTH*0.31, HEIGHT*0.8575, WIDTH*0.3, HEIGHT*0.045);

      // Draws map text
      fill(255);
      textSize(HEIGHT/30);
      text(mapNames[2], WIDTH*0.31, HEIGHT*0.8525);

      // Draws border
      strokeWeight(HEIGHT/50);
      noFill();
      // Colours border to theme
      if (customMapTheme[2].equals("Dirt")) {
        stroke(0, 130, 0);
      } else if (customMapTheme[2].equals("Sand")) {
        stroke(155, 115, 5);
      } else if (customMapTheme[2].equals("Road")) {
        stroke(95);
      } else if (customMapTheme[2].equals("Ice")) {
        stroke(87, 137, 190);
      }
      rect(WIDTH*0.31, HEIGHT*0.73, WIDTH*0.31, HEIGHT*0.31);
      noStroke();
    } 
    if (customExists[3]) {
      // Draws box under text and colours to theme
      if (customMapTheme[3].equals("Dirt")) {
        fill(0, 160, 0);
      } else if (customMapTheme[3].equals("Sand")) {
        fill(180, 140, 30);
      } else if (customMapTheme[3].equals("Road")) {
        fill(110);
      } else if (customMapTheme[3].equals("Ice")) {
        fill(117, 167, 220);
      }
      rect(WIDTH*0.69, HEIGHT*0.8575, WIDTH*0.3, HEIGHT*0.045);

      // Draws map text
      fill(255);
      textSize(HEIGHT/30);
      text(mapNames[3], WIDTH*0.69, HEIGHT*0.8525);

      // Draws border
      strokeWeight(HEIGHT/50);
      noFill();
      // Colours border to theme
      if (customMapTheme[3].equals("Dirt")) {
        stroke(0, 130, 0);
      } else if (customMapTheme[3].equals("Sand")) {
        stroke(155, 115, 5);
      } else if (customMapTheme[3].equals("Road")) {
        stroke(95);
      } else if (customMapTheme[3].equals("Ice")) {
        stroke(87, 137, 190);
      }
      rect(WIDTH*0.69, HEIGHT*0.73, WIDTH*0.31, HEIGHT*0.31);
      noStroke();
    }

    // Draws left arrow for choosing map
    float col; // Shade of arrow if can press button or not
    if (currentCustomPage==0) {
      col = 0.75;
    } else {
      col = 1;
    }
    fill(255*col);
    rect(WIDTH*0.09, HEIGHT*0.54, HEIGHT*0.11, HEIGHT*0.26);
    fill(220*col, 180*col, 0);
    rect(WIDTH*0.09, HEIGHT*0.54, HEIGHT/10, HEIGHT/4);
    fill(255*col, 255*col, 50*col);
    triangle(WIDTH*0.09+HEIGHT/30, HEIGHT*0.65, WIDTH*0.09+HEIGHT/30, HEIGHT*0.43, WIDTH*0.09-HEIGHT/30, HEIGHT*0.54);

    // Draws right arrow for choosing map
    if (currentCustomPage==customPages) {
      col = 0.75;
    } else {
      col = 1;
    }
    fill(255*col);
    rect(WIDTH*0.91, HEIGHT*0.54, HEIGHT*0.11, HEIGHT*0.26);
    fill(220*col, 180*col, 0);
    rect(WIDTH*0.91, HEIGHT*0.54, HEIGHT/10, HEIGHT/4);
    fill(255*col, 255*col, 50*col);
    triangle(WIDTH*0.91-HEIGHT/30, HEIGHT*0.65, WIDTH*0.91-HEIGHT/30, HEIGHT*0.43, WIDTH*0.91+HEIGHT/30, HEIGHT*0.54);

    // Draws exit button
    fill(200, 0, 0);
    rect(HEIGHT/10, HEIGHT*0.9, HEIGHT/15, HEIGHT/15);
    fill(255, 0, 0);
    rect(HEIGHT/10, HEIGHT*0.9, HEIGHT/20, HEIGHT/20);
    fill(255);
    textSize(HEIGHT/30);
    text("X", HEIGHT/10, HEIGHT*0.9-textDescent()/2);

    // Draws new custom map button
    fill(0, 160, 205);
    rect(WIDTH*0.992-HEIGHT/10, HEIGHT*0.9, WIDTH/18, HEIGHT/15);
    fill(0, 210, 255);
    rect(WIDTH*0.992-HEIGHT/10, HEIGHT*0.9, WIDTH/18-HEIGHT/60, HEIGHT/20);
    fill(255);
    text("NEW", WIDTH*0.992-HEIGHT/10, HEIGHT*0.9-textDescent()/2);
  } else if (screen=="CustomCreate") { // Custom map creation screen
    // Draws Background and sets theme
    if (customCreateTheme.equals("Dirt")) { // Grass
      themeR = 0; 
      themeG = 150; 
      themeB = 0;
    } else if (customCreateTheme.equals("Sand")) { // Desert
      themeR = 180; 
      themeG = 140; 
      themeB = 30;
    } else if (customCreateTheme.equals("Road")) { // Concrete
      themeR = 120; 
      themeG = 120; 
      themeB = 120;
    } else if (customCreateTheme.equals("Ice")) { // Ice
      themeR = 137; 
      themeG = 207; 
      themeB = 240;
    }
    fill(themeR, themeG, themeB);
    rectMode(CENTER);
    rect(WIDTH/2, HEIGHT/2, WIDTH, HEIGHT);

    // Draws background effect
    for (int i=0; i<grassCount; i++) {
      fill(themeR-10, themeG-10, themeB-10);
      rect(darkGrassX.get(i)*WIDTH, darkGrassY.get(i)*WIDTH, grassSize*WIDTH, grassSize*WIDTH);
      fill(themeR+10, themeG+10, themeB+10);
      rect(lightGrassX.get(i)*WIDTH, lightGrassY.get(i)*WIDTH, grassSize*WIDTH, grassSize*WIDTH);
    }

    // Redraws map
    trackX = new float[customCreateTrackX.size()]; // Turns arraylist into a float array
    trackY = new float[customCreateTrackY.size()];
    for (int i=0; i<customCreateTrackX.size(); i++) {
      trackX[i] = customCreateTrackX.get(i); // Stores the track x information
      trackY[i] = customCreateTrackY.get(i); // Stores the track y information
    }
    trackDir = new String[customCreateTrackDir.size()];
    for (int i=0; i<customCreateTrackDir.size(); i++) {
      trackDir[i] = customCreateTrackDir.get(i); // Stores the track dir information
    }
    trackWater = new float[customCreateWater.size()][]; 
    for (int i=0; i<customCreateWater.size(); i++) {
      trackWater[i] = customCreateWater.get(i); // Stores the track water information
    }
    mapPieces = new ArrayList<MapPiece>();
    drawMap(customCreateTheme);

    // If water is being created, creates the pool to the mouse coordinates
    if (selectedMapPiece.equals("WATER") && createWater) {
      finalCustomWater = new PVector(mouseX, mouseY);
    }

    // Makes a temporary map piece follow mouse
    int len = trackX.length; // Length of coordinates of track
    float wid = trackWidth; // Width of map piece
    float hig = trackWidth; // Height of map piece
    String type = customCreateTheme;

    if (!selectedMapPiece.equals("WATER") && !endTrack) {
      // Current mouse position is locked to bounds for when drawing map piece
      mX = mouseX;
      mY = mouseY;
      if (mX<0) { 
        mX = 0;
      } else if (mX>WIDTH) { 
        mX = WIDTH;
      }
      if (mY<0) { 
        mY = 0;
      } else if (mY>hotBarTop) { 
        mY = hotBarTop;
      }

      String lock = ""; // Axis it locks to
      // Starting position of map piece
      if (len>=2 && selectedMapPiece=="TRACK") {
        sX = trackX[len-1];
        sY = trackY[len-1];
        // Snaps piece
        if (abs(dist(mX, mY, sX, sY)-dist(mX, sY, sX, sY))<abs(dist(mX, mY, sX, sY)-dist(sX, mY, sX, sY))) { // Locks to horizontal
          mY = sY;
          lock = "HORIZONTAL";
        } else if (abs(dist(mX, mY, sX, sY)-dist(mX, sY, sX, sY))>abs(dist(mX, mY, sX, sY)-dist(sX, mY, sX, sY))) { // Locks to vertical
          mX = sX;
          lock = "VERTICAL";
        }
      } else if (selectedMapPiece=="START") {
        if (abs(dist(WIDTH/2, hotBarTop/2, mX, mY)-dist(WIDTH/2, mY, mX, mY))<
          abs(dist(WIDTH/2, hotBarTop/2, mX, mY)-dist(mX, hotBarTop/2, mX, mY))) { // Locks to vertical
          if (mX<WIDTH/2) { // Snaps to left 
            mX = 0;
          } else if (mX>WIDTH/2) { // Snaps to right
            mX = WIDTH;
          }
        } else if (abs(dist(WIDTH/2, hotBarTop/2, mX, mY)-dist(WIDTH/2, mY, mX, mY))>
          abs(dist(WIDTH/2, hotBarTop/2, mX, mY)-dist(mX, hotBarTop/2, mX, mY))) { // Locks to horizontal
          if (mY<hotBarTop/2) { // Snaps to top
            mY = 0;
          } else if (mY>hotBarTop/2) { // Snaps to bottom
            mY = hotBarTop;
          }
        }
        sX = mX;
        sY = mY;
      } else if (selectedMapPiece=="END" && startTrack) {
        sX = trackX[len-1];
        sY = trackY[len-1];
        // Snaps piece
        if (abs(dist(mX, mY, sX, sY)-dist(mX, sY, sX, sY))<abs(dist(mX, mY, sX, sY)-dist(sX, mY, sX, sY))) { // Locks to horizontal
          mY = sY;
          if (mX<sX) {
            mX = 0;
          } else {
            mX = WIDTH;
          }
          lock = "HORIZONTAL";
        } else if (abs(dist(mX, mY, sX, sY)-dist(mX, sY, sX, sY))>abs(dist(mX, mY, sX, sY)-dist(sX, mY, sX, sY))) { // Locks to vertical
          mX = sX;
          if (mY<sY) {
            mY = 0;
          } else {
            mY = hotBarTop;
          }
          lock = "VERTICAL";
        }
      }

      if (len>=2) {
        if (lock.equals("HORIZONTAL")) {
          wid = abs(mX-sX)+trackWidth;
          hig = trackWidth;
        } else if (lock.equals("VERTICAL")) {
          wid = trackWidth;
          hig = abs(mY-sY)+trackWidth;
        }
      }
    }

    // Creates temporary map piece to mouse pos
    if (!selectedMapPiece.equals("WATER")) {
      tempOut = new MapPiece((sX+mX)/2, (sY+mY)/2, wid, hig, type, false);
      tempIn = new MapPiece((sX+mX)/2, (sY+mY)/2, wid-spacing, hig-spacing, type, true);
    } else if (createWater) {
      tempOut = new MapPiece((initCustomWater.x+mouseX)/2, (initCustomWater.y+mouseY)/2, abs(initCustomWater.x-mouseX), abs(initCustomWater.y-mouseY), "Water", false);
      tempIn = new MapPiece((initCustomWater.x+mouseX)/2, (initCustomWater.y+mouseY)/2, abs(initCustomWater.x-mouseX), abs(initCustomWater.y-mouseY), "Water", true);
    }

    // Draws temporary map piece
    if (!selectedMapPiece.equals("WATER") && !endTrack) {
      tempOut.drawMap();
      tempIn.drawMap();
    } else if (selectedMapPiece.equals("WATER") && createWater) {
      tempOut.drawMap();
      tempIn.drawMap();
    }
    if (selectedMapPiece=="START") {
      fill(0, 255, 0); // Shows that track is start
      rect(mX, mY, trackWidth/3, trackWidth/3);
    } else if (selectedMapPiece=="END") {
      fill(255, 0, 0); // Shows that track is end
      rect(mX, mY, trackWidth/3, trackWidth/3);
    }

    // Draws greyish blue hotbar with map pieces to select, and then click to place (or drag for water)
    // Hotbar base
    fill(60, 75, 90);
    rect(WIDTH/2, HEIGHT*0.925, WIDTH, HEIGHT*0.15);
    fill(115, 147, 179);
    rect(WIDTH/2, HEIGHT*0.925, WIDTH-HEIGHT/50, HEIGHT*0.13);
    fill(60, 75, 90);
    rect(HEIGHT*0.08+barSize, HEIGHT*0.925, HEIGHT/50, HEIGHT*0.15);

    // Blue bar below map piece name
    fill(0, 200, 255);
    rectMode(CORNER);
    rect(HEIGHT/25, HEIGHT*0.925, barSize, HEIGHT/25);
    textAlign(LEFT, BOTTOM);
    rectMode(CENTER);

    // Shows selected map piece name
    fill(255);
    textSize(HEIGHT/30);
    text(selectedMapPiece, HEIGHT/25, HEIGHT*0.915);

    // Draws box for start of track
    drawBox(HEIGHT*0.175+barSize, !selectedMapPiece.equals("START"));
    drawMapDisplay(HEIGHT*0.175+barSize, true);
    fill(0, 255, 0); // Shows that track is start
    rect(HEIGHT*0.175+barSize, HEIGHT*0.925, trackWidth/3, trackWidth/3);

    // Draws box for track
    drawBox(HEIGHT*0.325+barSize, !selectedMapPiece.equals("TRACK"));
    drawMapDisplay(HEIGHT*0.325+barSize, true);

    // Draws box for end of track
    drawBox(HEIGHT*0.475+barSize, !selectedMapPiece.equals("END"));
    drawMapDisplay(HEIGHT*0.475+barSize, true);
    fill(255, 0, 0); // Shows that track is end
    rect(HEIGHT*0.475+barSize, HEIGHT*0.925, trackWidth/3, trackWidth/3);

    // Draws box for water
    drawBox(HEIGHT*0.625+barSize, !selectedMapPiece.equals("WATER"));
    drawMapDisplay(HEIGHT*0.625+barSize, false);

    // Draws box for dirt theme
    drawBox(HEIGHT*0.775+barSize, !customCreateTheme.equals("Dirt"));
    fill(0, 130, 0);
    ellipse(HEIGHT*0.775+barSize, HEIGHT*0.925, trackWidth, trackWidth);
    fill(0, 190, 0);
    ellipse(HEIGHT*0.775+barSize, HEIGHT*0.925, trackWidth*0.8, trackWidth*0.8);

    // Draws box for sand theme
    drawBox(HEIGHT*0.925+barSize, !customCreateTheme.equals("Sand"));
    fill(155, 115, 5);
    ellipse(HEIGHT*0.925+barSize, HEIGHT*0.925, trackWidth, trackWidth);
    fill(220, 180, 70);
    ellipse(HEIGHT*0.925+barSize, HEIGHT*0.925, trackWidth*0.8, trackWidth*0.8);

    // Draws box for road theme
    drawBox(HEIGHT*1.075+barSize, !customCreateTheme.equals("Road"));
    fill(95);
    ellipse(HEIGHT*1.075+barSize, HEIGHT*0.925, trackWidth, trackWidth);
    fill(138);
    ellipse(HEIGHT*1.075+barSize, HEIGHT*0.925, trackWidth*0.8, trackWidth*0.8);

    // Draws box for ice theme
    drawBox(HEIGHT*1.225+barSize, !customCreateTheme.equals("Ice"));
    fill(87, 137, 190);
    ellipse(HEIGHT*1.225+barSize, HEIGHT*0.925, trackWidth, trackWidth);
    fill(147, 217, 250);
    ellipse(HEIGHT*1.225+barSize, HEIGHT*0.925, trackWidth*0.8, trackWidth*0.8);

    // Clear button
    textAlign(CENTER);
    textSize(HEIGHT/40);
    fill(128, 85, 0);
    rect(WIDTH-HEIGHT*0.24, HEIGHT*0.895, HEIGHT/6, HEIGHT/26);
    fill(255, 170, 0);
    rect(WIDTH-HEIGHT*0.24, HEIGHT*0.895, HEIGHT/6-HEIGHT/100, HEIGHT/26-HEIGHT/100);
    fill(255);
    text("CLEAR", WIDTH-HEIGHT*0.24, HEIGHT*0.895+textAscent()/2-textDescent()/2);

    // Quit button
    fill(128, 0, 0);
    rect(WIDTH-HEIGHT*0.24, HEIGHT*0.955, HEIGHT/6, HEIGHT/26);
    fill(255, 0, 0);
    rect(WIDTH-HEIGHT*0.24, HEIGHT*0.955, HEIGHT/6-HEIGHT/100, HEIGHT/30-HEIGHT/100);
    fill(255);
    text("QUIT", WIDTH-HEIGHT*0.24, HEIGHT*0.955+textAscent()/2-textDescent()/2);

    // Save button
    if (endTrack) {
      fill(255);
    } else {
      fill(128);
    }
    rect(WIDTH-HEIGHT*0.075, HEIGHT*0.925, HEIGHT*0.1075, HEIGHT*0.1075);
    if (endTrack) {
      fill(0, 170, 210);
    } else {
      fill(0, 85, 105);
    }
    rect(WIDTH-HEIGHT*0.075, HEIGHT*0.925, HEIGHT/10, HEIGHT/10);
    if (endTrack) {
      fill(0, 200, 255);
    } else {
      fill(0, 100, 128);
    }
    rect(WIDTH-HEIGHT*0.075, HEIGHT*0.925, HEIGHT*0.08, HEIGHT*0.08);

    // Tick
    if (endTrack) {
      stroke(255);
    } else {
      stroke(128);
    }
    strokeWeight(HEIGHT/100);
    line(WIDTH-HEIGHT*0.1, HEIGHT*0.93, WIDTH-HEIGHT*0.075, HEIGHT*0.95);
    line(WIDTH-HEIGHT*0.075, HEIGHT*0.95, WIDTH-HEIGHT*0.05, HEIGHT*0.9);
    noStroke();

    // If name needs to be typed
    if (setName) {
      // Sets text name variables
      textAlign(CENTER);
      typeName.font = HEIGHT/20;
      textSize(typeName.font);
      typeName.x = WIDTH/2;
      typeName.y = HEIGHT/2 + textDescent()/2;

      // Draws text box
      fill(120, 60, 0);
      rect(WIDTH/2, HEIGHT*0.45-textDescent(), WIDTH/3, HEIGHT/5);
      fill(140, 80, 0);
      rect(WIDTH/2, HEIGHT/2-textDescent(), WIDTH/3-HEIGHT/40, HEIGHT*0.075);

      // Draws text asking user to type map name
      fill(0, 255, 200);
      text("MAP NAME: ", WIDTH/2, HEIGHT*0.415);

      // Displays text
      typeName.display();

      // Displays done button
      textSize(HEIGHT/15);
      fill(0, 205, 150);
      rect(WIDTH/2, HEIGHT*0.63, WIDTH/3, HEIGHT/8);
      fill(0, 255, 200);
      rect(WIDTH/2, HEIGHT*0.63, WIDTH/3-HEIGHT/40, HEIGHT/10);
      fill(255);
      text("DONE", WIDTH/2, HEIGHT*0.64+textDescent());
    }

    // Clears the text which needs to be removed
    removeT = new HashSet<TextPulse>();

    // Draws pulsing text
    for (TextPulse text : texts) {
      text.drawText();
    }
    // Removes text which have finished pulsing
    for (TextPulse text : removeT) {
      texts.remove(text);
    }
  } else if (screen=="Game") { // Game screen
    // Sets variables proportional to screen size to scale them
    projectileDist = HEIGHT/10;
    beamSize = HEIGHT/15;
    redSize = HEIGHT*0.05;
    yellowSize = HEIGHT*0.08;
    greenSize = HEIGHT*0.065;
    boatSize = HEIGHT/11;
    beamRange = HEIGHT*0.3;
    boatRange = HEIGHT*0.6;
    helipadSize = HEIGHT/6;
    heliSize = HEIGHT/10;
    heliRange = HEIGHT*2/3;
    boltRange = HEIGHT*0.25;
    boltSize = HEIGHT/13;

    // Sets the select size to the current selected defence for checking collisions
    if (selected=="BEAM") {
      selectSize = beamSize;
    } else if (selected=="BOAT") {
      selectSize = boatSize;
    } else if (selected=="HELI") {
      selectSize = helipadSize;
    } else if (selected=="BOLT") {
      selectSize = boltSize;
    }

    // Sets last used theme to current theme
    lastTheme = gameTheme;

    // Draws Background and sets theme according to wave
    bossWave = wave%10==0;
    if (bossWave) { // Lava
      fill(80, 10, 0);
    } else {
      if (wave>100) { // Dark
        themeR = 20;
        themeG = 20;
        themeB = 30;
      } else if (gameTheme==1) { // Grass
        themeR = 0; 
        themeG = 150; 
        themeB = 0;
      } else if (gameTheme==2) { // Desert
        themeR = 180; 
        themeG = 140; 
        themeB = 30;
      } else if (gameTheme==3) { // Concrete
        themeR = 120; 
        themeG = 120; 
        themeB = 120;
      } else if (gameTheme==4) { // Ice
        themeR = 137; 
        themeG = 207; 
        themeB = 240;
      }
      fill(themeR, themeG, themeB);
    } 
    rectMode(CENTER);
    rect(WIDTH/2, HEIGHT/2, WIDTH, HEIGHT);

    // Draws background effect
    if (lag!="ALL") {
      for (int i=0; i<grassCount; i++) {
        if (bossWave) {
          fill(120, 20, 0);
        } else {
          fill(themeR-10, themeG-10, themeB-10);
        }
        rect(darkGrassX.get(i)*WIDTH, darkGrassY.get(i)*WIDTH, grassSize*WIDTH, grassSize*WIDTH);
        if (bossWave) {
          fill(160, 60, 0);
        } else {
          fill(themeR+10, themeG+10, themeB+10);
        }
        rect(lightGrassX.get(i)*WIDTH, lightGrassY.get(i)*WIDTH, grassSize*WIDTH, grassSize*WIDTH);
      }
    }

    // Adjusts track to selected track
    if (selectedTrack==1) {
      trackX = track1X;
      trackY = track1Y;
      trackDir = track1Dir;
      trackWater = waterT1;
    } else if (selectedTrack==2) {
      trackX = track2X;
      trackY = track2Y;
      trackDir = track2Dir;
      trackWater = waterT2;
    } else if (selectedTrack==3) {
      trackX = track3X;
      trackY = track3Y;
      trackDir = track3Dir;
      trackWater = waterT3;
    } else if (selectedTrack==4) {
      trackX = track4X;
      trackY = track4Y;
      trackDir = track4Dir;
      trackWater = waterT4;
    }

    // Creates and draws with theme
    mapPieces = new ArrayList<MapPiece>();
    if (gameTheme==1) {
      drawMap("Dirt");
    } else if (gameTheme==2) {
      drawMap("Sand");
    } else if (gameTheme==3) {
      drawMap("Road");
    } else if (gameTheme==4) {
      drawMap("Ice");
    }

    // Checks what stage of tutorial the player is up to and sets text displayed accordingly
    tutorialText = "";
    if (!chooseTower && !selectDifficulty) {
      tutorialText = "CHOOSE TOWER AND DRAG TO MAP";
    }
    if (defences.size()>0) {
      chooseTower = true;
    }
    if (!startFirst && chooseTower) {
      tutorialText = "CLICK GO TO START WAVE";
    }
    if (startWave) {
      startFirst = true;
    }
    if (!selectTowerToUpgrade && defences.size()>0 && selected!="Defence" && !upgradeTower) {
      for (Defence defence : defences) {
        if (money>=defence.cost1 || money>=defence.cost2 || money>defence.cost3 || money>defence.cost4) {
          tutorialText = "SELECT A TOWER TO UPGRADE";
        }
      }
    }
    if (!upgradeTower && selected=="Defence") {
      tutorialText = "CHOOSE AN UPGRADE";
      for (Defence defence : defences) {
        if (defence.upgrade1>1 || defence.upgrade2>1 || defence.upgrade3>1 || defence.upgrade4>1) {
          upgradeTower = true;
        }
      }
    }
    // Shows hints for particular waves
    if (upgradeTower) {
      if (hintTime>0) {
        if ((wave+1)%10==0) {
          tutorialText = "PREPARE YOURSELF FOR NEXT WAVE";
        } else if (wave==100) {
          tutorialText = "NO PRESSURE :)";
        } else if (bossWave) {
          tutorialText = "HERE IT COMES";
        } else if (wave==3) {
          tutorialText = "HAVE FUN :)";
        } else if (wave==5) {
          tutorialText = "ENEMIES LOOKING KINDA SUS";
        } else if (wave==7) {
          tutorialText = "CLICK '?' TO VIEW STATS OF TOWER";
        } else if (wave==11) {
          tutorialText = "THAT WAS SCARY!";
        } else if (wave==15) {
          tutorialText = "YELLOWS ARE BIG AND SLOW";
        } else if (wave==17) {
          tutorialText = "YELLOWS TAKE LITTLE DAMAGE FROM BOAT SHARDS";
        } else if (wave==21) {
          tutorialText = "TOO HECTIC? CHECK OUT THE PAUSE MENU";
        } else if (wave==25) {
          tutorialText = "GREENS ARE FAST! MAKE SURE TO UPGRADE SPEED";
        } else if (wave==31) {
          tutorialText = "MAXING A DEFENCE GRANTS IT A NEW ABILITY";
        } else if (wave==34) {
          tutorialText = "MAKE SURE YOU ARE BEAMED UP FOR NEXT WAVE";
        } else if (wave==35) {
          tutorialText = "BEAM DOES 10X DAMAGE TO ARMOUR!";
        } else if (wave==36) {
          tutorialText = "MAX BOAT ALSO WRECKS ARMOUR";
        } else if (wave==38) {
          tutorialText = "UNFORTUNATELY HELI SUCKS AGAINST ARMOUR";
        } else if (wave==41) {
          tutorialText = "YOU ARE DOING GREAT";
        } else if (wave==50) {
          tutorialText = "HALFWAY TO 100!";
        } else if (wave==61) {
          tutorialText = "ENJOYING THE THEMES?";
        } else if (wave==81) {
          tutorialText = "GO PAUSE AND TAKE A BREAK";
        }
        if (win) {
          tutorialText = "YOU LEGEND!!!";
        }
      }
    }

    speed = trueSpeed*pause; // Sets speed relative to whether game is paused

    // Timer for when displaying hints/tips
    if (hintTime>0) {
      hintTime-=speed;
    } else {
      hintTime=0;
    }

    // Creating new hashsets for removing projectiles and enemies
    removeP = new HashSet<Projectile>();
    removeE = new HashSet<Enemy>();
    livesLost = new HashSet<Enemy>();
    removeBolt = new HashSet<BoltEffect>();

    // Checks if game is paused
    if (pause==1) {
      timer++;
    }
    fireRate = projectileDist/speed;

    // Spawns enemies at a certain rate proportional to the wave and the speed of the game
    enemySpeed = speed*pow(wave, 0.25);
    if (wave<100) {
      enemySpawnRate = (1.5*(100-(wave-wave%10)))/enemySpeed;
      if (wave==15 || wave==25 || wave==35) {
        enemySpawnRate = enemySpawnRate*5;
      }
    } else {
      enemySpawnRate = 15/enemySpeed;
    }

    // Starts counter for remaining enemies
    enemiesLeft = 0;
    for (Enemy enemy : enemies) {
      // Sets the enemy speed according to their type, wave of game, and speed of game
      enemySpeed = speed*pow(wave, 0.25);
      if (enemy.type=="RedBoss") {
        enemySpeed = enemySpeed*0.3;
      } else if ( enemy.type=="Yellow") {
        enemySpeed = enemySpeed*0.6;
      } else if ( enemy.type=="Green") {
        enemySpeed = enemySpeed*1.75;
      }

      // Adjusts enemy speed to difficulty of game
      if (difficulty=="EASY") {
        enemySpeed = enemySpeed*0.9;
      } else if (difficulty=="HARD") {
        enemySpeed = enemySpeed*1.1;
      } else if (difficulty=="EXPERT") {
        enemySpeed = enemySpeed*1.2;
      }

      // Draws enemy
      enemy.drawEnemy();

      // If struck by max bolt, it doens't move when stunned (or slows down if it is a boss)
      if (enemy.stun>0) {
        if (enemy.type!="RedBoss") {
          enemySpeed = 0;
        } else {
          enemySpeed = enemySpeed/2;
        }
      }

      // Ensures it skips over starting map piece
      if (trackX[enemy.track]==trackX[enemy.track+1] && trackY[enemy.track]==trackY[enemy.track+1]) {
        enemy.track++;
      }

      // Moves enemies according to their direction on the track
      enemy.distance+=enemySpeed;
      if (enemy.dir.equals("RIGHT")) {
        if (enemy.x<trackX[enemy.track+1]) {
          enemy.xMoved += enemySpeed;
        } else {
          if (enemy.track==trackDir.length-1 && enemy.x<WIDTH+enemy.size/2) {
            enemy.xMoved += enemySpeed;
          } else {
            enemy.track++;
          }
        }
      } else if (enemy.dir.equals("LEFT")) {
        if (enemy.x>trackX[enemy.track+1]) {
          enemy.xMoved -= enemySpeed;
        } else {
          if (enemy.track==trackDir.length-1 && enemy.x>-enemy.size/2) {
            enemy.xMoved -= enemySpeed;
          } else {
            enemy.track++;
          }
        }
      } else if (enemy.dir.equals("UP")) {
        if (enemy.y>trackY[enemy.track+1]) {
          enemy.yMoved -= enemySpeed;
        } else {
          if (enemy.track==trackDir.length-1 && enemy.y>-enemy.size/2) {
            enemy.yMoved -= enemySpeed;
          } else {
            enemy.track++;
          }
        }
      } else if (enemy.dir.equals("DOWN")) {
        if (enemy.y<trackY[enemy.track+1]) {
          enemy.yMoved += enemySpeed;
        } else {
          if (enemy.track==trackDir.length-1 && enemy.y<HEIGHT*0.85+enemy.size/2) {
            enemy.yMoved += enemySpeed;
          } else {
            enemy.track++;
          }
        }
      }

      // Player loses a life if enemy completes track
      if (enemy.track==trackDir.length) {
        livesLost.add(enemy);
      }
      enemiesLeft++;
    }
    // Calculates the enemies remaining by adding the enemies on screen with the enemies off screen (haven't spawned)
    enemiesLeft+=enemiesToSpawn; 

    // Loses lives when enemies complete the track
    for (Enemy enemy : livesLost) {
      if (lives>0) {
        // Calculates position of where the text will show for losing lives
        float x = 0;
        float y = 0;
        if (enemy.dir.equals("RIGHT")) {
          x = WIDTH-enemy.size;
          y = enemy.y-enemy.size*1.5;
        } else if (enemy.dir.equals("LEFT")) {
          x = enemy.size;
          y = enemy.y-enemy.size*1.5;
        } else if (enemy.dir.equals("UP")) {
          x = enemy.x;
          y = enemy.size/2;
        } else if (enemy.dir.equals("DOWN")) {
          x = enemy.x;
          y = HEIGHT*0.85-enemy.size/2;
        }

        // Displays text where the enemy is, and loses a certain amount of lives depending on the enemy
        if (enemy.type!="RedBoss") {
          lives--;
          texts.add(new TextPulse (x, y, "-1 LIFE", 255, 0, 0));
        } else if (enemy.type=="RedBoss") {
          if (wave<100) {
            lives-=10;
            texts.add(new TextPulse (x, y, "-10 LIVES", 255, 0, 0));
          } else {
            // Loses all lives if it is the final boss wave needed for winning the game
            lives-=25;
            texts.add(new TextPulse (x, y, "-25 LIVES", 255, 0, 0));
          }
        }
      }
      // Removes enemy if completed track and plays a sound effect
      enemies.remove(enemy);
      if (lives>0) {
        lifeLost.stop();
        lifeLost.play();
      }
    }

    // Ensures lives are not negative
    if (lives<0) {
      lives = 0;
    }

    // Draws defences and creates projectiles, targeting the enemy according to their target priority
    for (Defence defence : defences) {
      defence.drawDefence();
      float targetValue = 0;
      float x = defence.x;
      float y = defence.y;
      float xDir = 0;
      float yDir = 0;
      String type = defence.type;
      float mod = 0;
      Boolean found;
      if (type=="HELI") {
        x = defence.heliX;
        y = defence.heliY;
      }
      Enemy targetEnemy = null;
      for (Enemy enemy : enemies) {
        found = false;
        if (defence.target=="FIRST") { // Finds the first enemy in the track
          if ((enemy.distance>targetValue || targetEnemy==null)) {
            if (type!="HELI" && defence.enemyDist(enemy)<defence.range/2) { // If in range and not a heli
              found = true;
              targetValue = enemy.distance;
            } else if (type=="HELI") { // If a heli, range doesn't matter
              found = true;
              targetValue = enemy.distance;
            }
          }
        } else if (defence.target=="LAST") { // Finds the last enemy in the track
          if ((enemy.distance<targetValue || targetEnemy==null) && defence.enemyDist(enemy)<defence.range/2) {
            found = true;
            targetValue = enemy.distance;
          }
        } else if (defence.target=="CLOSE") { // Finds the closest enemy
          if ((defence.enemyDist(enemy)<targetValue || targetEnemy==null) && defence.enemyDist(enemy)<defence.range/2) {
            found = true;
            targetValue = defence.enemyDist(enemy);
          }
        } else if (defence.target=="STRONG") { // Finds the strongest enemy in the track
          if ((enemy.health>targetValue || targetEnemy==null) && defence.enemyDist(enemy)<defence.range/2) {
            found = true;
            targetValue = enemy.health;
          }
        }

        // Faces target enemy if within range
        if (found) {
          targetEnemy = enemy;
          mod = speed*2/(pow(pow(enemy.x-x, 2) + pow(enemy.y-y, 2), 0.5));
          xDir = (enemy.x-x)*mod;
          yDir = (enemy.y-y)*mod;
        }

        // Calculates position heli needs to fly to, so it is in front of the first enemy
        if (type=="HELI") {
          Enemy aimEnemy = enemy;
          if (targetEnemy!=null) {
            aimEnemy = targetEnemy;
          }
          float xAim = aimEnemy.x;
          float yAim = aimEnemy.y;
          if (aimEnemy.dir.equals("RIGHT")) {
            xAim += aimEnemy.size/2+heliSize*0.75;
          } else if (aimEnemy.dir.equals("LEFT")) {
            xAim -= aimEnemy.size/2+heliSize*0.75;
          } else if (aimEnemy.dir.equals("DOWN")) {
            yAim += aimEnemy.size/2+heliSize*0.75;
          } else if (aimEnemy.dir.equals("UP")) {
            yAim -= aimEnemy.size/2+heliSize*0.75;
          }
          mod = 1/sqrt(pow(xAim-x, 2) + pow(yAim-y, 2));
          defence.xAim = (xAim-x)*mod;
          defence.yAim = (yAim-y)*mod;
          defence.xAimPos = xAim;
          defence.yAimPos = yAim;
        }
      }

      // Calculates direction to enemy if not null
      if (targetEnemy!=null) {
        if (type=="HELI") { // Faces enemy if type is heli, and is in range
          if (defence.enemyDist(targetEnemy)<defence.range/2) {
            float dMod = 1/(pow(pow(targetEnemy.x-x, 2) + pow(targetEnemy.y-y, 2), 0.5));
            defence.xDir = (targetEnemy.x-x)*dMod;
            defence.yDir = (targetEnemy.y-y)*dMod;
            defence.heliFace = true;
          }
        } else {
          float dMod = 1/(pow(pow(targetEnemy.x-x, 2) + pow(targetEnemy.y-y, 2), 0.5));
          defence.xDir = (targetEnemy.x-x)*dMod;
          defence.yDir = (targetEnemy.y-y)*dMod;
        }
      } else {
        defence.heliFace = false;
      }

      // Creates projectile sent toward target enemy
      if (defence.rate>=fireRate/defence.attackSpeed && targetEnemy!=null) {
        if (targetEnemy.distance>0) {
          if (defence.type=="BOLT") {
            bolts.add(new BoltEffect(defence, targetEnemy));
          } else if (defence.type=="HELI") {
            // Creates heli projectiles if heli is in range
            if (defence.enemyDist(targetEnemy)<defence.range/2) {
              projectiles.add(new Projectile(type, x, y, defence.projectileSize, defence.attackSpeed*xDir, defence.attackSpeed*yDir, defence.damage, defence.pierce, defence.level, defence));
            }
          } else {
            projectiles.add(new Projectile(type, x, y, defence.projectileSize, defence.attackSpeed*xDir, defence.attackSpeed*yDir, defence.damage, defence.pierce, defence.level, defence));
          }
          defence.rate = 0;
        }
      }
      defence.rate+=WIDTH/1000;
    }

    // Draws bolts
    for (BoltEffect bolt : bolts) {
      bolt.drawBolt();
    }

    // Draws heli over other defences
    for (Defence defence : defences) {
      if (defence.type=="HELI") {
        defence.drawHeli();
      }
    }

    // Draws rotor shred effects
    for (RotorEffect rot : rotEffects) {
      rot.drawEffect();
    }

    // Removes rotor effects which are done
    for (RotorEffect rot : removeRotEffects) {
      rotEffects.remove(rot);
    }  

    // Increases wave when no enemies are left
    if (enemiesLeft==0) {
      if (enemiesToSpawn==0 && !autoStart) {
        startWave = false;
      }
      if (lives>0) {
        if (wave>0 && startFirst) {
          // When wave is over, cash is given as a reward
          if (wave>100) {
            texts.add(new TextPulse(width/2, HEIGHT*0.795, "WAVE COMPLETE", 255, 255, 220));
          } else {
            texts.add(new TextPulse(width/2, HEIGHT*0.795, "WAVE COMPLETE +$" + wave, 255, 255, 220));
            money+=wave;
          }
          waveOver.play();
        }
        if (startFirst) {
          if (wave==100) {
            // If you pass wave 100, you win
            win = true;
            pause = 0;
            victory.play();
          }
          // Increases wave when completed
          wave++;
          spawnedEnemies = 0;
        }

        // Resets timer for showing hint on certain waves
        if ((wave+1)%10==0 || bossWave || wave==3 || wave==5 || wave==7 || wave==11 || wave==15 || wave==17 || wave==21 || wave==25 || 
          wave==31 || wave==34 || wave==35 || wave==36 || wave==38 || wave==41 || wave==50 || wave==61 || wave==81 || wave==100 || wave==101) {
          hintTime = 250;
        }

        // Removes all projectiles from the screen when there are no enemies
        projectiles = new HashSet<Projectile>();
        bolts = new HashSet<BoltEffect>();

        // Calculates enemies to spawn for the wave
        if (wave==15 || wave==25 || wave==35) {
          enemiesToSpawn = 5;
        } else if (wave%10!=0) {
          enemiesToSpawn = wave+4;
        } else {
          enemiesToSpawn = 1; // Boss every 10 rounds
          // Plays epic boss music
          bossActive = true;
          stopMusic();
          bossMusic.loop();
        }
      }
    }

    // If boss defeated, resume normal music
    if (bossActive) {
      if (wave%10!=0) {
        bossActive = false;
        bossMusic.stop();
        if (gameTheme==1) {
          grassMusic.loop();
        } else if (gameTheme==2) {
          sandMusic.loop();
        } else if (gameTheme==3) {
          concreteMusic.loop();
        } else if (gameTheme==4) {
          iceMusic.loop();
        }
      }
    }

    // Calculates the base health of an enemy according to the wave and difficulty
    if (difficulty=="EASY") {
      baseHp = wave*pow(wave-1, 0.85)+1;
    } else if (difficulty=="MEDIUM") {
      baseHp = wave*pow(wave-1, 0.9)+1;
    } else if (difficulty=="HARD") {
      baseHp = wave*pow(wave-1, 0.95)+1;
    } else if (difficulty=="EXPERT") {
      baseHp = wave*(wave-1)+1;
    } 

    // Spawns enemies based on spawnrate
    if (timer>=enemySpawnRate && enemiesToSpawn>0 && startWave) {
      if (wave==15) {
        enemies.add(new Enemy("Yellow", trackX[0]+yellowSize*offset[selectedTrack-1][0], trackY[0]+yellowSize*offset[selectedTrack-1][1], yellowSize, 3*baseHp)); // Introduces yellow enemy
      } else if (wave==25) {
        enemies.add(new Enemy("Green", trackX[0]+greenSize*offset[selectedTrack-1][0], trackY[0]+greenSize*offset[selectedTrack-1][1], greenSize, 2*baseHp)); // Introduces green enemy
      } else if (wave==35) {
        enemies.add(new Enemy("RedArmour", trackX[0]+redSize*offset[selectedTrack-1][0], trackY[0]+redSize*offset[selectedTrack-1][1], redSize, 7*baseHp)); // Introduces red armour enemy
      } else if (wave%10!=0) {
        if (wave>35 && (spawnedEnemies+1)%10==0) {
          enemies.add(new Enemy("RedArmour", trackX[0]+redSize*offset[selectedTrack-1][0], trackY[0]+redSize*offset[selectedTrack-1][1], redSize, 7*baseHp)); // Spawns red armour enemy
        } 
        if (wave>25 && (spawnedEnemies+1)%7==0) {
          enemies.add(new Enemy("Green", trackX[0]+greenSize*offset[selectedTrack-1][0], trackY[0]+greenSize*offset[selectedTrack-1][1], greenSize, 2*baseHp)); // Spawns green enemy
        } else if (wave>15 && (spawnedEnemies+1)%5==0) {
          enemies.add(new Enemy("Yellow", trackX[0]+yellowSize*offset[selectedTrack-1][0], trackY[0]+yellowSize*offset[selectedTrack-1][1], yellowSize, 3*baseHp)); // Spawns yellow enemy
        } else {
          enemies.add(new Enemy("Red", trackX[0]+redSize*offset[selectedTrack-1][0], trackY[0]+redSize*offset[selectedTrack-1][1], redSize, baseHp)); // Spawns red enemy
        }
      } else {
        // Spawns boss
        enemies.add(new Enemy("RedBoss", trackX[0]+redSize*2*offset[selectedTrack-1][0], trackY[0]+redSize*2*offset[selectedTrack-1][1], redSize*2, ((11.5+(wave/20)+(int)(wave/100)*3)*baseHp)));
      }
      enemiesToSpawn--;
      spawnedEnemies++;
      timer = 0;
    }

    // Draws projectiles and checks if projectile collides with an enemy
    projectilesSpray = new HashSet<Projectile>();
    Enemy sprayEnemy = null;
    for (Projectile projectile : projectiles) {
      projectile.drawProjectile();
      if (projectile.checkBounds()) { // If projectile is out of bounds, it gets removed
        removeP.add(projectile);
      } else {
        for (Enemy enemy : enemies) {
          Enemy collide = projectile.collide(enemy);
          if (collide!=null) {
            if (!projectile.enemyHit.contains(enemy)) { // Makes sure enemy can only be hit once by the same projectile
              float damage = projectile.damage;
              if (enemy.type=="Yellow" && projectile.type=="BOAT2") { // Yellow takes less damage from boat shards
                damage = projectile.damage/5;
              } else if (enemy.type=="RedArmour") {
                if (projectile.type=="BEAM") { // Beam does 10x damage to armour
                  damage = damage*10;
                } else if ((projectile.type=="BOAT" || projectile.type=="BOAT2") && projectile.defence.level==25) { // Max boat does 20x damage to armour
                  damage = damage*20;
                } else if (projectile.type=="HELI") { // Heli does 5x less damage to armour
                  damage = damage/5;
                }
              } else if (enemy.type=="RedArmour" && projectile.defence.level<25 && projectile.type=="BOAT2") { // Armours absorbs shards
                damage = 0;
              } else if (enemy.type=="RedBoss" && projectile.defence.level==25 && projectile.type=="BEAM") { // Max beam does 3x damage to bosses
                damage = damage*3;
              } 
              if (enemy.health>=damage) {
                projectile.defence.damageDealt+=damage;
              } else {
                projectile.defence.damageDealt+=enemy.health;
              }
              enemy.health-=damage;
              projectile.pierce--;
              projectile.enemyHit.add(enemy);
              if (projectile.type=="BOAT") { // Creates shards for boat projectiles
                float shardDmg = projectile.damage/4;
                projectilesSpray.add(new Projectile("BOAT2", enemy.x, enemy.y, projectile.size/2, sqrt(2), 0, shardDmg, 1, projectile.level, projectile.defence));
                projectilesSpray.add(new Projectile("BOAT2", enemy.x, enemy.y, projectile.size/2, -sqrt(2), 0, shardDmg, 1, projectile.level, projectile.defence));
                projectilesSpray.add(new Projectile("BOAT2", enemy.x, enemy.y, projectile.size/2, -1, 1, shardDmg, 1, projectile.level, projectile.defence));
                projectilesSpray.add(new Projectile("BOAT2", enemy.x, enemy.y, projectile.size/2, -1, -1, shardDmg, 1, projectile.level, projectile.defence));
                projectilesSpray.add(new Projectile("BOAT2", enemy.x, enemy.y, projectile.size/2, 0, sqrt(2), shardDmg, 1, projectile.level, projectile.defence));
                projectilesSpray.add(new Projectile("BOAT2", enemy.x, enemy.y, projectile.size/2, 0, -sqrt(2), shardDmg, 1, projectile.level, projectile.defence));
                projectilesSpray.add(new Projectile("BOAT2", enemy.x, enemy.y, projectile.size/2, 1, 1, shardDmg, 1, projectile.level, projectile.defence));
                projectilesSpray.add(new Projectile("BOAT2", enemy.x, enemy.y, projectile.size/2, 1, -1, shardDmg, 1, projectile.level, projectile.defence));
                sprayEnemy = enemy;
              }
            }
            if (enemy.health<=0) {
              removeE.add(enemy);
            }
            if (projectile.pierce<=0) {
              removeP.add(projectile);
            }
          }
        }
      }
    }

    // Adds the spray effect to boat projectiles
    for (Projectile projectile : projectilesSpray) {
      projectiles.add(projectile);
      projectile.enemyHit.add(sprayEnemy);
    }

    // Removes enemies and projectiles if they collide
    for (Enemy remove : removeE) {
      int moneyAdd = 0;
      if (remove.type=="Red") {
        moneyAdd = 1;
      } else if (remove.type=="Yellow") {
        moneyAdd = 2;
      } else if (remove.type=="Green") {
        moneyAdd = 3;
      } else if (remove.type=="RedBoss") {
        if (wave<100) {
          moneyAdd = wave*10;
        } else {
          moneyAdd = 1000;
        }
      }
      // Adds money
      texts.add(new TextPulse (remove.x, remove.y-remove.size, "+$" + moneyAdd, 255, 255, 0));
      money+=moneyAdd;
      enemies.remove(remove);
      // Plays enemy death sound at random pitch
      enemyDie.stop();
      enemyDie.play();
    }

    // Removes projectiles which need to be removed
    for (Projectile remove : removeP) {
      projectiles.remove(remove);
    }

    // Removes bolts
    for (BoltEffect bolt : removeBolt) {
      bolts.remove(bolt);
    }

    rectMode(CENTER);
    // If a placed defence has been clicked on, it shows the information about that tower
    if (selected=="Defence") {
      // Shows range and highlights tower
      noFill();
      stroke(255);
      if (selectedDefence.type!="HELI") {
        strokeWeight(HEIGHT/500);
        ellipse(selectedDefence.x, selectedDefence.y, selectedDefence.range, selectedDefence.range);
        strokeWeight(HEIGHT/200);
        ellipse(selectedDefence.x, selectedDefence.y, selectedDefence.size, selectedDefence.size);
      } else {
        strokeWeight(HEIGHT/500);
        ellipse(selectedDefence.heliX, selectedDefence.heliY, selectedDefence.range, selectedDefence.range);
        strokeWeight(HEIGHT/200);
        rect(selectedDefence.x, selectedDefence.y, selectedDefence.size, selectedDefence.size);
      }
      noStroke();

      // Sets stats position
      float statsX = selectedDefence.x;
      float statsY = selectedDefence.y-selectedDefence.size/2-trackWidth;
      if (statsX<trackWidth) {
        statsX = trackWidth;
      } else if (statsX>WIDTH-trackWidth) {
        statsX = WIDTH - trackWidth;
      }
      if (statsY<trackWidth) {
        statsY = trackWidth;
      }
      // Displays stats
      if (displayStats) {
        if (selectedDefence.level==25) {
          fill(200, 150, 0);
        } else {
          fill(120, 60, 0);
        }
        rect(statsX, statsY, trackWidth*2, trackWidth*2);
        if (selectedDefence.level==25) {
          fill(255, 210, 0);
        } else {
          fill(140, 80, 0);
        }
        rect(statsX, statsY, trackWidth*2-HEIGHT/50, trackWidth*2-HEIGHT/50);
        fill(255);
        textAlign(LEFT);
        textSize(HEIGHT/41);
        statsX-=trackWidth*9/10-HEIGHT/100;
        statsY-=trackWidth*9/10;
        if (selectedDefence.type=="HELI") {
          text("MOVE: " + (int) selectedDefence.heliSpeed, statsX, statsY+trackWidth*0.2*1.6);
        } else {
          text("RANGE: " + (int) selectedDefence.range, statsX, statsY+trackWidth*0.2*1.6);
        }
        text("SPEED: " + (int) (selectedDefence.attackSpeed*10), statsX, statsY+trackWidth*0.4*1.6);
        text("DAMAGE: " + (int) selectedDefence.damage, statsX, statsY+trackWidth*0.6*1.6);
        if (selectedDefence.type=="BOLT") {
          text("CHAIN: " + selectedDefence.pierce, statsX, statsY+trackWidth*0.8*1.6);
        } else {
          text("PIERCE: " + selectedDefence.pierce, statsX, statsY+trackWidth*0.8*1.6);
        }
        text("HITS: " + (int) selectedDefence.damageDealt, statsX, statsY+trackWidth*1.6);
      }
    }

    // Hotbar base
    fill(120, 60, 0);
    rect(WIDTH/2, HEIGHT*0.925, WIDTH, HEIGHT*0.15);
    fill(140, 80, 0);
    rect(WIDTH/2, HEIGHT*0.925, WIDTH-HEIGHT/50, HEIGHT*0.13);
    fill(120, 60, 0);
    rect(HEIGHT*0.08+barSize, HEIGHT*0.925, HEIGHT/50, HEIGHT*0.15);

    // Green bar below tower name
    if (selected=="Defence" && selectedDefence.level==25) {
      fill(0, 200, 255);
    } else {
      fill(0, 255, 0);
    }
    rectMode(CORNER);
    rect(HEIGHT/25, HEIGHT*0.925, barSize, HEIGHT/25);
    textAlign(LEFT, BOTTOM);
    rectMode(CENTER);

    // Start round && toggle speed
    if (chooseTower) {
      fill(255);
    } else {
      fill(128);
    }
    rect(WIDTH-HEIGHT*0.075, HEIGHT*0.925, HEIGHT*0.1075, HEIGHT*0.1075);
    if (chooseTower) {
      fill(0, 170, 210);
    } else {
      fill(0, 85, 105);
    }
    rect(WIDTH-HEIGHT*0.075, HEIGHT*0.925, HEIGHT/10, HEIGHT/10);
    if (chooseTower) {
      fill(0, 200, 255);
    } else {
      fill(0, 100, 128);
    }
    rect(WIDTH-HEIGHT*0.075, HEIGHT*0.925, HEIGHT*0.08, HEIGHT*0.08);
    if (chooseTower) {
      fill(255);
    } else {
      fill(128);
    }
    float left = WIDTH-HEIGHT*0.075; // For simplifying code, x part of button
    float top = HEIGHT*0.925; // For simplifying code, y part of button
    float change = HEIGHT/45;
    if (!startWave) {
      textAlign(CENTER, CENTER);
      textSize(HEIGHT*0.0475);
      text("GO", left, HEIGHT*0.925-textDescent());
    } else  if (trueSpeed==1) {
      triangle(left-change*0.625, top+change, left-change*0.625, top-change, left+change*0.75, top);
    } else if (trueSpeed==2 && !autoStart) {
      triangle(left-change*1.125, top+change, left-change*1.125, top-change, left+change/2, top);
      triangle(left-change*0.125, top+change, left-change*0.125, top-change, left+change*1.25, top);
    } else {
      triangle(left-change*1.125, top+change, left-change*1.125, top-change, left+change/2, top);
      triangle(left-change*0.125, top+change, left-change*0.125, top-change, left+change*1.25, top);
      rect(left+change*1.15, top, change/5, change*2);
    }

    // Restart button & arrow
    fill(0, 170, 210);
    rect(WIDTH-HEIGHT*0.165, HEIGHT*0.895, HEIGHT/26, HEIGHT/26);
    fill(255);
    ellipse(WIDTH-HEIGHT*0.165, HEIGHT*0.895, HEIGHT/40, HEIGHT/40);
    fill(0, 170, 210);
    ellipse(WIDTH-HEIGHT*0.165, HEIGHT*0.895, HEIGHT/75, HEIGHT/75);
    rect(WIDTH-HEIGHT*0.165-HEIGHT/110, HEIGHT*0.895-HEIGHT/110, HEIGHT/55, HEIGHT/55);
    fill(255);
    triangle(WIDTH-HEIGHT*0.175, HEIGHT*0.885, WIDTH-HEIGHT*0.165, HEIGHT*0.885+HEIGHT/150, WIDTH-HEIGHT*0.165, HEIGHT*0.885-HEIGHT/150);

    // Pause button
    if (pause==1 || selectDifficulty) {
      fill(255, 170, 0);
    } else {
      fill(200, 130, 0);
    }
    rect(WIDTH-HEIGHT*0.165, HEIGHT*0.955, HEIGHT/26, HEIGHT/26);
    if (pause==1 || selectDifficulty) {
      fill(255);
    } else {
      fill(160);
    }
    rect(WIDTH-HEIGHT*0.165-HEIGHT/150, HEIGHT*0.955, HEIGHT/150, HEIGHT/40);
    rect(WIDTH-HEIGHT*0.165+HEIGHT/150, HEIGHT*0.955, HEIGHT/150, HEIGHT/40);

    // Displays hotbar info
    fill(255, 255, 220);
    textSize(HEIGHT/30);
    textAlign(LEFT, BOTTOM);

    if (selected=="Defence") {
      // Displays new ability if maxed
      if (selectedDefence.level==25) {
        textSize(HEIGHT/40);
        textAlign(CENTER, CENTER);
        if (selectedDefence.type=="BEAM") {
          text("SPECIAL ABILITY: 3X DAMAGE TO BOSSES", WIDTH/2, HEIGHT*0.82);
        } else if (selectedDefence.type=="BOAT") {
          text("SPECIAL ABILITY: ARMOUR BUSTER", WIDTH/2, HEIGHT*0.82);
        } else if (selectedDefence.type=="HELI") {
          text("SPECIAL ABILITY: RAZOR ROTORS", WIDTH/2, HEIGHT*0.82);
        } else if (selectedDefence.type=="BOLT") {
          text("SPECIAL ABILITY: STUN ON IMPACT", WIDTH/2, HEIGHT*0.82);
        }
      }
      // Shows info about tower and upgrades etc
      textSize(HEIGHT/30);
      textAlign(LEFT, BOTTOM);
      text(selectedDefence.type, HEIGHT/25, HEIGHT*0.915);
      textAlign(LEFT, TOP);
      fill(120, 60, 0);
      textSize(HEIGHT/40);
      text(" LEVEL " + selectedDefence.level, HEIGHT/25, HEIGHT*0.93);

      // Stats toggle
      fill(255, 210, 0);
      rect(HEIGHT*0.165, HEIGHT*0.8875, HEIGHT/26, HEIGHT/26);
      textSize(HEIGHT/30);
      fill(255);
      textAlign(CENTER, CENTER);
      text("?", HEIGHT*0.165, HEIGHT*0.8875-textAscent()/9);

      // Allows target priority (close, strong, first, last)
      textAlign(LEFT, BOTTOM);
      textSize(HEIGHT/35);
      targetOffset = textWidth("TARGET: STRONG");
      fill(255);
      if (selectedDefence.type=="HELI") {
        text("FLIGHT: " + selectedDefence.heliMovement, HEIGHT*0.175+barSize/2, HEIGHT*0.915);
        fill(255, 150, 0);
        rectMode(CORNER);
        rect(HEIGHT*0.175+barSize/2, HEIGHT*0.925, targetOffset, HEIGHT/25);
        rectMode(CENTER);
        fill(255);
        textAlign(LEFT, TOP);
        textSize(HEIGHT/40);
        text("  CHANGE FLIGHT", HEIGHT*0.175+barSize/2, HEIGHT*0.93);
      } else {
        text("TARGET: " + selectedDefence.target, HEIGHT*0.175+barSize/2, HEIGHT*0.915);
        fill(255, 150, 0);
        rectMode(CORNER);
        rect(HEIGHT*0.175+barSize/2, HEIGHT*0.925, targetOffset, HEIGHT/25);
        rectMode(CENTER);
        fill(255);
        textAlign(LEFT, TOP);
        textSize(HEIGHT/40);
        text("  CHANGE TARGET", HEIGHT*0.175+barSize/2, HEIGHT*0.93);
      }

      // Background for the upgrades
      fill(180, 100, 30);
      rectMode(CORNER);
      rect(HEIGHT*0.19+barSize+targetOffset*4/5, HEIGHT*0.87, HEIGHT/5+barSize+targetOffset*2, HEIGHT*0.11);

      // Displays upgrades
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(HEIGHT/30);
      text("UPGRADES", HEIGHT/5+barSize+targetOffset+HEIGHT/20, HEIGHT*0.925-textDescent());

      // Shows upgrade boxes with info
      rectMode(CORNER);
      // If you can afford the upgrade it displays the box brighter, and if you have maxed that upgrade it turns blue instead of yellow
      if (selectedDefence.upgrade1<7) {
        if (money<selectedDefence.cost1) {
          fill(210, 170, 0);
        } else {
          fill(255, 210, 0);
        }
      } else {
        fill(0, 200, 255);
      }
      rect(HEIGHT/2+targetOffset, HEIGHT*0.88, targetOffset/2, HEIGHT*0.09);
      if (selectedDefence.upgrade2<8) {
        if (money<selectedDefence.cost2) {
          fill(210, 170, 0);
        } else {
          fill(255, 210, 0);
        }
      } else {
        fill(0, 200, 255);
      }
      rect(HEIGHT/2+targetOffset*1.6, HEIGHT*0.88, targetOffset/2, HEIGHT*0.09);
      if (selectedDefence.upgrade3<8) {
        if (money<selectedDefence.cost3) {
          fill(210, 170, 0);
        } else {
          fill(255, 210, 0);
        }
      } else {
        fill(0, 200, 255);
      }
      rect(HEIGHT/2+targetOffset*2.2, HEIGHT*0.88, targetOffset/2, HEIGHT*0.09);
      if (selectedDefence.upgrade4<5) {
        if (money<selectedDefence.cost4) {
          fill(210, 170, 0);
        } else {
          fill(255, 210, 0);
        }
      } else {
        fill(0, 200, 255);
      }
      rect(HEIGHT/2+targetOffset*2.8, HEIGHT*0.88, targetOffset/2, HEIGHT*0.09);

      // Shows text info for upgrades
      fill(255);
      textSize(HEIGHT/40);
      textAlign(CENTER, BOTTOM);
      if (selectedDefence.type=="HELI") {
        text("MOVE", HEIGHT/2+targetOffset*1.25, HEIGHT*0.925);
      } else {
        text("RANGE", HEIGHT/2+targetOffset*1.25, HEIGHT*0.925);
      }
      text("SPEED", HEIGHT/2+targetOffset*1.85, HEIGHT*0.925);
      text("DAMAGE", HEIGHT/2+targetOffset*2.45, HEIGHT*0.925);
      if (selectedDefence.type=="BOLT") {
        text("CHAIN", HEIGHT/2+targetOffset*3.05, HEIGHT*0.925);
      } else {
        text("PIERCE", HEIGHT/2+targetOffset*3.05, HEIGHT*0.925);
      }
      textAlign(CENTER, TOP);

      // Shows cost of upgrade if not maxed, else shows that it is maxed
      if (selectedDefence.upgrade1<7) {
        text("$" + selectedDefence.cost1, HEIGHT/2+targetOffset*1.25, HEIGHT*0.925);
      } else {
        text("MAX", HEIGHT/2+targetOffset*1.25, HEIGHT*0.925);
      }
      if (selectedDefence.upgrade2<8) {
        text("$" + selectedDefence.cost2, HEIGHT/2+targetOffset*1.85, HEIGHT*0.925);
      } else {
        text("MAX", HEIGHT/2+targetOffset*1.85, HEIGHT*0.925);
      }
      if (selectedDefence.upgrade3<8) {
        text("$" + selectedDefence.cost3, HEIGHT/2+targetOffset*2.45, HEIGHT*0.925);
      } else {
        text("MAX", HEIGHT/2+targetOffset*2.45, HEIGHT*0.925);
      }
      if (selectedDefence.upgrade4<5) {
        text("$" + selectedDefence.cost4, HEIGHT/2+targetOffset*3.05, HEIGHT*0.925);
      } else {
        text("MAX", HEIGHT/2+targetOffset*3.05, HEIGHT*0.925);
      }

      // Exit defence hotbar
      fill(100);
      rectMode(CENTER);
      rect(WIDTH/2+HEIGHT/5+barSize+targetOffset, HEIGHT*0.895, targetOffset*0.75, HEIGHT/25);
      fill(255);
      textAlign(CENTER, CENTER);
      text("CLOSE", WIDTH/2+HEIGHT/5+barSize+targetOffset, HEIGHT*0.895-textDescent());

      // Sell button
      fill(255, 0, 0);
      rect(WIDTH/2+HEIGHT/5+barSize+targetOffset, HEIGHT*0.955, targetOffset*0.75, HEIGHT/25);
      fill(255);
      textAlign(CENTER, CENTER);
      text("SELL $" + selectedDefence.sell, WIDTH/2+HEIGHT/5+barSize+targetOffset, HEIGHT*0.955-textDescent());
    } else {
      if (hotBarSelect=="None") {
        text("TOWERS", HEIGHT/25, HEIGHT*0.915);
      } else {
        text(hotBarSelect, HEIGHT/25, HEIGHT*0.915);
        textAlign(LEFT, TOP);
        fill(120, 60, 0);
        textSize(HEIGHT/40);
        text(" $" + selectedCost, HEIGHT/25, HEIGHT*0.93);
      }
      // Draws beam tower for purchase
      drawBox(HEIGHT*0.175+barSize, money<5);
      drawTower("BEAM", HEIGHT*0.175+barSize, HEIGHT*0.925, money<5);

      // Draws boat for purchase
      drawBox(HEIGHT*0.325+barSize, money<25);
      drawTower("BOAT", HEIGHT*0.325+barSize, HEIGHT*0.925, money<25);

      // Draws heli for purchase
      scaleHeli = 0.5;
      drawBox(HEIGHT*0.475+barSize, money<250);
      drawTower("HELI", HEIGHT*0.475+barSize, HEIGHT*0.925, money<250);

      // Draws bolt for purchase
      drawBox(HEIGHT*0.625+barSize, money<100);
      drawTower("BOLT", HEIGHT*0.625+barSize, HEIGHT*0.925, money<100);

      // Draws none for purchase
      drawBox(HEIGHT*0.775+barSize, true);
      drawTower("NONE", HEIGHT*0.875+barSize, HEIGHT*0.925, true);

      // Draws none for purchase
      drawBox(HEIGHT*0.925+barSize, true);
      drawTower("NONE", HEIGHT*0.1025+barSize, HEIGHT*0.925, true);

      // Draws none for purchase
      drawBox(HEIGHT*1.075+barSize, true);
      drawTower("NONE", HEIGHT*1.075+barSize, HEIGHT*0.925, true);

      // Draws none for purchase
      drawBox(HEIGHT*1.225+barSize, true);
      drawTower("NONE", HEIGHT*1.225+barSize, HEIGHT*0.925, true);

      // Draws none for purchase
      drawBox(HEIGHT*1.375+barSize, true);
      drawTower("NONE", HEIGHT*1.375+barSize, HEIGHT*0.925, true);
    }

    // Deselects tower if game is won
    if (win && selected!="DEFENCE") {
      selected = "None";
    }

    // Draws selected defence to mouse position
    noFill();
    stroke(255);
    strokeWeight(HEIGHT/500);
    if (selected=="BEAM") {
      hotBarSelect = "BEAM";
      ellipse(mouseX, mouseY, beamRange, beamRange);
      noStroke();
      drawTower("BEAM", mouseX, mouseY, !canPlace());
      tutorialText = "SMOL AND CHEAP PLASMA BOI";
    } else if (selected=="BOAT") {
      hotBarSelect = "BOAT";
      ellipse(mouseX, mouseY, boatRange, boatRange);
      noStroke();
      boatCollide = true;
      if (!touchWater()) {
        boatCollide = false;
      } else if (mouseY+boatSize/2<hotBarTop) {
        boatCollide = true;
      }
      drawTower("BOAT", mouseX, mouseY, boatCollide);
      tutorialText = "THE CANNON CAUSES UTTER CARNAGE";
    } else if (selected=="HELI") {
      noStroke();
      hotBarSelect = "HELI";
      scaleHeli = 1;
      drawTower("HELI", mouseX, mouseY, !canPlace());
      tutorialText = "TIME TO BRING IN THE BIG GUNS";
    } else if (selected=="BOLT") {
      hotBarSelect = "BOLT";
      ellipse(mouseX, mouseY, boltRange, boltRange);
      noStroke();
      drawTower("BOLT", mouseX, mouseY, !canPlace());
      tutorialText = "UNLEASHES A CHAIN OF LIGHTNING";
    }
    noStroke();

    // Clears the text which needs to be removed
    removeT = new HashSet<TextPulse>();

    // Draws pulsing text
    for (TextPulse text : texts) {
      text.drawText();
    }
    // Removes text which have finished pulsing
    for (TextPulse text : removeT) {
      texts.remove(text);
    }

    // Displays tutorial/tips text
    textSize(HEIGHT/20);
    textAlign(CENTER, BOTTOM);
    fill(0, 255, 200);
    // Fixes contrast for certain maps
    if (gameTheme==4 && !bossWave && wave<100) {
      fill(153, 50, 204);
    } else if ((mapNames[selectedTrack-1] == "DOUBLE DIP" || mapNames[selectedTrack-1] == "WALK THE PLANK") && !bossWave) {
      fill(255, 255, 220);
    }
    text(tutorialText, WIDTH/2, HEIGHT*0.785);

    // Displays lives
    fill(255, 255, 220);
    textSize(HEIGHT/30);
    textAlign(LEFT);
    text("LIVES: " + lives, HEIGHT/25, HEIGHT/25+textDescent());

    // Displays enemies left
    if (startWave && chooseTower && !win) {
      if (wave%10!=0) {
        text("ENEMIES: " + enemiesLeft, HEIGHT/25, HEIGHT*0.8);
      } else {
        textSize(HEIGHT/15);
        text("BOSS!!!", HEIGHT/25, HEIGHT*0.8);
      }
    }

    // Displays difficulty
    textAlign(RIGHT);
    textSize(HEIGHT/30);
    if (!selectDifficulty) {
      text("DIFFICULTY: " + difficulty, WIDTH-HEIGHT/25, HEIGHT*0.8);
    }

    // Displays map name and wave
    textAlign(CENTER);
    fill(255, 255, 220);
    if (win) {
      text(mapNames[selectedTrack-1] + ": WAVE 100", WIDTH/2, HEIGHT/25+textDescent());
    } else {
      text(mapNames[selectedTrack-1] + ": WAVE " + wave, WIDTH/2, HEIGHT/25+textDescent());
    }

    // Displays cash
    textAlign(RIGHT);
    text("CASH: ", WIDTH-HEIGHT/25-textWidth("$" + money), HEIGHT/25+textDescent());
    fill(255, 255, 0);
    text("$" + money, WIDTH-HEIGHT/25, HEIGHT/25+textDescent());

    // Plays game over sound
    if (lives<=0 && !gameOver) {
      gameOver = true;
      gameOverSound.play();
    }

    // Displays game over or paused text
    rectMode(CENTER);
    spacing = HEIGHT/50;
    textAlign(CENTER, CENTER);
    fill(255, 255, 220);
    textSize(HEIGHT/5);
    pausedSize = textWidth("PAUSED");
    if (lives<=0) {
      text("GAME OVER", WIDTH/2, HEIGHT*0.425-textDescent());

      // Displays return to menu button
      fill(180, 0, 0);
      rect(WIDTH/2, HEIGHT*0.575, pausedSize, HEIGHT/8);
      fill(240, 20, 20);
      rect(WIDTH/2, HEIGHT*0.575, pausedSize-spacing, HEIGHT/8-spacing);
      fill(255);
      textSize(HEIGHT/15);
      text("RETURN TO MENU", WIDTH/2, HEIGHT*0.575-textDescent());
    } else if (win) {
      text("VICTORY", WIDTH/2, HEIGHT*0.3-textDescent());

      // Displays freeplay button
      textSize(HEIGHT/15);
      fill(0, 205, 150);
      rect(WIDTH/2, HEIGHT*0.5, pausedSize, HEIGHT/8);
      fill(0, 255, 200);
      rect(WIDTH/2, HEIGHT*0.5, pausedSize-spacing, HEIGHT/8-spacing);
      fill(255);
      text("FREEPLAY", WIDTH/2, HEIGHT*0.5-textDescent());

      // Displays return to menu button
      fill(180, 0, 0);
      rect(WIDTH/2, HEIGHT*0.65, pausedSize, HEIGHT/8);
      fill(240, 20, 20);
      rect(WIDTH/2, HEIGHT*0.65, pausedSize-spacing, HEIGHT/8-spacing);
      fill(255);
      textSize(HEIGHT/15);
      text("RETURN TO MENU", WIDTH/2, HEIGHT*0.65-textDescent());
    } else if (pause==0 && !selectDifficulty  && showDefenceInfo=="NONE") {
      text("PAUSED", WIDTH/2, HEIGHT*0.25-textDescent());

      // Displays resume button
      textSize(HEIGHT/15);
      fill(255, 180, 0);
      rect(WIDTH/2, HEIGHT*0.4, pausedSize, HEIGHT/8);
      fill(255, 210, 0);
      rect(WIDTH/2, HEIGHT*0.4, pausedSize-spacing, HEIGHT/8-spacing);
      fill(255);
      text("RESUME", WIDTH/2, HEIGHT*0.4-textDescent());

      // Displays reduce lag button
      if (lag=="ALL") {
        fill(0, 160, 205);
      } else if (lag=="SOME") {
        fill(0, 110, 140);
      } else if (lag=="OFF") {
        fill(0, 65, 78);
      }
      rect(WIDTH/2, HEIGHT*0.55, pausedSize, HEIGHT/8);
      if (lag=="ALL") {
        fill(0, 210, 255);
      } else if (lag=="SOME") {
        fill(0, 155, 192);
      } else if (lag=="OFF") {
        fill(0, 105, 128);
      }
      rect(WIDTH/2, HEIGHT*0.55, pausedSize-spacing, HEIGHT/8-spacing);
      fill(255);
      textSize(HEIGHT/18);
      text("REDUCE LAG: " + lag, WIDTH/2, HEIGHT*0.55-textDescent());

      // Return to menu button
      fill(180, 0, 0);
      rect(WIDTH/2, HEIGHT*0.7, pausedSize, HEIGHT/8);
      fill(240, 20, 20);
      rect(WIDTH/2, HEIGHT*0.7, pausedSize-spacing, HEIGHT/8-spacing);
      fill(255);
      text("RETURN TO MENU", WIDTH/2, HEIGHT*0.7-textDescent());

      // Draws audio toggle
      float audX = WIDTH/2;
      float audY = HEIGHT*0.8;
      float audSize = HEIGHT/15;
      fill(200, 150, 0);
      rect(audX, audY, audSize, audSize);
      fill(255, 200, 0);
      rect(audX, audY, audSize*0.8, audSize*0.8);

      // Music note
      fill(255);
      ellipse(audX-audSize/5-WIDTH/1000, audY+audSize/5, audSize/5, audSize/5);
      ellipse(audX+audSize/5-WIDTH/1000, audY+audSize/8, audSize/5, audSize/5);
      stroke(255);
      strokeWeight(HEIGHT/250);
      line(audX-audSize/5+audSize/10-WIDTH/1000, audY+audSize/5, audX-audSize/5+audSize/10-WIDTH/1000, audY-audSize/8);
      line(audX-audSize/5+audSize/10-WIDTH/1000, audY-audSize/8, audX+audSize/5+audSize/10-WIDTH/1000, audY-audSize/4);
      line(audX+audSize/5+audSize/10-WIDTH/1000, audY-audSize/5, audX+audSize/5+audSize/10-WIDTH/1000, audY+audSize/8);
      noStroke();

      // Draws an X if muted
      if (volume==0) {
        fill(255, 0, 0);
        text("X", audX, audY-textDescent()/2);
      }
    }

    if (selectDifficulty) {
      rectMode(CENTER);
      fill(30, 80, 100);
      rect(WIDTH/2, HEIGHT*0.15, WIDTH/2+WIDTH/200, HEIGHT/8+WIDTH/200);
      fill(70, 120, 170);
      rect(WIDTH/2, HEIGHT*0.15, WIDTH/2, HEIGHT/8);
      fill(100, 150, 200);
      rect(WIDTH/2, HEIGHT*0.15, WIDTH/2-spacing, HEIGHT/8-spacing);
      textSize(HEIGHT/16);
      fill(255);
      text("SELECT DIFFICULTY", WIDTH/2, HEIGHT*0.15-textDescent());
      // Easy
      textSize(HEIGHT/18);
      fill(255);
      rect(WIDTH/4+WIDTH*0.115, HEIGHT*0.3, WIDTH*0.235, HEIGHT/8+WIDTH/200);
      fill(0, 200, 50);
      rect(WIDTH/4+WIDTH*0.115, HEIGHT*0.3, WIDTH*0.23, HEIGHT/8);
      fill(0, 250, 75);
      rect(WIDTH/4+WIDTH*0.115, HEIGHT*0.3, WIDTH*0.23-spacing, HEIGHT/8-spacing);
      fill(255);
      text("EASY", WIDTH/4+WIDTH*0.115, HEIGHT*0.3-textDescent());
      // Medium
      fill(255);
      rect(WIDTH/4+WIDTH*0.115, HEIGHT*0.45, WIDTH*0.235, HEIGHT/8+WIDTH/200);
      fill(200, 180, 0);
      rect(WIDTH/4+WIDTH*0.115, HEIGHT*0.45, WIDTH*0.23, HEIGHT/8);
      fill(250, 230, 0);
      rect(WIDTH/4+WIDTH*0.115, HEIGHT*0.45, WIDTH*0.23-spacing, HEIGHT/8-spacing);
      fill(255);
      text("MEDIUM", WIDTH/4+WIDTH*0.115, HEIGHT*0.45-textDescent());
      // Hard
      fill(255);
      rect(WIDTH/4+WIDTH*0.115, HEIGHT*0.6, WIDTH*0.235, HEIGHT/8+WIDTH/200);
      fill(200, 100, 0);
      rect(WIDTH/4+WIDTH*0.115, HEIGHT*0.6, WIDTH*0.23, HEIGHT/8);
      fill(250, 150, 0);
      rect(WIDTH/4+WIDTH*0.115, HEIGHT*0.6, WIDTH*0.23-spacing, HEIGHT/8-spacing);
      fill(255);
      text("HARD", WIDTH/4+WIDTH*0.115, HEIGHT*0.6-textDescent());
      // Expert
      fill(255);
      rect(WIDTH/4+WIDTH*0.115, HEIGHT*0.75, WIDTH*0.235, HEIGHT/8+WIDTH/200);
      fill(200, 50, 0);
      rect(WIDTH/4+WIDTH*0.115, HEIGHT*0.75, WIDTH*0.23, HEIGHT/8);
      fill(250, 0, 0);
      rect(WIDTH/4+WIDTH*0.115, HEIGHT*0.75, WIDTH*0.23-spacing, HEIGHT/8-spacing);
      fill(255);
      text("EXPERT", WIDTH/4+WIDTH*0.115, HEIGHT*0.75-textDescent());
      // Info boxes
      fill(0, 250, 75);
      rect(WIDTH*3/4-WIDTH*0.115, HEIGHT*0.3, WIDTH*0.235, HEIGHT/8+WIDTH/200);
      fill(250, 230, 0);
      rect(WIDTH*3/4-WIDTH*0.115, HEIGHT*0.45, WIDTH*0.235, HEIGHT/8+WIDTH/200);
      fill(250, 150, 0);
      rect(WIDTH*3/4-WIDTH*0.115, HEIGHT*0.6, WIDTH*0.235, HEIGHT/8+WIDTH/200);
      fill(250, 0, 0);
      rect(WIDTH*3/4-WIDTH*0.115, HEIGHT*0.75, WIDTH*0.235, HEIGHT/8+WIDTH/200);
      fill(140, 80, 0);
      rect(WIDTH*3/4-WIDTH*0.115, HEIGHT*0.3, WIDTH*0.23, HEIGHT/8);
      rect(WIDTH*3/4-WIDTH*0.115, HEIGHT*0.45, WIDTH*0.23, HEIGHT/8);
      rect(WIDTH*3/4-WIDTH*0.115, HEIGHT*0.6, WIDTH*0.23, HEIGHT/8);
      rect(WIDTH*3/4-WIDTH*0.115, HEIGHT*0.75, WIDTH*0.23, HEIGHT/8);
      fill(160, 100, 0);
      rect(WIDTH*3/4-WIDTH*0.115, HEIGHT*0.3, WIDTH*0.23-spacing, HEIGHT/8-spacing);
      rect(WIDTH*3/4-WIDTH*0.115, HEIGHT*0.45, WIDTH*0.23-spacing, HEIGHT/8-spacing);
      rect(WIDTH*3/4-WIDTH*0.115, HEIGHT*0.6, WIDTH*0.23-spacing, HEIGHT/8-spacing);
      rect(WIDTH*3/4-WIDTH*0.115, HEIGHT*0.75, WIDTH*0.23-spacing, HEIGHT/8-spacing);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(HEIGHT/25);
      text("FOR NOOBS", WIDTH*3/4-WIDTH*0.115, HEIGHT*0.3-textDescent());
      text("RECOMMENDED", WIDTH*3/4-WIDTH*0.115, HEIGHT*0.45-textDescent());
      text("CHALLENGING", WIDTH*3/4-WIDTH*0.115, HEIGHT*0.6-textDescent());
      text("GOOD LUCK!", WIDTH*3/4-WIDTH*0.115, HEIGHT*0.75-textDescent());
    }

    if (showDefenceInfo!="NONE") {
      // Defence information box
      fill(120, 60, 0);
      rect(WIDTH/2, HEIGHT*0.45, WIDTH/2, HEIGHT/2);
      fill(140, 80, 0);
      rect(WIDTH/2, HEIGHT*0.45, WIDTH/2-spacing, HEIGHT/2-spacing);
      textSize(HEIGHT/20);
      fill(180, 120, 0);
      rect(WIDTH/2, HEIGHT*0.475, WIDTH*0.43, HEIGHT*0.33);
      // Close button
      fill(200, 0, 0);
      rect(WIDTH*0.7, HEIGHT*0.25, HEIGHT/20, HEIGHT/20);
      fill(255, 0, 0);
      rect(WIDTH*0.7, HEIGHT*0.25, HEIGHT/25, HEIGHT/25);
      fill(255);
      textSize(HEIGHT/25);
      text("X", WIDTH*0.7, HEIGHT*0.25-textDescent()/2);
      // Displays information for tower
      fill(255);
      textAlign(CENTER, CENTER);
      text(showDefenceInfo, WIDTH/2, HEIGHT/4);
      textSize(HEIGHT/30);
      textAlign(LEFT);
      if (showDefenceInfo=="BEAM") {
        showInfo = beamInfo;
      } else if (showDefenceInfo=="BOAT") {
        showInfo = boatInfo;
      } else if (showDefenceInfo=="HELI") {
        showInfo = heliInfo;
      } else if (showDefenceInfo=="BOLT") {
        showInfo = boltInfo;
      }
      text(showInfo[0], WIDTH*0.31, HEIGHT*0.37);
      text(showInfo[1], WIDTH*0.31, HEIGHT*0.445);
      text(showInfo[2], WIDTH*0.31, HEIGHT*0.52);
      text(showInfo[3], WIDTH*0.31, HEIGHT*0.595);
    }
  }
}

// Draws box for purchasing towers/selecting map pieces
void drawBox(float x, Boolean dark) {
  // If dark is true, draws the box darker
  if (dark) {
    fill(140);
  } else {
    fill(255, 220, 150);
  }
  rect(x, HEIGHT*0.925, HEIGHT*0.1075, HEIGHT*0.1075);

  if (dark) {
    fill(180, 120, 0);
  } else {
    fill(255, 180, 0);
  }
  rect(x, HEIGHT*0.925, HEIGHT/10, HEIGHT/10);

  if (dark) {
    fill(200, 150, 0);
  } else {
    fill(255, 210, 0);
  }
  rect(x, HEIGHT*0.925, HEIGHT*0.08, HEIGHT*0.08);
}

// Draws the background scenery for the menu
void drawMenu() {
  // Draws menu and colours to last theme used, otherwise dirt as default
  rectMode(CENTER);

  // Sky
  fill(115, 215, 255);
  rect(WIDTH/2, HEIGHT/2, WIDTH, HEIGHT);
  fill(145, 224, 255);
  ellipse(WIDTH/2, HEIGHT/2, WIDTH, HEIGHT);
  fill(185, 235, 255);
  ellipse(WIDTH/2, HEIGHT/2, WIDTH*0.75, HEIGHT*0.75);
  fill(225, 246, 255);
  ellipse(WIDTH/2, HEIGHT/2, WIDTH/2, HEIGHT/2);

  // Grass
  if (lastTheme==1) {
    fill(0, 190, 0);
  } else if (lastTheme==2) {
    fill(220, 180, 70);
  } else if (lastTheme==3) {
    fill(138);
  } else if (lastTheme==4) {
    fill(147, 217, 250);
  }
  rect(WIDTH/2, HEIGHT*0.75, WIDTH, HEIGHT/2);

  // Grass sticking out of path
  if (lastTheme==1) {
    fill(0, 130, 0);
  } else if (lastTheme==2) {
    fill(155, 115, 5);
  } else if (lastTheme==3) {
    fill(95);
  } else if (lastTheme==4) {
    fill(87, 137, 190);
  }
  beginShape();
  vertex(WIDTH*0.38, HEIGHT/2);
  vertex(WIDTH*0.62, HEIGHT/2);
  vertex(WIDTH*0.67, HEIGHT);
  vertex(WIDTH*0.33, HEIGHT);
  endShape();

  // Path
  if (lastTheme==1) {
    fill(210, 140, 80);
  } else if (lastTheme==2) {
    fill(168, 143, 89);
  } else if (lastTheme==3) {
    fill(150);
  } else if (lastTheme==4) {
    fill(199, 213, 224);
  }
  beginShape();
  vertex(WIDTH*0.4, HEIGHT/2);
  vertex(WIDTH*0.6, HEIGHT/2);
  vertex(WIDTH*0.65, HEIGHT);
  vertex(WIDTH*0.35, HEIGHT);
  endShape();
  if (lastTheme==1) {
    fill(230, 160, 110);
  } else if (lastTheme==2) {
    fill(238, 215, 153);
  } else if (lastTheme==3) {
    fill(180);
  } else if (lastTheme==4) {
    fill(219, 233, 244);
  }
  beginShape();
  vertex(WIDTH*0.42, HEIGHT/2);
  vertex(WIDTH*0.58, HEIGHT/2);
  vertex(WIDTH*0.63, HEIGHT);
  vertex(WIDTH*0.37, HEIGHT);
  endShape();

  // Grass sticking out of water
  if (lastTheme==1) {
    fill(0, 130, 0);
  } else if (lastTheme==2) {
    fill(155, 115, 5);
  } else if (lastTheme==3) {
    fill(95);
  } else if (lastTheme==4) {
    fill(87, 137, 190);
  }
  beginShape();
  vertex(WIDTH*0.7, HEIGHT/2);
  vertex(WIDTH, HEIGHT/2);
  vertex(WIDTH, HEIGHT);
  vertex(WIDTH*0.8, HEIGHT);
  endShape();

  // Water
  fill(0, 150, 200);
  beginShape();
  vertex(WIDTH*0.72, HEIGHT/2);
  vertex(WIDTH, HEIGHT/2);
  vertex(WIDTH, HEIGHT);
  vertex(WIDTH*0.82, HEIGHT);
  endShape();
  fill(0, 200, 255);
  beginShape();
  vertex(WIDTH*0.74, HEIGHT/2);
  vertex(WIDTH, HEIGHT/2);
  vertex(WIDTH, HEIGHT);
  vertex(WIDTH*0.84, HEIGHT);
  endShape();

  // Beam shadow
  float beamMenuSize = HEIGHT/3;
  float beamMenuX = WIDTH*0.15;
  float beamMenuY = HEIGHT*0.6;
  fill(80, 100, 80);
  ellipse(beamMenuX, beamMenuY+beamMenuSize/2, beamMenuSize, beamMenuSize/2);
  // Beam
  fill(128, 0, 255);
  ellipse(beamMenuX, beamMenuY, beamMenuSize, beamMenuSize);
  fill(128, 100, 255);
  ellipse(beamMenuX, beamMenuY, beamMenuSize*0.8, beamMenuSize*0.8);
  // Beam eye
  fill(128, 0, 255);
  ellipse(beamMenuX+beamMenuSize*0.2, beamMenuY, beamMenuSize*0.4, beamMenuSize*0.4);
  fill(255);
  ellipse(beamMenuX+beamMenuSize*0.2, beamMenuY, beamMenuSize/4, beamMenuSize/4);
  fill(0);
  ellipse(beamMenuX+beamMenuSize*0.2, beamMenuY, beamMenuSize/10, beamMenuSize/10);

  // Red enemy
  float redMenuSize = HEIGHT/3;
  float redMenuX = WIDTH/2;
  float redMenuY = HEIGHT*0.75;
  fill(255*0.75, 0, 0);
  rect(redMenuX, redMenuY, redMenuSize, redMenuSize);
  fill(255, 0, 0);
  rect(redMenuX, redMenuY, redMenuSize*0.8, redMenuSize*0.8);
  fill(255*0.85, 0, 0);
  ellipse(redMenuX, redMenuY+redMenuSize/4, redMenuSize/2, redMenuSize/2);
  fill(255, 255, 220);
  ellipse(redMenuX, redMenuY+redMenuSize/4, redMenuSize/3, redMenuSize/3);
  // Boat
  float boatMenuX = WIDTH*0.9;
  float boatMenuY = HEIGHT*0.7;
  float boatMenuSize = HEIGHT/3;
  fill(200, 160, 0);
  ellipse(boatMenuX, boatMenuY, boatMenuSize, boatMenuSize);
  fill(160, 130, 0);
  ellipse(boatMenuX, boatMenuY, boatMenuSize*0.8, boatMenuSize*0.8);

  // Boat mast pole
  fill(200, 160, 0);
  rect(boatMenuX, boatMenuY-boatMenuSize/2, boatMenuSize/6, boatMenuSize);
  // Cannon nuzzle base
  fill(80);
  ellipse(boatMenuX-boatMenuSize/3, boatMenuY, boatMenuSize/4, boatMenuSize/4);
  // Cannon nuzzle inner
  fill(0);
  ellipse(boatMenuX-boatMenuSize/3, boatMenuY, boatMenuSize/8, boatMenuSize/8);
  // Cannon top base
  fill(80);
  ellipse(boatMenuX-boatMenuSize/6, boatMenuY, boatMenuSize/3, boatMenuSize/3);
  // Top of cannon
  fill(40);
  ellipse(boatMenuX-boatMenuSize/6, boatMenuY, boatMenuSize/4, boatMenuSize/4);
  // Boat mast
  fill(200);
  rect(boatMenuX, boatMenuY-boatMenuSize*0.6, boatMenuSize*0.7, boatMenuSize*0.7);
  fill(255);
  ellipse(boatMenuX, boatMenuY-boatMenuSize*0.6, boatMenuSize*0.7, boatMenuSize*0.7);
}

// Draws the tower
void drawTower(String type, float x, float y, Boolean dark) {
  if (type=="BEAM") {
    // Beam body
    if (!dark) {
      fill(128, 0, 255);
    } else {
      fill(64, 0, 140);
    }
    ellipse(x, y, beamSize, beamSize);
    if (!dark) {
      fill(128, 100, 255);
    } else {
      fill(64, 50, 128);
    }
    ellipse(x, y, beamSize*0.8, beamSize*0.8);

    // Beam eye
    if (!dark) {
      fill(128, 0, 255);
    } else {
      fill(64, 0, 140);
    }
    ellipse(x, y+beamSize*0.2, beamSize*0.4, beamSize*0.4);
    if (!dark) {
      fill(255);
    } else {
      fill(140);
    }
    ellipse(x, y+beamSize*0.2, beamSize/4, beamSize/4);
    fill(0);
    ellipse(x, y+beamSize*0.2, beamSize/10, beamSize/10);
  } else if (type=="BOAT") {
    // Wooden boat
    if (!dark) {
      fill(200, 160, 0);
    } else {
      fill(90, 70, 0);
    }
    ellipse(x, y, boatSize, boatSize);
    if (!dark) {
      fill(160, 130, 0);
    } else {
      fill(70, 55, 0);
    }
    ellipse(x, y, boatSize-boatSize/5, boatSize-boatSize/5);
    // Cannon nuzzle base
    if (!dark) {
      fill(80);
    } else {
      fill(40);
    }
    ellipse(x, y+boatSize/3, boatSize/4, boatSize/4);
    // Cannon nuzzle inner
    fill(0);
    ellipse(x, y+boatSize/3, boatSize/8, boatSize/8);
    // Cannon top base
    if (!dark) {
      fill(80);
    } else {
      fill(40);
    }
    ellipse(x, y+boatSize/6, boatSize/3, boatSize/3);
    // Top of cannon
    if (!dark) {
      fill(40);
    } else {
      fill(20);
    }
    ellipse(x, y+boatSize/6, boatSize/4, boatSize/4);
    // Cannon mast
    if (!dark) {
      fill(200);
    } else {
      fill(100);
    }
    rect(x, y, boatSize/4, boatSize/4);
    if (!dark) {
      fill(255);
    } else {
      fill(128);
    }
    ellipse(x, y, boatSize/4, boatSize/4);
  } else if (type=="HELI") {
    // Grass
    if (!dark) {
      fill(80, 150, 0);
    } else {
      fill(40, 75, 0);
    }
    rect(x, y, helipadSize*scaleHeli, helipadSize*scaleHeli);
    if (!dark) {
      fill(120, 220, 0);
    } else {
      fill(60, 110, 0);
    }
    rect(x, y, helipadSize*scaleHeli*0.85, helipadSize*scaleHeli*0.85);
    // Heli pad lights
    if (!dark) {
      fill(255, 255, 0);
    } else {
      fill(128, 128, 0);
    }
    ellipse(x-helipadSize*scaleHeli/3, y-helipadSize*scaleHeli/3, helipadSize*scaleHeli/10, helipadSize*scaleHeli/10);
    ellipse(x-helipadSize*scaleHeli/3, y+helipadSize*scaleHeli/3, helipadSize*scaleHeli/10, helipadSize*scaleHeli/10);
    ellipse(x+helipadSize*scaleHeli/3, y-helipadSize*scaleHeli/3, helipadSize*scaleHeli/10, helipadSize*scaleHeli/10);
    ellipse(x+helipadSize*scaleHeli/3, y+helipadSize*scaleHeli/3, helipadSize*scaleHeli/10, helipadSize*scaleHeli/10);
    if (!dark) {
      fill(255);
    } else {
      fill(128);
    }
    ellipse(x-helipadSize*scaleHeli/3, y-helipadSize*scaleHeli/3, helipadSize*scaleHeli/15, helipadSize*scaleHeli/15);
    ellipse(x-helipadSize*scaleHeli/3, y+helipadSize*scaleHeli/3, helipadSize*scaleHeli/15, helipadSize*scaleHeli/15);
    ellipse(x+helipadSize*scaleHeli/3, y-helipadSize*scaleHeli/3, helipadSize*scaleHeli/15, helipadSize*scaleHeli/15);
    ellipse(x+helipadSize*scaleHeli/3, y+helipadSize*scaleHeli/3, helipadSize*scaleHeli/15, helipadSize*scaleHeli/15);

    // Heli pad circle
    noFill();
    if (!dark) {
      stroke(255);
    } else {
      stroke(128);
    }
    strokeWeight(HEIGHT/120*scaleHeli);
    ellipse(x, y, helipadSize*scaleHeli*0.7, helipadSize*scaleHeli*0.7);
    // Heli pad "H"
    if (!dark) {
      fill(255);
    } else {
      fill(128);
    }
    noStroke();
    textAlign(CENTER, CENTER);
    textSize(HEIGHT*scaleHeli/12);
    text("H", x, y-textDescent()/2);
  } else if (type=="BOLT") {
    // Tesla
    if (!dark) {
      fill(60);
    } else {
      fill(30);
    }
    ellipse(x, y, boltSize, boltSize);
    if (!dark) {
      fill(90);
    } else {
      fill(45);
    }
    ellipse(x, y, boltSize*0.9, boltSize*0.9);

    // Tesla coils
    noFill();
    for (int i=3; i>0; i--) {
      if (!dark) {
        stroke(200, 200, 0);
      } else {
        stroke(100, 100, 0);
      }
      strokeWeight(HEIGHT/160);
      ellipse(x, y, boltSize*i/4, boltSize*i/4);
      if (!dark) {
        stroke(255, 255, 220);
      } else {
        stroke(128, 128, 110);
      }
      strokeWeight(HEIGHT/600);
      ellipse(x, y, boltSize*i/4, boltSize*i/4);
    }
    noStroke();
    if (!dark) {
      fill(180);
    } else {
      fill(90);
    }
    ellipse(x, y, boltSize/9, boltSize/9);
  }
}

// Draws the current map
void drawMap(String type) {
  // Draws base of track
  for (int i=0; i<trackDir.length; i++) {
    float wid=0;
    float hig=0;
    if (trackDir[i].equals("RIGHT") || trackDir[i].equals("LEFT")) {
      wid = abs(trackX[i+1]-trackX[i])+trackWidth;
      hig = trackWidth;
    } else if (trackDir[i].equals("UP") || trackDir[i].equals("DOWN")) {
      wid = trackWidth;
      hig = abs(trackY[i+1]-trackY[i])+trackWidth;
    }
    mapPieces.add(new MapPiece((trackX[i]+trackX[i+1])/2, (trackY[i]+trackY[i+1])/2, wid, hig, type, false));
  }
  // Draws lighter top of track
  for (int i=0; i<trackDir.length; i++) {
    float wid=0;
    float hig=0;
    if (trackDir[i].equals("RIGHT") || trackDir[i].equals("LEFT")) {
      wid = abs(trackX[i+1]-trackX[i])+trackWidth;
      hig = trackWidth;
    } else if (trackDir[i].equals("UP") || trackDir[i].equals("DOWN")) {
      wid = trackWidth;
      hig = abs(trackY[i+1]-trackY[i])+trackWidth;
    }
    mapPieces.add(new MapPiece((trackX[i]+trackX[i+1])/2, (trackY[i]+trackY[i+1])/2, wid-spacing, hig-spacing, type, true));
  }

  // Draws darker water
  for (int i=0; i<trackWater.length; i++) {
    mapPieces.add(new MapPiece(trackWater[i][0], trackWater[i][1], trackWater[i][2], trackWater[i][3], "Water", false));
  }

  // Draws lighter water on top
  for (int i=0; i<trackWater.length; i++) {
    mapPieces.add(new MapPiece(trackWater[i][0], trackWater[i][1], trackWater[i][2]-spacing, trackWater[i][3]-spacing, "Water", true));
  }
  // Draws each piece of the map
  for (MapPiece map : mapPieces) {
    map.drawMap();
  }
}

// Draws a mini preview of the track piece for the buttons of custom map creation
void drawMapDisplay(float x, Boolean track) {
  float mapSize = trackWidth*0.8; // Scales size of map piece
  if (track) {
    // Dark bit of dark
    if (customCreateTheme.equals("Dirt")) { // Dirt path
      fill(210, 140, 80);
    } else if (customCreateTheme.equals("Sand")) { // Sand path
      fill(168, 143, 89);
    } else if (customCreateTheme.equals("Road")) { // Road path
      fill(150);
    } else if (customCreateTheme.equals("Ice")) { // Ice path
      fill(199, 213, 224);
    }
    rect(x, HEIGHT*0.925, mapSize, mapSize);

    // Light bit of track
    if (customCreateTheme.equals("Dirt")) { // Dirt path
      fill(230, 160, 110);
    } else if (customCreateTheme.equals("Sand")) { // Sand path
      fill(238, 215, 153);
    } else if (customCreateTheme.equals("Road")) { // Road path
      fill(180);
    } else if (customCreateTheme.equals("Ice")) { // Ice path
      fill(219, 233, 244);
    }
    rect(x, HEIGHT*0.925, mapSize-spacing, mapSize-spacing);
  } else {
    // Dark bit of water
    fill(0, 150, 200);
    rect(x, HEIGHT*0.925, mapSize, mapSize);

    // Light bit of water
    fill(0, 200, 255);
    rect(x, HEIGHT*0.925, mapSize-spacing, mapSize-spacing);
  }
}

// Starts a new game
void newGame() {
  // Plays sound effect when new game is created, and resets everything
  newGame.play();
  stopMusic();
  if (gameTheme==1) {
    grassMusic.loop();
  } else if (gameTheme==2) {
    sandMusic.loop();
  } else if (gameTheme==3) {
    concreteMusic.loop();
  } else if (gameTheme==4) {
    iceMusic.loop();
  }
  defences = new HashSet<Defence>();
  enemies = new HashSet<Enemy>();
  projectiles = new HashSet<Projectile>();
  texts = new HashSet<TextPulse>();
  rotEffects = new HashSet<RotorEffect>();
  bolts = new HashSet<BoltEffect>();
  lives = 25;
  wave = 1;
  enemiesLeft = 0;
  enemiesToSpawn = 0;
  startWave = false;
  timer = 0;
  money = 5;
  selected = "None";
  hotBarSelect = "None";
  screen = "Game";
  // Randomizes the background effect
  darkGrassX = new ArrayList<Float>();
  darkGrassY = new ArrayList<Float>();
  grassSize = (HEIGHT/20)/WIDTH;
  for (int i=0; i<grassCount; i++) {
    darkGrassX.add(random(grassSize/2, WIDTH-grassSize/2)/WIDTH);
    darkGrassY.add(random(grassSize/2, hotBarTop-grassSize/2)/WIDTH);
  }
  lightGrassX = new ArrayList<Float>();
  lightGrassY = new ArrayList<Float>();
  for (int i=0; i<grassCount; i++) {
    lightGrassX.add(random(grassSize/2, WIDTH-grassSize/2)/WIDTH);
    lightGrassY.add(random(grassSize/2, hotBarTop-grassSize/2)/WIDTH);
  }
  chooseTower = false; 
  startFirst = false;
  selectTowerToUpgrade = false;
  upgradeTower = false;
  pause = 0;
  selectDifficulty = true;
  lag = "OFF"; // Sets the reduce lag off
  defenceInfo = new Boolean[] {false, false, false, false};
  showDefenceInfo = "NONE";
  win = false;
  bossActive = false;
  gameOver = false;
}

// Creates a blank custom map
void newCustomMap() {
  newGame.play();
  // Resets everything needed for custom map creation
  setName = false;
  createWater = false;
  startTrack = false;
  endTrack = false;
  customCreateTheme = "Dirt"; // Starts with theme of dirt
  customCreateName = "NONE"; // Sets name to none for now
  selectedMapPiece = "START";
  texts = new HashSet<TextPulse>();
  customCreateTrackX = new ArrayList<Float>();
  customCreateTrackY= new ArrayList<Float>(); 
  customCreateOffset= new ArrayList<Float>();
  customCreateTrackDir = new ArrayList<String>();
  customCreateWater = new ArrayList<float[]>();
  refreshCustomTheme();
}

// Refreshes the theme for the custom level being created
void refreshCustomTheme() {
  // Plays song appropriate to theme selected
  stopMusic();
  if (customCreateTheme.equals("Dirt")) {
    grassMusic.loop();
  } else if (customCreateTheme.equals("Sand")) {
    sandMusic.loop();
  } else if (customCreateTheme.equals("Road")) {
    concreteMusic.loop();
  } else if (customCreateTheme.equals("Ice")) {
    iceMusic.loop();
  }
  // Randomizes the background effect
  darkGrassX = new ArrayList<Float>();
  darkGrassY = new ArrayList<Float>();
  grassSize = (HEIGHT/20)/WIDTH;
  for (int i=0; i<grassCount; i++) {
    darkGrassX.add(random(grassSize/2, WIDTH-grassSize/2)/WIDTH);
    darkGrassY.add(random(grassSize/2, hotBarTop-grassSize/2)/WIDTH);
  }
  lightGrassX = new ArrayList<Float>();
  lightGrassY = new ArrayList<Float>();
  for (int i=0; i<grassCount; i++) {
    lightGrassX.add(random(grassSize/2, WIDTH-grassSize/2)/WIDTH);
    lightGrassY.add(random(grassSize/2, hotBarTop-grassSize/2)/WIDTH);
  }
}

// Checks if defence can be placed
Boolean canPlace() {
  // Touching other defences
  if (!touchDefence()) {
    return false;
  }
  // Out of bounds
  if (mouseX-selectSize/2<0 || mouseX+selectSize/2>WIDTH ||
    mouseY-selectSize/2<0 || mouseY+selectSize/2>hotBarTop) {
    return false;
  }
  // Touches map
  return touchMap();
}

// Detects if selected defence is touching another defence
Boolean touchDefence() { 
  // Returns false if touching other defences
  for (Defence defence : defences) {
    if (selected!="HELI" && defence.type!="HELI") {
      // Circle circle collision
      if (sqrt(pow(defence.x-mouseX, 2)+pow(defence.y-mouseY, 2))<(defence.size+selectSize)/2) {
        return false;
      }
    } else if (selected=="HELI" && defence.type=="HELI") {
      // Rectangle rectangle collision
      if (abs(defence.x-mouseX)<helipadSize && abs(defence.y-mouseY)<helipadSize) {
        return false;
      }
    } else {
      float circle, rect;
      if (selected!="HELI" && defence.type=="HELI") {
        circle = selectSize;
        rect = defence.size;
      } else {
        circle = defence.size;
        rect = selectSize;
      }
      // Circle rectangle collision
      float circleDistX = abs(mouseX - defence.x);
      float circleDistY = abs(mouseY - defence.y);

      if (circleDistX > (selectSize/2 + defence.size/2)) { 
        return true;
      }
      if (circleDistY > (selectSize/2 + defence.size/2)) { 
        return true;
      }

      if (circleDistX <= (rect/2)) { 
        return false;
      } 
      if (circleDistY <= (rect/2)) { 
        return false;
      }

      float cornerDistance = pow(circleDistX - helipadSize/2, 2) +
        pow(circleDistY - helipadSize/2, 2);

      if (cornerDistance <= (pow(circle/2, 2))) {
        return false;
      }
    }
  }
  return true;
}

// Detects if selected defence is touching water
Boolean touchWater() {
  // In water
  if (selected=="BOAT") {
    if (!touchDefence()) {
      return true;
    }
  }
  for (MapPiece map : mapPieces) {
    if (map.checkWater() && map.type=="Water") {
      return false; // Returns false if touching water
    }
  }
  return true;
}

// Detects if selected defence is touching map
Boolean touchMap() { 
  // Touches map
  for (MapPiece map : mapPieces) {
    if (map.check()) {
      return false; // Returns false if touching map
    }
  }
  return true;
}

void mouseReleased() {
  if (screen=="CustomCreate") {
    if (selectedMapPiece.equals("WATER") && createWater) {
      Boolean canPlace = true;
      finalCustomWater = new PVector(mouseX, mouseY);
      createWater = false;
      float wX = (finalCustomWater.x+initCustomWater.x)/2;
      float wY = (finalCustomWater.y+initCustomWater.y)/2;
      for (MapPiece map : mapPieces) {
        if (map.type!="Water") {
          if (!map.placeWater(wX, wY)) {
            canPlace = false;
          }
        }
      }

      // Cannot place if mouse is out of bounds or name is being set
      if (mouseY>hotBarTop || setName) {
        return;
      }

      // Cannot place water on track
      if (!canPlace) {
        texts.add(new TextPulse(mouseX, mouseY, "CANNOT PLACE HERE", 255, 0, 0));
        noPlace.play();
        return;
      }

      // Cannot place water if water pool is too small
      if (tempOut.w<trackWidth || tempOut.h<trackWidth) {
        texts.add(new TextPulse(mouseX, mouseY, "TOO SMALL", 255, 0, 0));
        noPlace.play();
        return;
      }
      customCreateWater.add(new float[] {wX, wY, tempOut.w, tempOut.h});
      placeBoat.play();
    }
  } else if (screen=="Game") {
    // Moves heli
    for (Defence defence : defences) {
      if (defence.type=="HELI") {
        defence.heliMove = false;
      }
    }
    Boolean canBuy;
    if (selected=="BEAM") {
      selected = "None";
      canBuy = canPlace();
      // In water or not enough money
      if (!touchWater()) {
        texts.add(new TextPulse(mouseX, mouseY, "CANNOT PLACE IN WATER", 255, 0, 0));
        noPlace.play();
        canBuy = false;
        return;
      } else if (money<5 && mouseY+beamSize/2<hotBarTop) {
        texts.add(new TextPulse(mouseX, mouseY, "NOT ENOUGH CASH", 255, 0, 0));
        noPlace.play();
        canBuy = false;
        return;
      } 

      // Else can buy tower
      if (canBuy) {
        defences.add(new Defence("BEAM", mouseX, mouseY, beamSize, "FIRST", beamRange, 1));
        placeTower.play();
        placeBeam.play();
        money-=5;
        if (defenceInfo[0]==false) {
          defenceInfo[0] = true;
          pause = 0;
          showDefenceInfo = "BEAM";
          firstBuy.play();
        }
      } else if (mouseY+beamSize/2<hotBarTop) {
        texts.add(new TextPulse(mouseX, mouseY, "CANNOT PLACE HERE", 255, 0, 0));
        noPlace.play();
      }
    } else if (selected=="BOAT") {
      selected = "None";
      canBuy = !boatCollide;
      // If touching land
      if (!touchDefence()) {
        texts.add(new TextPulse(mouseX, mouseY, "CANNOT PLACE HERE", 255, 0, 0));
        noPlace.play();
        return;
      }

      if (mouseY+boatSize/2<hotBarTop && !canBuy) {
        texts.add(new TextPulse(mouseX, mouseY, "CANNOT PLACE ON LAND", 255, 0, 0));
        noPlace.play();
        return;
      }
      // Not enough money
      if (money<25 && mouseY+boatSize/2<hotBarTop) {
        texts.add(new TextPulse(mouseX, mouseY, "NOT ENOUGH CASH", 255, 0, 0));
        noPlace.play();
        canBuy = false;
      }

      // Else can buy tower
      if (canBuy) {
        defences.add(new Defence("BOAT", mouseX, mouseY, boatSize, "FIRST", boatRange, 8));
        placeTower.play();
        placeBoat.play();
        money-=25;
        if (defenceInfo[1]==false) {
          defenceInfo[1] = true;
          pause = 0;
          showDefenceInfo = "BOAT";
          firstBuy.play();
        }
      }
    } else if (selected=="HELI") {
      selected = "None";
      canBuy = canPlace();
      // In water or not enough money
      if (!touchWater()) {
        texts.add(new TextPulse(mouseX, mouseY, "CANNOT PLACE IN WATER", 255, 0, 0));
        noPlace.play();
        canBuy = false;
        return;
      } else if (money<250 && mouseY+helipadSize/2<hotBarTop) {
        texts.add(new TextPulse(mouseX, mouseY, "NOT ENOUGH CASH", 255, 0, 0));
        noPlace.play();
        canBuy = false;
        return;
      } 

      // Else can buy tower
      if (canBuy) {
        defences.add(new Defence("HELI", mouseX, mouseY, helipadSize, "FIRST", heliRange, 50));
        placeTower.play();
        placeHeli.play();
        money-=250;
        if (defenceInfo[2]==false) {
          defenceInfo[2] = true;
          pause = 0;
          showDefenceInfo = "HELI";
          firstBuy.play();
        }
      } else if (mouseY+helipadSize/2<hotBarTop) {
        texts.add(new TextPulse(mouseX, mouseY, "CANNOT PLACE HERE", 255, 0, 0));
        noPlace.play();
      }
    } else if (selected=="BOLT") {
      selected = "None";
      canBuy = canPlace();
      // In water or not enough money
      if (!touchWater()) {
        texts.add(new TextPulse(mouseX, mouseY, "CANNOT PLACE IN WATER", 255, 0, 0));
        noPlace.play();
        canBuy = false;
        return;
      } else if (money<100 && mouseY+boltSize/2<hotBarTop) {
        texts.add(new TextPulse(mouseX, mouseY, "NOT ENOUGH CASH", 255, 0, 0));
        noPlace.play();
        canBuy = false;
        return;
      } 

      // Else can buy tower
      if (canBuy) {
        defences.add(new Defence("BOLT", mouseX, mouseY, boltSize, "FIRST", boltRange, 200));
        placeTower.play();
        placeBolt.play();
        money-=100;
        if (defenceInfo[3]==false) {
          defenceInfo[3] = true;
          pause = 0;
          showDefenceInfo = "BOLT";
          firstBuy.play();
        }
      } else if (mouseY+boltSize/2<hotBarTop) {
        texts.add(new TextPulse(mouseX, mouseY, "CANNOT PLACE HERE", 255, 0, 0));
        noPlace.play();
      }
    }
  }
}

void mouseClicked() {
  if (screen=="Menu") {
    // When play is clicked it goes to map select screen
    if (abs(mouseX-WIDTH/2)<WIDTH*0.12 && abs(mouseY-HEIGHT*0.31)<WIDTH*0.045) {
      screen = "MapSelect";
      mapDifficulty = "BEGINNER";
      select.play();
    } else if (abs(mouseX-WIDTH/20)<HEIGHT/30 && abs(mouseY-HEIGHT+WIDTH/20)<HEIGHT/30) {
      // Toggles sound
      if (volume!=0) {
        volume = 0;
      } else {
        volume = 0.5;
      }
      setMusic(volume);
      setSound(volume);
    } else if (abs(mouseX-WIDTH/2)<WIDTH*0.096 && abs(mouseY-HEIGHT*0.475)<WIDTH*0.036) {
      // Goes to custom map screen
      loadMaps();
      mapDifficulty = "CUSTOM";
      screen = "CustomSelect";
      select.play();
    } else if (abs(mouseX-WIDTH*0.945)<WIDTH*0.035 && abs(mouseY-HEIGHT+WIDTH*0.035)<WIDTH*0.015) {
      // Exits game
      exit();
    }
  } else if (screen=="MapSelect") {
    if (abs(mouseX-HEIGHT/10)<HEIGHT/30 && abs(mouseY-HEIGHT*0.9)<HEIGHT/30) {
      // Returns to menu
      screen = "Menu";
      info.play();
      // Detects if player chooses a map
    } else if (abs(mouseX-WIDTH*0.31)<WIDTH*0.16 && abs(mouseY-HEIGHT*0.35)<HEIGHT*0.16) {
      gameTheme = 1;
      selectedTrack = 1;
      newGame();
    } else if (abs(mouseX-WIDTH*0.69)<WIDTH*0.16 && abs(mouseY-HEIGHT*0.35)<HEIGHT*0.16) {
      gameTheme = 2;
      selectedTrack = 2;
      newGame();
    } else if (abs(mouseX-WIDTH*0.31)<WIDTH*0.16 && abs(mouseY-HEIGHT*0.73)<HEIGHT*0.16) {
      gameTheme = 3;
      selectedTrack = 3;
      newGame();
    } else if (abs(mouseX-WIDTH*0.69)<WIDTH*0.16 && abs(mouseY-HEIGHT*0.73)<HEIGHT*0.16) {
      gameTheme = 4;
      selectedTrack = 4;
      newGame();
    }
  } else if (screen=="CustomSelect") {
    if (abs(mouseX-HEIGHT/10)<HEIGHT/30 && abs(mouseY-HEIGHT*0.9)<HEIGHT/30) {
      // Returns to menu
      screen = "Menu";
      info.play();
      // Detects if player chooses a map
    } else if (abs(mouseX-WIDTH*0.31)<WIDTH*0.16 && abs(mouseY-HEIGHT*0.35)<HEIGHT*0.16 && customExists[0]) {
      if (customMapTheme[0].equals("Dirt")) {
        gameTheme = 1;
      } else if (customMapTheme[0].equals("Sand")) {
        gameTheme = 2;
      } else if (customMapTheme[0].equals("Road")) {
        gameTheme = 3;
      } else if (customMapTheme[0].equals("Ice")) {
        gameTheme = 4;
      }
      selectedTrack = 1;
      newGame();
    } else if (abs(mouseX-WIDTH*0.69)<WIDTH*0.16 && abs(mouseY-HEIGHT*0.35)<HEIGHT*0.16 && customExists[1]) {
      if (customMapTheme[1].equals("Dirt")) {
        gameTheme = 1;
      } else if (customMapTheme[1].equals("Sand")) {
        gameTheme = 2;
      } else if (customMapTheme[1].equals("Road")) {
        gameTheme = 3;
      } else if (customMapTheme[1].equals("Ice")) {
        gameTheme = 4;
      }
      selectedTrack = 2;
      newGame();
    } else if (abs(mouseX-WIDTH*0.31)<WIDTH*0.16 && abs(mouseY-HEIGHT*0.73)<HEIGHT*0.16 && customExists[2]) {
      if (customMapTheme[2].equals("Dirt")) {
        gameTheme = 1;
      } else if (customMapTheme[2].equals("Sand")) {
        gameTheme = 2;
      } else if (customMapTheme[2].equals("Road")) {
        gameTheme = 3;
      } else if (customMapTheme[2].equals("Ice")) {
        gameTheme = 4;
      }
      selectedTrack = 3;
      newGame();
    } else if (abs(mouseX-WIDTH*0.69)<WIDTH*0.16 && abs(mouseY-HEIGHT*0.73)<HEIGHT*0.16 && customExists[3]) {
      if (customMapTheme[3].equals("Dirt")) {
        gameTheme = 1;
      } else if (customMapTheme[3].equals("Sand")) {
        gameTheme = 2;
      } else if (customMapTheme[3].equals("Road")) {
        gameTheme = 3;
      } else if (customMapTheme[3].equals("Ice")) {
        gameTheme = 4;
      }
      selectedTrack = 4;
      newGame();
    }
  } else if (screen=="CustomCreate") {
    if (abs(mouseX-WIDTH+HEIGHT*0.24)<HEIGHT/12 && abs(mouseY-HEIGHT*0.895)<HEIGHT/52) {
      // Clears custom map
      newCustomMap();
      return;
    } else if (abs(mouseX-WIDTH+HEIGHT*0.24)<HEIGHT/12 && abs(mouseY-HEIGHT*0.955)<HEIGHT/52) {
      // Sets last theme to the theme last used
      if (customCreateTheme.equals("Dirt")) {
        lastTheme = 1;
      } else if (customCreateTheme.equals("Sand")) {
        lastTheme = 2;
      } else if (customCreateTheme.equals("Road")) {
        lastTheme = 3;
      } else if (customCreateTheme.equals("Ice")) {
        lastTheme = 4;
      }
      // Returns to menu
      screen = "Menu";
      info.play();
      stopMusic();
      menuMusic.loop();
      return;
    }
    // Adds new map piece for custom map
    Boolean canPlace = true;
    for (MapPiece map : mapPieces) {
      if (map.type.equals("Water")) {
        if (!map.placeWater(tempOut.x, tempOut.y)) {
          canPlace = false;
        }
      }
    }

    // If name is being set, or mouse out of bounds
    if (mouseY>hotBarTop || setName) {
      return;
    }

    // If intercepts with water
    if (!canPlace) {
      texts.add(new TextPulse(mouseX, mouseY, "CANNOT TOUCH WATER", 255, 0, 0));
      noPlace.play();
      return;
    }

    if (!selectedMapPiece.equals("WATER")) {
      if (endTrack && !selectedMapPiece.equals("WATER")) {
        texts.add(new TextPulse(mouseX, mouseY, "TRACK IS COMPLETE", 255, 0, 0));
        noPlace.play();
        return;
      }
      if (startTrack && selectedMapPiece.equals("START")) {
        texts.add(new TextPulse(mouseX, mouseY, "START ALREADY EXISTS", 255, 0, 0));
        noPlace.play();
        return;
      }
      if (customCreateTrackX.isEmpty()) { // There are no map pieces
        if (selectedMapPiece.equals("START")) { // Ensures first piece is a start piece
          customCreateTrackX.add(sX);
          customCreateTrackY.add(sY);
          startTrack = true;
          if (mX==0) { // Right
            customCreateOffset.add(-0.5); // Offset X
            customCreateOffset.add(0.0); // Offset Y
          } else if (mX==WIDTH) { // Left
            customCreateOffset.add(0.5); // Offset X
            customCreateOffset.add(0.0); // Offset Y
          } else if (mY==0) { // Down
            customCreateOffset.add(0.0); // Offset X
            customCreateOffset.add(-0.5); // Offset Y
          } else if (mY==hotBarTop) { // Up
            customCreateOffset.add(0.0); // Offset X
            customCreateOffset.add(0.5); // Offset Y
          } else { // If for some reason rest is false, then sets it to right
            customCreateOffset.add(-0.5); // Offset X
            customCreateOffset.add(0.0); // Offset Y
          }
        } else {
          texts.add(new TextPulse(mouseX, mouseY, "MUST BE A START PIECE", 255, 0, 0));
          noPlace.play();
          return;
        }
      }
      if (selectedMapPiece.equals("END") && startTrack) {
        // Ends track
        endTrack = true;
      }
      customCreateTrackX.add(mX);
      customCreateTrackY.add(mY);
      if (selectedMapPiece.equals("START")) {
        if (mX==0) {
          customCreateTrackDir.add("RIGHT");
        } else if (mX==WIDTH) {
          customCreateTrackDir.add("LEFT");
        } else if (mY==0) {
          customCreateTrackDir.add("DOWN");
        } else if (mY==hotBarTop) {
          customCreateTrackDir.add("UP");
        }
      } else if (mX>sX && mY==sY) {
        customCreateTrackDir.add("RIGHT");
      } else if (mX<sX && mY==sY) {
        customCreateTrackDir.add("LEFT");
      } else if (mY<sY && mX==sX) {
        customCreateTrackDir.add("UP");
      } else if (mY>sY && mX==sX) {
        customCreateTrackDir.add("DOWN");
      } else {
        // Adds direction right if for some reason these if statements are all false
        customCreateTrackDir.add("RIGHT");
      }
      placeBeam.play();
    }
  } else if (screen=="Game") {
    if (win && pause==0) { 
      if (abs(mouseX-WIDTH/2)<pausedSize/2 && abs(mouseY-HEIGHT*0.5)<HEIGHT/16) {
        // Enables freeplay if won and button clicked
        win = false;
        pause = 1;
        hintTime = 250;
        info.play();
        return;
      } else if (abs(mouseX-WIDTH/2)<pausedSize/2 && abs(mouseY-HEIGHT*0.65)<HEIGHT/16) {
        // Returns to menu if won and button clicked
        screen = "Menu";
        info.play();
        stopMusic();
        menuMusic.loop();
        return;
      }
    }

    // Return to menu when lost
    if (lives<=0) { 
      if (abs(mouseX-WIDTH/2)<pausedSize/2 && abs(mouseY-HEIGHT*0.575)<HEIGHT/16) {
        screen = "Menu";
        info.play();
        stopMusic();
        menuMusic.loop();
        return;
      }
    }

    // Stops displaying defence info
    if (showDefenceInfo!="NONE") {
      if (abs(mouseX-WIDTH*0.7)<HEIGHT/40 && abs(mouseY-HEIGHT*0.25)<HEIGHT/40) {
        showDefenceInfo = "NONE";
        pause = 1;
        info.play();
      }
    }

    // Deselects defence
    if (!win) {
      // Selects defence else deselects defence
      for (Defence defence : defences) {
        if (sqrt((pow(mouseX-defence.x, 2)+pow(mouseY-defence.y, 2)))<defence.size/2) {
          selected = "Defence";
          selectedDefence = defence;
          return;
        }
      }
      if (mouseY<hotBarTop && selected=="Defence") {
        selected = "None";
        displayStats = false;
        deselect.play();
      }
    }

    // Allows user to choose out of four difficulties, buttons detection below
    if (selectDifficulty) {
      Boolean selectDiff = true;
      if (abs(mouseX-WIDTH/4-WIDTH*0.115)<WIDTH*0.1175 && abs(mouseY-HEIGHT*0.3)<HEIGHT/16+WIDTH/400) {
        difficulty = "EASY";
      } else if (abs(mouseX-WIDTH/4-WIDTH*0.115)<WIDTH*0.1175 && abs(mouseY-HEIGHT*0.45)<HEIGHT/16+WIDTH/400) {
        difficulty = "MEDIUM";
      } else if (abs(mouseX-WIDTH/4-WIDTH*0.115)<WIDTH*0.1175 && abs(mouseY-HEIGHT*0.6)<HEIGHT/16+WIDTH/400) {
        difficulty = "HARD";
      } else if (abs(mouseX-WIDTH/4-WIDTH*0.115)<WIDTH*0.1175 && abs(mouseY-HEIGHT*0.75)<HEIGHT/16+WIDTH/400) {
        difficulty = "EXPERT";
      } else {
        selectDiff = false;
      }
      if (selectDiff) {
        selectDifficulty = false;
        pause = 1;
        select.play();
      }
    } else if (pause==1) {
      // Restarts game
      if (abs(mouseX-WIDTH+HEIGHT*0.165)<HEIGHT/52 && abs(mouseY-HEIGHT*0.895)<HEIGHT/52) {
        newGame();
        texts.add(new TextPulse(WIDTH-HEIGHT*0.165, HEIGHT*0.82, "NEW GAME", 255, 255, 220));
      } else if (lives>0) { // Shows information about tower
        if (abs(mouseX-HEIGHT*0.175-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20 && selected!="Defence") {
          hotBarSelect = "BEAM";
        } else if (abs(mouseX-HEIGHT*0.325-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20 && selected!="Defence") {
          hotBarSelect = "BOAT";
        } else if (abs(mouseX-HEIGHT*0.475-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20 && selected!="Defence") {
          hotBarSelect = "HELI";
        } else if (abs(mouseX-HEIGHT*0.625-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20 && selected!="Defence") {
          hotBarSelect = "BOLT";
        } else if (selected=="Defence") {
          if (abs(mouseX-WIDTH/2-HEIGHT/5-barSize-targetOffset)<targetOffset*0.375 && abs(mouseY-HEIGHT*0.955)<HEIGHT/50) {
            // Sells defence
            sell.play();
            money+=selectedDefence.sell;
            texts.add(new TextPulse(WIDTH/2+HEIGHT/5+barSize+targetOffset, HEIGHT*0.82, "SOLD " + selectedDefence.type + " +$" + selectedDefence.sell, 255, 255, 220));
            defences.remove(selectedDefence);
            selected = "None";
          }

          // Upgrades defence if possible
          Boolean upgraded = true;
          if (abs(mouseX-HEIGHT/2-targetOffset*1.25)<targetOffset/4 && abs(mouseY-HEIGHT*0.925)<HEIGHT*0.045) { 
            // Upgrade path 1 which is range or heli speed
            if (money>=selectedDefence.cost1 && selectedDefence.upgrade1<7) {
              money-=selectedDefence.cost1;
              selectedDefence.totalCost+=selectedDefence.cost1;
              selectedDefence.upgrade1++;
              if (selectedDefence.type=="HELI") {
                texts.add(new TextPulse(HEIGHT/2+targetOffset*1.25, HEIGHT*0.82, "+1 MOVE", 255, 255, 220));
              } else {
                texts.add(new TextPulse(HEIGHT/2+targetOffset*1.25, HEIGHT*0.82, "+20% RANGE", 255, 255, 220));
              }
            } else {
              upgraded = false;
            }
          } else if (abs(mouseX-HEIGHT/2-targetOffset*1.85)<targetOffset/4 && abs(mouseY-HEIGHT*0.925)<HEIGHT*0.045) { 
            // Upgrade path 2 which is attack speed
            if (money>=selectedDefence.cost2 && selectedDefence.upgrade2<8) {
              money-=selectedDefence.cost2;
              selectedDefence.totalCost+=selectedDefence.cost2;
              selectedDefence.upgrade2++;
              texts.add(new TextPulse(HEIGHT/2+targetOffset*1.85, HEIGHT*0.82, "+50% SPEED", 255, 255, 220));
            } else {
              upgraded = false;
            }
          } else if (abs(mouseX-HEIGHT/2-targetOffset*2.45)<targetOffset/4 && abs(mouseY-HEIGHT*0.925)<HEIGHT*0.045) { 
            // Upgrade path 3 which is damage
            if (money>=selectedDefence.cost3 && selectedDefence.upgrade3<8) {
              money-=selectedDefence.cost3;
              selectedDefence.totalCost+=selectedDefence.cost3;
              int damageIncrease = (int) (selectedDefence.upgrade3*1.4);
              if (selectedDefence.type=="HELI") {
                damageIncrease = 25;
              } else if (selectedDefence.type=="BOAT") {
                damageIncrease = 4;
              } else if (selectedDefence.type=="BOLT") {
                damageIncrease = damageIncrease*10;
              }
              selectedDefence.damage += damageIncrease;
              texts.add(new TextPulse(HEIGHT/2+targetOffset*2.45, HEIGHT*0.82, "+" + damageIncrease + " DAMAGE", 255, 255, 220));
              selectedDefence.upgrade3++;
            } else {
              upgraded = false;
            }
          } else if (abs(mouseX-HEIGHT/2-targetOffset*3.05)<targetOffset/4 && abs(mouseY-HEIGHT*0.925)<HEIGHT*0.045) { 
            // Upgrade path 4 which is pierce or bolt chain
            if (money>=selectedDefence.cost4 && selectedDefence.upgrade4<5) {
              money-=selectedDefence.cost4;
              selectedDefence.totalCost+=selectedDefence.cost4;
              int pierceIncrease = (int) ((selectedDefence.upgrade4*1.5)/2)+1;
              if (selectedDefence.type=="HELI") {
                pierceIncrease += (int) (pierceIncrease/3);
              } else if (selectedDefence.type=="BOAT") {
                pierceIncrease = 1;
              }
              selectedDefence.pierce += pierceIncrease;
              if (selectedDefence.type=="BOLT") {
                texts.add(new TextPulse(HEIGHT/2+targetOffset*3.05, HEIGHT*0.82, "+" + pierceIncrease + " CHAIN", 255, 255, 220));
              } else {
                texts.add(new TextPulse(HEIGHT/2+targetOffset*3.05, HEIGHT*0.82, "+" + pierceIncrease + " PIERCE", 255, 255, 220));
              }
              selectedDefence.upgrade4++;
            } else {
              upgraded = false;
            }
          } else {
            upgraded = false;
          }
          if (upgraded) {
            if (selectedDefence.level==24) {
              maxTower.play();
            } else {
              upgrade.stop();
              upgrade.play();
            }
          }
        }
      }
    } else if (pause==0 && !win && lives>0 && showDefenceInfo=="NONE") { // Returns to menu when in game
      if (abs(mouseX-WIDTH/2)<pausedSize/2 && abs(mouseY-HEIGHT*0.7)<HEIGHT/16) {
        info.play();
        screen = "Menu";
        stopMusic();
        menuMusic.loop();
      }
    }
  }
}

void mousePressed() {
  if (screen=="MapSelect") {
    if (abs(mouseX-WIDTH*0.09)<HEIGHT*0.055 && abs(mouseY-HEIGHT*0.54)<HEIGHT*0.13) {
      // Left arrow
      if (mapDifficulty=="EXTREME") {
        mapDifficulty = "ADVANCED";
        select.play();
      } else if (mapDifficulty=="ADVANCED") {
        mapDifficulty = "INTERMEDIATE";
        select.play();
      } else if (mapDifficulty=="INTERMEDIATE") {
        mapDifficulty = "BEGINNER";
        select.play();
      } else {
        info.play();
      }
    } else if (abs(mouseX-WIDTH*0.91)<HEIGHT*0.055 && abs(mouseY-HEIGHT*0.54)<HEIGHT*0.13) {
      // Right arrow
      if (mapDifficulty=="BEGINNER") {
        mapDifficulty = "INTERMEDIATE";
        select.play();
      } else if (mapDifficulty=="INTERMEDIATE") {
        mapDifficulty = "ADVANCED";
        select.play();
      } else if (mapDifficulty=="ADVANCED") {
        mapDifficulty = "EXTREME";
        select.play();
      } else {
        info.play();
      }
    }
  } else if (screen=="CustomSelect") {
    if (abs(mouseX-WIDTH*0.09)<HEIGHT*0.055 && abs(mouseY-HEIGHT*0.54)<HEIGHT*0.13) {
      // Left arrow
      if (currentCustomPage>0) {
        currentCustomPage--;
        select.play();
      } else {
        info.play();
      }
    } else if (abs(mouseX-WIDTH*0.91)<HEIGHT*0.055 && abs(mouseY-HEIGHT*0.54)<HEIGHT*0.13) {
      // Right arrow
      if (currentCustomPage<customPages) {
        currentCustomPage++;
        select.play();
      } else {
        info.play();
      }
    } else if (abs(mouseX-WIDTH*0.992+HEIGHT/10)<WIDTH/36 && abs(mouseY-HEIGHT*0.9)<HEIGHT/30) {
      // Goes to custom map creation screen
      screen = "CustomCreate";
      newCustomMap();
    }
  } else if (screen=="CustomCreate") {
    if (!setName) {
      // Selects map piece in hotbar when mouse is clicked down on it
      if (abs(mouseX-HEIGHT*0.175-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20) {
        selectedMapPiece = "START";
        return;
      } else if (abs(mouseX-HEIGHT*0.325-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20) {
        selectedMapPiece = "TRACK";
        return;
      } else if (abs(mouseX-HEIGHT*0.475-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20) {
        selectedMapPiece = "END";
        return;
      } else if (abs(mouseX-HEIGHT*0.625-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20) {
        selectedMapPiece = "WATER";
        return;
      } else if (abs(mouseX-HEIGHT*0.775-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20) {
        customCreateTheme = "Dirt";
        refreshCustomTheme();
        return;
      } else if (abs(mouseX-HEIGHT*0.925-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20) {
        customCreateTheme = "Sand";
        refreshCustomTheme();
        return;
      } else if (abs(mouseX-HEIGHT*1.075-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20) {
        customCreateTheme = "Road";
        refreshCustomTheme();
        return;
      } else if (abs(mouseX-HEIGHT*1.225-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20) {
        customCreateTheme = "Ice";
        refreshCustomTheme();
        return;
      } else if (abs(mouseX-WIDTH+HEIGHT*0.075)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20 && endTrack) {
        selectedMapPiece = "NONE";
        setName = true;
        typeName.reset();
        victory.play();
        return;
      } else if (mouseY<hotBarTop && selectedMapPiece.equals("WATER")) {
        initCustomWater = new PVector(mouseX, mouseY);
        createWater = true;
      }
    } else if (abs(mouseX-WIDTH/2)<WIDTH/6 && abs(mouseY-HEIGHT*0.63)<HEIGHT/16) {
      if (typeName.numChars>0) {
        maxTower.play();
        customCreateName = typeName.readString();
        saveMap();
      } else {
        textSize(HEIGHT/20);
        texts.add(new TextPulse(WIDTH/2, HEIGHT/2+textDescent(), "NEEDS A NAME", 255, 0, 0));
        noPlace.play();
      }
    }
  } else if (screen=="Game") {
    if (lives>0 && showDefenceInfo=="NONE" && !win && !selectDifficulty) {
      if (pause==0) { // If paused
        if (abs(mouseX-WIDTH/2)<pausedSize/2 && abs(mouseY-HEIGHT*0.55)<HEIGHT/16) {
          info.play();
          if (lag=="OFF") {
            lag = "SOME";
          } else if (lag=="SOME") {
            lag = "ALL";
          } else if (lag=="ALL") {
            lag = "OFF";
          }
        } else if (abs(mouseX-WIDTH/2)<pausedSize/2 && abs(mouseY-HEIGHT*0.4)<HEIGHT/16) {
          info.play();
          pause = 1;
        } else if (abs(mouseX-WIDTH/2)<HEIGHT/30 && abs(mouseY-HEIGHT*0.8)<HEIGHT/30) {
          // Toggles sound
          if (volume!=0) {
            volume = 0;
          } else {
            volume = 0.5;
          }
          setMusic(volume);
          setSound(volume);
        }
      }
      if (pause==1) { // If unpaused
        if (selected=="Defence") {
          if (abs(mouseX-HEIGHT*0.175-barSize/2-targetOffset/2)<targetOffset/2 && abs(mouseY-HEIGHT*0.945)<HEIGHT/50) {
            info.play();
            if (selectedDefence.type=="HELI") {
              if (selectedDefence.heliMovement=="MOUSE") {
                selectedDefence.heliMovement="LOCK";
              } else if (selectedDefence.heliMovement=="LOCK") {
                selectedDefence.heliMovement="AUTO";
              } else if (selectedDefence.heliMovement=="AUTO") {
                selectedDefence.heliMovement="MOUSE";
              }
            } else {
              if (selectedDefence.target=="FIRST") {
                selectedDefence.target="LAST";
              } else if (selectedDefence.target=="LAST") {
                selectedDefence.target="CLOSE";
              } else if (selectedDefence.target=="CLOSE") {
                selectedDefence.target="STRONG";
              } else if (selectedDefence.target=="STRONG") {
                selectedDefence.target="FIRST";
              }
            }
          } else if (abs(mouseX-WIDTH/2-HEIGHT/5-barSize-targetOffset)<targetOffset*0.375 && abs(mouseY-HEIGHT*0.895)<HEIGHT/50) {
            selected = "None";
            deselect.play();
          }
        }
        // Selects defence
        for (Defence defence : defences) {
          if (sqrt((pow(mouseX-defence.x, 2)+pow(mouseY-defence.y, 2)))<defence.size/2) {
            selected = "Defence";
            selectedDefence = defence;
            select.play();
            return;
          }
        }
        // Moves heli
        for (Defence defence : defences) {
          if (defence.type=="HELI" && defence.heliMovement=="MOUSE" && mouseY<hotBarTop) {
            defence.heliMove = true;
          }
        }
        // Shows info of tower for purchase in hotbar when clicked or dragged
        if (abs(mouseX-HEIGHT*0.175-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20 && selected!="Defence") {
          selected = "BEAM";
          selectedCost = 5;
          return;
        } else if (abs(mouseX-HEIGHT*0.325-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20 && selected!="Defence") {
          selected = "BOAT";
          selectedCost = 25;
          return;
        } else if (abs(mouseX-HEIGHT*0.475-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20 && selected!="Defence") {
          selected = "HELI";
          selectedCost = 250;
          return;
        } else if (abs(mouseX-HEIGHT*0.625-barSize)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20 && selected!="Defence") {
          selected = "BOLT";
          selectedCost = 100;
          return;
        } else if (hotBarSelect!="None") {
          hotBarSelect = "None";
        }
      }

      // Start round button/change speed
      if (abs(mouseX-WIDTH+HEIGHT*0.075)<HEIGHT/20 && abs(mouseY-HEIGHT*0.925)<HEIGHT/20 && pause==1 && chooseTower) {
        info.play();
        // Toggles round speed and starts round
        if (!startWave) {
          startWave = true;
        } else if (trueSpeed==1) {
          trueSpeed=2;
          timer=timer/2;
        } else if (trueSpeed==2 && !autoStart) {
          autoStart = true;
          texts.add(new TextPulse(WIDTH-HEIGHT*0.075, HEIGHT*0.82, "AUTO", 255, 255, 220));
        } else if (autoStart) {
          autoStart = false;
          trueSpeed=1;
          timer=timer*2;
        }
      } else if (abs(mouseX-WIDTH+HEIGHT*0.165)<HEIGHT/52 && abs(mouseY-HEIGHT*0.955)<HEIGHT/52 && !selectDifficulty && pause==1) {
        // Pauses game
        info.play();
        pause = 0;
      }
    }

    // Tower stats button
    if (abs(mouseX-HEIGHT*0.165)<HEIGHT/52 && abs(mouseY-HEIGHT*0.8875)<HEIGHT/52 && pause==1) {
      // Toggles displaying tower stats
      displayStats = !displayStats;
      info.play();
    }
  }
}

// Stops music being played
void stopMusic() {
  // Stops all music
  menuMusic.stop();
  grassMusic.stop();
  sandMusic.stop();
  concreteMusic.stop();
  iceMusic.stop();
  bossMusic.stop();
}

// Sets the sound effect volume
void setSound(float volume) {
  // Adjusts the volume for the sound effects so they are balanced with other audio
  enemyDie.amp(volume);
  placeBoat.amp(volume);
  placeHeli.amp(volume);
  placeBolt.amp(volume);
  placeTower.amp(volume);
  firstBuy.amp(volume);
  upgrade.amp(volume);
  gameOverSound.amp(volume);
  lifeLost.amp(volume/3);
  maxTower.amp(volume*2);
  victory.amp(volume*2);
  newGame.amp(volume*2);
  placeBeam.amp(volume*2);
  deselect.amp(volume*2);
  noPlace.amp(volume*2);
  sell.amp(volume*2);
  select.amp(volume*2);
  waveOver.amp(volume*2);
  info.amp(volume*2);
}

// Sets the music volume
void setMusic(float volume) {
  // Adjusts the volume of the background music so they are roughly of equal volume
  menuMusic.amp(volume);
  grassMusic.amp(volume);
  sandMusic.amp(volume);
  concreteMusic.amp(volume*2);
  iceMusic.amp(volume*2);
  bossMusic.amp(volume);
}

// Loads custom maps
void loadMaps() { 
  int i=0;
  customMaps = 0;
  while (dataFile("map"+i+".txt").isFile()) { // Gets amount of maps
    i++;
  }
  customMapNames = new String[i];
  customMapThemes = new String[i];
  customOffset = new float[i][];
  customTrackX = new float[i][];
  customTrackY = new float[i][];
  customTrackDir = new String[i][];
  customTrackWater = new float[i][][];
  i=0;
  while (dataFile("map"+i+".txt").isFile()) { // If a custom map exists for i
    String[] lines = loadStrings("data/map"+i+".txt"); // Turns it into an array of lines
    for (String line : lines) {
      Scanner sc = new Scanner(line);
      String token = sc.next();
      if (token.equals("Name")) {
        customMapNames[i] = sc.next(); // Sets custom map name
      } else if (token.equals("Theme")) {
        customMapThemes[i] = sc.next();
      } else if (token.equals("Offset")) {
        customOffset[i] = new float[] {sc.nextFloat(), sc.nextFloat()};
      } else if (token.equals("TrackX")) {
        ArrayList<Float> customStoreX = new ArrayList<Float>();
        while (sc.hasNextFloat()) {
          customStoreX.add(sc.nextFloat()); // Adds track x floats to an arraylist
        }
        float[] customX = new float[customStoreX.size()]; // Turns arraylist into a float array
        for (int x=0; x<customStoreX.size(); x++) {
          customX[x] = customStoreX.get(x);
        }
        customTrackX[i] = new float[customX.length];
        arrayCopy(customX, customTrackX[i]); // Stores the custom track x information
      } else if (token.equals("TrackY")) {
        ArrayList<Float> customStoreY = new ArrayList<Float>();
        while (sc.hasNextFloat()) {
          customStoreY.add(sc.nextFloat()); // Adds track y floats to an arraylist
        }
        float[] customY = new float[customStoreY.size()]; // Turns arraylist into a float array
        for (int y=0; y<customStoreY.size(); y++) {
          customY[y] = customStoreY.get(y);
        }
        customTrackY[i] = new float[customY.length];
        arrayCopy(customY, customTrackY[i]); // Stores the custom track y information
      } else if (token.equals("TrackDir")) {
        ArrayList<String> customStoreDir = new ArrayList<String>();
        while (sc.hasNext()) {
          customStoreDir.add(sc.next()); // Adds track directions to an arraylist
        }
        String[] customDir = new String[customStoreDir.size()]; // Turns arraylist into a string array
        for (int dir=0; dir<customStoreDir.size(); dir++) {
          customDir[dir] = customStoreDir.get(dir);
        }
        customTrackDir[i] = new String[customDir.length];
        arrayCopy(customDir, customTrackDir[i]); // Stores the custom track direction information
      } else if (token.equals("TrackWater")) {
        if (sc.hasNext("NONE")) {
          customTrackWater[i] = new float[0][0]; // For converting back to float[][]
        } else {
          int water = 0; // Number of water pools
          ArrayList<ArrayList<Float>> customWater = new ArrayList<ArrayList<Float>>(); // Holds water pools
          String status = "Next"; // Whether there are more water pools to be loaded in 
          while (!status.equals("End")) {
            customWater.add(new ArrayList<Float>());
            for (int y=0; y<4; y++) { // Adds x, y, width, height to arraylist
              customWater.get(water).add(sc.nextFloat());
            }
            water++;
            if (sc.hasNext("End")) {
              status = "End";
            }
          }
          float[][] customWaterPools = new float[water][4]; // For converting back to float[][]
          for (int w=0; w<customWater.size(); w++) { // Gets water pools and turns them into a float[][]
            for (int p=0; p<4; p++) {
              customWaterPools[w][p] = customWater.get(w).get(p);
            }
          }
          customTrackWater[i] = new float[customWaterPools.length][4];
          arrayCopy(customWaterPools, customTrackWater[i]); // Stores the custom track water information
        }
      }
      sc.close();
    }
    customMaps++;
    i++;
  }
  customPages = (int) ((customMaps-1)/4);
}

// Saves custom map which has just been created
void saveMap() {
  // Saves map to a file
  int i=0;
  while (dataFile("map"+i+".txt").isFile()) { // Finds next available file
    i++;
  }
  output = createWriter("data/map"+ i+".txt"); // Creates map file

  // Prints map data
  output.println("Name " + customCreateName);
  output.println("Theme " + customCreateTheme);
  output.println("Offset " + customCreateOffset.get(0) + " " + customCreateOffset.get(1));
  output.print("TrackX");
  for (int x=0; x<customCreateTrackX.size(); x++) {
    output.print(" " + customCreateTrackX.get(x));
  }
  output.print("\nTrackY");
  for (int y=0; y<customCreateTrackY.size(); y++) {
    output.print(" " + customCreateTrackY.get(y));
  }
  output.print("\nTrackDir");
  for (int d=0; d<customCreateTrackDir.size(); d++) {
    output.print(" " + customCreateTrackDir.get(d));
  }

  output.print("\nTrackWater");
  if (customCreateWater.isEmpty()) {
    output.print(" NONE");
  }
  for (int W=0; W<customCreateWater.size(); W++) {
    for (int w=0; w<customCreateWater.get(W).length; w++) {
      output.print(" " + customCreateWater.get(W)[w]);
    }
  }
  output.print(" End");

  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file

  // Sets last theme to the theme last used
  if (customCreateTheme.equals("Dirt")) {
    lastTheme = 1;
  } else if (customCreateTheme.equals("Sand")) {
    lastTheme = 2;
  } else if (customCreateTheme.equals("Road")) {
    lastTheme = 3;
  } else if (customCreateTheme.equals("Ice")) {
    lastTheme = 4;
  }

  // Returns to menu
  screen = "Menu";
  stopMusic();
  menuMusic.loop();
}

void keyPressed() {
  if (key == ESC) {
    key = 0;  // Prevents esc from quitting game
  }

  if (setName) { // If name for custom map is ready to be typed
    // Needs to either be a letter or a number
    if (typeName.keyAnalyzer(key).compareTo("LETTER") == 0 || typeName.keyAnalyzer(key).compareTo("NUMBER") == 0) {
      textSize(typeName.font);
      if (textWidth(typeName.readString() + key) < WIDTH/3-HEIGHT/40) {
        typeName.addChar(key);
      }
    }

    // Removes character when backspace is pressed
    if (keyCode == BACKSPACE) {
      typeName.deleteChar();
    }
  }
}
