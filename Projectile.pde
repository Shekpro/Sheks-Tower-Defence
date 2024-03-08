// Created 14/8/21 4:30pm Shekinah Pratap 300565138
public class Projectile {
  String type;
  float initX, initY, x, y, initSize, size, initXDir, initYDir, xDir, yDir, xMoved, yMoved, damage;
  Defence defence;
  float life, totalLife;
  int pierce, level;
  HashSet<Enemy> enemyHit = new HashSet<Enemy>();

  public Projectile(String type, float x, float y, float size, float xDir, float yDir, float damage, int pierce, int level, Defence defence) {
    // Creates projectile using parameters
    this.type = type;
    this.initX = x/WIDTH;
    this.initY = y/WIDTH;
    this.initSize = size/WIDTH;
    this.initXDir = xDir/WIDTH;
    this.initYDir = yDir/WIDTH;
    this.damage = damage;
    this.pierce = pierce;
    this.level = level;
    this.defence = defence;
    this.totalLife = 200+50*(level-1/24)*sqrt(defence.attackSpeed/2)/2;
    this.life = totalLife;
  }

  public void drawProjectile() {
    // Calculates position of projectile
    xDir = initXDir*WIDTH;
    yDir = initYDir*WIDTH;
    xMoved += speed;
    yMoved += speed;
    x = initX*WIDTH+xDir*xMoved;
    y = initY*WIDTH+yDir*yMoved;
    
    // Calculates size of projectile
    if (type=="BOAT2") {
      size = initSize*WIDTH*(life/totalLife);
      life-=speed*defence.attackSpeed/2;
      if (life<=100) {
        // Removes boat shard when it becomes smaller than a certain size
        removeP.add(this);
      }
    } else if (type=="HELI") {
      size = initSize*WIDTH+HEIGHT/50;
    } else {
      size = initSize*WIDTH;
    }
    
    // Draws the projectile according to type, size, and level
    ellipseMode(CENTER);
    if (lag=="OFF") {
      if (type == "BEAM") {
        fill(255, 165, (level-1)*10);
        ellipse(x, y, size, size);
        fill(255, 255, (level-1)*10);
        ellipse(x, y, size/2, size/2);
      } else if (type == "BOAT" || type == "BOAT2") {
        fill((level-1)*5, 0, 0);
        ellipse(x, y, size, size);
        fill((level-1)*10, 0, 0);
        ellipse(x, y, size/2, size/2);
        fill((level-1)*10, (level-1)*5, 0);
        ellipse(x, y, size/3, size/3);
      } else if (type == "HELI") {
        fill((level-1)*5, 165, (level-1)*10.625);
        rect(x, y, size/2, size/2);
        fill(255);
        rect(x, y, size/4, size/4);
      }
    } else if (lag=="SOME") {
      fill(0);
      if (type=="BOAT2") {
        ellipse(x, y, HEIGHT/200, HEIGHT/200);
      } else if (type=="HELI"){
        rect(x,y,HEIGHT/50,HEIGHT/50);
      }else{
        ellipse(x, y, HEIGHT/50, HEIGHT/50);
      }
    }
  }

  public Boolean checkBounds() {
    if (this.x+size/2<0 || this.x-size/2>WIDTH || 
      this.y+size/2<0 || this.y-size/2>HEIGHT) {
      return true;
    }
    return false;
  }

  public Enemy collide(Enemy enemy) {
    if (type!="HELI") {
      float circleDistX = abs(enemy.x - this.x);
      float circleDistY = abs(enemy.y - this.y);

      if (circleDistX > (enemy.size/2 + this.size/2)) { 
        return null;
      }
      if (circleDistY > (enemy.size/2 + this.size/2)) { 
        return null;
      }

      if (circleDistX <= (enemy.size/2)) { 
        return enemy;
      } 
      if (circleDistY <= (enemy.size/2)) { 
        return enemy;
      }

      float cornerDistance = pow(circleDistX - enemy.size/2, 2) +
        pow(circleDistY - enemy.size/2, 2);
      Boolean touch = cornerDistance <= (pow(this.size/2, 2));

      if (touch) {
        return enemy;
      }
    } else {
      if (abs(enemy.x-this.x)<enemy.size/2+this.size/4 && abs(enemy.y-this.y)<enemy.size/2+this.size/4) {
        return enemy;
      }
    }
    return null;
  }
}
