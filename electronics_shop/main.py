# Huvudprogram för Electronics Shop

from .queries import get_all_products, get_customer_orders, get_products_by_brand


def print_rows(title, rows):
    """Skriver ut resultat till konsolen."""
    print(f"\n=== {title} ===")
    if not rows:
        print("(inga resultat)")
        return

    for row in rows:
        print({key: value for key, value in row.items()})


def main():
    """Demonstrerar query-funktionerna."""
    all_products = get_all_products()
    print_rows("Alla produkter", all_products)

    novatech_products = get_products_by_brand("NovaTech")
    print_rows("Produkter från NovaTech", novatech_products)

    customer_orders = get_customer_orders(1)
    print_rows("Beställningar för kund #1", customer_orders)


if __name__ == "__main__":
    main()
