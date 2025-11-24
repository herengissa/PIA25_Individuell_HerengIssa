# SQLAlchemy models för Electronics Shop databasen

from __future__ import annotations

from sqlalchemy import (
    CheckConstraint,
    Column,
    Date,
    ForeignKey,
    Integer,
    Numeric,
    String,
    Text,
    TIMESTAMP,
    UniqueConstraint,
)
from sqlalchemy.orm import declarative_base, relationship

Base = declarative_base()


class Brand(Base):
    __tablename__ = "brands"

    id = Column(Integer, primary_key=True)
    name = Column(String(120), nullable=False, unique=True)
    country = Column(String(80))
    founded_year = Column(Integer)
    description = Column(Text)
    created_at = Column(TIMESTAMP, nullable=False, server_default="CURRENT_TIMESTAMP")

    products = relationship("Product", back_populates="brand", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Brand(id={self.id}, name='{self.name}')>"


class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True)
    name = Column(String(150), nullable=False)
    brand_id = Column(Integer, ForeignKey("brands.id", ondelete="CASCADE"), nullable=False)
    sku = Column(String(80), unique=True)
    release_year = Column(Integer)
    price = Column(Numeric(10, 2), nullable=False)
    warranty_months = Column(Integer)
    category = Column(String(80))
    stock_quantity = Column(Integer, nullable=False, server_default="0")
    created_at = Column(TIMESTAMP, nullable=False, server_default="CURRENT_TIMESTAMP")

    brand = relationship("Brand", back_populates="products")
    order_items = relationship("OrderItem", back_populates="product", cascade="all, delete-orphan")
    reviews = relationship("Review", back_populates="product", cascade="all, delete-orphan")

    __table_args__ = (
        CheckConstraint("price > 0", name="products_price_positive"),
        CheckConstraint("stock_quantity >= 0", name="products_stock_non_negative"),
    )

    def __repr__(self):
        return f"<Product(id={self.id}, name='{self.name}', price={self.price})>"


class Customer(Base):
    __tablename__ = "customers"

    id = Column(Integer, primary_key=True)
    first_name = Column(String(80), nullable=False)
    last_name = Column(String(80), nullable=False)
    email = Column(String(120), nullable=False, unique=True)
    phone = Column(String(30))
    city = Column(String(80))
    registration_date = Column(Date, nullable=False, server_default="CURRENT_DATE")
    created_at = Column(TIMESTAMP, nullable=False, server_default="CURRENT_TIMESTAMP")

    orders = relationship("Order", back_populates="customer", cascade="all, delete-orphan")
    reviews = relationship("Review", back_populates="customer", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Customer(id={self.id}, name='{self.first_name} {self.last_name}')>"


class Order(Base):
    __tablename__ = "orders"

    id = Column(Integer, primary_key=True)
    customer_id = Column(Integer, ForeignKey("customers.id", ondelete="CASCADE"), nullable=False)
    order_date = Column(Date, nullable=False, server_default="CURRENT_DATE")
    total_amount = Column(Numeric(12, 2), nullable=False, server_default="0")
    status = Column(String(40), nullable=False, server_default="pending")
    shipping_city = Column(String(80))
    created_at = Column(TIMESTAMP, nullable=False, server_default="CURRENT_TIMESTAMP")

    customer = relationship("Customer", back_populates="orders")
    order_items = relationship("OrderItem", back_populates="order", cascade="all, delete-orphan")

    __table_args__ = (
        CheckConstraint("total_amount >= 0", name="orders_total_amount_non_negative"),
    )

    def __repr__(self):
        return f"<Order(id={self.id}, customer_id={self.customer_id}, status='{self.status}')>"


class OrderItem(Base):
    __tablename__ = "order_items"

    id = Column(Integer, primary_key=True)
    order_id = Column(Integer, ForeignKey("orders.id", ondelete="CASCADE"), nullable=False)
    product_id = Column(Integer, ForeignKey("products.id", ondelete="CASCADE"), nullable=False)
    quantity = Column(Integer, nullable=False)
    unit_price = Column(Numeric(10, 2), nullable=False)
    created_at = Column(TIMESTAMP, nullable=False, server_default="CURRENT_TIMESTAMP")

    order = relationship("Order", back_populates="order_items")
    product = relationship("Product", back_populates="order_items")

    __table_args__ = (
        CheckConstraint("quantity > 0", name="order_items_quantity_positive"),
        CheckConstraint("unit_price > 0", name="order_items_unit_price_positive"),
    )

    def __repr__(self):
        return f"<OrderItem(id={self.id}, order_id={self.order_id}, product_id={self.product_id})>"


class Review(Base):
    __tablename__ = "reviews"

    id = Column(Integer, primary_key=True)
    product_id = Column(Integer, ForeignKey("products.id", ondelete="CASCADE"), nullable=False)
    customer_id = Column(Integer, ForeignKey("customers.id", ondelete="CASCADE"), nullable=False)
    rating = Column(Integer, nullable=False)
    comment = Column(Text)
    review_date = Column(Date, nullable=False, server_default="CURRENT_DATE")
    created_at = Column(TIMESTAMP, nullable=False, server_default="CURRENT_TIMESTAMP")

    product = relationship("Product", back_populates="reviews")
    customer = relationship("Customer", back_populates="reviews")

    __table_args__ = (
        CheckConstraint("rating BETWEEN 1 AND 5", name="reviews_rating_range"),
        UniqueConstraint("product_id", "customer_id", name="reviews_unique_product_customer"),
    )

    def __repr__(self):
        return f"<Review(id={self.id}, product_id={self.product_id}, rating={self.rating})>"
