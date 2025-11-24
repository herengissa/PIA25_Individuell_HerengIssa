# Electronics Shop – Individuell Examination

## Struktur

```
electronics_shop/
├── database.py        # Databasanslutning (psycopg2)
├── main.py            # Enkel CLI som visar hur queries körs
├── queries.py         # Parameteriserade SQL-funktioner
├── README.md          # Denna fil
├── requirements.txt   # Python-beroenden
└── ../sql/
    ├── schema.sql     # Skapar databasen electronics_db
    ├── testdata.sql   # Laddar realistisk testdata
    └── queries.sql    # 10 grundläggande/analytiska SQL-frågor
```

## Kom igång

1. Skapa databasen:
   - Öppna pgAdmin (eller psql) och kör `sql/schema.sql`.
   - Efter `CREATE DATABASE` ansluter du till `electronics_db` och kör resten av filen.
2. Ladda testdata med `sql/testdata.sql`.
3. Installera Pythonberoenden:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate  # Windows: .venv\Scripts\activate
   pip install -r electronics_shop/requirements.txt
   ```
4. Kör demon:
   ```bash
   python -m electronics_shop.main
   ```

## Miljövariabler

Standardinställningarna för `database.py` antar följande:

```
POSTGRES_DB=electronics_db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
```

Överstyr värdena vid behov (t.ex. via `.env` eller terminalen).

