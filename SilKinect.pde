public class SilKinect{
  
 SimpleOpenNI context;
 int rate = 1;
 int frameNum = 0;
 boolean record = false;
 int numberUser;
 public ArrayList<PImage []> silList = new ArrayList<PImage []>();
 int[] userMap; 
 
 public SilKinect(SimpleOpenNI context){
   this.context = context;
   
   File file = new File("/Users/mariushoggenmuller/Documents/Processing/CCBerlin_2_/records/");
   int amount = 0;
   for(String fileName : file.list()){
     if(fileName.contains("user")){
       amount++;
     }
   }
   this.numberUser = amount;
   println(amount);
    /*int dirNum = file.list().length-2;
    file = new File("/Users/mariushoggenmuller/Documents/Processing/CCBerlin_2_/records/user"+dirNum);
    int numFrames = file.list().length;
    println(file.list().length);
    
    PImage[] images = new PImage[numFrames];
    for(int i=0; i<numFrames; i++){
      images[i]  = loadImage(file+"/"+file.list()[i]);
    }
    silList.add(images);*/
 }
 
 public void update(){
  if(record){
    boolean userMapEmpty = true;
    if(frameCount%rate==0){
      //println(frameRate);
      PGraphics pgSaver = createGraphics(640,480);
      pgSaver.beginDraw();
      if(context.getNumberOfUsers() > 0) 
      {    
        userMap = context.userMap();
        pgSaver.background(0);
        pgSaver.loadPixels();
        for(int i = 0; i < userMap.length; i++) 
        {
          if (userMap[i] !=0) 
          {
          //pixels[i] = context.rgbImage().pixels[i];
          pgSaver.pixels[i] = color(255,255,255);
          //println("true");
          userMapEmpty = false;
          }
        }
        if(!userMapEmpty){
          pgSaver.updatePixels();
          pgSaver.endDraw();
          PImage img = pgSaver.get(80,0,pgSaver.width-80,pgSaver.height);
          img.resize(240,240);
          String fileName = "records/user"+numberUser+"/frame"+frameNum+".jpg";
          img.save(fileName);
          image(img,0,0);
          frameNum++;
        }
      }  
    }
  }
 }
 
 public void loadLastUser(int amount){  
   //for(int k=0; k<20; k++){ 
   for(int i=0; i<amount; i++){
     File file = new File("/Users/mariushoggenmuller/Documents/Processing/CCBerlin_2_/records/user"+(numberUser-i));
     println(file);
     
     int count = 0;
     for(String fileName : file.list()){
       if(fileName.contains("frame")){
         count++;
       }
     }
   
     int numFrames = count;
     println(numFrames);
     PImage[] images = new PImage[numFrames];
     for(int j=0; j<numFrames; j++){
       images[j]  = loadImage(file+"/"+"frame"+j+".jpg");
       //image(images[j],0,400);
       PGraphics pg = createGraphics(images[j].width, images[j].height);
       pg.beginDraw();
       pg.background(0);
       pg.image(images[j],0,0);
       pg.filter(BLUR, (int)random(2,8));
       pg.endDraw();  
       images[j] = pg;  
     }
     silList.add(images);
   }
   //}
}
 
 public void startRec(){
   record = true; 
   numberUser++;
 }
 
 public void stopRec(){
   record = false;  
   File file = new File("/Users/mariushoggenmuller/Documents/Processing/CCBerlin_2_/records/user"+numberUser);
   int numFrames = file.list().length;
    
   PImage[] images = new PImage[numFrames];
   for(int i=0; i<numFrames; i++){
     images[i]  = loadImage(file+"/"+file.list()[i]);
   }
   silList.add(images);
   silList.remove(0);
      
   println(silList.size());
 }
 
 public PImage[] getRandomUser(){
   int size = silList.size();   
   println(size);
   return silList.get((int)random(0,size));
 }
 
 public int getUserSize(){
   return silList.size();  
 }

}
  

