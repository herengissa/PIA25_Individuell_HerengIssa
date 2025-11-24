# Electronics Shop

Examinationsprojekt för Databasteknik PIA25. Ett databassystem för en elektronikbutik med PostgreSQL och Python.

## Projektstruktur

```
Electronics-Shop/
├── sql/
│   ├── schema.sql          # Skapar databasen och tabeller
│   ├── testdata.sql        # Testdata
│   ├── queries.sql         # 10 grundläggande queries
│   ├── queries_advanced.sql # 6 avancerade queries (VG)
│   └── optimization.sql    # Indexoptimering (VG)
├── electronics_shop/
│   ├── models.py           # SQLAlchemy ORM-modeller
│   ├── database.py         # Databasanslutning
│   ├── queries.py          # Query-funktioner
│   ├── main.py             # Huvudprogram
│   └── requirements.txt    # Python-paket
├── REPORT.md               # Rapport (VG)
└── README.md               # Denna fil
```

## Installation

### 1. Skapa databasen

Kör `sql/schema.sql` i pgAdmin eller psql för att skapa databasen `electronics_db` och alla tabeller.

### 2. Lägg till testdata

Kör `sql/testdata.sql` för att lägga till testdata.

### 3. Installera Python-paket

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r electronics_shop/requirements.txt
```

### 4. Sätt miljövariabler (valfritt)

Om du inte använder standardinställningarna, sätt:
```bash
export POSTGRES_DB=electronics_db
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=ditt_lösenord
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
```

### 5. Kör Python-applikationen

```bash
python -m electronics_shop.main
```

## SQL Queries

- `queries.sql` - 10 grundläggande queries (G-nivå)
- `queries_advanced.sql` - 6 avancerade queries med subqueries, window functions och CASE (VG-nivå)
- `optimization.sql` - Indexoptimering med EXPLAIN ANALYZE (VG-nivå)

