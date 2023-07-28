import flask, requests, multiprocessing
from flask import render_template
from time import sleep
import os
from pathlib import Path

app = flask.Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

server = multiprocessing.Process(target=app.run, args=("0.0.0.0", 8888))

server.start()

input_nb = Path(os.environ["DY_SIDECAR_PATH_INPUTS"]).joinpath("input_1/voila.ipynb")
while not os.path.exists(input_nb):
    sleep(0.1)

server.terminate()
server.join()

sleep(5)