// Created 14/8/21 4:30pm Shekinah Pratap 300565138
public class Enemy {
  String type, dir;
  float initX, initY, initSize, x, y, size, health, totalHealth, xMoved, yMoved, initWidth, ratio, distance;
  int track = 0;
  float stun = 0;

  public Enemy(String type, float x, float y, float size, float health) {
    // Creates enemy using parameters
    this.type = type;
    this.initX = x/WIDTH;
    this.initY = y/WIDTH;
    this.initSize = size/WIDTH;
    this.health = health;
    this.totalHealth = health;
    this.initWidth = WIDTH;
  }

  public void drawEnemy() {
    // Updates variables
    x = initX*WIDTH+xMoved*(WIDTH/initWidth);
    y = initY*WIDTH+yMoved*(WIDTH/initWidth);
    size = initSize*WIDTH;
    dir = trackDir[track];
    rectMode(CENTER);
    // Decreases stun duration
    if (pause==1) {
      if (stun>0) {
        stun-=0.1;
      }
      if (stun<0) {
        stun = 0;
      }
    }
    
    // Calculates positions for health bar drawn
    if (type=="RedArmour") {
      ratio = (health-(totalHealth/7))/(totalHealth*6/7);
      if (ratio<=0) {
        // For when armour is destroyed, player gets +$5, and change enemy type back to original form
        type = "Red";
        totalHealth = totalHealth/7;
        texts.add(new TextPulse (x, y-size, "+$5", 255, 255, 0));
        money+=5;
      }
    } else {
      ratio = health/totalHealth;
    }

    // Draws healthbar if reduce lag is off and sets colour according to enemy type
    if (lag=="OFF") {
      if (type=="RedBoss") {
        fill(128, 0, 0);
      } else if (type=="RedArmour") {
        fill(110);
      } else {
        fill(255, 0, 0);
      }
      rect(x, y-size/2-size/6, size, size/5);
      if (type=="RedBoss") {
        fill(255, 255, 0);
      } else if (type=="RedArmour") {
        fill(0, 100, 255);
      } else {
        fill(0, 255, 0);
      }
      rect(x+size*(1-ratio)/2, y-size/2-size/6, size*ratio, size/5);
    }

    // Draws enemy base
    if (type == "Red" || type == "RedBoss") {
      fill(255*ratio*0.75, 0, 0);
    } else if (type == "Yellow") {
      fill(255*ratio*0.75, 220*ratio*0.75, 0);
    } else if (type == "Green") {
      fill(0, 255*ratio*0.75, 0);
    } else if (type == "RedArmour") {
      fill(80*ratio*0.75);
    }
    rect(x, y, size, size);
    // Draws enemy inner
    if (type == "Red" || type == "RedBoss") {
      fill(255*ratio, 0, 0);
    } else if (type == "Yellow") {
      fill(255*ratio, 220*ratio, 0);
    } else if (type == "Green") {
      fill(0, 255*ratio, 0);
    } else if (type == "RedArmour") {
      fill(200*ratio, 210*ratio, 210*ratio);
    }
    rect(x, y, size*0.8, size*0.8);

    // If has armour reveals some red
    if (type=="RedArmour") {
      fill(80*ratio*0.75);
      if (dir.equals("RIGHT")) {
        rect(x+size/4, y, size/2, size/2);
      } else if (dir.equals("LEFT")) {
        rect(x-size/4, y, size/2, size/2);
      } else if (dir.equals("DOWN")) {
        rect(x, y+size/4, size/2, size/2);
      } else if (dir.equals("UP")) {
        rect(x, y-size/4, size/2, size/2);
      }
    }

    // Draws eye
    if (type == "Red" || type == "RedBoss" ) {
      fill(255*ratio*0.85, 0, 0);
    } else if (type == "Yellow") {
      fill(255*ratio*0.85, 220*ratio*0.85, 0);
    } else if (type == "Green") {
      fill(0, 255*ratio*0.85, 0);
    } else if (type == "RedArmour") {
      fill(255*ratio, 0, 0);
    }
    // Outline of eye
    float eyeSize = size/2;
    if (type=="RedArmour") {
      eyeSize = eyeSize*0.7;
    }
    if (dir.equals("RIGHT")) {
      ellipse(x+size/4, y, eyeSize, eyeSize);
    } else if (dir.equals("LEFT")) {
      ellipse(x-size/4, y, eyeSize, eyeSize);
    } else if (dir.equals("DOWN")) {
      ellipse(x, y+size/4, eyeSize, eyeSize);
    } else if (dir.equals("UP")) {
      ellipse(x, y-size/4, eyeSize, eyeSize);
    }
    // White part of eye
    eyeSize = size/3;
    if (type=="RedArmour") {
      eyeSize = eyeSize*0.7;
    }
    fill(255*ratio, 255*ratio, 220*ratio);
    if (dir.equals("RIGHT")) {
      ellipse(x+size/4, y, eyeSize, eyeSize);
    } else if (dir.equals("LEFT")) {
      ellipse(x-size/4, y, eyeSize, eyeSize);
    } else if (dir.equals("DOWN")) {
      ellipse(x, y+size/4, eyeSize, eyeSize);
    } else if (dir.equals("UP")) {
      ellipse(x, y-size/4, eyeSize, eyeSize);
    }
  }
}
