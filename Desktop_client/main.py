from flask import Flask, request
from pynput.keyboard import Controller, Key

app = Flask(__name__)
keyboard = Controller()

@app.route("/", methods=["POST"])
def handle_command():
    command = request.data.decode("utf-8").strip()
    print(f"Received: {command}")

    if command == "UP":
        keyboard.press(Key.up)
        keyboard.release(Key.up)
    elif command == "DOWN":
        keyboard.press(Key.down)
        keyboard.release(Key.down)
    elif command == "F5":  # Start Presentation
        keyboard.press(Key.f5)
        keyboard.release(Key.f5)

    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
