from flask import Flask,request, url_for, redirect, render_template, jsonify
import pandas as pd
import joblib
import numpy as np


app = Flask(__name__)

# load model
with open("../results/winequality_pred_model.joblib", 'rb') as model:
    tree_model = joblib.load(model)

cols = ['alcohol', 
		'sulphates', 
		'total sulfur dioxide', 
		'volatile acidity', 
		'pH', 
		'density',
		'fixed acidity',
		'citric acid',
		'residual sugar',
		'chlorides',
		'free sulfur dioxide']

@app.route('/')
def home():
    return render_template("home.html")

@app.route('/predict', methods=['POST'])
def predict():
	important_features = [eval(x[0]) for x in list(request.form.listvalues())] # get features from user inputt
	wine_features = important_features + [0] * 5 # 5 trivial features
	X_new = pd.DataFrame(np.array(wine_features).reshape(-1,1).T, columns=cols)
	prediction = tree_model.predict(X_new).tolist()[0] # make prediction on user input
	pred_label = 'BAD' if prediction == 0 else 'GOOD' 
	return render_template('home.html', pred='Expected wine quality would be {}'.format(pred_label))


if __name__ == '__main__':
    app.run(debug=True)
