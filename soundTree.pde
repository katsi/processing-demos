
import ddf.minim.*;
import ddf.minim.analysis.*;



Minim minim;
AudioInput input;
FFT fft;

float maxSpec = 0;

float theta;   

//Tree growth parameters
float currentAngle;
float currentHeight;
float targetHeight;
float growthPlace;

ArrayList<Float> arr;
//int arrIndex;

//decay is still buggy
ArrayList<Integer> decayIndex;

float minW = 0.1;
float maxW = 0.4;
int changeW = 0;

float minH = 0.0;
float maxH = 0.3;
int changeH = 0;

float freqRate = 0.02;//how much it opens up, from 0.070-0.084
float levelRate = 100;//how quickly it grows MIGHT BE SMALLER

int maxNoOfTrees = 50;

int decayRate = 5;

int groupNr = 1;//FFT CHANNEL, choose from 0-15

boolean endThis = false;



void setup () {
  //size(640, 360);
  fullScreen();
   
   //pg = createGraphics(width, height, P2D);

  // Audiotool-Box und Mikrofoneingang erstellen 
  // und einrichten. Die '256' bestimmen dabei die 
  // spÃ¤tere AuflÃ¶sung des Spektrums.
  minim = new Minim (this);
  input = minim.getLineIn (Minim.STEREO, 256);
  // FFT-Instanz fÃ¼r die Spektrumsanalyse
  fft = new FFT (input.bufferSize (), 
    input.sampleRate ());
    
  //intial tree things
  growthPlace = maxW * width;
  targetHeight = maxH * height;
  currentAngle = 0.0;
  currentHeight = 0.0;
  arr = new ArrayList<Float>(); 
  //arrIndex = 0;
  
  //decay still buggy
  decayIndex = new ArrayList<Integer>(); 
}

void draw () {
  if (endThis) {
    noStroke();
    color c = color(0, 0, 255, 10);
    fill(c);
    rect(0, 0, width, height);
    
  } else {
  
  background (0);
  
  //soundlevel
  text("level: "+input.mix.level()*20, 120, 10);
  fill(0, 102, 153);
  
  frameRate(30);
  
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  //float currentAngle = (mouseX / (float) width) * 90f;
  
  //Code to get curretAngle
  float h = 0;    
  
  
  float[] group = getGroup (16);
  float specStep = width / group.length;
  for (int i=0; i < group.length; i++) {
    float map = map (group[i], 0, maxSpec, 0, height);
    h = height - map;
    line (i * specStep, h, (i+1) * specStep, h);
    text(i+": "+floor(map), 10, 10*i+10);
    
    fill(0, 102, 153);
  }
  float map = map (group[groupNr], 0, maxSpec, 0, height);
  h = height - map;
  
  if (currentHeight > targetHeight) {
    //stop growing
    arr.add(currentAngle);
    arr.add(currentHeight);
    arr.add(growthPlace);
     
    //reset tree
    currentAngle = 0;  
    currentHeight = 0;  
    
    //select a new place for the new tree in random
    growthPlace = random(minW + maxW*changeW, minW + maxW*changeW + maxW) * width;
    //DONE set a new target height
    targetHeight = random(minH + maxH * changeH, minH + maxH * changeH + maxH) * height; 
    
    //adding variety in location and height class
    changeH = round(random(0,1));
    changeW = round(random(0,1));
  }
  
  currentAngle += map * freqRate;
  currentHeight += input.mix.level() * levelRate;
  standingTree(currentAngle, currentHeight, growthPlace, 255);
  
  //Decaying still buggy
  int noOfDecayingTrees = arr.size() - maxNoOfTrees * 3;  
  
  boolean removeOldTree = false;
  for (int i = arr.size()-3; i >= 0; i -= 3) {
    //println(i);
    if (noOfDecayingTrees > 0 && i < noOfDecayingTrees) {
      if(decayIndex.size() <= i/3 ) {
        decayIndex.add(i/3, 255 - decayRate); 
        //println(decayIndex.get(i/3));
        standingTree(arr.get(i), arr.get(i + 1), arr.get(i + 2), decayIndex.get(i/3));
      }
      else {
        int decayment = decayIndex.get(i/3) - decayRate;
        if (decayment >= 0) {        
          decayIndex.add(i/3, decayment);
          standingTree(arr.get(i), arr.get(i + 1), arr.get(i + 2), decayIndex.get(i/3));
        } else {
          //println("Dead Trees");
           removeOldTree = true; 
        }
      }
      
    }
    else 
      standingTree(arr.get(i), arr.get(i + 1), arr.get(i + 2), 255);
  }
  if (removeOldTree) {
     arr.remove(2); 
     arr.remove(1);
     arr.remove(0);
     decayIndex.remove(0);
     //println("DecayIndex size: " + decayIndex.size());
     
  }
  }
}

void standingTree(float a, float b, float growthPlace, int colour) {
  //println(colour);
  stroke(colour);
  
  pushMatrix();    // Save the current state of transformation (i.e. where are we now)
   
  // Convert it to radians
  theta = radians(min(a, 55f));
  // Start the tree from the bottom of the screen
  translate(growthPlace, height);
  // Draw a line 120 pixels
  line(0, 0, 0, -b);
  // Move to the end of that line
  translate(0, -b);
  // Start the recursive branching!
  branch(b);
  
  popMatrix();
  
}