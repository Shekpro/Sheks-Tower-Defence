// Created 14/8/21 4:30pm Shekinah Pratap 300565138
public class RotorEffect {
  Defence heli;
  float size = heliSize;

  public RotorEffect(Defence heli) {
    // Gives the rotor effect the helicopter it is associated with
    this.heli = heli;
  }

  public void drawEffect() {
    // Draws pulsing rotor effect on the heli at a certain speed
    noFill();
    stroke(255*(heliSize/size), 255, 255);
    strokeWeight(HEIGHT/250);
    ellipse(heli.heliX, heli.heliY, size, size);
    noStroke();
    size+=speed*5;
    if (size>=heliSize*2){
      removeRotEffects.add(this);
    }
  }
}
