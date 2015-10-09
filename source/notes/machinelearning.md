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

#### Linear Regression with Multiple Variables

For more information, please refer to the Coursera wiki (login required): https://share.coursera.org/wiki/index.php/ML:Linear_Regression_with_Multiple_Variables

* **Multiple Features**

Linear regression with multiple variables is also known as "multivariable linear regression."

the multivariable form of the hypothesis function as follows, accomodating these multiple features:

$$$
h_\theta (x) = \theta_0 + \theta_1 x_1 + \theta_2 x_2 + \theta_3 x_3 + \cdots + \theta_n x_n

Using the definition of matrix multiplication, our multivariable hypothesis function can be concisely represented as:

$$$
\begin{align*}
h_\theta(x) =
\begin{bmatrix}
\theta_0 \hspace{2em}  \theta_1 \hspace{2em}  ...  \hspace{2em}  \theta_n
\end{bmatrix}
\begin{bmatrix}
x_0 \newline
x_1 \newline
\vdots \newline
x_n
\end{bmatrix}
= \theta^T x
\end{align*}

Now we can collect all $m$ training examples each with $n$ features and record them in an $n+1$ by $m$ matrix.

$$$
\begin{align*}
X =
\begin{bmatrix}
x^{(1)}_0 \hspace{2em} x^{(2)}_0\hspace{2em}  ... \hspace{2em} x^{(m)}_0 \newline
x^{(1)}_1 \hspace{2em} x^{(2)}_1 \hspace{2em} ... \hspace{2em} x^{(m)}_1 \newline
\vdots \newline
x^{(1)}_n \hspace{2em} x^{(2)}_n \hspace{2em} ... \hspace{2em} x^{(m)}_n \newline
\end{bmatrix} 
&=
\begin{bmatrix}
1 & 1 &  ... & 1 \newline
x^{(1)}_1 & x^{(2)}_1 &... & x^{(m)}_1 \newline
\vdots \newline
x^{(1)}_n & x^{(2)}_n & ... & x^{(m)}_n \newline
\end{bmatrix} 
\end{align*}

Notice above that the first column is the first training example (like the vector above), the second column is the second training example, and so forth.

Now we can define $h_\theta(X)$ as a row vector that gives the value of $h_\theta(x)$ at each of the $m$ training examples:

$$$
\begin{align*}
h_\theta(X) =
\begin{bmatrix}
\theta_0 x^{(1)}_0 + \theta_1 x^{(1)}_1 + ... + \theta_n x^{(1)}_n \hspace{3em}
\theta_0 x^{(2)}_0 + \theta_1 x^{(2)}_1 + ... + \theta_n x^{(2)}_n \hspace{3em} ... \hspace{3em}
\theta_0  x^{(m)}_0 + \theta_1 x^{(m)}_1 + ... + \theta_n x^{(m)}_n \newline
\end{bmatrix}
\end{align*}

But again using the definition of matrix multiplication, we can represent this more concisely:

$$$
\begin{align*}
h_\theta(X) =
\begin{bmatrix}
\theta_0 \hspace{2em}  \theta_1 \hspace{2em} ... \hspace{2em} \theta_n
\end{bmatrix}
\begin{bmatrix}
x^{(1)}_0 \hspace{2em} x^{(2)}_0\hspace{2em}  ... \hspace{2em} x^{(m)}_0 \newline
x^{(1)}_1 \hspace{2em} x^{(2)}_1 \hspace{2em} ... \hspace{2em} x^{(m)}_1 \newline
\vdots \newline
x^{(1)}_n \hspace{2em} x^{(2)}_n \hspace{2em} ... \hspace{2em} x^{(m)}_n \newline
\end{bmatrix}=
\theta^T X
\end{align*}

Note: this version of the hypothesis function assumes the matrix $X$ and vector $\theta$ store their values as follows:

$$$
\begin{align*}
X = 
\begin{bmatrix}
x^{(1)}_0 & x^{(2)}_0 & x^{(3)}_0  \newline
x^{(1)}_1 & x^{(2)}_1 & x^{(3)}_1 
\end{bmatrix}
&
,\theta = 
\begin{bmatrix}
\theta_0 \newline
\theta_1 \newline
\end{bmatrix}
\end{align*}

You might instead store the training examples in $X$ row-wise, like such:

$$$
\begin{align*}
X = 
\begin{bmatrix}
x^{(1)}_0 & x^{(1)}_1  \newline
x^{(2)}_0 & x^{(2)}_1  \newline
x^{(3)}_0 & x^{(3)}_1 
\end{bmatrix}
&
,\theta = 
\begin{bmatrix}
\theta_0 \newline
\theta_1 \newline
\end{bmatrix}
\end{align*}

