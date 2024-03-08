// Created 14/8/21 4:30pm Shekinah Pratap 300565138
public class Defence {
  String type, target;
  float initX, initY, initSize, x, y, size, initRange, range, attackSpeed, damage, totalCost, initWidth, 
    projectileSize, damageDealt, initHeliX, initHeliY, heliX, heliY, heliXMoved, heliYMoved;
  float xDir = 0;
  float yDir = 1;
  int pierce = 1;
  int sell, level;
  float rate = 0;
  int upgrade1 = 1; // First upgrade path which is range or move
  int upgrade2 = 1; // Second upgrade path which is attack speed
  int upgrade3 = 1; // Third upgrade path which is damage
  int upgrade4 = 1; // Third upgrade path which is pierce
  int cost1, cost2, cost3, cost4; // Cost for each upgrade
  int heliRotate;
  float heliSpeed, xAim, yAim, xAimPos, yAimPos;
  Boolean heliMove = false;
  String heliMovement = "MOUSE";
  Boolean heliFace = false;
  int rotorTime = 0;

  public Defence(String type, float x, float y, float size, String target, float defRange, int damage) {
    // Uses parameters to set defence variables
    this.type = type;
    this.initX = x/WIDTH;
    this.initY = y/WIDTH;
    this.initSize = size/WIDTH;
    this.initRange = defRange/WIDTH;
    this.target = target;
    if (type=="BEAM") {
      this.totalCost = 5;
    } else if (type=="BOAT") {
      this.totalCost = 25;
    } else if (type=="HELI") {
      this.totalCost = 250;
      this.pierce = 5;
      this.initHeliX = initX;
      this.initHeliY = initY;
      this.initWidth = WIDTH;
    } else if (type=="BOLT"){
      this.totalCost = 100;
      this.pierce = 2;
    }
    this.damage = damage;
  }

  public void drawHeli() {
    // Draws heli
    fill(215-(level-1)*6.25, 215-(level-1)*6.25, (level-1)*6.25-40);
    ellipse(heliX, heliY, heliSize, heliSize);
    fill(255-(level-1)*6.25, 255-(level-1)*6.25, (level-1)*6.25);
    ellipse(heliX, heliY, heliSize*0.8, heliSize*0.8);
    fill(215-(level-1)*6.25, 215-(level-1)*6.25, (level-1)*6.25-40);
    ellipse(heliX+xDir*heliSize/5, heliY+yDir*heliSize/5, heliSize*0.4, heliSize*0.4);
    fill(255);
    ellipse(heliX+xDir*heliSize/5, heliY+yDir*heliSize/5, heliSize*0.3, heliSize*0.3);

    // Draws rotors
    float sRot = 1; // Scales rotor
    if (level==25) {
      sRot = 1.25;
    }
    stroke(180);
    strokeWeight(HEIGHT*sRot/100);
    if (heliRotate%12<6) {
      line(heliX, heliY-heliSize*sRot*sqrt(2)/2, heliX, heliY+heliSize*sRot*sqrt(2)/2);
      line(heliX-heliSize*sRot*sqrt(2)/2, heliY, heliX+heliSize*sRot*sqrt(2)/2, heliY);
      stroke(255);
      strokeWeight(HEIGHT*sRot/150);
      line(heliX, heliY-heliSize*sRot*sqrt(2)/2, heliX, heliY+heliSize*sRot*sqrt(2)/2);
      line(heliX-heliSize*sRot*sqrt(2)/2, heliY, heliX+heliSize*sRot*sqrt(2)/2, heliY);
    } else {
      line(heliX-heliSize*sRot/2, heliY-heliSize*sRot/2, heliX+heliSize*sRot/2, heliY+heliSize*sRot/2);
      line(heliX+heliSize*sRot/2, heliY-heliSize*sRot/2, heliX-heliSize*sRot/2, heliY+heliSize*sRot/2);
      stroke(255);
      strokeWeight(HEIGHT*sRot/150);
      line(heliX-heliSize*sRot/2, heliY-heliSize*sRot/2, heliX+heliSize*sRot/2, heliY+heliSize*sRot/2);
      line(heliX+heliSize*sRot/2, heliY-heliSize*sRot/2, heliX-heliSize*sRot/2, heliY+heliSize*sRot/2);
    }
    noStroke();
    fill(100);
    ellipse(heliX, heliY, heliSize/4, heliSize/4);
    fill(200);
    ellipse(heliX, heliY, heliSize/8, heliSize/8);
    heliRotate+=speed;
  }

