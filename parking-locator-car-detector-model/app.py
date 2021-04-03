from flask_cors import CORS
import base64
import json
import io
import os
import numpy as np
import requests
import cv2
import numpy as np
from flask import Flask, request, jsonify, render_template
from json import JSONEncoder

APP_ROOT = os.path.dirname(os.path.abspath(__file__))
app = Flask(__name__)
CORS(app)
PORT = 4000
app.config["ENV"] = "development"


class NumpyArrayEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return JSONEncoder.default(self, obj)

# Testing URL


@app.route('/', methods=['GET'])
def hello_world():
    return render_template("index.html")


target = os.path.join(APP_ROOT, 'images/')
MODEL_ENDPOINT = 'http://localhost:8501/v1/models/carDetector:predict'


@app.route('/predict/', methods=['POST'])
def image_classifier():
    if not os.path.isdir(target):
        os.mkdir(target)

    print(request.files)
    data_for_pred = []
    for upload in request.files.getlist("files[]"):
        filename = upload.filename
        destination = "/".join([target, filename])
        upload.save(destination)
        image = cv2.imread(destination)
        image = cv2.resize(image, (128, 128))
        image = image * 1.0/255.0
        data_for_pred.append(image)

    data = np.array(data_for_pred)

    payload = json.dumps({"signature_name": "serving_default",
                          "instances": data}, cls=NumpyArrayEncoder)
    headers = {"content-type": "application/json"}
    r = requests.post(MODEL_ENDPOINT, data=payload, headers=headers)

    preds = json.loads(r.text)['predictions']
    response = []
    files = request.files.getlist("files[]")
    i = 0
    for pred in preds:
        filename = files[i].filename
        response.append(
            {"filename": filename, "isCar": pred[0] > 0.4, "confidence": "{:.3f}".format(float(pred[0]))})
        i += 1
    return jsonify(response)


if __name__ == "__main__":
    app.run('0.0.0.0', port=PORT)
