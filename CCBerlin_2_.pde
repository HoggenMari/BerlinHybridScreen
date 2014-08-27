

/* --------------------------------------------------------------------------
 * SimpleOpenNI DepthImage Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect 2 library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / Zhdk / http://iad.zhdk.ch/
 * date:  12/12/2012 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import DMXlib.*;
import SimpleOpenNI.*;
import processing.video.*;
import deadpixel.keystone.*;
import processing.serial.*;
import beads.*;
import java.util.Arrays; 


//Kinect
SimpleOpenNI context;
int[] userMap; 
boolean KINECT = true;

//Camera
Capture cam;
boolean CAM = true;

//Serial
Serial myPort;       
static String ARDUINO_DEVICE = null;
static int lf = 10;
boolean SERIAL = false;

//LEDs
DMXController dmx;
LEDScreen screen1, screen2, screen3, screen4, screen5, screen6, screen7, screen8, screen9, screen10, screen11, screen12, screen13, screen14, screen15, screen16, screen17, screen18, screen19, screen20, screen21, screen22, screen23, screen24;
int [][] map = {{0,0,1,1,1},{0,0,1,1,1},{0,1,1,1,1},{0,1,1,1,1},{1,1,1,1,1},{1,1,1,1,1}};
LEDScreen [][] screenMap = {{screen1,screen2},{screen3,screen4}};
ArrayList<LEDScreen> screenList = new ArrayList<LEDScreen>();

//KeyStone
Keystone ks;
ArrayList<CornerPinSurface> surfaceList = new ArrayList<CornerPinSurface>();
ArrayList<PGraphics> offscreenList = new ArrayList<PGraphics>();
int HR_WIDTH = 100;
int HR_HEIGHT = 100;
int HR_AMOUNT = 6;
int[] displaySize = {2,2,3,3,3,3};
CornerPinSurface surface1, surface2, surface3,surface4, surface5, surface6;

//PGraphics
PGraphics pg,pg1,pg2,pg3,pg4,offscreen1,offscreen2,offscreen3;
PGraphics offLED, offVideo;
PGraphics ledScreen1;
int ran = 0;

int x=0;
int y=0;

//structure
int  d=6;

float[][] val ;
float xSize,ySize;
float increment = 0.03;
float zoff = 0.0;
float zincrement = 0.01;
int t=0;
int br=0;

//double num;
String myString;

//Audio
AudioContext ac;
Glide glide;
boolean changed;
boolean newVal;
double num;
double vel;
SamplePlayer player;
double songLength;

//Silhouetten-Application
boolean record = false;
int recNum = 0;
int frameNum = 0;
ArrayList<PImage []> silList = new ArrayList<PImage []>();
int currentFrame = 0;
SilKinect silContext;

void setup()
{
  //println(Capture.list());
  


  size(1920, 1200, P3D);
  
  pg1 = createGraphics(4,4,JAVA2D);
  pg2 = createGraphics(4,4,JAVA2D);
  pg3 = createGraphics(4,4,JAVA2D);
  pg4 = createGraphics(4,4,JAVA2D);
  
  ledScreen1 = createGraphics(1000,750,JAVA2D);
  
  screen1 = new LEDScreen(4, 4, "LU", "V");
  screen1.update(pg1);
  screen2 = new LEDScreen(4, 4, "RO", "H");
  screen2.update(pg2);
  screen3 = new LEDScreen(4, 4, "RO", "H");
  screen3.update(pg3);
  screen4 = new LEDScreen(4, 4, "RU", "H");
  screen4.update(pg4);
  screen5 = new LEDScreen(4, 4, "RU", "H");
  screen5.update(pg4);
  screen6 = new LEDScreen(4, 4, "RU", "H");
  screen6.update(pg4);
  screen7 = new LEDScreen(4, 4, "RO", "H");
  screen7.update(pg4);
  screen8 = new LEDScreen(4, 4, "RO", "H");
  screen8.update(pg4);
  screen9 = new LEDScreen(4, 4, "RO", "H");
  screen9.update(pg4);
  screen10 = new LEDScreen(4, 4, "RU", "H");
  screen10.update(pg4);
  screen11 = new LEDScreen(4, 4, "RU", "H");
  screen11.update(pg4);
  screen12 = new LEDScreen(4, 4, "RU", "H");
  screen12.update(pg4);
  screen13 = new LEDScreen(4, 4, "RO", "H");
  screen13.update(pg4);
  screen14 = new LEDScreen(4, 4, "RO", "V");
  screen14.update(pg4);
  screen15 = new LEDScreen(4, 4, "RU", "V");
  screen15.update(pg4);
  screen16 = new LEDScreen(4, 4, "RO", "V");
  screen16.update(pg4);
  screen17 = new LEDScreen(4, 4, "RO", "V");
  screen17.update(pg4);
  screen18 = new LEDScreen(4, 4, "RO", "V");
  screen18.update(pg4);
  screen19 = new LEDScreen(4, 4, "RO", "H");
  screen19.update(pg4);
  screen20 = new LEDScreen(4, 4, "RO", "H");
  screen20.update(pg4);
  screen21 = new LEDScreen(4, 4, "RO", "H");
  screen21.update(pg4);
  screen22 = new LEDScreen(4, 4, "RU", "H");
  screen22.update(pg4);
  screen23 = new LEDScreen(4, 4, "RU", "H");
  screen23.update(pg4);
  screen24 = new LEDScreen(4, 4, "RU", "H");
  screen24.update(pg4);
  
  screenList.add(screen24);
  screenList.add(screen23);
  screenList.add(screen22);
  screenList.add(screen19);
  screenList.add(screen20);
  screenList.add(screen21);
  screenList.add(screen1);
  screenList.add(screen2);
  screenList.add(screen3);
  screenList.add(screen18);
  screenList.add(screen6);
  screenList.add(screen5);
  screenList.add(screen4);
  screenList.add(screen17);
  screenList.add(screen12);
  screenList.add(screen11);
  screenList.add(screen10);
  screenList.add(screen15);
  screenList.add(screen16);
  screenList.add(screen7);
  screenList.add(screen8);
  screenList.add(screen9);
  screenList.add(screen13);
  screenList.add(screen14);

  
  

  
  dmx = new DMXController("224.1.1.1", 5026, 4);  
  dmx.add(1, 0, screen1);
  dmx.add(1, 1, screen2);
  dmx.add(1, 2, screen3);
  dmx.add(1, 3, screen4);
  dmx.add(1, 4, screen5);
  dmx.add(1, 5, screen6);
  dmx.add(1, 6, screen7);
  dmx.add(1, 7, screen8);
  dmx.add(1, 8, screen9);
  dmx.add(1, 9, screen10);
  dmx.add(1, 10, screen11);
  dmx.add(1, 11, screen12);
  dmx.add(2, 12, screen13);
  dmx.add(2, 13, screen14);
  dmx.add(2, 14, screen15);
  dmx.add(2, 15, screen16);
  dmx.add(2, 16, screen17);
  dmx.add(2, 17, screen18);
  dmx.add(2, 18, screen19);
  dmx.add(2, 19, screen20);
  dmx.add(2, 20, screen21);
  dmx.add(2, 21, screen22);
  dmx.add(2, 22, screen23);
  dmx.add(2, 23, screen24);
  //dmx.start();
  
  ks = new Keystone(this);
  
  for(int i=0; i<HR_AMOUNT; i++){
  surfaceList.add(ks.createCornerPinSurface(HR_WIDTH, HR_HEIGHT*displaySize[i], 20));
  }
  
  surface1 = ks.createCornerPinSurface(62*6, 62*6, 20);
  surface2 = ks.createCornerPinSurface(62*6, 62*6, 20);
  surface3 = ks.createCornerPinSurface(62*6, 62*6, 20);
  surface4 = ks.createCornerPinSurface(62*6, 62*6, 20);
  surface5 = ks.createCornerPinSurface(62*6, 62*6, 20);
  surface6 = ks.createCornerPinSurface(62*6, 62*6, 20);
  
  if(KINECT){
  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }

  // mirror is by default enabled
  context.setMirror(true);

  // enable depthMap generation 
  context.enableDepth();

  // enable ir generation
  context.enableRGB();
  
  context.enableUser();
  }
  
  if(CAM){
  String[] cameras = Capture.list();
  println(Capture.list());
  cam = new Capture(this, cameras[15]);
  cam.start();
  }
  

  
  offscreen1 = createGraphics(400, 400, P3D);
  offscreen2 = createGraphics(640, 480, P3D);
  offscreen3 = createGraphics(400, 400, P3D);

  offLED = createGraphics(4, 4);
  offVideo = createGraphics(400,400,P3D);

  //structure
  val = new float[400][400];
  xSize = 400;
  ySize = 400;
  
  
  val = new float[63][63];
  xSize = 63;
  ySize = 63;
  pg = createGraphics(63*6,63*6,P3D);
  
  // List all the available serial ports:
  if(SERIAL){
  println(Serial.list());
  
  for (int i = 0; i < Serial.list().length; i++) {
    System.out.println("Device " + i + " " + Serial.list()[i]);
    if(Serial.list()[i].contains("/dev/tty.HC-05")){
      ARDUINO_DEVICE = Serial.list()[i];
    }
  }
    
  // Open the port you are using at the rate you want:
  if(ARDUINO_DEVICE!=null){
  myPort = new Serial(this, ARDUINO_DEVICE, 9600);
  }else{
    exit();
  }
  }
    
 ac = new AudioContext();
 selectInput("Select an audio file:", "fileSelected");

  //loadUser();

  silContext = new SilKinect(context);
  
  silContext.loadLastUser(5);
 //contrast();
}

void draw()
{
  
  //println(frameRate);
  background(0);
  
  //AUDIO
  if(changed){
    if(newVal){
    glide.setValue((float)((vel-20)/100));
    newVal = false;
    }else{
    glide.setValue((float)(1));
    }
    
    if(songLength <= player.getPosition()){
      println("ENDE");
      changeSong();
    }
  }
  
  
  
  
  // Convert the mouse coordinate into surface coordinates
  // this will allow you to use mouse events inside the 
  // surface from your screen. 
  PVector surfaceMouse = surfaceList.get(0).getTransformedMouse();
  
  
  // update the caml
  context.update();

  //contrast();
  background(0, 0, 0);

  // draw depthImageMap
  //image(context.depthImage(), 0, 0);

  // draw irImageMap
  //image(context.rgbImage(), context.depthWidth() + 10, 0);
  
  if(CAM){
  if (cam.available() == true) {
    cam.read();
    //cam.resize(24,20);
  }
  }
  
    //image(cam,24,0);

  
  //image(cam, context.depthWidth()*2, 0);
  
    // Draw the scene, offscreen
  //offscreen1.beginDraw();
  //offscreen1.background(0,0,0);
  //offscreen1.noFill();
  //offscreen1.stroke(255,255,255);
  //offscreen1.strokeWeight(20);
  //offscreen1.rect(0,0,x,y);
  //offscreen.image(cam,0,0);
  //offscreen1.image(pg,0,0);
  //offscreen1.endDraw();

  /*if(x>offscreen1.width){
    x=0;
  }
  if(y>offscreen1.height){
    y=0;
  }
  x++;
  y++;*/
  
    // Draw the scene, offscreen
  //offscreen1.beginDraw();
  //offscreen1.image(cam,0,0,62*6,62*6);
  //offscreen2.background(255,255,255);
  //offscreen.image(cam,0,0);
  //offscreen2.image(context.depthImage(),0,0);
  
  //recordUser();
  
  
  /*PGraphics pgColorSil = createGraphics(640,480);
  pgColorSil.beginDraw();
  for(int ix=0; ix<pgSaver.width; ix++){
    for(int iy=0; iy<pgSaver.height; iy++){
      if(pgSaver.get(ix,iy)==color(0,0,0)){
        color c = cam.get(ix,iy);
        pgColorSil.set(ix,iy,c);  
      }   
    }
  }
  pgColorSil.endDraw();
  image(pgColorSil,0,0);*/
  
  /*for(int ix=0; ix<offscreen1.width; ix++){
    for(int iy=0; iy<offscreen1.height; iy++){
      if(pgSaver.get(ix,iy) == color(0,0,0)){
        color c1 = color(0,0,0,100);
        offscreen1.set(ix,iy,c1);
      }
    }
  }*/
    //offscreen1.endDraw();
    
  PImage img = silHR();
  image(img,0,0);
  
  //PImage img2 = new PImage(img.width, img.height);
  //img2.copy(img,0,0,img.width,img.height,0,0,img.width,img.height);
  //img2.resize(100,100);
  
  PGraphics pgColorSil = createGraphics(640,480);
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
  image(pgColorSil,0,0);
  
  /*img.set(0,0,pgColorSil);
  
  pg.beginDraw();
  //pg.set(0,0,cam);
  pg.background(0);
  pg.image(img,0,0);
  pg.endDraw();
  

  //image(img,0,0);
    
  for(CornerPinSurface cps : surfaceList){
    cps.render(pg);
  }*/
  
  //surface1.render(pg);
  //surface2.render(pg);
  
      // Draw the scene, offscreen
  //offscreen3.beginDraw();
  //offscreen3.background(0,0,255);
  //offscreen.image(cam,0,0);
  //offscreen3.endDraw();
  //surface3.render(pg);
  //surface4.render(pg);
  //surface5.render(pg);
  //surface6.render(pg);

  
  /*pg2.beginDraw();
  for(int ix=0; ix<4; ix++){
    for(int iy=0; iy<4; iy++){
      color c = color(150,10,50);
      //println(c);
      pg2.set(ix,iy,c);
    }
  } 
  pg2.background(255,255,255);
  pg2.endDraw();*/
  
  /*pg1.beginDraw();
  for(int ix=0; ix<4; ix++){
    for(int iy=0; iy<4; iy++){
      color c = cam.get(ix,iy);
      //println(c);
      pg1.set(ix,iy,c);
    }
  }  
  pg1.background(255);
  //pg1.image(cam,0,0,4,4);
  //pg1.endDraw();
  
  pg2.beginDraw();
  for(int ix=0; ix<4; ix++){
    for(int iy=0; iy<4; iy++){
      color c = cam.get(ix,iy);
      //println(c);
      pg2.set(ix,iy,c);
    }
  } 
  pg2.background(255,255,255);
  pg2.endDraw();
  
  pg3.beginDraw();
  for(int ix=0; ix<4; ix++){
    for(int iy=0; iy<4; iy++){
      color c = cam.get(ix,iy);
      //println(c);
      pg3.set(ix,iy,c);
    }
  } 
  pg3.background(255,255,255);
  pg3.endDraw();
  
  pg4.beginDraw();
  for(int ix=0; ix<4; ix++){
    for(int iy=0; iy<4; iy++){
      color c = cam.get(ix,iy);
      //println(c);
      pg4.set(ix,iy,c);
    }
  }
  pg4.background(255,255,255); 
  pg4.endDraw();*/
  
  ledScreen1.beginDraw();
  //PImage img;
  //img = loadImage("/Users/mariushoggenmuller/Downloads/test.jpg");
  ledScreen1.set(0,0,cam);
  ledScreen1.endDraw();

  PImage imgZs = ledScreen1.get(0, 0, ledScreen1.width, ledScreen1.height);
  imgZs.resize(24,20);
  //imgZs = gestureLive();
  //image(ledScreen1,0,0);
  //image(pg1,0,0);
  int zaehler=0;
  PGraphics pgS = createGraphics(4,4,JAVA2D);
  for(int ix=0; ix<map.length; ix++){
   for(int iy=0; iy<map[ix].length; iy++){
     if(map[ix][iy]==1){
       //print(ix);
       //print(" ");
       //println(iy);
       zaehler++;
       pgS.beginDraw();
       for(int ixp=0; ixp<4; ixp++){
        for(int iyp=0; iyp<4; iyp++){
          color c = imgZs.get(ix*4+ixp,iy*4+iyp);
          //println(c);
          pgS.set(ixp,iyp,c);
        }
       }
       pgS.endDraw();
       //if(zaehler-1==ran){
        //pgS.background(255); 
        //image(pgS, 0, iy*4);
       //}
       screenList.get(zaehler-1).update(pgS);
       //screenMap[ix][iy].update(pgS);
       //pgS = ledScreen1.get(ix*4,iy*4,4,4);
     }
   }
    
  }
  
  if(frameCount%10==0){
  if(ran<24){
    ran++;
  }else{
    ran=0;
  }
  }
  
  dmx.send();
  
  /*for(LEDScreen s : screenList){
    s.update(pg1);
  }*/
  //println("Bla");
  /*screen1.update(pgS);
  screen2.update(pg1);
  screen3.update(pg1);
  screen4.update(pg1);
  screen5.update(pg1);
  screen6.update(pg1);
  screen7.update(pg1);
  screen8.update(pg1);
  screen9.update(pg1);
  screen10.update(pg1);
  screen11.update(pg1);
  screen12.update(pg1);
  screen13.update(pg1);
  screen14.update(pg1);
  screen15.update(pg1);
  screen16.update(pg1);
  screen17.update(pg1);
  screen18.update(pg1);
  screen19.update(pg1);
  screen20.update(pg1);
  screen21.update(pg1);
  screen22.update(pg1);
  screen23.update(pg1);
  screen24.update(pg1);*/
  
  //drawStructure();
  
  //image(pg,0,0);
  
  
  //stroke(0);
  //rect(50,(int)num,10,10);
  
  //image(cam, 0, 0);
 
  silContext.update(); 
  
}

