from flask import Flask, render_template, request, redirect, url_for
from models.database import create_database
from models.user import User

app = Flask(__name__)

# Create the database and table when the app starts
create_database()

@app.route('/')
def index():
    users = User.get_all()
    return render_template('index.html', users=users)

@app.route('/add', methods=['POST'])
def add_user():
    name = request.form['name']
    email = request.form['email']
    user = User(name=name, email=email)
    user.save()
    return redirect(url_for('index'))

@app.route('/update/<int:user_id>', methods=['POST'])
def update_user(user_id):
    user = User.get_by_id(user_id)
    if user:
        user.name = request.form['name']
        user.email = request.form['email']
        user.save()
    return redirect(url_for('index'))

@app.route('/delete/<int:user_id>', methods=['POST'])
def delete_user(user_id):
    user = User.get_by_id(user_id)
    if user:
        user.delete()
    return redirect(url_for('index'))

if __name__ == '__main__':
    # App1 runs on port 5000
    app.run(host='0.0.0.0', port=5000)
