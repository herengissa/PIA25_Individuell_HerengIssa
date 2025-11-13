# ⚡️ Electronics Shop Analytics

Ett examinationsprojekt som analyserar en onlinebutik för elektronik. Lösningen följer kraven i kursens individuella examination *Databasanalys och SQL* och fokuserar på produkter, varumärken, kunder, beställningar och recensioner.

## 📦 Projektstruktur
```
electronics-shop/
├── sql/
│   ├── schema.sql       # Skapar databasen electronics_db och alla tabeller
│   ├── testdata.sql     # Realistisk testdata (brands, products, orders, reviews)
│   └── queries.sql      # 10 grundläggande/analytiska SQL-frågor (Del 1)
├── electronics_shop/
│   ├── __init__.py
│   ├── database.py      # psycopg2-anslutning med miljövariabler
│   ├── queries.py       # Parameteriserade query-funktioner
│   ├── main.py          # Enkel CLI-demonstration
│   ├── README.md        # Instruktioner för delmomenten
│   └── requirements.txt # Python-beroenden för CLI:t
├── requirements.txt     # (valfritt) extra verktyg för vidare analys
└── README.md            # Denna fil
```

## 🚀 Kom igång

### 1. Skapa databasen i pgAdmin (eller psql)
1. Kör `sql/schema.sql`. Filen skapar databasen `electronics_db`, återanslut och skapar alla tabeller, index och constraints enligt specifikationen.
2. Kör `sql/testdata.sql` för att fylla databasen med testdata (3 varumärken, 10 produkter, 5 kunder, 10 beställningar, 10 recensioner).

### 2. Kör SQL-frågorna
- Öppna `sql/queries.sql` och kör frågorna för att verifiera resultat och täcka kraven: grundläggande SELECT, JOINs och aggregeringar.

### 3. Python-klienten (valfri demo för Del 1.3)
```bash
python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r electronics_shop/requirements.txt
python -m electronics_shop.main
```
Sätt miljövariablerna (`POSTGRES_DB`, `POSTGRES_USER`, osv.) om du inte använder standardinställningarna. Scriptet listar produkter, filtrerar på varumärke och visar beställningar för kund #1.

## ✅ Kravmatchning (Del 1 – G-nivå)
- **Schema**: tabeller för `brands`, `products`, `customers`, `orders`, `order_items`, `reviews` med PK/FK, ON DELETE CASCADE, UNIQUE och CHECK (pris, rating, quantity, lager).
- **Testdata**: minst 3 varumärken, 10 produkter, 5 kunder, 10 beställningar och ratingvariationer.
- **Queries**: 10 frågor med kommentarer enligt kravlistan (grundläggande, JOIN, aggregering).
- **Python**: psycopg2-anslutning, parameteriserade queries, enkel CLI som demonstrerar funktionerna.

## ➕ Nästa steg (för VG)
- Skapa filerna `queries_advanced.sql`, `optimization.sql` och `REPORT.md` enligt uppgiften.
- Lägg till fler Python-funktioner eller Jupyter-notebooks om du vill visualisera resultaten.

Lycka till med den fortsatta analysen! 💡

