

public void gameOver(){   //kun peli loppuu, lasketaan aika
  loppuSekunnit = millis()/1000;
  loppuMinuutit = loppuSekunnit/60;
  loppuSekunnit = loppuSekunnit-60*loppuMinuutit;
  pyorii = false;
}
