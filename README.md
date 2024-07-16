<p align="center">
  <img width="180" src="assets/logo-circle.png" alt="GameTracker"></img>
  <h1 align="center">GameTracker</h1>
  <p align="center">Applicazione per gestire videogiochi aggiunti
</p>

## ⚒️ Builds

|Piattaforma| Compatibilità | Release                                                                |
|--------|---------------|------------------------------------------------------------------------|
|<p><img width="24" height="24" align="left" src="https://img.icons8.com/nolan/64/android-os.png" alt="android"> Android </p>| ✔ | [Download](https://github.com/ShyVortex/game-tracker/releases/latest) |
|<p><img width="24" height="24" align="left" src="https://img.icons8.com/nolan/64/ios-logo.png" alt="ios"> iOS </p>| ✔ | Non disponibile |

## 📜 Descrizione
GameTracker è un'applicazione per Android e iOS che permette all'utente di aggiungere videogiochi e di tenerne traccia in base a diversi fattori quali piattaforma, ore di gioco, trofei ottenuti, 
data e luogo di completamento, ed highlights, ovvero i ricordi più importanti che si vuole tenere a mente.  
Questa repository che gestisce il frontend applicativo è stata creata per il conseguimento dell'esame 'Programmazione Mobile' della facoltà di Informatica presso l'Università degli Studi del Molise (UNIMOL),
sede di Pesche.  
Il frontend applicativo è stato sviluppato da [Angelo Trotta](https://github.com/ShyVortex) e [Mario Rascato](https://github.com/mariorascato), 
così come il backend, accessibile a quest'altra [repository](https://github.com/mariorascato/GameManager-backend).

## ⚡ Funzionalità
- Creazione account salvato su e sincronizzato da un host remoto
- Personalizzazione profilo
- Aggiunta videogiochi alla libreria
  - Dalla libreria, aggiunta videogiochi ai preferiti
- Gestione luogo di completamento mediante OpenStreetMap
- Modifica campi gioco salvato
- Menù impostazioni con possibilità di cambio tema da Chiaro a Scuro e viceversa
- Visualizzazione informazioni app

## Dipendenze
Per buildare l'applicazione è necessaria la pre-installazione di [Flutter](https://flutter.dev/) e la sua configurazione su qualsiasi IDE o code editor.
Qui di seguito sarà elencato solamente il procedimento di building per Android, dato che è la piattaforma per cui l'applicazione è stata pensata e testata principalmente.  
Se volete buildarla per altre piattaforme, fare riferimento a [Flutter Multi-Platform](https://flutter.dev/multi-platform).  
È possibile procedere alla build aprendo una finestra di terminale nella directory di lavoro e digitando:
 ```shell
 flutter build apk
 ```
Il deliverable generato sarà disponibile in 'app/outputs/apk/release'.

## Riconoscimenti
- [Flaticon](https://www.flaticon.com/) per il logo dell'applicazione,
- [pub.dev](https://pub.dev/) per i plugins utilizzati,
- Google per il font [Inter](https://fonts.google.com/specimen/Inter),
- [Render](https://render.com/) per l'hosting sia del database che del backend web service.

## Licenza
- Questo progetto è distribuito sotto i termini della [GNU General Public License v3.0](https://github.com/ShyVortex/game-tracker/blob/master/LICENSE.md).
- Copyright di [@ShyVortex](https://github.com/ShyVortex) e [@mariorascato](https://github.com/mariorascato), 2024.
