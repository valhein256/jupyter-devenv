import os
import logging
import urllib.request
import joblib
import cv2
import numpy as np # linear algebra

from flask import Flask, flash, request, redirect, url_for, render_template
from werkzeug.utils import secure_filename
from flask import Flask

UPLOAD_FOLDER = '/opt/app/static/uploads/'

app = Flask(__name__)
app.secret_key = "secret key"
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024


ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'gif'])

Image_size = 150
model = joblib.load('/usr/local/lib/models/RFC-best_D6')
label_mapping = {
    0: "bad",
    1: "good"
}

def allowed_data(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def upload_form():
    return render_template('upload.html')

@app.route('/', methods=['POST'])
def upload_image():
    if 'file' not in request.files:
        flash('No file part')
        return redirect(request.url)

    data = request.files['file']

    if data.filename == '':
        flash('No image selected for uploading')
        return redirect(request.url)

    if data and allowed_data(data.filename):
        filename = secure_filename(data.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        data.save(filepath)

        img = cv2.imread(filepath)
        test_data = []
        test_data.append(cv2.resize(img, (Image_size, Image_size)))
        test_imgs = np.array(test_data)
        test_imgs = test_imgs.reshape(1, np.dot(150,150), 3)
        test_imgs = cv2.cvtColor(test_imgs, cv2.COLOR_BGR2GRAY)

        y_pred = model.predict(test_imgs)

        #print('upload_image filename: ' + filename)
        flash('The predicted result is "{}"'.format(label_mapping[y_pred[0]]))
        return render_template('upload.html', filename=filename)
    else:
        flash('Allowed image types are -> png, jpg, jpeg, gif')
        return redirect(request.url)

@app.route('/display/<filename>')
def display_image(filename):
    #print('display_image filename: ' + filename)
    return redirect(url_for('static', filename='uploads/' + filename), code=301)

if __name__ == "__main__":
    app.run(port=5031, host='0.0.0.0')

else:
    gunicorn_logger = logging.getLogger('gunicorn.info')
    app.logger.handlers = gunicorn_logger.handlers[:]
    app.logger.setLevel(gunicorn_logger.level)
