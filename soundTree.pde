
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

float[] otherTreesCurrentAngle;
float[] otherTreesCurrentHeight;
float[] otherTreesGrowthPlace;
int[] otherTreesColoursRed;
int[] otherTreesColoursGreen;
int[] otherTreesColoursBlue;

float minW = 0.1;
float maxW = 0.4;
int changeW = 0;

float minH = 0.01;
float maxH = 0.23;
int changeH = 0;

float freqRate = 0.1;//how much it opens up, from 0.070-0.084 at #MTF, 0.2..0.1 at Flow
float levelRate = 40;//how quickly it grows 

int maxNoOfTrees = 2;

int decayRate = 3;

int groupNr = 1;//FFT CHANNEL, choose from 0-15

boolean endThis = false;

boolean flag;

void setup () {
  size(768, 512);
  //fullScreen();

  flag = false;

  //pg = createGraphics(width, height, P2D);

  // Audiotool-Box und Mikrofoneingang erstellen 
  // und einrichten. Die '256' bestimmen dabei die 
  // spÃ¤tere AuflÃ¶sung des Spektrums.
  minim = new Minim (this);
  input = minim.getLineIn (Minim.STEREO, 256);
  // FFT-Instanz fÃ¼r die Spektrumsanalyse
  fft = new FFT (input.bufferSize (), 
    input.sampleRate ());

  //intial tree settings
  growthPlace = maxW * width;
  targetHeight = maxH * height;
  currentAngle = 0.1;
  currentHeight = 0.0;

  otherTreesCurrentAngle = new float[maxNoOfTrees*40/decayRate];
  otherTreesCurrentHeight = new float[maxNoOfTrees*40/decayRate];
  otherTreesGrowthPlace = new float[maxNoOfTrees*40/decayRate];
  otherTreesColoursRed = new int[maxNoOfTrees*40/decayRate];
  otherTreesColoursGreen = new int[maxNoOfTrees*40/decayRate];
  otherTreesColoursBlue = new int[maxNoOfTrees*40/decayRate];
}

void draw () {

  if (!flag) {
    surface.setLocation(0, 0);
    flag = true;
  }
  
  if (endThis) {
    noStroke();
    color c = color(0, 0, 255, 10);
    fill(c);
    rect(0, 0, width, height);
  } else {

    background (0);

    //soundlevel
    /*text("level: "+input.mix.level()*20, 120, 10);
     fill(0, 102, 153);*/

    //frameRate(25);

    // Let's pick an angle 0 to 90 degrees based on the mouse position
    //float currentAngle = (mouseX / (float) width) * 90f;

    //Code to get curretAngle
    float h = 0;    

    //Draw fft group lines
    float[] group = getGroup (16);

    /*float specStep = width / group.length;
     for (int i=0; i < group.length; i++) {
     float map = map (group[i], 0, maxSpec, 0, height);
     h = height - map;
     line (i * specStep, h, (i+1) * specStep, h);
     //text(i+": "+floor(map), 10, 10*i+10);
     
     fill(0, 102, 153);
     }*/

    float map = map (group[groupNr], 0, maxSpec, 0, height);
    h = height - map;

    if (currentHeight > targetHeight) {
      //stop growing and save tree to otherTrees*

      for (int i = otherTreesCurrentAngle.length - 1; i > 0; i--) {
        otherTreesCurrentAngle[i] = otherTreesCurrentAngle[i-1];
        otherTreesCurrentHeight[i] = otherTreesCurrentHeight[i-1];
        otherTreesGrowthPlace[i] = otherTreesGrowthPlace[i-1];
        otherTreesColoursRed[i] = otherTreesColoursRed[i-1];
        otherTreesColoursGreen[i] = otherTreesColoursGreen[i-1];
        otherTreesColoursBlue[i] = otherTreesColoursBlue[i-1];
      }    

      otherTreesCurrentAngle[0] = currentAngle;
      otherTreesCurrentHeight[0] = currentHeight;
      otherTreesGrowthPlace[0] = growthPlace;
      otherTreesColoursRed[0] = 255;
      otherTreesColoursGreen[0] = 255;
      otherTreesColoursBlue[0] = 255;

      //reset tree
      currentAngle = 0.1;  
      currentHeight = 0;  

      //select a new place for the new tree in random
      growthPlace = random(minW + maxW*changeW, minW + maxW*changeW + maxW) * width;
      //DONE set a new target height
      targetHeight = random(minH + maxH * changeH, minH + maxH * changeH + maxH) * height; 

      //adding variety in location and height class
      changeH = round(random(0, 1));
      changeW = round(random(0, 1));
    }

    currentAngle += map * freqRate;
    currentHeight += 1 + input.mix.level() * levelRate;

    drawOtherTrees();
    standingTree(currentAngle, currentHeight, growthPlace, 255, 255, 255);
  }
}

void standingTree(float a, float b, float growthPlace, int red, int green, int blue) {
  //println(colour);
  stroke(red, green, blue);

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