from pathlib import Path
import sys
from google.cloud import bigquery

PROJECT_ID = "olist-ecom-503120"
DATASET_ID = "olist_bronze"

PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "data" / "raw"

client = bigquery.Client()

table_id = "olist-ecom-503120.olist_bronze.olist_order_reviews"

schema = [
    bigquery.SchemaField("review_id", "STRING"),
    bigquery.SchemaField("order_id", "STRING"),
    bigquery.SchemaField("review_score", "STRING"),
    bigquery.SchemaField("review_comment_title", "STRING"),
    bigquery.SchemaField("review_comment_message", "STRING"),
    bigquery.SchemaField("review_creation_date", "STRING"),
    bigquery.SchemaField("review_answer_timestamp", "STRING"),
]

job_config = bigquery.LoadJobConfig(
    schema=schema,
    source_format=bigquery.SourceFormat.CSV,
    skip_leading_rows=1,
    field_delimiter=",",
    quote_character='"',
    allow_quoted_newlines=True,
    encoding="UTF-8",
    write_disposition="WRITE_TRUNCATE",
)

with open(
    "data/raw/olist_order_reviews_dataset.csv",
    "rb",
) as source_file:
    load_job = client.load_table_from_file(
        source_file,
        table_id,
        job_config=job_config,
    )

load_job.result()

table = client.get_table(table_id)

print(f"{table.num_rows} linhas carregadas em {table_id}")