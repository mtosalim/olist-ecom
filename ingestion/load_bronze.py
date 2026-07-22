from pathlib import Path
import sys
from google.cloud import bigquery

PROJECT_ID = "olist-ecom-503120"
DATASET_ID = "olist_bronze"

PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "data" / "raw"


def load_csv(client: bigquery.Client, csv_path: Path) -> None:
    """Carrega um CSV local em uma tabela do BigQuery."""

    table_name = csv_path.stem
    table_id = f"{PROJECT_ID}.{DATASET_ID}.{table_name}"

    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        skip_leading_rows=1,
        autodetect=True,
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
    )

    print(f"Carregando {csv_path.name} em {table_id}...")

    with csv_path.open("rb") as source_file:
        load_job = client.load_table_from_file(
            source_file,
            table_id,
            job_config=job_config,
        )

    # Aguarda a conclusão e lança uma exceção em caso de erro.
    load_job.result()

    table = client.get_table(table_id)
    print(f"Concluído: {table_id} — {table.num_rows} linhas")


def main() -> int:
    if not DATA_DIR.exists():
        print(f"Diretório não encontrado: {DATA_DIR}")
        return 1

    csv_files = sorted(DATA_DIR.glob("*.csv"))

    if not csv_files:
        print(f"Nenhum CSV encontrado em: {DATA_DIR}")
        return 1

    client = bigquery.Client(project=PROJECT_ID)

    try:
        for csv_path in csv_files:
            load_csv(client, csv_path)
    except Exception as error:
        print(f"Falha na ingestão: {error}")
        return 1

    print("Todas as tabelas Bronze foram carregadas.")
    return 0


if __name__ == "__main__":
    sys.exit(main())