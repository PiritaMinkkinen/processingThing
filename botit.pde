//liikuttaa botteja
public float[] laatikkoLiike(Nelio pelaaja, Nelio botti,ArrayList<Nelio> botit, ArrayList<Suoja> suojat){
  int max = 1;
  String[] toimiLista = {"pelaajanPerassa","kokoontumassa"};
  
  tarkistaEtaisyysSuojista(suojat, botti, false);  //poistaa botin jos se on suojan alueella
  
  if(botti.tavoite == null){
    //jos tavoite on tyhä, botti ottaa sellaisen itselleen
    botti.tavoite = toimiLista[seuraava];
    if(seuraava < max){seuraava += 1;}
    else{seuraava = 0;}
    } 
    else if(botti.tavoite == "pelaajanPerassa"){  //botti menee pelaajaa kohti
      botti.sijainti = etaisyys(pelaaja.sijainti[0], pelaaja.sijainti[1], botti.sijainti[0], botti.sijainti[1],  botti.nopeus ,pelaaja.koko/2, botti.koko/2, false, true);
    } 
    else if(botti.tavoite == "kokoontumassa"){  //botti etsii kohteen itselleen ja jahtaa sitä
      botti.sijainti = etsiKaverit(botit, botti);
      int kaverienMaara = kaverienMaara(botit, botti);
      if(kaverienMaara > 4){     //jos botteja on tarpeeksi syntyy suoja
       teeUusiSuoja( botti);
       poistaKaverit(botti);
      }    
    }
  return(botti.sijainti);
}


public int kaverienMaara(ArrayList<Nelio> botit, Nelio nykynenBotti){  //laskee kaverit jotka ovat tarpeeksi lähellä
  int maara = 0;
  for(Nelio botti : botit){
    if(botti.variRyhma == nykynenBotti.variRyhma && botti.sijainti != nykynenBotti.sijainti){
      float[] etaisyys = etaisyys(botti.sijainti[0], botti.sijainti[1], nykynenBotti.sijainti[0], nykynenBotti.sijainti[1], nykynenBotti.nopeus, botti.koko/2, nykynenBotti.koko/2, true, false);
      if(etaisyys[0] < 20){
        maara += 1;
      }
    }
  }
  return(maara);
}

public void poistaKaverit(Nelio nykynenBotti){   //poistaa botit jotka muodostivat suojan
  poistettavatNeliot.add(nykynenBotti);
  for(Nelio botti : botit){
    if(botti.variRyhma == nykynenBotti.variRyhma && botti.sijainti != nykynenBotti.sijainti){
      float[] etaisyys = etaisyys(botti.sijainti[0], botti.sijainti[1], nykynenBotti.sijainti[0], nykynenBotti.sijainti[1],  nykynenBotti.nopeus, botti.koko/2, nykynenBotti.koko/2, true, false);
      if(etaisyys[0] < 20){
        poistettavatNeliot.add(botti);
      }
    }
  }
}


public float[] etsiKaverit(ArrayList<Nelio> botit, Nelio nykynenBotti){   //etsii lähimmän kaverin ja kertoo uuden sijainnin kun on laskettu mihin suuntaan pitää lähteä
  float[] uudetKoordinaatit = nykynenBotti.sijainti;   //botti ei liiku jos se ei löydä kaveria läheltä
  ArrayList<Nelio> kaverit = new ArrayList<Nelio>();
  ArrayList<Float> matkat = new ArrayList<Float>();
  
  for (Nelio botti : botit){
    Nelio seurattava = botti.seurattava;
    Boolean seurattu = false;
    Boolean pyorii = true;
    
    while(pyorii){
      if(seurattava != nykynenBotti){   //tarkistaa, ettei botti jota aijotaan seuraa itseä, käy kaiken läpi. Näin vältetään jumiin jääminen
        if(seurattava == null){pyorii = false;}
        else{
          seurattava = seurattava.seurattava; 
        }
      }
      else{
        seurattu = true;
        pyorii = false;
      }
    }
    
    if(seurattu){}
    else{    //jos kohdetta voidaan seurata, se lisätään listaan jossa on kaikki mahdolliset seurattavat
      if(botti.variRyhma == nykynenBotti.variRyhma && botti.sijainti != nykynenBotti.sijainti){
        float[] etaisyys = etaisyys(botti.sijainti[0], botti.sijainti[1], nykynenBotti.sijainti[0], nykynenBotti.sijainti[1],  nykynenBotti.nopeus, botti.koko/2, nykynenBotti.koko/2, true, false);
        kaverit.add(botti);
        matkat.add(etaisyys[0]);
      }
    }
  }
  
  if(matkat.size() == 0){}  //käydään 
  else{
    ArrayList<Float> uudetMatkat = new ArrayList<Float>();
    uudetMatkat = matkat;
    Collections.sort(uudetMatkat);
    
    Nelio kohde;
    int i = 0;
    if(matkat.size() == 0){}
    else{
      while(uudetMatkat.get(0)!= matkat.get(i)){
        i += 1;
      }
    }
    kohde = kaverit.get(i);
    nykynenBotti.seurattava = kohde;
    uudetKoordinaatit = etaisyys(kohde.sijainti[0], kohde.sijainti[1], nykynenBotti.sijainti[0], nykynenBotti.sijainti[1],  nykynenBotti.nopeus, kohde.koko/2, nykynenBotti.koko/2, false, false);
  }
  
  if (uudetKoordinaatit == nykynenBotti.sijainti){    //jos sijainti ei muutu, eli ei löydetä kaeria, lähdetään pelaajan perään
    nykynenBotti.tavoite = "pelaajanPerassa";
  }
  
  return(uudetKoordinaatit);
}