void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  }
}


void drawStructure(){
  
if(t>100){
    t=0;
  }
  t++;
  
if(br>255){
  br=0;
}
br++;

  //t=(int)(random(0,100));
  pg.beginDraw();
  pg.background(0);
  pg.lights();
  pg.fill(255, 0, 175);
  //stroke(0, 150, 150);
  pg.noStroke();
  /*camera(2000, 2000, 2000,
         0, 0, 0, // centerX, centerY, centerZ
        -1.0, 1.0, -1.0); // upX, upY, upZ*/
  //translate(0, height/2, -300);
  //rotateX(70);

 noiseSeed(1);
  float xoff = 0.0; // Start xoff at 0
  noiseDetail(8,0.3);
  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (int x = 0; x < 63; x++) {
    xoff += increment;   // Increment xoff
    float yoff = 0.0;   // For every xoff, start yoff at 0
    for (int y = 0; y < 63; y++) {
      yoff += vel; // Increment yoff
      float z = noise(xoff,yoff,zoff)*600;
      val[x][y] = t*sin(0.4*x+5)+t*sin(0.4*y+5)+z;
    }
  }

 for (int x=0; x<xSize-1; x++){
    for(int y=0; y<ySize-1; y++){
      pg.fill((val[x][y])+50,(val[x][y])+20,(val[x][y])+20);
      pg.beginShape();
      pg.vertex(x*d, y*d, 0);
      pg.vertex( x*d+d, y*d, 0);
      pg.vertex(x*d+d, y*d+d, 0);
      pg.vertex(x*d, y*d+d,0);
      pg.endShape(CLOSE);
    }
  }
  zoff += zincrement; // Increment zoff
  pg.endDraw();
  //image(pg,0,0);
  
}

