import requests
import redis
import psycopg2
import time

# ======================
# 1. إعداد الاتصال بـ Redis (التخزين المؤقت السريع)
# ======================
# تأكد من تشغيل Redis أولاً باستخدام الأمر:
# docker run -d -p 6379:6379 redis
cache = redis.Redis(host="localhost", port=6379, decode_responses=True)

# ======================
# 2. دالة لجلب سعر الصرف من API البنك النرويجي
# ======================
def get_rate_from_api():
    url = "https://data.norges-bank.no/api/data/EXR/B.USD.NOK.SP"
    params = {"format": "sdmx-json", "lastNObservations": 1}
    
    response = requests.get(url, params=params)
    data = response.json()
    
    # استخراج السعر من الاستجابة المعقدة
    try:
        series = data["data"]["dataSets"][0]["series"]
        for key in series:
            observations = series[key]["observations"]
            for obs_key in observations:
                return float(observations[obs_key][0])
    except Exception as e:
        print("خطأ في قراءة API:", e)
        return None

# ======================
# 3. دالة لحفظ السعر في PostgreSQL (اختيارية - لن توقف البرنامج إذا فشلت)
# ======================
def save_to_sql(rate):
    # يمكنك تعديل هذه الإعدادات حسب قاعدة البيانات لديك
    # إذا لم تكن قاعدة البيانات جاهزة، البرنامج سيستمر دون توقف
    try:
        conn = psycopg2.connect(
            dbname="gnucash",      # اسم قاعدة البيانات
            user="student",        # اسم المستخدم
            password="password",   # كلمة المرور
            host="localhost"       # عنوان الخادم
        )
        conn.autocommit = False    # نبدأ المعاملة (transaction)
        cur = conn.cursor()
        
        # إدراج أو تحديث السعر في جدول prices
        cur.execute("""
            INSERT INTO prices (commodity_id, currency_id, date, value)
            VALUES (1, 2, CURRENT_DATE, %s)
            ON CONFLICT (commodity_id, currency_id, date)
            DO UPDATE SET value = EXCLUDED.value
        """, (rate,))
        
        conn.commit()              # تأكيد المعاملة
        print("stored pice in DB")
        
    except Exception as e:
        print("  SQL Error", e)
        if 'conn' in locals():
            conn.rollback()
    finally:
        if 'conn' in locals():
            conn.close()

# ======================
# 4. المنطق الأساسي للـ Cache (هذا هو قلب المهمة)
# ======================
def get_rate():
    key = "price:USD:NOK"
    
    # الخطوة 1: هل السعر موجود في Redis؟
    cached_value = cache.get(key)
    
    if cached_value:
        print("  --> Cache HIT (it fornd from cash )")
        return float(cached_value)
    
    # الخطوة 2: غير موجود -> Cache Miss
    print("  --> Cache MISS (API not founf  we wanto to get it )")
    
    # جلب السعر من API الحقيقي
    rate = get_rate_from_api()
    if rate is None:
        print("Error in  API")
        return None
    
    # حفظ السعر في Redis لمدة ساعة (3600 ثانية)
    cache.set(key, rate, ex=3600)
    print(f"  --> the pris stored in {rate} for Redis ")
    
    # محاولة حفظ السعر في PostgreSQL (إذا فشلت، لا مشكلة)
    save_to_sql(rate)
    
    return rate

# ======================
# 5. محاكاة 10 استدعاءات متتالية
# ======================
print("\n=====  start 10 request USD/NOK =====\n")

for i in range(1, 11):
    print(f"request :  {i}")
    start_time = time.time()
    
    rate = get_rate()
    
    elapsed_ms = (time.time() - start_time) * 1000
    if rate:
        print(f"  => price: {rate} NOK (time: {elapsed_ms:.0f} ms )")
    else:
        print("  => fetch price erroe")
    
    print("-" * 50)
    time.sleep(1)   # انتظر ثانية بين الطلبات

print("\n===== END =====")