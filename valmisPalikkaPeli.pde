import java.util.ArrayList;
import java.util.Random;
import java.util.HashMap;
import java.util.Collections;

Boolean omaSuojaPienenee = true;
Boolean pyorii = true;
Boolean ekaKerta = true;
Boolean voitti = false;
Boolean voiParantua = true;
Boolean naytaOhje = false;

float parannettavaMaara = 5;
float kerroin = 2;
float muutos = 2;
float kuinkaUsein = 20;
float aika = 150;
float bottienNopeus = 2.5;

int seuraava = 0;
int ajastus = 0;
int loppuSekunnit;
int loppuMinuutit;
int suojanR = 60;
int value = 0;  
int kerta = 0;
int vallattavatSuojat = 20;
int uusienMaara = 10; 

Nelio pelaaja = new Nelio();
Suoja suoja = new Suoja();
Vektori v = new Vektori();

Suoja edellinenVallattuSuoja;

ArrayList<Suoja> suojat = new ArrayList<Suoja>();
ArrayList<Suoja> omatSuojat = new ArrayList<Suoja>();
ArrayList<Nelio> botit = new ArrayList<Nelio>();
ArrayList<Nelio> uudetBotit = new ArrayList<Nelio>();
ArrayList<Nelio> ehkaPoistettavat = new ArrayList<Nelio>();
ArrayList<Nelio> poistettavatNeliot = new ArrayList<Nelio>();
ArrayList<Suoja> poistettavatSuojat = new ArrayList<Suoja>();



void setup() {
  size(800, 600);
  frameRate(60);
  background(0, 0, 0);
  colorMode(HSB,100);
  teeObjektit(uusienMaara);
  suojat.add(suoja);
  botit.addAll(uudetBotit); //tehdään ensimmäiset botit
}


//suojien luokka
public class Suoja{
  float x = random(0,800);
  float y = random(0,600);
  float r = suojanR;
  float[] vari = {0,0,100};
  String variRyhma = "valkoinen";
  float dmg = 0;
}


//bottien ja pelaajan luokka
public class Nelio {
  String tyyppi;
  String variRyhma = "valkoinen";
  String tavoite;
  
  float[] sijainti = {100, 100};  //omat koordinaatit
  float[] asu = {100, 100};
  float[] vari = {0,0,100};
  float[] kohdeKaveri = null;  //kohteen koordinaatit
  
  float nopeus = 10;
  float koko = 5;
  float dmg = 1;
  float hp = 100;
  
  Nelio seurattava;
}



public class Vektori {
  float x;
  float y;
  float etaisyys;
}



void draw() {
  if(pyorii){
    if(ekaKerta){
      omatSuojat.add(suoja);
      ekaKerta = false;
    }
    
    background(value, 0, 0);
    hpBaari();
    pisteet();
  
    if(omatSuojat.size() == vallattavatSuojat){
      gameOver();
      voitti = true;
    }
  
    if (kerta%kuinkaUsein==0) {
      pelaaja.asu = pelaajanPuku(pelaaja);  //pelaajan animaatio
    }
    
    for (Nelio botti : botit) {  //köydään läpi kaikki botit
      //tarkistetaan koskeeko pelaajaa
      Boolean koskeePelaajaa = koskeekoPelaajaa(pelaaja, botti);
      if(koskeePelaajaa || botti.sijainti[0] < 0 || botti.sijainti[1] < 0 || botti.sijainti[0] > 800 || botti.sijainti[1] > 600){   //siirretään poistettavien joukkoon jos ulkona ruudusta tai koskee pelaajaa
        poistettavatNeliot.add(botti);
        if(koskeePelaajaa) {
          otaDmg(botti.dmg);   //jos botti on elossa se saa liikkua
        }
      } 
      botti.sijainti = laatikkoLiike(pelaaja, botti, botit, suojat);
      fill(botti.vari[0], botti.vari[1], botti.vari[2]);   //liikutetaan bottia
      rect(botti.sijainti[0], botti.sijainti[1], botti.koko, botti.koko);
    }
    
    //poistetaan poistettavaksi merkityt
    poistaPoistettavat();
 
    for(Suoja suoja : suojat){  //piirretään suojat
      fill(suoja.vari[0], suoja.vari[1], suoja.vari[2]);
      noStroke();
      ellipse(suoja.x, suoja.y, suoja.r, suoja.r);
      stroke(1);
    }
  
    //piirretään pelaaja
    stroke(1);
    stroke(0,0,0);
    omaSuojaPienenee = tarkistaEtaisyysSuojista(suojat, pelaaja, true);
    fill(pelaaja.vari[0], pelaaja.vari[1], pelaaja.vari[2]);
    rect(pelaaja.sijainti[0], pelaaja.sijainti[1], pelaaja.asu[0], pelaaja.asu[1]);
  
    naytaOhje();



    kerta += 1;
    if (kerta > 30){
      kerta = 0;
      teeObjektit(uusienMaara/2*omatSuojat.size());  //tehdään uusia botteja omien suojien määrästä riippuen
      botit.addAll(uudetBotit);   //lisätään kaikki bottilistaan
   
     for(Suoja suoja : omatSuojat){   
       if(omaSuojaPienenee){
         pienennaSuojaa(suoja);
       } else{
         suoja.r=suojanR;
       }
    }
  }
  }
  else{   //kun peli loppuu
    background(0,0,0);
    textAlign(CENTER, CENTER);
    textSize(30);
    fill(0,0,100);
    String loppuTeksti;
    if(voitti){
      loppuTeksti = "Voitit!";
    }else{
      loppuTeksti = "Hävisit!";
    }
    text(loppuTeksti, 400, 300);
    
    text("Siihen meni: "+ loppuMinuutit+ " min " + loppuSekunnit + " s" ,400, 330);
    if(edellinenVallattuSuoja == null){}
    else{
      if(edellinenVallattuSuoja.r < 10000){
        edellinenVallattuSuoja.r += 100;
        fill(edellinenVallattuSuoja.vari[0], edellinenVallattuSuoja.vari[1],edellinenVallattuSuoja.vari[2]);
        noStroke();
        ellipse(edellinenVallattuSuoja.x,edellinenVallattuSuoja.y, edellinenVallattuSuoja.r, edellinenVallattuSuoja.r);
        stroke(1);
      }
    }
    }
   
}



public void poistaPoistettavat(){
  for(Nelio poistettavaNelio : poistettavatNeliot){
    for(Nelio botti : botit){
      if(poistettavaNelio == botti.seurattava){
        botti.seurattava = null;     //kun poistetaan botti, on varmistettava että kukaan ei yritä seurata olematonta bottia
      }
    }
    botit.remove(poistettavaNelio);     //botti poistetaan kaikkien bottien listasta
  }
  for(Suoja poistettavaSuoja : poistettavatSuojat){ //myös kuolleet suojat poistetaan
    suojat.remove(poistettavaSuoja);
    omatSuojat.remove(poistettavaSuoja);
  }
  poistettavatNeliot.clear();   //listat tyhjennetään jottei jo poistettuja objekteja yritetö poistaa uudestaan
  poistettavatSuojat.clear();
}