In which case you would calculate the hypothesis function with:

$$$
h_\theta(X) = X \theta

* **Cost function**

$$$
J(\theta) = \dfrac {1}{2m} \displaystyle \sum_{i=1}^m \left (h_\theta (x^{(i)}) - y^{(i)} \right)^2

The vectorized version is:

$$$
J(\theta) = \dfrac {1}{2m} (X\theta - \vec{y})^{T} (X\theta - \vec{y})

* **Gradient Descent for Multiple Variables**

The gradient descent equation itself is generally the same form; we just have to repeat it for our 'n' features:

$$$
\begin{align*}
& \text{repeat until convergence:} \; \lbrace \newline 
\; & \theta_0 := \theta_0 - \alpha \frac{1}{m} \sum\limits_{i=1}^{m} (h_\theta(x^{(i)}) - y^{(i)}) \cdot x_0^{(i)}\newline
\; & \theta_1 := \theta_1 - \alpha \frac{1}{m} \sum\limits_{i=1}^{m} (h_\theta(x^{(i)}) - y^{(i)}) \cdot x_1^{(i)} \newline
\; & \theta_2 := \theta_2 - \alpha \frac{1}{m} \sum\limits_{i=1}^{m} (h_\theta(x^{(i)}) - y^{(i)}) \cdot x_2^{(i)} \newline
& \cdots
\newline \rbrace
\end{align*}

In other words:

$$$
\begin{align*}
& \text{repeat until convergence:} \; \lbrace \newline 
\; & \theta_j := \theta_j - \alpha \frac{1}{m} \sum\limits_{i=1}^{m} (h_\theta(x^{(i)}) - y^{(i)}) \cdot x_j^{(i)} \;  & \text{for j := 0..n}
\newline \rbrace
\end{align*}

Finally, the matrix notation (vectorized) of the Gradient Descent rule is:

$$$
\large
\theta := \theta - \frac{\alpha}{m} X^{T} (X\theta - \vec{y})

* **Gradient Descent in Practice**

We can speed up gradient descent by having each of our input values in roughly the same range. This is because $\theta$ will descend quickly on small ranges and slowly on large ranges, and so will oscillate inefficiently down to the optimum when the variables are very uneven.

The way to prevent this is to modify the ranges of our input variables so that they are all roughly the same. Ideally:

$$$
-1 \le x_i \le 1

or:

$$$
-0.5 \le x_i \le 0.5

These aren't exact requirements; we are only trying to speed things up. The goal is to get all input variables into roughly one of these ranges, give or take a few.

Two techniques to help with this are **feature scaling** and **mean normalization**. Feature scaling involves dividing the input values by the range (i.e. the maximum value minus the minimum value) of the input variable, resulting in a new range of just 1. Mean normalization involves subtracting the average value for an input variable from the values for that input variable, resulting in a new average value for the input variable of just zero. To implement both of these techniques, adjust your input values as shown in this formula:

$$$
x_i := \dfrac{x_i - \mu_i}{s_i}

Example: xi is housing prices in range 100-2000. Then, $x_i := \dfrac{price-1000}{1900}$, where 1000 is the average price and 1900 is the maximum (2000) minus the minimum (100).

* **Features and Polynomial Regression**

We can improve our features and the form of our hypothesis function in a couple different ways.

We can combine multiple features into one. For example, we can combine $x_1$ and $x_2$ into a new feature $x_3$ by taking $x_1 \cdot x_2$.

**Polynomial Regression**

Our hypothesis function need not be linear (a straight line) if that does not fit the data well.

We **can change the behavior or curve** of our hypothesis function by making it a quadratic, cubic or square root function (or any other form).

* **Normal Equation**

The "normal equation" is a version of finding the optimum **without iteration**.

$$$
\large
\theta = (X^T X)^{-1}X^T y

There is **no need to do feature scaling** with the normal equation.

| **Gradient Descent**        | **Normal Equation**           |
| --------------------------- |:-----------------------------:|
| Need to choose alpha        | No need to choose alpha       |
| Needs many iterations       | No need to iterate            |
| Works well when n is large  | Slow if n is very large       |

With the normal equation, computing the inversion has complexity $\mathcal{O}(n^3)$. So if we have a very large number of features, the normal equation will be slow. In practice, according to A. Ng, when $n$ exceeds 10,000 it might be a good time to go from a normal solution to an iterative process.

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