void serialEvent(Serial myPort) {
  try {
    myString = myPort.readStringUntil(lf);
    //println(myString);
    if(myString!=null){
    //print(myString);
    String[] spl1 = split(myString, ':');
    if(spl1[0].compareTo("ypr")==0){
    //String[] spl11 = split(myString, ':');
  
    num = Double.parseDouble(spl1[1]);
    //print(num);
    }
    if(spl1[2].compareTo("vel")==0){
        //print(spl1[2]);

    vel = 120+Double.parseDouble(spl1[5]);
    print(vel);
    newVal = true;
    }
    }
  } catch (Exception e) {
    //println("Initialization exception");
  }
}


/*
 * This code is used by the selectInput() method to get the filepath.
 */
void fileSelected(File selection) {
  /*
   * Here's how to play back a sample.
   * 
   * The first line gives you a way to choose the audio file.
   * The (commented, optional) second line allows you to stream the audio rather than loading it all at once.
   * The third line creates a sample player and loads in the Sample.
   * SampleManager is a utility which keeps track of loaded audio
   * files according to their file names, so you don't have to load them again.
   */
  String audioFileName = selection.getAbsolutePath();
  player = new SamplePlayer(ac, SampleManager.sample(audioFileName));
  glide = new Glide(ac, 1);
  player.setRate(glide);
  //player.setKillOnEnd(true);
  songLength = player.getSample().getLength();
  /*
   * And as before...
   */
  Gain g = new Gain(ac, 2, 0.9);
  g.addInput(player);
  ac.out.addInput(g);
  ac.start();
  
  changed = true;
  /*
   * Note there is a lot more you can do. e.g., Varispeed. Try adding this...
   Envelope speedControl = new Envelope(ac, 1);
   player.setRate(speedControl);
   speedControl.addSegment(1, 1000);  //wait a second
   speedControl.addSegment(-0.5, 3000); //now rewind
   *
   */
   
}

