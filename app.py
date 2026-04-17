from flask import Flask, render_template, request, redirect, session, flash, Response 
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector
from datetime import datetime
import plotly.graph_objects as go
import json
import plotly
import os
from datetime import timedelta

app = Flask(__name__)
app.permanent_session_lifetime = timedelta(minutes=10)
app.secret_key = "CHANGE_THIS_SECRET_KEY_123" # Replace with something random
#-----------------------------------------------
# Database connection
#-----------------------------------------------

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="SQLclass#99@Database#8",
        database="visitor_system"
    )

#-----------------------------------------------
# Home --> Redirect to check-in page
#-----------------------------------------------

@app.route('/') #Check to see if it should have checkin here too 
def home():
    return redirect('/checkin')

#-----------------------------------------------
# Visitor Check-In
#-----------------------------------------------

@app.route('/checkin', methods=['GET', 'POST'])
def checkin():
    if request.method == 'POST':
        visitor_name = request.form['visitor_name']
        purpose = request.form['purpose']
        visiting_person = request.form['visiting_person']
        department = request.form['department']

        conn = get_db_connection()
        cursor = conn.cursor()

        #Check if visitor already has an active (not checked out) visit
        cursor.execute(""" SELECT * FROM visits WHERE visitor_name = %s AND checkout_time IS NULL""", (visitor_name,))
        active_visit = cursor.fetchone()
        
        if active_visit:
            cursor.close()
            conn.close()
            flash("Error: Visitor is already checked in and has not checked out.", "error")
            return redirect('/checkin')
        
        # Close cursor to avoid unread result issue
        cursor.close()

        # If not active visit, allow check-in
        cursor = conn.cursor()
        sql = """INSERT INTO visits (visitor_name, purpose, visiting_person, department, checkin_time) VALUES (%s, %s, %s, %s, %s)"""
        cursor.execute(sql, (visitor_name, purpose, visiting_person, department, datetime.now()))
        conn.commit()

        cursor.close()
        conn.close()

        flash(f" {visitor_name} checked in successfully!", "success")
        return redirect('/checkin')
    
    return render_template('checkin.html')

#------------------------------------------------
# Visitor Check-Out
#------------------------------------------------
@app.route('/checkout', methods=['GET'])
def checkout_error_redirect():
    return redirect('/admin')
@app.route('/checkout', methods=['POST'])
def checkout():
        visit_id = request.form.get('visitor_id')

        if not visit_id:
            return "Error: Missing visitor ID", 400
        
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("UPDATE visits SET checkout_time= NOW() WHERE visit_id = %s", (visit_id,))
        conn.commit()
        
        cursor.close()
        conn.close()

        return redirect('/admin')

@app.route('/checkout')
def checkout_page():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT visit_id, visitor_name, purpose, checkin_time FROM visits WHERE checkout_time IS NULL")
    visitors = cursor.fetchall()
    cursor.close()
    conn.close()
        
    return render_template('checkout.html', visitors=visitors)

#------------------------------------------------
# Admin Login Page
#------------------------------------------------

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username'].strip().lower()
        entered_password = request.form['password']

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM admin_users WHERE LOWER(username)=LOWER(%s)", (username,))
        admin = cursor.fetchone()

        cursor.close()
        conn.close()

        if admin and check_password_hash(admin['password'], entered_password):
            # Store session login
            session.permanent = True
            session['admin'] = admin['username']
            return redirect('/admin')
        else: 
            flash("Invalid login. Try again.", "error")
        
    return render_template('login.html')

#-------------------------------------------------
# Admin Page --> See All Visitors
#-------------------------------------------------

@app.route('/admin', methods=['GET', 'POST'])
def admin():
    if 'admin' not in session:
        return redirect('/login')
    
    search_query= request.args.get('search', '')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""SELECT COUNT(*) AS today_count  FROM visits WHERE DATE(checkin_time) = CURDATE()""")
    today_count = cursor.fetchone()['today_count']

    if search_query:
        cursor.execute("""SELECT * FROM visits WHERE checkout_time IS NULL AND LOWER(visitor_name) LIKE %s ORDER BY checkin_time DESC""", ('%' + search_query.lower() + '%',))
        
    else: 
        cursor.execute("""SELECT * FROM visits WHERE checkout_time IS NULL ORDER BY checkin_time DESC""")

    visitors = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template('admin.html', visitors=visitors, today_count=today_count)
@app.route('/logout')
def logout():
    session.pop('admin', None)
    return redirect('/login')

#------------------------------------------------
# Plotly 
#------------------------------------------------

@app.route('/analytics')
def department_chart():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""SELECT department, COUNT(*) AS total FROM visits GROUP BY department ORDER BY total DESC""")
    dept_data = cursor.fetchall()

    cursor.execute("""SELECT purpose, COUNT(*) AS total FROM visits GROUP BY purpose ORDER BY total DESC""")
    purpose_data = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("visitor_stats.html", dept_data=dept_data, purpose_data=purpose_data)

#------------------------------------------------
@app.route('/export-visits-csv')
def export_visits_csv():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""SELECT department, COUNT(*) AS total FROM visits GROUP BY department ORDER BY total DESC""")
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    def generate():
        yield "Department, Total Visits\n"
        for row in data:
            yield f"{row[0]}, {row[1]}\n"

    return Response(generate(), mimetype='text/csv', headers={"Content-Disposition": "attachment; filename=visits_by_department.csv"})

#-------------------------------------------------
# Run App
#-------------------------------------------------

if __name__ == "__main__":
   app.run()
