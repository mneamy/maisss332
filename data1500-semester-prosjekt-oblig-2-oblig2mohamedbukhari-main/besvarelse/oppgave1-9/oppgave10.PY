import requests
import redis
import psycopg2
import time

# -----------------------
# Redis
# -----------------------
cache = redis.Redis(host="localhost", port=6379, decode_responses=True)

# -----------------------
# API
# -----------------------
def get_rate_from_api():
    url = "https://data.norges-bank.no/api/data/EXR/B.USD.NOK.SP"
    params = {"format": "sdmx-json", "lastNObservations": 1}

    res = requests.get(url, params=params)
    data = res.json()

    obs = data["data"]["dataSets"][0]["observations"]
    for k in obs:
        return float(obs[k][0])

# -----------------------
# SQL (Transaction)
# -----------------------
def save_to_sql(rate):
    conn = psycopg2.connect(
        dbname="gnucash",
        user="student",
        password="password",
        host="localhost"
    )

    conn.autocommit = False

    try:
        cur = conn.cursor()

        cur.execute("""
            INSERT INTO prices (commodity_id, currency_id, date, value)
            VALUES (1, 2, CURRENT_DATE, %s)
            ON CONFLICT (commodity_id, currency_id, date)
            DO UPDATE SET value = EXCLUDED.value
        """, (rate,))

        conn.commit()
        print("SQL updated")

    except Exception as e:
        conn.rollback()
        print("SQL error:", e)

    finally:
        conn.close()

# -----------------------
# Cache Logic
# -----------------------
def get_rate():
    key = "price:USD:NOK"

    value = cache.get(key)

    if value:
        print("Cache HIT")
        return float(value)

    print("Cache MISS")

    rate = get_rate_from_api()

    cache.set(key, rate, ex=3600)  # TTL = 1 hour

    save_to_sql(rate)

    return rate

# -----------------------
# Simulation (10 calls)
# -----------------------
for i in range(10):
    print(f"\nRequest {i+1}")

    rate = get_rate()

    print("Rate:", rate)

    time.sleep(1)
    
    
    
    
    #python -m pip install requests