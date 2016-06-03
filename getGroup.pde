float[] getGroup (int theGroupNum) {
  fft.forward (input.mix);

  // Leeres Array fÃ¼r die Gruppen erstellen
  float[] group  = new float[theGroupNum];
  // Das FFT-Spekturm hat eine Stelle mehr 
  // als beim Input definiert. (256->257).
  // Diese wird ignoriert.
  int specLimit  = fft.specSize () - 1;
  // Anzahl der FrequenzbÃ¤nder pro Gruppe
  int groupSize = specLimit / theGroupNum;

  // Alle Gruppen mit einem Startwert fÃ¼llen
  for (int i=0; i < group.length; i++) {
    group[i] = 0;
  }

  // FÃ¼r jedes FFT-Frequenz-Band
  for (int i=0; i < specLimit; i++) {
    // Maximum?
    if (fft.getBand (i) > maxSpec) {
      maxSpec = fft.getBand (i);
    }
    // Jedes Band einer Gruppe zuweisen
    int index = (int) Math.floor (i / groupSize);
    group[index] += fft.getBand (i);
  }

  // Der Wert jeder Gruppe durch die Anzahl
  // der enthaltenen BÃ¤nder Teilen - >Mittelwert
  for (int i=0; i < group.length; i++) {
    group[i] /= groupSize;
  }
  // Gruppe zurÃ¼ck geben.
  return group;
}