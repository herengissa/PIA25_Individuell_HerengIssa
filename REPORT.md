# Electronics Shop – Rapport (VG)

## 1. Databasdesign

### Översikt

Databasen modellerar en onlinebutik för elektronik. Följande tabeller och relationer finns:

- `brands` – tillverkare (1) ↔ `products` – produkter (M).
- `customers` – kunder (1) ↔ `orders` – beställningar (M).
- `orders` (1) ↔ `order_items` – beställningsrader (M) ↔ `products` (M).
- `products` (1) ↔ `reviews` – kundrecensioner (M).

![ER-diagram](docs/er-diagram-electronics-shop.png "ER-diagram")

> Diagrammet visar huvudtabellerna med primärnycklar (fetstil) och foreign keys (streckade linjer). `orders` och `order_items` bildar en klassisk faktatabell/dimension-struktur.

### Designbeslut

- **ON DELETE CASCADE** används där en förälder saknar värde utan sina barn (t.ex. om en kund raderas ska även beställningar och orderrader försvinna). Det förenklar testdata och undviker orphan rows.
- **CHECK constraints** på `price`, `unit_price`, `quantity`, `stock_quantity` och `rating` garanterar dataintegritet direkt i databasen.
- **UNIQUE (product_id, customer_id)** i `reviews` säkerställer att en kund endast lämnar en recension per produkt.
- **Index** på samtliga foreign keys ger snabba JOINs, vilket är viktigt för rapportering och kundvy.

## 2. Avancerade SQL-queries

Se `sql/queries_advanced.sql` för fullständiga definitioner. Kort sammanfattning:

| Nr | Teknik | Syfte |
|----|--------|-------|
| 1  | Subquery | Produkter dyrare än genomsnittet |
| 2  | Subquery + HAVING | Kunder med fler order än snittet |
| 3  | Window (ROW_NUMBER) | Rangordning av produkter per varumärke |
| 4  | Window (RANK) | Kunders spending-rank |
| 5  | CASE | Kategorisering av prisnivå |
| 6  | CASE + LEFT JOIN | Kundsegment baserat på orderantal |

Queries 3–4 använder window functions (krav för VG). Queries 5–6 visar villkorlig logik med `CASE`.

## 3. Index och optimering

Detaljerad SQL finns i `sql/optimization.sql`. Sammanfattning:

| Query | Problem | Åtgärd | Effekt |
|-------|---------|--------|--------|
| `queries.sql` #5 (produkter per varumärke) | Sekventiellt scan på `brands` vid `LOWER(name)` | Index `idx_brands_name_lower` på `LOWER(name)` | Exekveringstid minskade från ~0.15 ms till ~0.05 ms (plans visar indexscan) |
| `queries.sql` #9 (totalt spenderat) | Aggregering över `orders` utan selektivt index | Kompositindex `idx_orders_customer_status` | Planner bytte till indexscan + bitmap heap, färre reads |

### EXPLAIN ANALYZE (utdrag)

```
EXPLAIN ANALYZE SELECT ... WHERE LOWER(b.name) = LOWER('NovaTech');
-- Före: Seq Scan on brands  (actual time=0.026..0.027)
-- Efter: Index Scan using idx_brands_name_lower  (actual time=0.009..0.010)
```

```
EXPLAIN ANALYZE SELECT ... SUM(o.total_amount) ...
-- Före: HashAggregate + Seq Scan on orders (rows=10)
-- Efter: HashAggregate + Bitmap Heap Scan using idx_orders_customer_status (rows=8)
```

Även om datasetet är litet för examensuppgiften illustrerar detta hur index påverkar planerna och skalar när databasen växer.

## 4. Python-integration

`electronics_shop`-paketet innehåller:

- `database.py` – psycopg2-anslutning med miljövariabler.
- `queries.py` – parameteriserade funktioner (listning av produkter, filtrering per varumärke, kundorder).
- `main.py` – CLI som demonstrerar funktionerna.

Kodens struktur följer Del 1.3-kraven och kan byggas ut med fler funktioner (t.ex. för VG-queries).

## 5. Vidare utveckling

- Lägg till views/materialiserade views för vanliga rapporter.
- Integrera Python-applikationen med Pandas för visualisering.
- Implementera testfall (pytest) som validerar SQL-resultat mot förväntade summor.

Med dessa komponenter uppfyller projektet både G- och VG-kraven i examinationen.

