


public Boolean tarkistaEtaisyysSuojista(ArrayList<Suoja> suojat, Nelio botti, Boolean testataanPelaajaa) {
  Boolean omaSuojaPienenee = true;
  for (Suoja suoja : suojat) {  //tarkastetaan kaikki suojat
    float[] etaisyys = etaisyys(suoja.x, suoja.y, botti.sijainti[0], botti.sijainti[1], botti.nopeus, 0, botti.koko/2, true, false);
    if (etaisyys[0]<suoja.r/2) {   //tarkistetaan onko suojan alueella
      if (suoja.variRyhma == botti.variRyhma) {   //tarkistetaan onko oma suoja
        if(testataanPelaajaa){
          parannu(botti);             //pelaajan hp täyttyy kun se menee omaan suojaan
          omaSuojaPienenee = false;
        }
      } else if (testataanPelaajaa) {  //jos on jonkun muun suojassa, ottaa dmg
        otaDmg(suoja.dmg);
        suojanValloitus(suoja);    //mahdollista kaapa suoja
        naytaOhje= true;         //kertoo pelaajalle painaa E:tä
      } else {
        poistettavatNeliot.add(botti);  //jos kohde ei ole pelaaja tai omalla alueella, se on poistettava koska se on jonkun muun suojassa
      }
    } 
  }
  return(omaSuojaPienenee);
}



public void naytaOhje() {
  if (naytaOhje) {
    textAlign(CENTER, CENTER);
    stroke(0, 0, 0);
    fill(0, 100, 0);
    text("E", pelaaja.sijainti[0]+pelaaja.koko/2, pelaaja.sijainti[1]-pelaaja.koko/2);
    naytaOhje = false;         //ei nöytä ohjetta ellei ole suojassa
  }
}



public void suojanValloitus(Suoja suoja) {
  if (ajastus > aika) {
    valloitettu(suoja); //suoja on onnistuttu valtaamaan
    ajastus = 0;
  }

  edellinenVallattuSuoja = suoja;

  if (keyPressed == true) {
    if (key == 'e' || key == 'E') {
      ajastus += 1;             //e:tä on painettava 150 kertaa sen aikana kun ollaan suojassa
      voiParantua = false;   //pelaaja ei voi parantua vallatessaan toista ympyrää
      valtausPalkki();        //näyttää valtaamisen edistyksen
    }
  } else {
    voiParantua = true;       //voidaan taas parantua
    ajastus = 0;
  }
}



public void valloitettu(Suoja suoja) {
  suoja.variRyhma = pelaaja.variRyhma;  //muutetaan suojan arvot sellaisiksi että se tunnistetaan omaksi suojaksi
  suoja.vari = pelaaja.vari;
  omatSuojat.add(suoja);
  voiParantua = true;
  omaSuojaPienenee = false;
}



public void pienennaSuojaa(Suoja suoja) {       //pienennetään suojaa
  suoja.r -= 1;
  if (suoja.r < 1) {
    poistettavatSuojat.add(suoja);
  }
}



public void teeUusiSuoja( Nelio botti) {    //tehdään uusi suoja, jos botit ovat tarpeeksi lähellä toisiaan
  Boolean suojaLupa = true;
  for (Suoja suoja : suojat) {
    float[] etaisyys = etaisyys(suoja.x, suoja.y, botti.sijainti[0], botti.sijainti[1], botti.nopeus, 0, botti.koko/2, true, false);
    if (etaisyys[0] < 10) {        //jos botit eivät ole tarpeeksi lähellä ne eivät voi muodostaa suojaa
      suojaLupa = false;
    }
  }
  if (suojaLupa) {        //kun botit ovat tarpeeksi lähellä suoja muodostetaan 
    Suoja suoja = new Suoja();
    suoja.variRyhma = botti.variRyhma;
    suoja.vari = botti.vari;
    suoja.x = botti.sijainti[0];
    suoja.y = botti.sijainti[1];
    suoja.dmg = botti.dmg/3;
    suojat.add(suoja);
  }
}
