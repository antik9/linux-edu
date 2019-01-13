from flask import Flask, render_template

app = Flask(__name__)

@app.route("/flask/")
def hello():
    return render_template("index.html", title='Flask')

if __name__ == "__main__":
    app.run('0.0.0.0', '8001')
