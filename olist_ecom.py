import pandas as pd
import unicodedata
import re
import ftfy

df = pd.read_csv("C:/Users/mathe/Desktop/olist_ecom/orders/olist_geolocation_dataset.csv", encoding="utf-8")

#print(df.head())
#print(df.info())
#print(df.shape)

print(df["geolocation_city"].nunique())

def normalize_city(texto):
    if pd.isna(texto):
        return texto
    
    texto = ftfy.fix_text(texto)
    texto = texto.lower().strip()
    texto = unicodedata.normalize("NFKD", texto)
    texto = texto.encode("ASCII", "ignore").decode("ASCII")
    texto = re.sub(r"[-_/']", "", texto)
    texto = re.sub(r"\s+", " ", texto).strip()
    return texto

df["geolocation_city"] = df["geolocation_city"].apply(normalize_city)

print(df["geolocation_city"].nunique())

df.to_csv("C:/Users/mathe/Desktop/olist_ecom/orders/olist_geolocation_dataset_clean.csv", index=False, encoding="utf-8")

#print(df["city_clean"].value_counts().head(30))

#print(df.duplicated().sum())
#print(df.isnull().sum())

#print(data.head(10))
#print(data.info())
#print(data.duplicated().sum())
#print(data.isnull().sum())
#print(data.describe())
#print(data["label"].value_counts())