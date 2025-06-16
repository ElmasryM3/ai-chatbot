import os
from flask import Flask, request, render_template, redirect, url_for
from dotenv import load_dotenv
import openai

load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")

app = Flask(__name__)
chat_history = []

@app.route("/", methods=["GET", "POST"])
def home():
    if request.method == "POST":
        user_input = request.form["message"]
        chat_history.append({"role": "user", "content": user_input})

        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=chat_history
        )

        assistant_reply = response.choices[0].message["content"]
        chat_history.append({"role": "assistant", "content": assistant_reply})

    return render_template("index.html", history=chat_history)

@app.route("/reset", methods=["POST"])
def reset():
    global chat_history
    chat_history = []
    return redirect(url_for("home"))

if __name__ == "__main__":
    app.run(debug=True)
