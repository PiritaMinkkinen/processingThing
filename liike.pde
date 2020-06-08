void keyPressed() {   //jos kyttäjä painelee nappeja
  kuinkaUsein = 5;
  if (key == CODED){
    if(keyCode == UP){
      pelaaja.sijainti = ylos();
    }
    if(keyCode == DOWN){
      pelaaja.sijainti = alas();
    }
    if(keyCode == RIGHT){
      pelaaja.sijainti = oikealle();
    }
    if(keyCode == LEFT){
      pelaaja.sijainti = vasemmalle();
    }
  }
  
  if(key == 'w' || key == 'W'){
    pelaaja.sijainti = ylos();
  }
  if(key == 's'|| key == 'S'){
    pelaaja.sijainti = alas();
  }
  if(key == 'a' || key == 'A'){
    pelaaja.sijainti = vasemmalle();
  }
  if(key == 'd'|| key == 'D'){
    pelaaja.sijainti = oikealle();
  }
  
  if(key != 'e' && key != 'E'){  //jos e:tä ei paineta enää voi parantua
    voiParantua = true;
  }
}

public float[] ylos(){   //liikutetaan pelaajaa ylös
  float[] pelaajanSijainti = pelaajanSijainti(pelaaja.sijainti[0], pelaaja.sijainti[1], 0, -pelaaja.nopeus);
  return(pelaajanSijainti);
}

public float[] oikealle(){  //liikutetaan pelaajaa oikealle
  float[] pelaajanSijainti = pelaajanSijainti(pelaaja.sijainti[0], pelaaja.sijainti[1], pelaaja.nopeus, 0);
  return(pelaajanSijainti);
}

public float[] alas(){   //liikutetaan pelaajaa alas
  float[] pelaajanSijainti = pelaajanSijainti(pelaaja.sijainti[0], pelaaja.sijainti[1], 0, pelaaja.nopeus);
  return(pelaajanSijainti);
}


public float[] vasemmalle(){  //liikutetaan pelaajaa vasemmalle
  float[] pelaajanSijainti = pelaajanSijainti(pelaaja.sijainti[0], pelaaja.sijainti[1], -pelaaja.nopeus, 0);
  return(pelaajanSijainti);
}


void keyReleased(){
  kuinkaUsein = 10;  //animaatio hidastuu
} 

public float[] pelaajanSijainti(float x, float y, float muutosX, float muutosY){  //lasketaan pelaajan uusi sijainti
  float[] pelaajanKoordinaatit = {x+muutosX,y+muutosY};
  return(pelaajanKoordinaatit);
}


public float[] pelaajanPuku(Nelio pelaaja){   //animaatio
  float aika = 0;
  if(pelaaja.koko < 15){
    pelaaja.koko+= muutos*2;
    pelaaja.sijainti = pelaajanSijainti(pelaaja.sijainti[0], pelaaja.sijainti[1], -muutos, 0);
  } else if(pelaaja.koko > 25){
    pelaaja.koko -= muutos*2;
    pelaaja.sijainti = pelaajanSijainti(pelaaja.sijainti[0], pelaaja.sijainti[1], muutos, 0);
  }else{
    if(aika!=millis()){
      if(millis()%30<=14){
        pelaaja.koko += muutos;
        aika = millis();
        pelaaja.sijainti = pelaajanSijainti(pelaaja.sijainti[0], pelaaja.sijainti[1], -muutos/2, 0);
      }else if (millis()%30>=14){
        pelaaja.koko -= muutos;
        aika = millis();
        pelaaja.sijainti = pelaajanSijainti(pelaaja.sijainti[0], pelaaja.sijainti[1], muutos/2, 0);
      }  
    }
  }
  float[] pelaajanPuku = {pelaaja.koko,-pelaaja.koko};
  return(pelaajanPuku);
}
