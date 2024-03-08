// Created 14/8/21 4:30pm Shekinah Pratap 300565138
public class MapPiece {
  float x, y, w, h;
  String type;
  Boolean in;

  public MapPiece(float x, float y, float w, float h, String type, Boolean in) {
    // Creates map piece using parameters
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.type = type;
    this.in = in;
  }

  public void drawMap() {
    // Draws the piece of the map
    rectMode(CENTER);
    if (type!="Water") {
      if (!in) {
        if ((bossWave || wave>100) && screen=="Game") {
          fill(100);
        } else if (type.equals("Dirt")){ // Dirt path
          fill(210,140,80); 
        } else if (type.equals("Sand")){ // Sand path
          fill(168,143,89);
        } else if (type.equals("Road")){ // Road path
          fill(150);
        } else if (type.equals("Ice")){ // Ice path
          fill(199,213,224);
        }
        rect(x, y, w, h);
      } else {
        if ((bossWave || wave>100) && screen=="Game") {
          fill(60);
        } else if (type.equals("Dirt")){ // Dirt path
          fill(230,160,110);
        } else if (type.equals("Sand")){ // Sand path
          fill(238, 215, 153);
        } else if (type.equals("Road")){ // Road path
          fill(180);
        } else if (type.equals("Ice")){ // Ice path
          fill(219,233,244);
        }
        rect(x, y, w, h);
      }
    } else if (type=="Water") {
      if (!in) {
        if (bossWave && screen=="Game") {
          fill(255, 180, 0);
        } else {
          fill(0, 150, 200);
        }
        rect(x, y, w, h);
      } else {
        if (bossWave && screen=="Game") {
          fill(255, 140, 0);
        } else {
          fill(0, 200, 255);
        }
        rect(x, y, w, h);
      }
    }
  }

  public Boolean check() { // Checks if touches map
    if (selected!="HELI") {
      // Circle rectangle collision
      float circleDistX = abs(this.x - mouseX);
      float circleDistY = abs(this.y - mouseY);

      if (circleDistX > (this.w/2 + selectSize/2)) { 
        return false;
      }
      if (circleDistY > (this.h/2 + selectSize/2)) { 
        return false;
      }

      if (circleDistX <= (this.w/2)) { 
        return true;
      } 
      if (circleDistY <= (this.h/2)) { 
        return true;
      }

      float cornerDistance = pow(circleDistX - this.w/2, 2) +
        pow(circleDistY - this.h/2, 2);

      return cornerDistance <= (pow(selectSize/2, 2));
    } else {
      // Rectangle rectangle collision
      if (abs(this.x-mouseX)<helipadSize/2+this.w/2 && abs(this.y-mouseY)<helipadSize/2+this.h/2){
        return true;
      }else{
        return false;
      }
    }
  }

  public Boolean checkWater() { // Checks if fully in water
    if (abs(mouseX-this.x)<this.w/2-selectSize/2 && abs(mouseY-this.y)<this.h/2-selectSize/2) {
      return true;
    }
    return false;
  }
  
  public Boolean placeWater(float wX, float wY){ // Checks if map piece does not collide with the water piece being placed in custom map
    if (abs(this.x-wX)<(this.w+tempOut.w)/2 && abs(this.y-wY)<(this.h+tempOut.h)/2){
      return false;
    }
    return true;
  }
}
