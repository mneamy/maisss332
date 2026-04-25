# =========================
# IMPORTS
# =========================
import psycopg2
import threading
import time

# =========================
# DB CONNECTION
# =========================
conn_params = {
    "host": "localhost",
    "database": "regnskap",
    "user": "admin",
    "password": "1234"
}

# =========================
# SETUP TABLE
# =========================
def setup():
    conn = psycopg2.connect(**conn_params)
    conn.autocommit = True
    cur = conn.cursor()

    cur.execute("DROP TABLE IF EXISTS konto_saldo;")

    cur.execute("""
        CREATE TABLE konto_saldo (
            id INT PRIMARY KEY,
            saldo INT
        );
    """)

    cur.execute("INSERT INTO konto_saldo VALUES (1, 248500);")

    cur.close()
    conn.close()

# =========================
# READ SALDO
# =========================
def get_saldo(conn):
    cur = conn.cursor()
    cur.execute("SELECT saldo FROM konto_saldo WHERE id=1;")
    return cur.fetchone()[0]

# =========================
# PRINT SALDO
# =========================
def print_saldo(conn):
    print("Saldo etter:", get_saldo(conn))

# =========================
# SCENARIO B1: LOST UPDATE (unsafe)
# =========================
def unsafe_update(name, delay, delta):
    conn = psycopg2.connect(**conn_params)
    cur = conn.cursor()

    cur.execute("SELECT saldo FROM konto_saldo WHERE id=1;")
    saldo = cur.fetchone()[0]
    print(f"[{name}] LES: saldo = {saldo}")

    time.sleep(delay)

    new_saldo = saldo + delta

    cur.execute("""
        UPDATE konto_saldo
        SET saldo=%s
        WHERE id=1;
    """, (new_saldo,))

    conn.commit()
    print(f"[{name}] COMMIT: satte saldo = {new_saldo}")

    cur.close()
    conn.close()

def run_unsafe():
    print("\n=== SCENARIO B1: LOST UPDATE ===")

    t1 = threading.Thread(target=unsafe_update, args=("Bjørn", 1, 1500))
    t2 = threading.Thread(target=unsafe_update, args=("Ane", 0.5, -3000))

    t1.start()
    t2.start()

    t1.join()
    t2.join()

    conn = psycopg2.connect(**conn_params)
    print_saldo(conn)
    conn.close()

# =========================
# SCENARIO B2: FIXED (FOR UPDATE LOCK)
# =========================
def safe_update(name, delay, delta):
    conn = psycopg2.connect(**conn_params)
    conn.autocommit = False
    cur = conn.cursor()

    cur.execute("BEGIN;")

    # 🔒 Database-level locking (IMPORTANT)
    cur.execute("""
        SELECT saldo
        FROM konto_saldo
        WHERE id=1
        FOR UPDATE;
    """)

    saldo = cur.fetchone()[0]
    print(f"[{name}] LES+LOCK: saldo = {saldo}")

    time.sleep(delay)

    new_saldo = saldo + delta

    cur.execute("""
        UPDATE konto_saldo
        SET saldo=%s
        WHERE id=1;
    """, (new_saldo,))

    conn.commit()
    print(f"[{name}] COMMIT: saldo = {new_saldo}")

    cur.close()
    conn.close()

def run_safe():
    print("\n=== SCENARIO B2: FIXED WITH LOCK ===")

    t1 = threading.Thread(target=safe_update, args=("Bjørn", 0.5, 1500))
    t2 = threading.Thread(target=safe_update, args=("Ane", 0.5, -3000))

    t1.start()
    t2.start()

    t1.join()
    t2.join()

    conn = psycopg2.connect(**conn_params)
    print_saldo(conn)
    conn.close()

# =========================
# MAIN
# =========================
if __name__ == "__main__":
    setup()

    run_unsafe()
    run_safe()