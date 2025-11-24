# Electronics Shop - Rapport

## Databasdesign

Jag har skapat en databas för en elektronikbutik med följande tabeller:

- `brands` - varumärken/tillverkare
- `products` - produkter som tillhör varumärken
- `customers` - kunder
- `orders` - beställningar från kunder
- `order_items` - produkter i varje beställning
- `reviews` - recensioner från kunder på produkter

Relationerna är:
- Varje produkt tillhör ett varumärke
- Varje beställning tillhör en kund
- Varje beställning kan ha flera produkter (via order_items)
- Varje produkt kan ha flera recensioner

### Designval

Jag använde ON DELETE CASCADE på foreign keys så att när man raderar en kund eller produkt så försvinner även relaterade beställningar och recensioner. Det gör det enklare att hantera testdata.

Jag lade till CHECK constraints för att säkerställa att priser är positiva, att rating är mellan 1-5, och att kvantiteter inte kan vara negativa. Detta gör att databasen själv validerar data.

I reviews-tabellen gjorde jag en UNIQUE constraint på (product_id, customer_id) så att en kund bara kan lämna en recension per produkt.

Jag skapade index på alla foreign keys för att göra JOINs snabbare.

## Avancerade SQL-queries

Jag skapade 6 avancerade queries i `queries_advanced.sql`:

1. **Subquery** - Hittar produkter som kostar mer än genomsnittspriset
2. **Subquery med HAVING** - Hittar kunder som har fler beställningar än genomsnittet
3. **Window function (ROW_NUMBER)** - Rankar produkter per varumärke efter pris
4. **Window function (RANK)** - Rankar kunder efter hur mycket de spenderat totalt
5. **CASE** - Kategoriserar produkter i Budget (<1000), Medium (1000-5000) eller Premium (>5000)
6. **CASE med LEFT JOIN** - Kategoriserar kunder som VIP (>3 beställningar), Regular (2-3) eller New (1)

Window functions var lite svårare att förstå först men de är användbara för att ranka saker. CASE är bra för att kategorisera data.

## Index och optimering

Jag identifierade två queries som kunde förbättras med index:

**Query 1:** När man söker efter produkter per varumärke med LOWER(name) så gör databasen en sekventiell scan. Jag skapade ett index på LOWER(brands.name) vilket gör sökningen snabbare.

**Query 2:** Queryn som hittar kunder som spenderat mest gör en JOIN och filtrerar på status. Jag skapade ett kompositindex på (customer_id, status) i orders-tabellen vilket hjälper både JOIN och WHERE.

Jag använde EXPLAIN ANALYZE för att se skillnaden. Före index gjorde databasen seq scan, efter index använder den index scan vilket är snabbare. Även om datasetet är litet nu kommer detta vara viktigt när databasen växer.

## Python-applikation

Jag byggde en Python-applikation med SQLAlchemy ORM. Det finns:

- `models.py` - ORM-modeller för alla tabeller
- `database.py` - Hanterar databasanslutning
- `queries.py` - Funktioner som hämtar produkter, filtrerar på varumärke, och visar kundbeställningar
- `main.py` - Ett enkelt program som demonstrerar funktionerna

SQLAlchemy ORM gör det enklare att arbeta med databasen jämfört med raw SQL. Man kan använda Python-objekt istället för att skriva SQL direkt.

## Slutsats

Projektet innehåller en komplett databas med schema, testdata, queries (både grundläggande och avancerade), indexoptimering, och en Python-applikation. Allt fungerar som det ska och jag har lärt mig mycket om databaser, SQL och Python-integration.