void changeSong(){
    File file = new File("/Users/mariushoggenmuller/Documents/Processing/CCBerlin_2_/audio");
    String names[] = file.list();
    int i = (int)random(0, names.length-1);
    String name = "/Users/mariushoggenmuller/Documents/Processing/CCBerlin_2_/audio/" + names[i];
    println(name);
    File selection = new File(name);
    String audioFileName = selection.getAbsolutePath();
    player = new SamplePlayer(ac, SampleManager.sample(audioFileName));


    glide = new Glide(ac, 1);
    player.setRate(glide);
    //player.setKillOnEnd(true);
    songLength = player.getSample().getLength();
    /*
     * And as before...
     */
    Gain g = new Gain(ac, 2, 0.9);
    g.addInput(player);
    ac.out.addInput(g);
    ac.start();
}

void contrast(){
  
  pg1.beginDraw();
  //pg1.clear();
  pg1.colorMode(RGB,255,255,255,255);
  pg1.noStroke();
  pg1.fill(100,100,100);
  pg1.rect(0,0,2,2);
  //pg1.rect(0,0,4,4);
  pg1.endDraw();
  
  offVideo.beginDraw();
  offVideo.background(255,abs((int)vel));
  offVideo.endDraw();
  
  //println(vel);
  
  if(br<255 && (!newVal)){
    br = br +5;
  }else if(!newVal){
    br=0;
  }
  
}

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  record = true;
  recNum++;
  
  silContext.startRec();
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
  
  record = false;
  silContext.stopRec();

}

