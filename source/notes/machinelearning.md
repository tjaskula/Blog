@{
    Layout = "page";
    Title = "Machine Learning";
    Date = "2015-08-01T13:48:27";
    Tags = "Machine Learning";
    Description = "Machine learning is a subfield of computer science[1] that evolved from the study of pattern recognition and computational learning theory in artificial intelligence. " +
    			  "Machine learning explores the construction and study of algorithms that can learn from and make predictions on data. " +
    			  "Such algorithms operate by building a model from example inputs in order to make data-driven predictions or decisions, rather than following strictly static program instructions.";
}

# Machine Learning

In a nutshell, ML allows computing systems to become smarter with experience, where the experience happens to be past data and human input. Unlike a traditional rules-based approach to software development where inputs and outputs are known at the outset, ML provides a powerful way to construct and study algorithms that learn from data without the need to program individual rules. ML enables computers to learn the relationships between inputs and expected outcomes such that – when the machine is fed new data at a later point in the future – it can predict what the likely outcome is going to be.

## Vocabulary

Machine Learning vocabulary:

* **Experiments** are built by data scientists to create and study different algorithms while they determine the best model to solve their current problem.
* **Model** generally refers to a *trained model* in which an algorithm has been trained to work with a specific set of data around which it can make predictions.
* **Features** are individual and measurable data points that are to be fed into models to perform predictions on.
* **Labels** are historic results associated with a set of features.
* **Training Data** is a pairing of historic Features and historic Labels and is used as a basis to train a model. Note, however, that labels are not always required to create a useful model.
* **Supervised Learning** refers to the training of a model where the *Training Data* contains both *Features* and *Labels*. The way to think about this is we are training the computer to learn on historic outcomes, so it already has an understanding of what it should produce.
* **Unsupervised Learning** refers to the training of a model where the *Training Data* contains only Features.

## Use cases

Spam filtering, priority filtering, smart tagging, product recommendations

## General information

There are three main types of machine learning:

* classification: multiple choice answers, each corresponding to a class like email's "spam vs. ham,"" it uses predictive analysis to answer the question: "What type of email is this?""
* regression: numerical answers, like the value of a house assessed by a real estate agent. Take characteristics of houses on the market like number of bedrooms and bathrooms, overall size, and year built along with their pricing information. With machine learning, we are trying to fill in the missing values of new houses to market, based on the input you can give. The ML should give the pricing output.
* recommendation: Simply, given this user, what are the top five products to show him?


http://www.saedsayad.com/data_mining_map.htm
Extract also info from this http://image.slidesharecdn.com/machinelearningwithspark-150401081552-conversion-gate01/95/machine-learning-with-big-data-using-apache-spark-4-638.jpg?cb=1427876633

Azure
https://azure.microsoft.com/en-us/documentation/articles/machine-learning-algorithm-choice/

## Algorithms

### K-nearest neighbors

http://www.statsoft.com/textbook/k-nearest-neighbors