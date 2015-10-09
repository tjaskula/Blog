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

### Supervised learning

In supervised learning, we are given a data set and already know what our correct output should look like, having the idea that there is a relationship between the input and the output.
Supervised learning problems are categorized into "**regression**" and "**classification**" problems. In a **regression** problem, we are trying to predict results within a **continuous output**, meaning that we are trying to map input variables to some **continuous** function. In a **classification** problem, we are instead trying to predict results in a **discrete** output. In other words, we are trying to map input variables into **discrete** categories.

**Example**:

Given data about the size of houses on the real estate market, try to predict their price. Price as a function of size is a continuous output, so this is a regression problem.
We could turn this example into a classification problem by instead making our output about whether the house "sells for more or less than the asking price." Here we are classifying the houses based on price into two discrete categories.

#### Linear regression with one variable

For more information, please refer to the Coursera wiki (login required): https://share.coursera.org/wiki/index.php/ML:Linear_Regression_with_One_Variable

* **Model Representation**

In *regression* problems, we are taking input variables and trying to map the output onto a *continuous* expected result function.

Linear regression with one variable is also known as "univariate linear regression."

* **The Hypothesis Function**

Hypothesis function has the general form: $h_\theta(x) = \theta_0 + \theta_1 x$

We give to $h_\theta$ values for $\theta_0$ and $\theta_1$ to get our output 'y'. In other words, we are trying to create a function called $h_\theta$ that is able to reliably map our input data (the x's) to our output data (the y's).

* **Cost function**

We can measure the accuracy of our hypothesis function by using a **cost function**. This takes an average (actually a fancier version of an average) of all the results of the hypothesis with inputs from x's compared to the actual output y's.

$$$
J(\theta_0, \theta_1) = \dfrac {1}{2m} \displaystyle \sum _{i=1}^m \left (h_\theta (x_{i}) - y_{i} \right)^2

This function is otherwise called the "Squared error function", or "Mean squared error". The mean is halved ($\frac{1}{2m}$) as a convenience for the computation of the gradient descent, as the derivative term of the square function will cancel out the $\frac{1}{2}$ term.

Now we are able to concretely measure the accuracy of our predictor function against the correct results we have so that we can predict new results we don't have.

* **Gradient Descent**

So we have our hypothesis function and we have a way of measuring how accurate it is. Now what we need is a way to automatically improve our hypothesis function. That's where gradient descent comes in.

If we were to plot the cost function, we put $\theta_0$ on the x axis and $\theta_1$ on the y axis, with the cost function on the vertical z axis. The points on our graph will be the result of the cost function using our hypothesis with those specific theta parameters.

We will know that we have succeeded when our cost function is at the very bottom of the pits in our graph, i.e. when its value is the minimum.

The way we do this is by taking the **derivative** (the line tangent to a function) of our cost function. The slope of the tangent is the derivative at that point and it will give us a direction to move towards. We make steps down that derivative by the parameter $\alpha$, called the learning rate.

The gradient descent equation is (repeat until convergence):

$$$
\theta_j := \theta_j - \alpha \frac{\partial}{\partial \theta_j} J(\theta_0, \theta_1)

for j=0 and j=1

Intuitively, this could be thought of as (repeat until convergence):

$$$
\theta_j :=\theta_j - \alpha [Slope\:of\:tangent\:aka\:derivative\:in\:j\:dimension]

* **Gradient Descent for Linear Regression**

When specifically applied to the case of linear regression, a new form of the gradient descent equation can be derived. We can substitute our actual cost function and our actual hypothesis function and modify the equation to:

$$$
\begin{align*}
\text{repeat until convergence: } \lbrace & \newline 
\theta_0 := & \theta_0 - \alpha \frac{1}{m} \sum\limits_{i=1}^{m}(h_\theta(x_{i}) - y_{i}) \newline
\theta_1 := & \theta_1 - \alpha \frac{1}{m} \sum\limits_{i=1}^{m}\left((h_\theta(x_{i}) - y_{i}) x_{i}\right) \newline
\rbrace&
\end{align*}

where m is the size of the training set, $\theta_0$ a constant that will be changing simultaneously with $\theta_1$ and $x_{i}, y_{i}$ are values of the given training set (data).

### Unsupervised Learning

Unsupervised learning, on the other hand, allows us to approach problems with little or no idea what our results should look like. We can derive structure from data where we don't necessarily know the effect of the variables.
We can derive this structure by **clustering** the data based on relationships among the variables in the data.
With unsupervised learning there is no feedback based on the prediction results, i.e., there is no teacher to correct you. It’s not just about clustering. For example, associative memory is unsupervised learning.

**Example**:

*Clustering*: Take a collection of 1000 essays written on the US Economy, and find a way to automatically group these essays into a small number that are somehow similar or related by different variables, such as word frequency, sentence length, page count, and so on.
Another, non-Clustering example, is the "Cocktail Party Algorithm" which can find structure in messy data- like identifying individual voices and music from a mesh of sounds at a cocktail party

## Algorithms

### K-nearest neighbors

http://www.statsoft.com/textbook/k-nearest-neighbors