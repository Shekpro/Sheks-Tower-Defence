// Created 14/8/21 4:30pm Shekinah Pratap 300565138
public class TextPulse {
  float x, y, initX, initY;
  float pulse = 0.4;
  String text;
  int r, g, b;

  public TextPulse(float x, float y, String text, int r, int g, int b) {
    // Creates text pulse effect using parameters
    this.initX = x/WIDTH;
    this.initY = y/WIDTH;
    this.text = text;
    this.r = r;
    this.g = g;
    this.b = b;
  }

  public void drawText() {
    x = initX*WIDTH;
    y = initY*WIDTH;
    textAlign(CENTER,CENTER);
    pulse+=0.05;
    
    // Makes pulse increase to a certain size then hold it there
    if (pulse>=1) {
      textSize(HEIGHT/40);
    }else{
      textSize(HEIGHT*pulse/40);
    }
    
    // Removes text when finished pulsing
    if (pulse>=2.5){
      removeT.add(this);
    }
    
    // Displays text if lag mode is not set to all
    if (lag!="ALL"){
      fill(r,g,b);
      text(text, x, y);
    }
  }
}
