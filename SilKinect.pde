public class SilKinect{
  
 SimpleOpenNI context;
 int rate = 5;
 boolean record = false;
 
 public SilKinect(SimpleOpenNI context){
   this.context = context;
 }
 
 public void update(){
  if(record){
  boolean userMapEmpty = true;
  if(frameCount%rate==0){
  println(frameRate);
  PGraphics pgSaver = createGraphics(640,480);
  pgSaver.beginDraw();
  if(context.getNumberOfUsers() > 0) 
  {    
    userMap = context.userMap();
    pgSaver.background(255);
    pgSaver.loadPixels();
    for(int i = 0; i < userMap.length; i++) 
    {
      if (userMap[i] !=0) 
      {
        //pixels[i] = context.rgbImage().pixels[i];
        pgSaver.pixels[i] = color(0,0,0);
        //println("true");
        userMapEmpty = false;
      }
    }
    if(!userMapEmpty){
    pgSaver.updatePixels();
    pgSaver.endDraw();
    String fileName = "records/user"+recNum+"/frame"+frameNum+".jpg";
    pgSaver.save(fileName);
    image(pgSaver,0,0);
    frameNum++;
    }
  }  
  }
  }
 }
 
 
 public void startRec(){
   record = true; 
 }
 
 public void stopRec(){
   record = false;  
 }

}
  

