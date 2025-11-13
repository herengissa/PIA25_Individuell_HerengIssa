"""
Reusable SQL query helpers for the Electronics Shop project.

Each function exposes a parameterised query and returns plain Python data
structures so they can be consumed by CLI tools, tests or other applications.
"""

from __future__ import annotations

from typing import Any, Dict, List, Optional

import psycopg2.extras

from .database import get_connection


def get_all_products() -> List[Dict[str, Any]]:
    """Return all products ordered alphabetically by name."""
    sql = """
        SELECT id, name, price, category, stock_quantity
        FROM products
        ORDER BY name
    """
    with get_connection() as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql)
            return list(cur.fetchall())


def get_products_by_brand(brand_name: str) -> List[Dict[str, Any]]:
    """
    Return all products belonging to a specific brand.

    Args:
        brand_name: Name of the brand to filter by (case insensitive).
    """
    sql = """
        SELECT p.id,
               p.name,
               p.price,
               p.category,
               b.name AS brand_name
        FROM products p
        JOIN brands b ON b.id = p.brand_id
        WHERE LOWER(b.name) = LOWER(%s)
        ORDER BY p.name
    """
    with get_connection() as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql, (brand_name,))
            return list(cur.fetchall())


def get_customer_orders(customer_id: int) -> List[Dict[str, Any]]:
    """
    Return orders and line totals for a given customer.

    Args:
        customer_id: Primary key of the customer.
    """
    sql = """
        SELECT o.id AS order_id,
               o.order_date,
               o.status,
               o.total_amount,
               SUM(oi.quantity * oi.unit_price) AS calculated_total
        FROM orders o
        JOIN order_items oi ON oi.order_id = o.id
        WHERE o.customer_id = %s
        GROUP BY o.id, o.order_date, o.status, o.total_amount
        ORDER BY o.order_date DESC
    """
    with get_connection() as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql, (customer_id,))
            return list(cur.fetchall())

