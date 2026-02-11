# Terraform + Python EventHub CI
Ten projekt zawiera:
- Infrastruktura jako kod (Terraform) w katalogu `iac/`
- Skrypt Python do wysyłania zdarzeń do Azure Event Hub (`scripts/send_events.py`)
- CI w GitHub Actions sprawdzający poprawność Terraform i Pythona

## Struktura repozytorium
```
root/
├─ scripts/
│  ├─ send_events.py       
│  └─ requirements.txt
├─ notebooks/
│  ├─ aggregateData.py       
│  └─ daily_task_trigger.py 
└─ iac/
   ├─ main.tf
   ├─ variables.tf
   └─ terraform.tfvars
```

## Wymagania
- GitHub Actions do CI
- Python 3.11
- Terraform >= 1.6.0
- Konto Azure z dostępem do Event Hub

## Instalacja
1. Sklonuj repozytorium:
   ```bash
   git clone <repo-url>
   cd <repo-folder>
   ```
2. Zainstaluj zależności Pythona
    ```bash
    pip install -r scripts/requirements.txt
    ```

3. Upewnij się, że nazwy zmiennych środowiskowych są dopasowane od indywidualnego środowiska. **UWAGA**, aby projekt mógł zadziałać, należy dodać fragment pozwalający na zalogowanie w Azure z komendą az login. Tutaj nie zostało to dodane z powodu ograniczeń konta studenckiego.
   
4. W katalogu iac/ możesz testować Terraform. Pamiętaj o dostosowaniu nazw zasobów i reguł w pliku terraaform.tfvars:
   ```bash
   cd iac
   terraform init
   terraform validate
   terraform plan -var-file="terraform.tfvars"
    
5. Uruchom skrypt
    ```bash
    python scripts/send_events.py
    ```

## Dalszy przebieg projektu
W dalszych krokach można skonfigurować analizowanie przeysłanego przez skrypt potoku danych, np. poprzez Databricks (w repozytorium załączony jest gotowy notatnik wykonujący agregację w Databricks).

