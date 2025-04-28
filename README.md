# MyProject: C++ Template con Premake, Ninja & vcpkg

**MyProject** è un template C++ progettato per l'utilizzo con **Premake5**, **Ninja** e **vcpkg**. Questo template offre una configurazione moderna e scalabile per gestire progetti C++ con un flusso di lavoro ottimizzato.

---

## Architettura del Progetto

```
my_project/
│
├── src/                  # Codice sorgente (es. main.cpp)
├── external/             # Librerie esterne (scaricate automaticamente da script)
│   └── vcpkg/
├── vcpkg.json            # Dipendenze C++ (gestite tramite vcpkg)
├── premake5.lua          # Script di configurazione Premake
└── README.md             # Documentazione
```

---

## Strumenti Utilizzati

| Strumento   | Descrizione                                 | Link |
|-------------|---------------------------------------------|------|
| **Premake5** | Generatore di file di progetto              | https://premake.github.io/ |
| **Ninja**   | Build system rapido e scalabile             | https://ninja-build.org/  |
| **vcpkg**   | Gestore di pacchetti C++                    | https://vcpkg.io/         |

---

## Flusso di Build

1. **Premake5** scarica e configura **vcpkg** automaticamente.
2. **Premake5** esegue il bootstrap di **vcpkg** con telemetria disabilitata.
3. **Premake5** installa le dipendenze lette da `vcpkg.json`.
4. **Premake5** genera i file di build per **Ninja**.
5. **Ninja** compila il progetto.
6. **Esegui** il binario generato.

---

## Aggiungere Nuove Dipendenze

1. Modifica il file `vcpkg.json` aggiungendo il nome del pacchetto.
2. Rigenera i file di progetto:

   ```bash
   premake5 ninja
   ```

3. Compila il progetto:

   ```bash
   ninja
   ```

---

## Suggerimenti Avanzati

- **Telemetria disabilitata**: ogni comando vcpkg è eseguito con `VCPKG_DISABLE_METRICS=1`.
- **Cache intelligente**: bootstrap/install eseguiti una sola volta grazie a flag interni Lua.
- **Triplet automatico**: determinato da `os.istarget()`; personalizzabile per triplet custom.
- **Parallelismo in Ninja**: utilizzare `ninja -j$(nproc)` o `ninja -j %NUMBER_OF_PROCESSORS%`.
- **Configurazioni multiple**: specificare `--config=Release` in Premake per build ottimizzate.

---

## Troubleshooting Avanzato

| Problema                                     | Soluzione                                                                                  |
|----------------------------------------------|--------------------------------------------------------------------------------------------|
| vcpkg non scaricato                         | Verifica connessione/proxy; imposta `HTTP_PROXY` / `HTTPS_PROXY` se dietro firewall.      |
| Errore durante il bootstrap                  | Esegui manualmente `bootstrap-vcpkg.sh` o `.bat` in `external/vcpkg/`.                     |
| Dipendenze mancanti o versioni incorrette     | Controlla `vcpkg.json` e rilancia `premake5 ninja`.                                        |
| Linker error “undefined reference”           | Aggiungi il nome esatto della libreria in `links { ... }` in `premake5.lua`.              |
| Compilazione lenta                           | Usa `Release` e `ninja -j`; aggiungi `-O2`/`-O3` in `buildoptions` per Linux/macOS.        |
| Aggiornamento vcpkg o pacchetti              | Esegui `git -C external/vcpkg pull` e `bootstrap-vcpkg`, poi `vcpkg upgrade --no-dry-run`. |
| Errori di permessi su Windows                | Esegui PowerShell come Amministratore o usa prompt con privilegi elevati.                  |

---

## Comandi Rapidi

```bash
premake5 ninja       # Genera build.ninja
ninja                # Compila
./bin/Debug/MyProject  # Esegue il binario
```

---

## Requisiti

- **Git**  
- **Ninja** (`apt install ninja-build` su Linux)  
- **Compilatore C++17** (g++ 9+, clang++, MSVC 2019+)  

