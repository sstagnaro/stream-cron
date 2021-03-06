# Stream-Cron
### Introduzione
Stream-cron è un progetto nato dall'esigenza di trasmettere in diretta le celebrazioni sulle piattaforme Facebook e Youtube utilizzando `ffmpeg`, un Raspberry Pi 4 e `cron` per la programmazione delle dirette.
### Utilizzo
Utilizzare lo script è molto semplice:
```shell
./stream_cron.sh -d|--durata hh:mm:ss -yk|--youtube-key <key>  -fk|--facebook-key <key>
```
Dove le varie opzioni consentono di specificare:
* `-d` o `--durata` la durata della diretta con il formato `hh:mm:ss`
* `-yk` o `--youtube-key` la chiave fornita da YouTube Studio per la diretta
* `-fk` o `--facebook-key` la chiave fornita dal pannello di controllo della diretta di Facebook
