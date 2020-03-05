//constants
static final float ACCEL     = 0.2;
static final float DEACCEL   = 0.2;
static final float GRAVITY   = 0.15;
static final float MAX_SPEED = 3.0;

static final int TILE_WIDTH    = 16;
static final int TILE_HEIGHT   = 16;
static final int PLAYER_WIDTH  = 15;
static final int PLAYER_HEIGHT = 15;

static final int LEVEL_WIDTH  = 32;
static final int LEVEL_HEIGHT = 32;

enum TILE_TYPE { EMPTY, SOLID, SLOPE_LEFT, SLOPE_RIGHT };

//classes
//box
class Box
{
  PVector pos;
  PVector dim;
  int     col;
  
  Box(float x, float y, float w, float h) { pos = new PVector(x, y); dim = new PVector(w, h); col = 0xFFFFFF; }
  
  void render()
  {
    fill((col >> 16) & 0xFF, (col >> 8) & 0xFF, (col >> 0) & 0xFF);
    rect(pos.x, pos.y, dim.x, dim.y);
  }
}

//player
class Player extends Box
{
  PVector mov;
  boolean on_ground;
  boolean check_ground;
  
  float   scale_x;
  
  int     frame;
  int     sub_frame;
  
  Player(float x, float y, float w, float h) 
  { 
    super(x, y, w, h); 
    mov          = new PVector(0, 0); 
    on_ground    = false; 
    check_ground = false; 
    
    frame     = 0;
    sub_frame = 0;
  }
  
  void render()
  {
    if     (mov.x < 0) { scale_x = -1; }
    else if(mov.x > 0) { scale_x =  1; }
    
    if(scale_x < 0)
    {
      pushMatrix();
      translate(pos.x + dim.x, pos.y);
      scale(-1.0, 1.0);
      image(player_sprite_sheet[frame], 0, 0, dim.x, dim.y);
      popMatrix();
    }
    else
    {
      image(player_sprite_sheet[frame], pos.x, pos.y, dim.x, dim.y);
    }
  }
  
  void animation()
  {
    if(on_ground && mov.x == 0) { frame = 0; }
    if(!on_ground)              { frame = mov.y < 0 ? 2 : 3; }
    if(on_ground && mov.x != 0) { sub_frame = (sub_frame + 1) % 2; if(sub_frame == 0) { if(frame == 0) { frame = 1; } else { frame = 0; } } }
  }
}

//tile
class Tile extends Box
{
  TILE_TYPE  type;
  Tile(float x, float y, float w, float h, TILE_TYPE t) { super(x, y, w, h); type = t; }
  
  void render() //override
  {
    if(type == TILE_TYPE.SOLID)
    {
      fill((col >> 16) & 0xFF, (col >> 8) & 0xFF, (col >> 0) & 0xFF);
      rect(pos.x, pos.y, dim.x, dim.y);
    } else if(type == TILE_TYPE.SLOPE_LEFT)
    {
      fill((col >> 16) & 0xFF, (col >> 8) & 0xFF, (col >> 0) & 0xFF);
      triangle(pos.x,         pos.y + dim.y, 
               pos.x + dim.x, pos.y + dim.y, 
               pos.x + dim.x, pos.y);
    } else if(type == TILE_TYPE.SLOPE_RIGHT)
    {
      fill((col >> 16) & 0xFF, (col >> 8) & 0xFF, (col >> 0) & 0xFF);
      triangle(pos.x,         pos.y + dim.y, 
               pos.x + dim.x, pos.y + dim.y, 
               pos.x,         pos.y);
    }
  }
};


//instances
PImage player_sprite_sheet[] = new PImage[4];
PImage background = new PImage();
Player player     = new Player(200, 200, PLAYER_WIDTH, PLAYER_HEIGHT);
Tile    level[][] = new Tile[LEVEL_HEIGHT][LEVEL_WIDTH];

