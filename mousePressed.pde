void mousePressed() {
  //endThis = true;
}

void keyReleased() {
 if (key == CODED) {
    if (keyCode == UP) {
      freqRate += 0.005;
      textSize(22);
      text(freqRate, 0, height - 5);
      fill(150);
      //println(freqRate);
    } 
    
    else if (keyCode == DOWN) {
      freqRate = max(0, freqRate- 0.005);
      textSize(22);
      text(freqRate, 0, height - 5);
      fill(150);
      //println(freqRate);
    } 
    
    else if (keyCode == RIGHT) {
      levelRate += 10;
      textSize(22);
      text(levelRate, width - 100, height - 5);
      fill(150);
      //println(levelRate);
    } 
    
    else if (keyCode == LEFT) {
      levelRate = max(0, levelRate - 10);
      textSize(22);
      text(levelRate, width - 100, height - 5);
      fill(150);
      //println(levelRate);
    } 
  } 
}