public void otaDmg(float dmg){  //pelaaja ottaa dmg niin paljon kuin satuttaja sitä tekee
  pelaaja.hp -= dmg;
  if(pelaaja.hp < 1){   //jos pelaajan hp on liian alhainen, häviää
    voitti = false;
    gameOver();
    
  }
}



public void parannu(Nelio parannettava){   //pelaaja parannetaan jos siihem on mahdollisuus
  if(voiParantua){
    parannettava.hp += parannettavaMaara;
  }
}



public void hpBaari(){  //tehdään hp baari
  textSize(12);
  textAlign(LEFT, TOP);
  stroke(0,0,100);
  fill(0,0,100);
  text("Hp:", 10, 10);
  fill(0, 0, 0);
  rect(35, 10, 200, 10);
  
  if(pelaaja.hp > 100){
    pelaaja.hp = 100;
  }
  noStroke();
  fill(0, 100, 100);
  rect(35, 10, pelaaja.hp*2, 10);
}



public void pisteet(){  //näytetään pisteet
  textSize(12);
  textAlign(LEFT, TOP);
  fill(0,0,100);
  text("Pisteet:", 700, 10);
  text(omatSuojat.size() + "/" + vallattavatSuojat, 750, 10);
}




public void valtausPalkki(){ //näytetään paljonko on vallattu ja valtaamatta
  textSize(12);
  int korkeus = 5;
  int leveys = 25;
  int pelaajanMaxKorkeus = 25;
  
  float x = pelaaja.sijainti[0]+pelaaja.koko/2-leveys/2;
  float y = pelaaja.sijainti[1]-pelaajanMaxKorkeus-korkeus;
  stroke(0,0,0);
  fill(0, 0, 100);
  rect(x, y, leveys, korkeus);
  
  noStroke();
  fill(60, 100, 100);
  rect(x, y, 0.166666*ajastus, korkeus);
  stroke(1);
}
