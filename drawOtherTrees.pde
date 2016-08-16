void drawOtherTrees () {
  
  
  for (int i = otherTreesCurrentAngle.length - 1; i >= 0; i--) {
    
    if (i >= maxNoOfTrees && otherTreesCurrentHeight[i] > 0.01) {
       int cRand = round(random(0.5,3.4));
       
       switch (cRand) {
          case 1:
          otherTreesColoursRed[i] = max(0, otherTreesColoursRed[i] - decayRate);
        //  println(cRand);
          
          case 2:
          otherTreesColoursGreen[i] = max(0, otherTreesColoursGreen[i] - decayRate);
        //  println(cRand);
          
          case 3:
          otherTreesColoursBlue[i] = max(0, otherTreesColoursBlue[i] - decayRate);
         // println(cRand);
       }
    }
    
    if (otherTreesColoursRed[i] + otherTreesColoursGreen[i] + otherTreesColoursBlue[i] > 0 && otherTreesCurrentHeight[i] > 0.01) {
      standingTree(otherTreesCurrentAngle[i], otherTreesCurrentHeight[i], otherTreesGrowthPlace[i], otherTreesColoursRed[i], otherTreesColoursGreen[i], otherTreesColoursBlue[i]);
    }
    
  }
  
}