  public void drawDefence() {
    // Calculates upgrade costs for each path, and sets projectile size proportional to the level
    if (type=="BEAM") {
      cost1 = (int) pow(2.8, upgrade1-1)+upgrade1+1;
      cost2 = (int) pow(3.8, upgrade2-2)+upgrade2+1;
      cost3 = (int) pow(3.8, upgrade3-2)+upgrade3+1;
      cost4 = (int) pow(3.4, upgrade4)+upgrade4+1;
      projectileSize = HEIGHT*pow(1.1, level-1)/50;
    } else if (type=="BOAT") {
      projectileSize = pow(1.075, level-1)*size/3;
      cost1 = (int) pow(3, upgrade1-1)+25*upgrade1;
      cost2 = (int) pow(4, upgrade2-2)+25*upgrade2;
      cost3 = (int) pow(4, upgrade3-2)+25*upgrade3;
      cost4 = (int) pow(3.6, upgrade4+1)+25*upgrade4;
    } else if (type=="HELI") {
      projectileSize = HEIGHT*pow(1.1, level-1)/50;
      cost1 = (int) pow(3, upgrade1-1)+50+50*upgrade1;
      cost2 = (int) pow(4, upgrade2-2)+50+50*upgrade2;
      cost3 = (int) pow(4, upgrade3-2)+50+50*upgrade3;
      cost4 = (int) pow(3.6, upgrade4)+50+50*upgrade4;
    } else if (type=="BOLT") {
      projectileSize = HEIGHT*pow(1.1, level-1)/50;
      cost1 = (int) pow(3, upgrade1-1)+50*upgrade1;
      cost2 = (int) pow(4, upgrade2-2)+50*upgrade2;
      cost3 = (int) pow(4, upgrade3-2)+50*upgrade3;
      cost4 = (int) pow(3.6, upgrade4)+50*upgrade4;
    }
    sell = (int) (totalCost*0.6); // Sell price
    x = initX*WIDTH;
    y = initY*WIDTH;
    if (type=="HELI") {
      rotorTime+=speed;
      if (level==25 && rotorTime>=30) {
        rotorTime = 0;
        for (Enemy enemy : enemies) {
          // Circle rectangle collision
          Boolean collide = false;
          float circleDistX = abs(enemy.x - heliX);
          float circleDistY = abs(enemy.y - heliY);

          if (circleDistX <= (enemy.size/2)) { 
            collide = true;
          } 
          if (circleDistY <= (enemy.size/2)) { 
            collide = true;
          }
          if (circleDistX > (heliSize/2 + enemy.size/2)) { 
            collide = false;
          }
          if (circleDistY > (heliSize/2 + enemy.size/2)) { 
            collide = false;
          }

          float cornerDistance = pow(circleDistX - enemy.size/2, 2) +
            pow(circleDistY - enemy.size/2, 2);

          if (cornerDistance <= (pow(heliSize*2/2, 2))) {
            collide = true;
          }

          if (collide) {
            enemy.health-=damage*2;
            rotEffects.add(new RotorEffect(this));
          }
        }
      }
      
      // Moves helicopter
      float moveX = 0;
      float moveY = 0;
      heliSpeed = upgrade1+2;
      if (heliMovement=="AUTO" && enemies.size()>0) {
        moveX = xAim*speed*heliSpeed;
        moveY = yAim*speed*heliSpeed;
        if (abs(xAimPos-heliX)<moveX) {
          moveX = 0;
          heliX = xAimPos;
        }
        if (abs(yAimPos-heliY)<moveY) {
          moveY = 0;
          heliY = yAimPos;
        }
      }

      float mod = 1/sqrt(pow(mouseX-heliX, 2) + pow(mouseY-heliY, 2));
      float xD = (mouseX-heliX)*mod;
      float yD = (mouseY-heliY)*mod;

      if (heliMove) {
        moveX = xD*speed*heliSpeed;
        moveY = yD*speed*heliSpeed;
        xAimPos = mouseX;
        yAimPos = mouseY;
        if (abs(mouseX-heliX)<moveX) { 
          moveX = 0;
          heliX = mouseX;
        }
        if (abs(mouseY-heliY)<moveY) {
          moveY = 0;
          heliY = mouseY;
        }
        // Faces mouse if no enemies are in range
        if (!heliFace) {
          xDir=xD;
          yDir=yD;
        }
      }
      
      // Collision with other helicopters
      for (Defence defence : defences) {
        if (defence.type=="HELI" && defence!=this) {
          if (sqrt(pow(defence.heliX-heliX, 2)+pow(defence.heliY-heliY, 2))<heliSize) {
            mod = 1/(sqrt(pow(defence.heliX-heliX, 2) + pow(defence.heliY-heliY, 2)));
            xD = (defence.heliX-heliX)*mod;
            yD = (defence.heliY-heliY)*mod;
            if (heliMovement!="LOCK" && (defence.heliMovement=="LOCK" || 
              sqrt(pow(xAimPos-heliX, 2) + pow(yAimPos-heliY, 2))>sqrt(pow(xAimPos-defence.heliX, 2) + pow(yAimPos-defence.heliY, 2)))) {
              heliXMoved-=xD*speed*heliSpeed+moveX;
              heliYMoved-=yD*speed*heliSpeed+moveY;
            }
          }
        }
      }

      // If out of bounds, fixes it
      if (heliX+moveX<heliSize/2) {
        heliXMoved -= abs(moveX/(heliSize/2+heliX+moveX));
      }
      if (heliX+moveX>WIDTH-heliSize/2) {
        heliXMoved -= abs(moveX/(heliSize/2+heliX+WIDTH-moveX));
      }
      if (heliY+moveY<heliSize/2) {
        heliXMoved -= abs(moveY/(heliSize/2+heliY+moveY));
      }
      if (heliY+moveY>hotBarTop-heliSize/2) {
        heliYMoved -= abs(moveY/(heliSize/2+moveY+hotBarTop-heliY));
      } 

      // Sets heli x and y position
      heliXMoved+=moveX;
      heliYMoved+=moveY;
      heliX = initHeliX*WIDTH+heliXMoved*(WIDTH/initWidth);
      heliY = initHeliY*WIDTH+heliYMoved*(WIDTH/initWidth);
    }

    level = upgrade1+upgrade2+upgrade3+upgrade4-3;
    size = initSize*WIDTH;
    
    // Sets range of defence according to the type and upgraded range
    if (type=="HELI") {
      range = heliRange;
    } else {
      range = initRange*WIDTH*pow(1.2, upgrade1-1);
    }
    
    // Sets attack speed for defence according to the type and upgrades
    attackSpeed = pow(1.5, upgrade2-1);
    if (type=="BOLT"){
      attackSpeed = attackSpeed/5;
    }
    
    // Draws defence
    ellipseMode(CENTER);
    if (type == "BEAM") {
      // Beam body
      fill(128+3.5*(level-1), 7*(level-1), 255);
      ellipse(x, y, size, size);
      fill(128+5*(level-1), 100+5*(level-1), 255);
      ellipse(x, y, size*0.8, size*0.8);
      // Beam eye
      fill(128+8.5*(level-1), 7*(level-1), 255);
      ellipse(x+size*0.2*xDir, y+size*0.2*yDir, size*0.4, size*0.4);
      fill(255, 255-(level-1)*5, 255-(level-1)*2);
      ellipse(x+size*0.2*xDir, y+size*0.2*yDir, size/4, size/4);
      fill(0, (level-1)*5, (level-1)*10);
      ellipse(x+size*0.2*xDir, y+size*0.2*yDir, size/10, size/10);
    } else if (type == "BOAT") {
      // Wooden boat
      fill(200-(level-1)*5, 160-(level-1)*2.5, (level-1)*4.2);
      ellipse(x, y, boatSize, boatSize);
      fill(161-level, 130+(level-1)*1.25, (level-1)*6.7);
      ellipse(x, y, boatSize-boatSize/5, boatSize-boatSize/5);
      // Cannon nuzzle base
      fill(80+(level-1)*6, 80, 80);
      ellipse(x+xDir*boatSize/3, y+yDir*boatSize/3, boatSize/4, boatSize/4);
      // Cannon nuzzle inner
      fill(0);
      ellipse(x+xDir*boatSize/3, y+yDir*boatSize/3, boatSize/8, boatSize/8);
      // Cannon top base
      fill(80+(level-1)*6, 80, 80);
      ellipse(x+xDir*boatSize/6, y+yDir*boatSize/6, boatSize/3, boatSize/3);
      // Top of cannon
      fill(40);
      ellipse(x+xDir*boatSize/6, y+yDir*boatSize/6, boatSize/4, boatSize/4);
      // Cannon mast
      fill(200);
      rect(x, y, boatSize/4, boatSize/4);
      fill(255);
      ellipse(x, y, boatSize/4, boatSize/4);
    } else if (type == "HELI") {
      // Grass
      fill(80-(level-1)*10/3, 150-(level-1)*6.25, 0);
      rect(x, y, helipadSize, helipadSize);
      fill(120-(level-1)*2.9, 220-(level-1)*7.1, (level-1)*2.1);
      rect(x, y, helipadSize*0.85, helipadSize*0.85);
      // Heli pad lights
      fill(255-(level-1)*10.625, 255-level*2, (level-1)*10.625);
      ellipse(x-helipadSize/3, y-helipadSize/3, helipadSize/10, helipadSize/10);
      ellipse(x-helipadSize/3, y+helipadSize/3, helipadSize/10, helipadSize/10);
      ellipse(x+helipadSize/3, y-helipadSize/3, helipadSize/10, helipadSize/10);
      ellipse(x+helipadSize/3, y+helipadSize/3, helipadSize/10, helipadSize/10);
      fill(255);
      ellipse(x-helipadSize/3, y-helipadSize/3, helipadSize/15, helipadSize/15);
      ellipse(x-helipadSize/3, y+helipadSize/3, helipadSize/15, helipadSize/15);
      ellipse(x+helipadSize/3, y-helipadSize/3, helipadSize/15, helipadSize/15);
      ellipse(x+helipadSize/3, y+helipadSize/3, helipadSize/15, helipadSize/15);
      // Heli pad circle
      noFill();
      stroke(255);
      strokeWeight(HEIGHT/120);
      ellipse(x, y, helipadSize*0.7, helipadSize*0.7);
      // Heli pad "H"
      fill(255);
      noStroke();
      textAlign(CENTER, CENTER);
      textSize(HEIGHT/12);
      text("H", x, y-textDescent()/2);
    } else if (type == "BOLT") {
      // Tesla
      fill(60);
      ellipse(x, y, boltSize, boltSize);
      fill(90);
      ellipse(x, y, boltSize*0.9, boltSize*0.9);
      
      // Tesla coils
      noFill();
      for (int i=3; i>0; i--) {
        stroke(200-(level-1)*200/24, 200, (level-1)*255/24);
        strokeWeight(HEIGHT/160);
        ellipse(x, y, boltSize*i/4, boltSize*i/4);
        stroke(255-(level-1)*35/24, 255-(level-1)*35/24, 220+(level-1)*35/24);
        strokeWeight(HEIGHT/600);
        ellipse(x, y, boltSize*i/4, boltSize*i/4);
      }
      noStroke();
      fill(180);
      ellipse(x, y, boltSize/9, boltSize/9);
    }
  }

  public float enemyDist(Enemy enemy) {
    // Calculates distance from defence to enemy
    if (type=="HELI") {
      return (sqrt(pow(enemy.x-this.heliX, 2)+pow(enemy.y-this.heliY, 2)));
    }
    return (sqrt(pow(enemy.x-this.x, 2)+pow(enemy.y-this.y, 2)));
  }
}
