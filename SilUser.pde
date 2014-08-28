public class SilUser{
  
  PImage images[];
  PGraphics pgCur;
  int numFrames;
  int currentFrame;
  int cols, rows;
  
  public SilUser(PImage [] images){
    this.images = images;
    this.numFrames = images.length; 
    pgCur = createGraphics(images[0].width, images[0].height);
    pgCur.beginDraw();
    pgCur.background(0);
    pgCur.endDraw();
  } 
 
  public PImage getFrame(){
    if(frameCount%2==0){
    int numFrames = images.length;
    if(currentFrame<numFrames-1){
    currentFrame++;  // Use % to cycle through frames
    } else {
    currentFrame = 0;   
    }
    int offset = 0;
    //image(images[currentFrame],0,0);
    PImage img = images[currentFrame];
    //image(img,0,0);
    //img.resize(100,100);
    //img.filter(BLUR, (int)random(1,8));
    PGraphics pg = createGraphics(img.width, img.height);
    pg.beginDraw();
    pg.image(img,0,0);
    //pg.filter(BLUR, (int)random(1,8));
    pg.endDraw();
    pgCur = pg;
    //curFrame.image(pg,0,0);
    }
    //img.filter(INVERT);
    return pgCur; 
  }
  
  public PImage getFrameEffect(){
    
    println(frameRate);
    
    int numFrames = images.length;
    currentFrame = (currentFrame+1) % numFrames;  // Use % to cycle through frames
    int offset = 0;
    //image(images[currentFrame],0,0);
    PImage img = images[currentFrame]; 
    
    
    PGraphics pgColorSil = createGraphics(240,240);
    pgColorSil.beginDraw();
    pgColorSil.background(0);
    for(int ix=0; ix<img.width; ix++){
      for(int iy=0; iy<img.height; iy++){
        if(img.get(ix,iy)==color(0,0,0)){
          color c = cam.get(ix,iy);
          pgColorSil.set(ix,iy,c);  
        }   
      }
    }
    pgColorSil.endDraw();
    
    PGraphics bubbleSil = createGraphics(240,240);

    int cellSize = (int) random(5,5);

    cols = pgColorSil.width / cellSize;
    rows = pgColorSil.height / cellSize;

      bubbleSil.beginDraw();
      bubbleSil.background(0);
      pgColorSil.loadPixels();
    
      // Begin loop for columns
      for (int i = 0; i < cols; i++) {
        // Begin loop for rows
        for (int j = 0; j < rows; j++) {
      
        // Where are we, pixel-wise?
        int x = i*cellSize;
        int y = j*cellSize;
        int loc = (pgColorSil.width - x - 1) + y*pgColorSil.width; // Reversing x to mirror the image
      
        float r = red(pgColorSil.pixels[loc]);
        float g = green(pgColorSil.pixels[loc]);
        float b = blue(pgColorSil.pixels[loc]);
        // Make a new color with an alpha component
        color c = color(r, g, b, 75);
      
        // Code for drawing a single rect
        // Using translate in order for rotation to work properly
        bubbleSil.pushMatrix();
        bubbleSil.translate(x+cellSize/2, y+cellSize/2);
        // Rotation formula based on brightness
        bubbleSil.rotate((2 * PI * brightness(c) / 255.0));
        bubbleSil.rectMode(CENTER);
        bubbleSil.fill(c);
        bubbleSil.noStroke();
        // Rects are larger than the cell for some overlap
        bubbleSil.ellipse(0, 0, cellSize*(brightness(c)/100), cellSize*(brightness(c)/100));
        bubbleSil.popMatrix();
      }
    }
    bubbleSil.endDraw();
    
    return bubbleSil;
          //fill(255,255,255,50);
          //rect(0,0,width,height);
    
  }
  
  
}
