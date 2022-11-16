---
title: Supervised Learning With scikit-learn
date: 2023-12-01 00:00:00
featured_image: https://images.unsplash.com/photo-1599194038569-3893bfaff741
excerpt: Supervised learning with scikit-learn is a popular approach for building predictive models based on labeled data. It involves splitting the data into training and testing sets, fitting a model on the training data, making predictions on the test data, and evaluating the model's performance.
keywords: scikit-learn, machine-learning
---

![](https://images.unsplash.com/photo-1599194038569-3893bfaff741)

Supervised learning with scikit-learn is a popular approach for building predictive models based on labeled data. It involves splitting the data into training and testing sets, fitting a model on the training data, making predictions on the test data, and evaluating the model's performance.

Here's a step-by-step guide on how to perform supervised learning with scikit-learn:

- Imagine we have a customer data and based on these data we want to predict if he is most likely will buy a boat. We have a set of customers data like following and if they bought a boat or not.

```bash
pip3 install numpy scipy matplotlib ipython scikit-learn pandas
```

```python
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split

dataset = [
    {
        'age': 66,
        'num_of_cars': 1,
        'owns_house': 'yes',
        'num_of_childs': 2,
        'marital_status': 'widowed',
        'owns_dog': 'no',
        'bought_boat': 'yes'
    },
    {
        'age': 52,
        'num_of_cars': 2,
        'owns_house': 'yes',
        'num_of_childs': 3,
        'marital_status': 'married',
        'owns_dog': 'no',
        'bought_boat': 'yes'
    },
    {
        'age': 22,
        'num_of_cars': 0,
        'owns_house': 'no',
        'num_of_childs': 0,
        'marital_status': 'married',
        'owns_dog': 'yes',
        'bought_boat': 'no'
    },
    {
        'age': 25,
        'num_of_cars': 1,
        'owns_house': 'no',
        'num_of_childs': 1,
        'marital_status': 'single',
        'owns_dog': 'no',
        'bought_boat': 'no'
    },
    {
        'age': 44,
        'num_of_cars': 0,
        'owns_house': 'no',
        'num_of_childs': 2,
        'marital_status': 'divorced',
        'owns_dog': 'yes',
        'bought_boat': 'no'
    },
    {
        'age': 39,
        'num_of_cars': 1,
        'owns_house': 'yes',
        'num_of_childs': 2,
        'marital_status': 'married',
        'owns_dog': 'yes',
        'bought_boat': 'no'
    },
    {
        'age': 26,
        'num_of_cars': 1,
        'owns_house': 'no',
        'num_of_childs': 2,
        'marital_status': 'single',
        'owns_dog': 'no',
        'bought_boat': 'no'
    },
    {
        'age': 40,
        'num_of_cars': 3,
        'owns_house': 'yes',
        'num_of_childs': 1,
        'marital_status': 'married',
        'owns_dog': 'yes',
        'bought_boat': 'no'
    },
    {
        'age': 53,
        'num_of_cars': 2,
        'owns_house': 'yes',
        'num_of_childs': 2,
        'marital_status': 'divorced',
        'owns_dog': 'no',
        'bought_boat': 'no'
    },
    {
        'age': 64,
        'num_of_cars': 2,
        'owns_house': 'yes',
        'num_of_childs': 3,
        'marital_status': 'divorced',
        'owns_dog': 'no',
        'bought_boat': 'no'
    },
    {
        'age': 58,
        'num_of_cars': 2,
        'owns_house': 'yes',
        'num_of_childs': 2,
        'marital_status': 'married',
        'owns_dog': 'yes',
        'bought_boat': 'yes'
    },
    {
        'age': 33,
        'num_of_cars': 1,
        'owns_house': 'no',
        'num_of_childs': 1,
        'marital_status': 'single',
        'owns_dog': 'no',
        'bought_boat': 'no'
    }
]

flags = {
    'single': 0,
    'married': 1,
    'divorced': 2,
    'widowed': 3,
    'no': 0,
    'yes': 1
}
```

- Then we need to transform the above data to be ready for training

```python
import pandas as pd

data = []
target = []
target_names = ["bought_boat"]
feature_names = [
    "age",
    "num_of_cars",
    "owns_house",
    "num_of_childs",
    "marital_status",
    "owns_dog"
]

for item in dataset:
    target.append(flags[item["bought_boat"]])
    data.append([
        item["age"],
        item["num_of_cars"],
        flags[item["owns_house"]],
        item["num_of_childs"],
        flags[item["marital_status"]],
        flags[item["owns_dog"]]
    ])

df = pd.DataFrame.from_records(data, columns=feature_names)
df['target'] = target

X = df.drop('target', axis=1).values.tolist()
y = list(df['target'])
```

- Then we can train and measure the accuracy

```python
X_train, X_test, y_train, y_test = train_test_split(X, y)

# Train the model
model = LogisticRegression()
model.fit(X_train, y_train)

accuracy = model.score(X_test, y_test)

print(accuracy)
```

- Let's predict of new customers will likely buy a boat or not

```python
inputs = [
    {
        'age': 58,
        'num_of_cars': 2,
        'owns_house': 'yes',
        'num_of_childs': 2,
        'marital_status': 'married',
        'owns_dog': 'yes'
    },
    {
        'age': 33,
        'num_of_cars': 1,
        'owns_house': 'no',
        'num_of_childs': 1,
        'marital_status': 'single',
        'owns_dog': 'no'
    }
]

def transform_inputs(items):
    data = []
    for item in items:
        data.append([
            item["age"],
            item["num_of_cars"],
            flags[item["owns_house"]],
            item["num_of_childs"],
            flags[item["marital_status"]],
            flags[item["owns_dog"]]
        ])
    return data

def transform_prediction(predictions):
    out = []
    for prediction in predictions:
        out.append({"buys_boat": True} if prediction == 1 else {"buys_boat": False})
    return out

prediction = model.predict(transform_inputs(inputs))
print(transform_prediction(prediction))
```

The code is also shared as a notebook on [Kaggle](https://www.kaggle.com/clivern/supervised-learning-with-scikit-learn)