int level_tiles[][] =
{
  { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 1, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 1, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 1, 3, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 0, 1, 1, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1 },
  { 1, 0, 1, 1, 1, 1, 0, 0, 0, 2, 1, 1, 1, 1, 1, 3, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
  { 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 3, 0, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 1, 3, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
  { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
};

//init
void setup() 
{ 
  size(512, 512);
  
  frameRate(60);
  stroke(0xFF, 0xFF, 0xFF, 0x00);
  
  player_sprite_sheet[0] = loadImage("idle.png");
  player_sprite_sheet[1] = loadImage("runn.png");
  player_sprite_sheet[2] = loadImage("jmup.png");
  player_sprite_sheet[3] = loadImage("jmdw.png");
    
  background = loadImage("map.png");
  //initialize level
  for(int i = 0; i < 32; i++)
  {
    for(int j = 0; j < 32; j++)
    {
      level[i][j] = new Tile(j * TILE_WIDTH, i * TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT, TILE_TYPE.values()[level_tiles[i][j]]);
    }
  }
}

//utility
//axis aligned bounding box collision
//side_mask is 4-bit value for ignoring left/right/up/down side of static box
void AABB(Player nstat, Box stat, char side_mask)
{
  float dx = (stat.pos.x + stat.dim.x / 2) - (nstat.pos.x + nstat.dim.x / 2);
  float dy = (stat.pos.y + stat.dim.y / 2) - (nstat.pos.y + nstat.dim.y / 2);
  
  if(dx == 0.0 && dy == 0.0) return; //<- bullshit
  
  
  //collision detection
  if(abs(dx) < nstat.dim.x / 2 + stat.dim.x / 2 &&
     abs(dy) < nstat.dim.y / 2 + stat.dim.y / 2)
  {
    //choose which axis to process
    if(abs(dx) > abs(dy))
    {
      //process x axis
      if(dx > 0 && boolean(side_mask & 0x01)) { return; } //ignore left side
      if(dx < 0 && boolean(side_mask & 0x02)) { return; } //ignore right side
      
      if(dx > 0 && nstat.mov.x < 0) { return; } //ignore left side if going left   --\
      if(dx < 0 && nstat.mov.x > 0) { return; } //ignore right side if going right --/ solves clipping problem, but can cause bug where player can be momentarly inside a tile
      
      //set non static box position
      nstat.pos.x = stat.pos.x;
      if(dx > 0) { nstat.pos.x -= nstat.dim.x; }
      else       { nstat.pos.x += stat.dim.x;  }
      
      //reset movement
      nstat.mov.x = 0;
    }
    else
    {
      //process y axis
      if(dy > 0 && boolean(side_mask & 0x04)) { return; } //ignore top side
      if(dy < 0 && boolean(side_mask & 0x08)) { return; } //ignore bottom side
      
      if(dy > 0 && nstat.mov.y < 0) { return; } //ignore top side if going up      --\
      if(dy < 0 && nstat.mov.y > 0) { return; } //ignore bottom side if going down --/ solves clipping problem, but can cause bug where player can be momentarly inside a tile
      
      //set non static box position
      nstat.pos.y = stat.pos.y;
      if(dy > 0) { nstat.pos.y -= nstat.dim.y; }
      else       { nstat.pos.y += stat.dim.y;  }

      //reset movement
      nstat.mov.y = 0;
      
      //set on ground flags
      if(dy > 0) { nstat.on_ground = true; nstat.check_ground = true; }
    }
  }
}

//chech if tile coordinates are within map bounds
boolean within_bounds(int x, int y)
{
  return(x >= 0 && x < LEVEL_WIDTH && y >= 0 && y < LEVEL_HEIGHT);
}

//update
void draw()
{
  player.mov.y += GRAVITY;
  
  
  //reset cheking ground flag
  player.check_ground = false;
  
  
  //input handling
  
  //horizontal movement
  if(keyDown('a')) { player.mov.x -= ACCEL; }     if(player.mov.x < -MAX_SPEED) { player.mov.x = -MAX_SPEED; }
  if(keyDown('d')) { player.mov.x += ACCEL; }     if(player.mov.x >  MAX_SPEED) { player.mov.x =  MAX_SPEED; }
  
  //jump
  if(keyDown('w') && player.on_ground) { player.mov.y = -5; player.on_ground = false; }
  if(!keyDown('w'))
  {
    if(player.mov.y < 0) { player.mov.y = player.mov.y * 0.8; }
  }
  
  //slowing down
  if((!keyDown('a') && !keyDown('d')) || (keyDown('a') && keyDown('d')))
  {
    if(abs(player.mov.x) < ACCEL) 
    {
      player.mov.x = 0;
    }
    else
    {
      if(player.on_ground) { player.mov.x -= DEACCEL * (player.mov.x / abs(player.mov.x)); }
    }
  }
  
  //update player position
  player.pos.x += player.mov.x;
  player.pos.y += player.mov.y;
  
  //get player's tile coordinate
  int player_tile_x = (int)(player.pos.x + player.dim.x / 2) / TILE_WIDTH;
  int player_tile_y = (int)(player.pos.y + player.dim.y / 2) / TILE_HEIGHT;
  
  int foot_tile_y       = (int)(player.pos.y + player.dim.y - player.dim.y / 2) / TILE_WIDTH;
  int under_foot_tile_y = (int)(player.pos.y + player.dim.y + 1)                / TILE_HEIGHT;
  
  //if player is within map
  if(within_bounds(player_tile_x, player_tile_y))
  { 
    //handle slopes
    //slope with side diagonal
    if(within_bounds(player_tile_x, under_foot_tile_y) &&
       (level[foot_tile_y      ][player_tile_x].type == TILE_TYPE.SLOPE_LEFT || 
        level[under_foot_tile_y][player_tile_x].type == TILE_TYPE.SLOPE_LEFT))
    {
      //choose which slope to check
      //this solves slope sticking when player was on normal ground
      Box slope;
      if(level[under_foot_tile_y][player_tile_x].type == TILE_TYPE.SLOPE_LEFT)
      {
        slope = level[under_foot_tile_y][player_tile_x];
      }
      else
      {
        slope = level[foot_tile_y][player_tile_x];
      }
      
      //check if we hit the slope
      float dx = (player.pos.x + player.dim.x / 2) - slope.pos.x;
      float dy = (player.pos.y + player.dim.y)     - slope.pos.y;

      if(dx + dy >= TILE_WIDTH || player.on_ground)
      {
        player.pos.y = (slope.pos.y + TILE_WIDTH - dx) - player.dim.y;
        player.mov.y = player.mov.x < 0 ? -player.mov.x : 0;
        
        player.on_ground    = true;
        player.check_ground = true;
      }
    }
    
    //slope with main diagonal
    else if(within_bounds(player_tile_x, under_foot_tile_y) &&
       (level[foot_tile_y      ][player_tile_x].type == TILE_TYPE.SLOPE_RIGHT || 
        level[under_foot_tile_y][player_tile_x].type == TILE_TYPE.SLOPE_RIGHT))
    {
      //choose which slope to check
      //this solves slope sticking after walking on normal ground
      Box slope;
      if(level[under_foot_tile_y][player_tile_x].type == TILE_TYPE.SLOPE_RIGHT)
      {
        slope = level[under_foot_tile_y][player_tile_x];
      }
      else
      {
        slope = level[foot_tile_y][player_tile_x];
      }
      
      //check if we hit the slope
      float dx = (player.pos.x + player.dim.x / 2) - slope.pos.x;
      float dy = (player.pos.y + player.dim.y)     - slope.pos.y;

      if(dx <= dy || player.on_ground)
      {
        player.pos.y = (slope.pos.y + dx) - player.dim.y;
        player.mov.y = player.mov.x > 0 ? player.mov.x : 0;
        
        player.on_ground    = true;
        player.check_ground = true;
      }
    }
    //handle box collision
    else
    {
      //check 3x3 matrix of blocks around the player
      //player can only touch these blocks
      for(int i = -1; i <= 1; i++)
      {
        for(int j = -1; j <= 1; j++)
        {
          if(within_bounds(player_tile_x + j, player_tile_y + i))
          {
            if(level[player_tile_y + i][player_tile_x + j].type == TILE_TYPE.SOLID)
            {
              //check adjacent blocks, so we know which sides to ignore
              //solves player studdering when walking on the ground and wall clip
              char side_mask = 0x00;
              
              if(within_bounds(player_tile_x + j - 1, player_tile_y + i)) { if(level[player_tile_y + i][player_tile_x + j - 1].type == TILE_TYPE.SOLID) { side_mask |= 0x01; } }
              if(within_bounds(player_tile_x + j + 1, player_tile_y + i)) { if(level[player_tile_y + i][player_tile_x + j + 1].type == TILE_TYPE.SOLID) { side_mask |= 0x02; } }
              if(within_bounds(player_tile_x + j, player_tile_y + i - 1)) { if(level[player_tile_y + i - 1][player_tile_x + j].type == TILE_TYPE.SOLID) { side_mask |= 0x04; } }
              if(within_bounds(player_tile_x + j, player_tile_y + i + 1)) { if(level[player_tile_y + i + 1][player_tile_x + j].type == TILE_TYPE.SOLID) { side_mask |= 0x08; } }
              
              //collision detection and response
              AABB(player, level[player_tile_y + i][player_tile_x + j], side_mask);
            }
          }
        }
      }
    }
  }
  
  if(!player.check_ground)
  {
    player.on_ground = false;
  }
  
  
  //redraw scene
  background(0);
  
  stroke(255);
  circle(player.pos.x, foot_tile_y, 10);
  
  //draw tiles
  for(int i = 0; i < 32; i++)
  {
    for(int j = 0; j < 32; j++)
    {
      level[i][j].render();
      level[i][j].col = 0xFFFFFF;
    }
  }
  
  //image(background, 0, 0);
  
  player.animation();
  player.render();
}

//input
//utilize all bits of byte
/** non-optimized version:
 * boolean[] keys = new boolean[0x10000];
 * boolean keyDown(int key_code) { return keys[key_code]; }
 * void keyPressed()  { keys[key] = true;  }
 * void keyReleased() { keys[key] = false; }
 */
 
class BitField
{
  char data[];
  
  BitField(int num_bool) { data = new char[ceil(num_bool / 8)]; }
  
  //TODO: error checking
  void    set_bit(int index) { data[int(index / 8)] |=   1 << (index - int(index / 8) * 8);  }
  void  reset_bit(int index) { data[int(index / 8)] &= ~(1 << (index - int(index / 8) * 8)); }
  boolean get_bit(int index) { return boolean((data[int(index / 8)] >> (index - int(index / 8) * 8)) & 1); } 
}
 
BitField keys = new BitField(0x10000);
boolean keyDown(int key_code)  
{ 
  if(key_code < 0 || key_code >= 0x10000) { return false; }
  return keys.get_bit(key_code); 
}
void keyPressed()  { keys.set_bit(key);   }
void keyReleased() { keys.reset_bit(key); }
