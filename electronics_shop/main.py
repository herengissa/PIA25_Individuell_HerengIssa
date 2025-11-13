"""
Simple CLI entry point demonstrating the Electronics Shop queries.

Run this script after the database has been created and populated with
`schema.sql` and `testdata.sql`. Update environment variables if your database
credentials differ from the defaults.
"""

from __future__ import annotations

from typing import Iterable, Mapping

from .queries import get_all_products, get_customer_orders, get_products_by_brand


def _print_rows(title: str, rows: Iterable[Mapping[str, object]]) -> None:
    """Pretty-print a sequence of rows to the console."""
    print(f"\n=== {title} ===")
    data = list(rows)
    if not data:
        print("(inga resultat)")
        return

    for row in data:
        print({key: value for key, value in row.items()})


def main() -> None:
    """Execute a small demonstration of the available query helpers."""
    all_products = get_all_products()
    _print_rows("Alla produkter", all_products)

    novatech_products = get_products_by_brand("NovaTech")
    _print_rows("Produkter från NovaTech", novatech_products)

    customer_orders = get_customer_orders(1)
    _print_rows("Beställningar för kund #1", customer_orders)


if __name__ == "__main__":
    main()

