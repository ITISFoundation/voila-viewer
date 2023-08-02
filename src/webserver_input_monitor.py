import flask, requests, multiprocessing
from flask import render_template
from time import sleep
from uuid import uuid4
import os
from pathlib import Path

app = flask.Flask(__name__)

UNIQUE_TOKEN = "_".join([f"{uuid4()}" for x in range(10)])

@app.route("/")
def index():
    unique_tracking_token = UNIQUE_TOKEN
    return render_template("index.html", unique_tracking_token=unique_tracking_token)

server = multiprocessing.Process(target=app.run, args=("0.0.0.0", 8888))

server.start()

input_nb = Path(os.environ["DY_SIDECAR_PATH_INPUTS"]).joinpath("input_1/voila.ipynb")
while not os.path.exists(input_nb):
    sleep(0.1)

server.terminate()
server.join()

#sleep(5)