public Boolean koskeekoPelaajaa(Nelio pelaaja, Nelio botti){    //tarkistetaan koskeeko pelaajaa
  Boolean koskee = false;
  if(botti.sijainti[0]+botti.koko/2<pelaaja.sijainti[0]+pelaaja.koko && botti.sijainti[0]+botti.koko/2 > pelaaja.sijainti[0]){
    if(botti.sijainti[1]+botti.koko/2<pelaaja.sijainti[1] && botti.sijainti[1]+botti.koko/2 > pelaaja.sijainti[1]-pelaaja.koko){
      koskee = true;
    }
  }
  return(koskee);
}


//lasketaan etäisyys, ja uudet koordinaatit jos niitä tarvitaan
public float[] etaisyys(float maaranpaaX, float maaranpaaY, float alkuX, float alkuY, float nopeus, float lisausMaaranpaa, float lisaysAlku, Boolean vainEtaisyys, Boolean maaranpaaOnPelaaja){
  float lisausMaaranpaa2;         
  if(maaranpaaOnPelaaja){   //pelaajan animaatio kääntää y:n, joten y on käännettävä jotta päästään neliön keskustaan
    lisausMaaranpaa2 = -1*lisausMaaranpaa;
  }else{
    lisausMaaranpaa2 = lisausMaaranpaa;
  }
  v.x = (maaranpaaX+lisausMaaranpaa)-(alkuX+lisaysAlku);
  v.y = (maaranpaaY+lisausMaaranpaa2)-(alkuY+lisaysAlku);
  v.etaisyys = sqrt(v.x*v.x+v.y*v.y);
  float[] sijainti = {1000,1000};
  if(vainEtaisyys == true){
    sijainti[0]=v.etaisyys;
  }else{
    v.x /= v.etaisyys;
    v.y /= v.etaisyys;
    sijainti[0]=alkuX +nopeus*v.x;
    sijainti[1]= alkuY + nopeus*v.y;
  }
  
  return(sijainti);
}




public void teeObjektit(int maara) {   //tehdään uusia botteja
  uudetBotit.clear();   //tyhjennetään uusien bottiwn lista, jotta jo tehtyjä botteja ei lisätä bottilistaan uudestaan
  for (int i = 0; i < maara; ++i) {
    Nelio x = new Nelio();
    x.tyyppi = "botti";
    x.sijainti[0] = random(0, 800);
    x.sijainti[1] = random(0, 600);
    x.vari = ArvoVarit();
    x.nopeus = bottienNopeus;
    uudetBotit.add(x);
    
    String[] varit = {"oranssi","keltainen","vihreä","vihreä","vSininen","vSininen","tSininen","violetti","pinkki","punainen"};
    
    for(int j = 0; j < 10; j++){   //luokitellaan botit niiden värin mukaan
      for(Nelio botti : uudetBotit){
        if(botti.vari[0] >= j*10 && botti.vari[0] < j*10+10){
          botti.variRyhma = varit[j];
        }
      }
    }
  }
}



public float[] ArvoVarit() {    //arvotaan värit uudelle botille
  float[] varit = {random(0, 100), random(50,100), 100}; 
  return(varit);
}
