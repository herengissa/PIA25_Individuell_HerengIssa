# Query-funktioner för Electronics Shop

from typing import Any, Dict, List
from sqlalchemy import func
from sqlalchemy.orm import Session
from .database import get_session
from .models import Brand, Product, Customer, Order, OrderItem


def get_all_products() -> List[Dict[str, Any]]:
    """Hämtar alla produkter sorterade efter namn."""
    session = get_session()
    try:
        products = (
            session.query(
                Product.id,
                Product.name,
                Product.price,
                Product.category,
                Product.stock_quantity,
            )
            .order_by(Product.name)
            .all()
        )

        result = []
        for p in products:
            result.append({
                "id": p.id,
                "name": p.name,
                "price": float(p.price) if p.price else None,
                "category": p.category,
                "stock_quantity": p.stock_quantity,
            })
        return result
    finally:
        session.close()


def get_products_by_brand(brand_name: str) -> List[Dict[str, Any]]:
    """Hämtar alla produkter för ett specifikt varumärke."""
    session = get_session()
    try:
        products = (
            session.query(
                Product.id,
                Product.name,
                Product.price,
                Product.category,
                Brand.name.label("brand_name"),
            )
            .join(Brand, Product.brand_id == Brand.id)
            .filter(func.lower(Brand.name) == func.lower(brand_name))
            .order_by(Product.name)
            .all()
        )

        result = []
        for p in products:
            result.append({
                "id": p.id,
                "name": p.name,
                "price": float(p.price) if p.price else None,
                "category": p.category,
                "brand_name": p.brand_name,
            })
        return result
    finally:
        session.close()


def get_customer_orders(customer_id: int) -> List[Dict[str, Any]]:
    """Hämtar alla beställningar för en kund."""
    session = get_session()
    try:
        orders = (
            session.query(
                Order.id.label("order_id"),
                Order.order_date,
                Order.status,
                Order.total_amount,
                func.sum(OrderItem.quantity * OrderItem.unit_price).label("calculated_total"),
            )
            .join(OrderItem, Order.id == OrderItem.order_id)
            .filter(Order.customer_id == customer_id)
            .group_by(Order.id, Order.order_date, Order.status, Order.total_amount)
            .order_by(Order.order_date.desc())
            .all()
        )

        result = []
        for o in orders:
            result.append({
                "order_id": o.order_id,
                "order_date": o.order_date.isoformat() if o.order_date else None,
                "status": o.status,
                "total_amount": float(o.total_amount) if o.total_amount else None,
                "calculated_total": float(o.calculated_total) if o.calculated_total else None,
            })
        return result
    finally:
        session.close()