PImage gestureLive(){
  
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
      }
    }
  }  
  pgSaver.updatePixels();
  pgSaver.endDraw();
  
  PImage imgZs = pgSaver.get(0, 0, pgSaver.width, pgSaver.height);
  imgZs.resize(24,20);
  
  PGraphics pgColorSil = createGraphics(24,20);
  pgColorSil.beginDraw();
  for(int ix=0; ix<imgZs.width; ix++){
    for(int iy=0; iy<imgZs.height; iy++){
      if(imgZs.get(ix,iy)==color(0,0,0)){
        color c = cam.get(ix,iy);
        pgColorSil.set(ix,iy,c);  
      }   
    }
  }
  pgColorSil.endDraw();
  //image(pgColorSil,100,100);
  return(pgColorSil);
}

PImage silHR(){
  //background(0);
  PImage[] images = silContext.silList.get(0);
  int numFrames = images.length;
  currentFrame = (currentFrame+1) % numFrames;  // Use % to cycle through frames
  int offset = 0;
  image(images[currentFrame],0,0);
  return images[currentFrame];
  /*for (int x = -100; x < width; x += images[0].width) { 
    image(images[(currentFrame+offset) % numFrames], x, -20);
    offset+=2;
    image(images[(currentFrame+offset) % numFrames], x, height/2);
    offset+=2;
  }*/
}

