// Created 14/8/21 4:30pm Shekinah Pratap 300565138
public class BoltEffect {
  Defence bolt; // Gets defence it shoots from
  HashSet<Enemy> enemyStruck = new HashSet<Enemy>(); // Enemies it has struck
  ArrayList<PVector> posEnemy = new ArrayList<PVector>(); // List of enemy postions
  Enemy initE; // First enemy struck
  float size; // Size of lightning
  int chain = 0; // Amount of chain hits
  float chainTime; // Amount of time until next chain hit
  float timer; // Timer for the current chain hit
  int pierce; // Pierce of bolt

  public BoltEffect(Defence bolt, Enemy initE) {
    this.bolt = bolt;
    this.size = HEIGHT/150+HEIGHT*bolt.level/2500;
    this.initE = initE;
    this.pierce = bolt.pierce;
    enemyStruck.add(initE);
    chainTime = 30/(speed*pierce*bolt.attackSpeed);
    timer = chainTime;
    posEnemy.add(new PVector(initE.x, initE.y));
    float damage = bolt.damage;
    
    // Bolt does 5x less damage to armour
    if (initE.type=="RedArmour") { 
      damage = damage/5;
    }
    
    // Deals damage to enemy
    if (initE.health>=bolt.damage) {
      bolt.damageDealt+=bolt.damage;
    } else {
      bolt.damageDealt+=initE.health;
    }
    initE.health-=bolt.damage;
    
    // Removes enemy if it has no health left
    if (initE.health<=0) {
      removeE.add(initE);
    }
    
    // If bolt is maxed, stuns enemy
    if (bolt.level==25) {
      initE.stun = 1/speed;
    }
  }

  public void drawBolt() {
    if (lag=="OFF") {
      noFill();
      // Draws initial strike base colour
      stroke(220-(bolt.level-1)*220/24, 220, (bolt.level-1)*255/24);
      strokeWeight(size);
      line(bolt.x, bolt.y, posEnemy.get(0).x, posEnemy.get(0).y);
      // Draws chain strikes base colour
      for (int i=0; i<chain; i++) {
        line(posEnemy.get(i).x, posEnemy.get(i).y, posEnemy.get(i+1).x, posEnemy.get(i+1).y);
      }
      // Draws initial strike top colour
      stroke(255);
      strokeWeight(size/2);
      line(bolt.x, bolt.y, posEnemy.get(0).x, posEnemy.get(0).y);
      // Draws chain strikes top colour
      for (int i=0; i<chain; i++) {
        line(posEnemy.get(i).x, posEnemy.get(i).y, posEnemy.get(i+1).x, posEnemy.get(i+1).y);
      }
      noStroke();
    } else if (lag=="SOME") {
      noFill();
      // Draws initial strike
      stroke(0);
      strokeWeight(HEIGHT/150);
      line(bolt.x, bolt.y, posEnemy.get(0).x, posEnemy.get(0).y);
      // Draws chain strikes
      for (int i=0; i<chain; i++) {
        line(posEnemy.get(i).x, posEnemy.get(i).y, posEnemy.get(i+1).x, posEnemy.get(i+1).y);
      }
      noStroke();
    }
    if (timer<=0) {
      // Chains to next enemy
      chain++;
      if (chain<pierce) {
        float dist = 0;
        Enemy target = null;
        // Finds next enemy
        for (Enemy enemy : enemies) {
          if (((abs(enemy.distance-initE.distance)<dist) || target==null) && !enemyStruck.contains(enemy)) {
            dist = abs(enemy.distance-initE.distance);
            target = enemy;
          }
        }
        
        if (target!=null) { // Strikes to next enemy
          enemyStruck.add(target);
          // Damages enemy
          float damage = bolt.damage/sqrt(chain);
          if (initE.type=="RedArmour") { // Bolt does 5x less damage to armour
            damage = damage/5;
          }
          if (target.health>=damage) {
            bolt.damageDealt+=damage;
          } else {
            bolt.damageDealt+=target.health;
          }
          // If bolt is maxed, stuns enemy
          if (bolt.level==25) {
            target.stun = 1/speed;
          }
          target.health-=damage;
          if (target.health<=0) {
            removeE.add(target);
          }
          // Adds new location of lightning
          posEnemy.add(new PVector(random(target.x-target.size/2, target.x+target.size/2), random(target.y-target.size/2, target.y+target.size/2)));
        } else { // No enemies left
          removeBolt.add(this);
        }
        timer = chainTime;
      } else { // No more chain hits left
        removeBolt.add(this);
      }
    }
    if (pause==1) {
      // Only increments timer if game is not paused
      timer--;
    }
  }
}
