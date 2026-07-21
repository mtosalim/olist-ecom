import pandas as pd

df = pd.read_csv("C:/Users/mathe/Desktop/olist_ecom/orders/olist_orders_dataset.csv", encoding="utf-8")

#print(df.head())
#print(df.info())

df.notnull()