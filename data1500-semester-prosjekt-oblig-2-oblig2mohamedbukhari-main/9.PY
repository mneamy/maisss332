import psycopg2
import threading
import time

# ⚠️ عدل بيانات الاتصال حسب جهازك
conn_params = {
    "host": "localhost",
    "database": "regnskap",
    "user": "postgres",
    "password": "1234"
}

# ---------------------------------------
# إعداد جدول تجريبي فيه saldo
# ---------------------------------------
def setup():
    conn = psycopg2.connect(**conn_params)
    cur = conn.cursor()

    cur.execute("DROP TABLE IF EXISTS konto_saldo")
    cur.execute("""
        CREATE TABLE konto_saldo (
            id SERIAL PRIMARY KEY,
            saldo INT
        )
    """)

    cur.execute("INSERT INTO konto_saldo (saldo) VALUES (248500)")
    conn.commit()
    conn.close()

# ---------------------------------------
# قراءة الرصيد
# ---------------------------------------
def get_saldo():
    conn = psycopg2.connect(**conn_params)
    cur = conn.cursor()
    cur.execute("SELECT saldo FROM konto_saldo WHERE id = 1")
    saldo = cur.fetchone()[0]
    conn.close()
    return saldo

# ---------------------------------------
# Scenario B1 (خطأ)
# ---------------------------------------
def worker_unsafe(name, amount, delay):
    conn = psycopg2.connect(**conn_params)
    cur = conn.cursor()

    cur.execute("BEGIN")

    cur.execute("SELECT saldo FROM konto_saldo WHERE id = 1")
    saldo = cur.fetchone()[0]
    print(f"[{name}] LES: saldo = {saldo}")

    time.sleep(delay)

    new_saldo = saldo + amount
    cur.execute("UPDATE konto_saldo SET saldo = %s WHERE id = 1", (new_saldo,))

    conn.commit()
    print(f"[{name}] COMMIT: satte saldo = {new_saldo}")

    conn.close()

# ---------------------------------------
# Scenario B2 (حل باستخدام Lock)
# ---------------------------------------
def worker_safe(name, amount, delay):
    conn = psycopg2.connect(**conn_params)
    cur = conn.cursor()

    cur.execute("BEGIN")

    cur.execute("SELECT saldo FROM konto_saldo WHERE id = 1 FOR UPDATE")
    saldo = cur.fetchone()[0]
    print(f"[{name}] LES+LOCK: saldo = {saldo}")

    time.sleep(delay)

    new_saldo = saldo + amount
    cur.execute("UPDATE konto_saldo SET saldo = %s WHERE id = 1", (new_saldo,))

    conn.commit()
    print(f"[{name}] COMMIT: saldo = {new_saldo}")

    conn.close()

# ---------------------------------------
# تشغيل Scenario B1
# ---------------------------------------
def run_unsafe():
    print("\n=== SCENARIO B1: LOST UPDATE ===")

    setup()

    t1 = threading.Thread(target=worker_unsafe, args=("Ane", -3000, 0.3))
    t2 = threading.Thread(target=worker_unsafe, args=("Bjørn", 1500, 0.3))

    t1.start()
    t2.start()

    t1.join()
    t2.join()

    print("Saldo etter:", get_saldo())

# ---------------------------------------
# تشغيل Scenario B2
# ---------------------------------------
def run_safe():
    print("\n=== SCENARIO B2: FIXED WITH LOCK ===")

    setup()

    t1 = threading.Thread(target=worker_safe, args=("Ane", -3000, 0.3))
    t2 = threading.Thread(target=worker_safe, args=("Bjørn", 1500, 0.3))

    t1.start()
    t2.start()

    t1.join()
    t2.join()

    print("Saldo etter:", get_saldo())

# ---------------------------------------
# MAIN
# ---------------------------------------
if __name__ == "__main__":
    print("Start saldo:", get_saldo() if False else "Will be set in setup")

    run_unsafe()
    run_safe()