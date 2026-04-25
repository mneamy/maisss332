import psycopg2
import threading
import time

con_paramter = {
    "host": "localhost",
    "database": "regnskap",
    "user": "admin",
    "password": "1234"
}

# SETUP
def setup():
    conn = psycopg2.connect(**con_paramter)
    conn.autocommit = True
    cur = conn.cursor()

    cur.execute("DROP TABLE IF EXISTS konto")
    cur.execute("""
        CREATE TABLE konto (
            id INT PRIMARY KEY,
            saldo INT
        );
    """)
    cur.execute("INSERT INTO konto VALUES (1, 248500);")

    cur.close()
    conn.close()


# READ
def get_saldo(conn):
    cur = conn.cursor()
    cur.execute("SELECT saldo FROM konto WHERE id=1")
    return cur.fetchone()[0]


# PRINT
def print_saldo(conn):
    print("Saldo ETTER:", get_saldo(conn))


# UNSAFE UPDATE
def unsafeupdate(name, delay, saldoextra):
    conn = psycopg2.connect(**con_paramter)
    cur = conn.cursor()

    cur.execute("SELECT saldo FROM konto WHERE id=1")
    saldo = cur.fetchone()[0]
    print(f"[{name}] LES: saldo = {saldo}")

    time.sleep(delay)

    new_saldo = saldo + saldoextra

    cur.execute("UPDATE konto SET saldo=%s WHERE id=1", (new_saldo,))
    conn.commit()

    print(f"[{name}] COMMIT: satte saldo = {new_saldo}")

    cur.close()
    conn.close()


def rununsafe():
    print("\n=== SCENARIO B1: LOST UPDATE ===")

    t1 = threading.Thread(target=unsafeupdate, args=("Bjørn", 1, 1500))
    t2 = threading.Thread(target=unsafeupdate, args=("Ane", 0.5, 3000))

    t1.start()
    t2.start()

    t1.join()
    t2.join()

    conn = psycopg2.connect(**con_paramter)
    print_saldo(conn)
    conn.close()


#==============SCINARIO B2============


# SAFE UPDATE
def safeupdate(name, delay, saldoextra):
    conn = psycopg2.connect(**con_paramter)
    cur = conn.cursor()
    conn.autocommit= False  ########
    cur.execute("Begin;")   #######
    
    
    cur.execute("SELECT saldo FROM konto WHERE id=1 FOR Update ")
    saldo = cur.fetchone()[0]
    print(f"[{name}] LES:LOCK saldo = {saldo}")

    time.sleep(delay)

    new_saldo = saldo + saldoextra

    cur.execute("UPDATE konto SET saldo=%s WHERE id=1", (new_saldo,))
    conn.commit()

    print(f"[{name}] COMMIT: satte saldo = {new_saldo}")

    cur.close()
    conn.close()


def runsafe():
    print("\n=== SCENARIO B2: Save UPDATE  with LOCK===")

    t1 = threading.Thread(target=safeupdate, args=("Bjørn", 1, 1500))
    t2 = threading.Thread(target=safeupdate, args=("Ane", 0.5, 3000))

    t1.start()
    t2.start()

    t1.join()
    t2.join()

    conn = psycopg2.connect(**con_paramter)
    print_saldo(conn)
    conn.close()









# MAIN
if __name__ == "__main__":
    setup()
    rununsafe()
    runsafe()
    