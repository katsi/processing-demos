void drawOtherTrees () {
  
  
  
  int trees2Decay = arr.size()/3 - maxNoOfTrees;
  for (int i = 0; i < arr.size(); i += 3) { //if size is 30, i runs from 0 to 27 (0, 3, ..., 24, 27)
    //int decayment = decayIndex.get(i/3);
    
    if (i/3 < trees2Decay) {
      int decayment = max(0, decayIndex.get(i/3) - decayRate);
      decayIndex.put(i/3, decayment);
      
    }
    standingTree(arr.get(i), arr.get(i + 1), arr.get(i + 2), decayIndex.get(i/3));
  }
}