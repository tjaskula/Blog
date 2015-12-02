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

#### Logistic Regression

For more information, please refer to the Coursera wiki (login required): https://share.coursera.org/wiki/index.php/ML:Logistic_Regression

It's about **classification problems.**

* **Classification**

Instead of our output vector $y$ being a continuous range of values, it will only be 0 or 1.

$$$
\large
y \in \lbrace 0,1 \rbrace

Where 0 is usually taken as the "negative class" and 1 as the "positive class", but you are free to assign any representation to it.

One method is to use linear regression and map all predictions greater than 0.5 as a 1 and all less than 0.5 as a 0. This method doesn't work well because classification is not actually a linear function.

* **Hypothesis Representation**

Hypothesis should satisfy:

$$$
\large
0 \leq h_\theta (x) \leq 1

The new form uses the "Sigmoid Function," also called the "Logistic Function":

$$$
\large
\begin{align*}
& h_\theta (x) =  g ( \theta^T x ) \newline \newline
& z = \theta^T x \newline
& g(z) = \dfrac{1}{1 + e^{-z}}
\end{align*}

The function g(z) maps any real number to the (0, 1) interval, making it useful for transforming an arbitrary-valued function into a function better suited for classification.

$h_\theta$ will give us the probability that our output is 1. For example, $h_\theta(x)=0.7$ gives us the probability of 70% that our output is 1.

$$$
\large
\begin{align*}
& h_\theta(x) = P(y=1 | x ; \theta) = 1 - P(y=0 | x ; \theta) \newline
& P(y = 0 | x;\theta) + P(y = 1 | x ; \theta) = 1
\end{align*}

Our probability that our prediction is 0 is just the opposite of our probability that it is 1 (e.g. if probability that it is 1 is 70%, then the probability that it is 0 is 30%).

* **Decision Boundary**

In order to get our discrete 0 or 1 classification, we can translate the output of the hypothesis function as follows:

$$$
\begin{align*}
& h_\theta(x) \geq 0.5 \rightarrow y = 1 \newline
& h_\theta(x) < 0.5 \rightarrow y = 0 \newline
\end{align*}

The way our logistic function $g$ behaves is that when its input is greater than or equal to zero, its output is greater than or equal to 0.5:

$$$
\begin{align*}
& g(z) \geq 0.5 \newline
& when \; z \geq 0
\end{align*}

The **decision boundary** is the line that separates the area where y=0 and where y=1. It is created by our hypothesis function.

Again, the input to the sigmoid function $g(z)$ (e.g. $\theta^T X$) need not be linear, and could be a function that describes a circle (e.g. $z = \theta_0 + \theta_1 x_1^2 +\theta_2 x_2^2$) or any shape to fit our data.

* **Cost Function**

We cannot use the same cost function that we use for linear regression because the Logistic Function will cause the output to be wavy, causing many local optima. In other words, it will not be a convex function.

Instead, our cost function for logistic regression looks like:

$$$
\large
\begin{align*}
& J(\theta) = \dfrac{1}{m} \sum_{i=1}^m \mathrm{Cost}(h_\theta(x^{(i)}),y^{(i)}) \newline
& \mathrm{Cost}(h_\theta(x),y) = -\log(h_\theta(x)) \; & \text{if y = 1} \newline
& \mathrm{Cost}(h_\theta(x),y) = -\log(1-h_\theta(x)) \; & \text{if y = 0}
\end{align*}

The more our hypothesis is off from y, the larger the cost function output. If our hypothesis is equal to y, then our cost is 0:

$$$
\begin{align*}
& \mathrm{Cost}(h_\theta(x),y) = 0 \text{  if  } h_\theta(x) = y \newline
& \mathrm{Cost}(h_\theta(x),y) \rightarrow \infty \text{  if  } y = 0 \; \mathrm{and} \; h_\theta(x) \rightarrow 1 \newline
& \mathrm{Cost}(h_\theta(x),y) \rightarrow \infty \text{  if  } y = 1 \; \mathrm{and} \; h_\theta(x) \rightarrow 0 \newline
\end{align*}

If our correct answer 'y' is 0, then the cost function will be 0 if our hypothesis function also outputs 0. If our hypothesis approaches 1, then the cost function will approach infinity.
If our correct answer 'y' is 1, then the cost function will be 0 if our hypothesis function outputs 1. If our hypothesis approaches 0, then the cost function will approach infinity.


* **Simplified Cost Function and Gradient Descent**

We can compress our cost function's two conditional cases into one case:

$$$
\mathrm{Cost}(h_\theta(x),y) = - y \; \log(h_\theta(x)) - (1 - y) \log(1 - h_\theta(x))

A vectorized implementation is:

$$$
\large
J\left(\theta\right)  =  -\frac{1}{m}\left(\log\left(g\left(X\theta\right)\right)^{T}y+\log\left(1-g\left(X\theta\right)\right)^{T}\left(1-y\right)\right)

** Gradient Descent**

Remember that the general form of gradient descent is:

$$$
\begin{align*}
& Repeat \; \lbrace \newline
& \; \theta_j := \theta_j - \alpha \dfrac{\partial}{\partial \theta_j}J(\theta) \newline
& \rbrace
\end{align*}

We can work out the derivative part using calculus to get:

$$$
\begin{align*}
& Repeat \; \lbrace \newline
& \; \theta_j := \theta_j - \frac{\alpha}{m} \sum_{i=1}^m (h_\theta(x^{(i)}) - y^{(i)}) x_j^{(i)} \newline & \rbrace
\end{align*}

A vectorized implementation is:

$$$
\large
\theta := \theta - \frac{\alpha}{m} X^{T} (g(X \theta ) - \vec{y})

* **Multiclass Classification: One-vs-all**

Now we will approach the classification of data into more than two categories. Instead of y = {0,1} we will expand our definition so that y = {0,1...n}.

In this case we divide our problem into n+1 binary classification problems; in each one, we predict the probability that 'y' is a member of one of our classes.

$$$
\large
\begin{align*}
& y \in \lbrace0, 1 ... n\rbrace \newline
& h_\theta^{(0)}(x) = P(y = 0 | x ; \theta) \newline
& h_\theta^{(1)}(x) = P(y = 1 | x ; \theta) \newline
& \cdots \newline
& h_\theta^{(n)}(x) = P(y = n | x ; \theta) \newline
& \mathrm{prediction} = \max_i( h_\theta ^{(i)}(x) )\newline
\end{align*}

We are basically choosing one class and then lumping all the others into a single second class. We do this repeatedly, applying binary logistic regression to each case, and then use the hypothesis that returned the highest value as our prediction.

#### Regularization

* **The Problem of Overfitting**

Regularization is designed to address the problem of overfitting.

**High bias** or **underfitting** is when the form of our hypothesis maps poorly to the trend of the data. It is usually caused by a function that is too simple or uses too few features.

At the other extreme, **overfitting** or **high variance** is caused by a hypothesis function that fits the available data but does not generalize well to predict new data. It is usually caused by a complicated function that creates a lot of unnecessary curves and angles unrelated to the data.

There are two **main** options to address the issue of overfitting:

1. Reduce the number of features.
  * Manually select which features to keep.
  * Use a model selection algorithm
2. Regularization
  * Keep all the features, but reduce the parameters $\theta_j$.

Regularization works well when we have a lot of slightly useful features.

* **Cost Function**

If we have overfitting from our hypothesis function, we can reduce the weight that some of the terms in our function carry by increasing their cost.

Say we wanted to make the following function more quadratic:

$$$
\theta_0 + \theta_1x + \theta_2x^2 + \theta_3x^3 + \theta_4x^4

We'll want to eliminate the influence of $\theta_3 x3$ and $\theta_4 x4. Without actually getting rid of these features or changing the form of our hypothesis, we can instead modify our **cost function**:

$$$
min_\theta\ \dfrac{1}{2m}\sum_{i=1}^m (h_\theta(x^{(i)}) - y^{(i)})^2 + 1000\cdot\theta_3^2 + 1000\cdot\theta_4^2

We've added two extra terms at the end to inflate the cost of $\theta_3$ and $\theta_4$. Now, in order for the cost function to get close to zero, we will have to reduce the values of $\theta_3$ and $\theta_4$ to near zero. This will in turn greatly reduce the values of $\theta_3x^3$ and $\theta_4x^4$ in our hypothesis function.

$$$
min_\theta\ \dfrac{1}{2m}\ \left[ \sum_{i=1}^m (h_\theta(x^{(i)}) - y^{(i)})^2 + \lambda\ \sum_{j=1}^n \theta_j^2 \right]

The $\lambda$, or lambda, is the **regularization parameter**. It determines how much the costs of our theta parameters are inflated.

Using the above cost function with the extra summation, we can smooth the output of our hypothesis function to reduce overfitting. If lambda is chosen to be too large, it may smooth out the function too much and cause underfitting.

* **Regularized Linear Regression**

We can apply regularization to both linear regression and logistic regression. We will approach linear regression first.

**Gradient Descent**

We will modify our gradient descent function to separate out $\theta_0$ from the rest of the parameters because we do not want to penalize $\theta_0$.

$$$
\begin{align*}
& \text{Repeat}\ \lbrace \newline
& \ \ \ \ \theta_0 := \theta_0 - \alpha\ \frac{1}{m}\ \sum_{i=1}^m (h_\theta(x^{(i)}) - y^{(i)})x_0^{(i)} \newline
& \ \ \ \ \theta_j := \theta_j - \alpha\ \left[ \left( \frac{1}{m}\ \sum_{i=1}^m (h_\theta(x^{(i)}) - y^{(i)})x_j^{(i)} \right) + \frac{\lambda}{m}\theta_j \right] &\ \ \ \ \ \ \ \ \ \ j \in \lbrace 1,2...n\rbrace\newline
& \rbrace
\end{align*}

Update rule would look like:

$$$
\theta_j := \theta_j(1 - \alpha\frac{\lambda}{m}) - \alpha\frac{1}{m}\sum_{i=1}^m(h_\theta(x^{(i)}) - y^{(i)})x_j^{(i)}

The first term in the above equation, $1 - \alpha\frac{\lambda}{m}$ will always be less than 1.

**Normal Equation**

To add in regularization, the equation is the same as our original, except that we add another term inside the parentheses:

$$$
\begin{align*}
& \theta = \left( X^TX + \lambda \cdot L \right)^{-1} X^Ty \newline
& \text{where}\ \ L = 
\begin{bmatrix}
 0 & & & & \newline
 & 1 & & & \newline
 & & 1 & & \newline
 & & & \ddots & \newline
 & & & & 1 \newline
\end{bmatrix}
\end{align*}

* **Regularized Logistic Regression**

We can regularize logistic regression in a similar way that we regularize linear regression. Let's start with the cost function.

**Cost Function**

Original cost function:

$$$
(\theta) = - \frac{1}{m} \sum_{i=1}^m \large[ y^{(i)}\ \log (h_\theta (x^{(i)})) + (1 - y^{(i)})\ \log (1 - h_\theta(x^{(i)})) \large]

Regularized:

$$$
J(\theta) = - \frac{1}{m} \sum_{i=1}^m \large[ y^{(i)}\ \log (h_\theta (x^{(i)})) + (1 - y^{(i)})\ \log (1 - h_\theta(x^{(i)}))\large] + \frac{\lambda}{2m}\sum_{j=1}^n \theta_j^2

**Gradient Descent**

$$$
\begin{align*}
& \text{Repeat}\ \lbrace \newline
& \ \ \ \ \theta_0 := \theta_0 - \alpha\ \frac{1}{m}\ \sum_{i=1}^m (h_\theta(x^{(i)}) - y^{(i)})x_0^{(i)} \newline
& \ \ \ \ \theta_j := \theta_j - \alpha\ \left[ \left( \frac{1}{m}\ \sum_{i=1}^m (h_\theta(x^{(i)}) - y^{(i)})x_j^{(i)} \right) + \frac{\lambda}{m}\theta_j \right] &\ \ \ \ \ \ \ \ \ \ j \in \lbrace 1,2...n\rbrace\newline
& \rbrace
\end{align*}

This is identical to the gradient descent function presented for linear regression.

#### Neural Networks: Representation

Neural networks offers an alternate way to perform machine learning when we have complex hypotheses with many features.

* **Non-linear Hypotheses**

Performing linear regression with a complex set of data with many features is very unwieldy. For example:

$$$
\begin{align*}
& g(\theta_0 + \theta_1x_1^2 + \theta_2x_1x_2 + \theta_3x_1x_3 \newline
& + \theta_4x_2^2 + \theta_5x_2x_3 \newline
& + \theta_6x_3^2 )
\end{align*}

That gives us 6 features. $\frac{(3 + 2 - 1)!}{(2!\cdot (3-1)!)} = 6$

* **Model Representation 1**

At a very simple level, neurons are basically computational units that take input (**dendrites**) as electrical input (called "spikes") that are channeled to outputs (**axons**).
In our model, our dendrites are like the input features ($x_1\cdots x_n$), and the output is the result of our hypothesis function.

In neural networks, we use the same logistic function as in classification:

$$$
\frac{1}{1 + e^{-\theta^Tx}}

In neural networks however we sometimes call it a sigmoid (logistic) **activation** function.

$$$
\large
\begin{align*}
& a_i^{(j)} = \text{"activation" of unit $i$ in layer $j$} \newline
& \Theta^{(j)} = \text{matrix of weights controlling function mapping from layer $j$ to layer $j+1$}
\end{align*}

If we had one hidden layer, it would look visually something like:

$$$
\begin{bmatrix}
x_0 \newline
x_1 \newline
x_2 \newline
x_3
\end{bmatrix}
\rightarrow
\begin{bmatrix}
a_1^{(2)} \newline
a_2^{(2)} \newline
a_3^{(2)} \newline
\end{bmatrix}
\rightarrow
h_\theta(x)

The values for each of the "activation" nodes is obtained as follows:

$$$
\begin{align*}
a_1^{(2)} = g(\Theta_{10}^{(1)}x_0 + \Theta_{11}^{(1)}x_1 + \Theta_{12}^{(1)}x_2 + \Theta_{13}^{(1)}x_3) \newline
a_2^{(2)} = g(\Theta_{20}^{(1)}x_0 + \Theta_{21}^{(1)}x_1 + \Theta_{22}^{(1)}x_2 + \Theta_{23}^{(1)}x_3) \newline
a_3^{(2)} = g(\Theta_{30}^{(1)}x_0 + \Theta_{31}^{(1)}x_1 + \Theta_{32}^{(1)}x_2 + \Theta_{33}^{(1)}x_3) \newline
h_\Theta(x) = a_1^{(3)} = g(\Theta_{10}^{(2)}a_0^{(2)} + \Theta_{11}^{(2)}a_1^{(2)} + \Theta_{12}^{(2)}a_2^{(2)} + \Theta_{13}^{(2)}a_3^{(2)}) \newline
\end{align*}

This is saying that we compute our activation nodes by using a $3\times 4$ matrix of parameters. We apply each row of the parameters to our inputs to obtain the value for one activation node. Our hypothesis output is the logistic function applied to the sum of the values of our activation nodes, which have been multiplied by yet another parameter matrix $\Theta^{(2)}$ containing the weights for our second layer of nodes.

Each layer gets its own matrix of weights, $\Theta^{(j)}$.

The dimensions of these matrices of weights is determined as follows:

$$$
\text{If network has $s_j$ units in layer $j$ and $s_{j+1}$ units in layer $j+1$, then $\Theta^{(j)}$ will be of dimension $s_{j+1} \times (s_j + 1)$.}

The +1 comes from the addition in $\Theta^{(j)}$ of the "bias nodes," $x_0$ and $\Theta_0^{(j)}$. In other words the output nodes will not include the bias nodes while the inputs will.

* **Model Representation II**

In our previous example if we replaced the variable $z$ for all the parameters we would get:

$$$
\begin{align*}
a_1^{(2)} = g(z_1^{(2)}) \newline
a_2^{(2)} = g(z_2^{(2)}) \newline
a_3^{(2)} = g(z_3^{(2)}) \newline
\end{align*}

Now we can get a vector of our activation nodes for layer j as follows:

$$$
\large
a^{(j)} = g(z^{(j)})

Where our function $g$ can be applied element-wise to our vector $z^(j)$.

To compute our final hypothesis, let's first compute another $z$ vector:

$$$
z^{(j+1)} = \Theta^{(j)}a^{(j)}

This last theta matrix ($\Theta^{(j)}$) will have only **one row** so that our result is a single number.

We then get our final result with:

$$$
h_\Theta(x) = a^{(j+1)} = g(z^{(j+1)})

Notice that in this **last step**, between layer $j$ and layer $j+1$, we are doing **exactly the same thing** as we did in logistic regression.

Adding all these intermediate layers in neural networks allows us to more elegantly produce interesting and more complex non-linear hypotheses.

The $\Theta^{(1)}$ matrices for AND, NOR, and OR are:

$$$
\begin{align*}
AND:\newline
\Theta^{(1)} =
\begin{bmatrix}-30 & 20 & 20\end{bmatrix} \newline
NOR:\newline
\Theta^{(1)} = 
\begin{bmatrix}10 & -20 & -20\end{bmatrix} \newline
OR:\newline
\Theta^{(1)} = 
\begin{bmatrix}-10 & 20 & 20\end{bmatrix} \newline
\end{align*}

We can combine these to get the XNOR logical operator (which gives 1 if $x_1$ and $x_2$ are both 0 or both 1).

$$$
\begin{align*}
\begin{bmatrix}
x_0 \newline
x_1 \newline
x_2
\end{bmatrix} \rightarrow
\begin{bmatrix}
a_1^{(2)} \newline
a_2^{(2)} 
\end{bmatrix} \rightarrow
\begin{bmatrix}
a^{(3)}
\end{bmatrix} \rightarrow
h_\Theta(x)
\end{align*}

For the transition between the first and second layer, we'll use a $\Theta^{(1)}$ matrix that combines the values for AND and NOR:

$$$
\Theta^{(1)} = 
\begin{bmatrix}
-30 & 20 & 20 \newline
10 & -20 & -20
\end{bmatrix}

For the transition between the second and third layer, we'll use a $\Theta^{(2)}$ matrix that uses the value for OR:

$$$
\Theta^{(2)} = 
\begin{bmatrix}-10 & 20 & 20\end{bmatrix}

$$$
\begin{align*}
& a^{(2)} = g(\Theta^{(1)} \cdot x) \newline
& a^{(3)} = g(\Theta^{(2)} \cdot a^{(2)}) \newline
& h_\Theta(x) = a^{(3)}
\end{align*}

And there we have the XNOR operator using one hidden layer!

* **Multiclass Classification**

To classify data into multiple classes, we let our hypothesis function return a vector of values. Say we wanted to classify our data into one of four final resulting classes:

$$$
\begin{align*}
\begin{bmatrix}
x_0 \newline
x_1 \newline
x_2 \newline
\cdots \newline
x_n
\end{bmatrix} \rightarrow
\begin{bmatrix}
a_0^{(2)} \newline
a_1^{(2)} \newline
a_2^{(2)} \newline
\cdots
\end{bmatrix} \rightarrow
\begin{bmatrix}
a_0^{(3)} \newline
a_1^{(3)} \newline
a_2^{(3)} \newline
\cdots
\end{bmatrix} \rightarrow \cdots \rightarrow
\begin{bmatrix}
h_\Theta(x)_1 \newline
h_\Theta(x)_2 \newline
h_\Theta(x)_3 \newline
h_\Theta(x)_4 \newline
\end{bmatrix} \rightarrow
\end{align*}

Our final layer of nodes, when multiplied by its theta matrix, will result in another vector, on which we will apply the $g()$ logistic function to get a vector of hypothesis values.

Our resulting hypothesis for one set of inputs may look like:

$$$
h_\Theta(x) = 
\begin{bmatrix}
0 \newline
0 \newline
1 \newline
0 \newline
\end{bmatrix}

In which case our resulting class is the third one down, or $h_\Theta(x)_3$.

We can define our set of resulting classes as $y$:

$$$
y^{(i)} = \begin{bmatrix}1\newline 0\newline 0\newline 0\end{bmatrix}
\begin{bmatrix}0\newline 1\newline 0\newline 0\end{bmatrix}
\begin{bmatrix}0\newline 0\newline 1\newline 0\end{bmatrix}
\begin{bmatrix}0\newline 0\newline 0\newline 1\end{bmatrix}

Our final value of our hypothesis for a set of inputs will be one of the elements in y.

#### Neural Networks: Learning

For more information, please refer to the Coursera wiki (login required): https://share.coursera.org/wiki/index.php/ML:Neural_Networks:_Learning

* **Cost function**

In neural networks, we may have many output nodes.

For neural networks, the cost function is going to be slightly more complicated then for regularized logistic regression:

$$$
\begin{gather*}
\large
J(\Theta) = - \frac{1}{m} \left[ \sum_{i=1}^m \sum_{k=1}^K y^{(i)}_k \log ((h_\Theta (x^{(i)}))_k) + (1 - y^{(i)}_k)\log (1 - (h_\Theta(x^{(i)}))_k)\right] + \frac{\lambda}{2m}\sum_{l=1}^{L-1} \sum_{i=1}^{s_l} \sum_{j=1}^{s_{l+1}} ( \Theta_{j,i}^{(l)})^2
\end{gather*}

Some nested summations are added to account for our multiple output nodes. In the first part of the equation, between the square brackets, we have an additional nested summation that loops through the number of output nodes.

In the regularization part, after the square brackets, we must account for multiple theta matrices. The number of columns in our current theta matrix is equal to the number of nodes in our current layer (including the bias unit). The number of rows in our current theta matrix is equal to the number of nodes in the next layer (excluding the bias unit). As before with logistic regression, we square every term.

* **Backpropagation algorithm**

"Backpropagation" is neural-network terminology for minimizing our cost function, just like what we were doing with gradient descent in logistic and linear regression.

Our goal is to compute:

$$$
\min_\Theta J(\Theta)

For the **last layer**, we can compute the vector of delta values with:

$$$
\large
\delta^{(L)} = a^{(L)} - y

Where L is our total number of layers and $a^{(L)}$ is the vector of activation units for the last layer. So our "error values" for the last layer are simply the differences of our actual results in the last layer and the correct outputs in y.

To get the delta values of the layers before the last layer, we can use an equation that steps us back from right to left:

$$$
\delta^{(l)} = ((\Theta^{(l)})^T \delta^{(l+1)})\ .*\ g'(z^{(l)})

The delta values of layer $l$ are calculated by multiplying the delta values in the next layer with the theta matrix of layer $l$. We then element-wise multiply that with a function called $g'$, or g-prime, which is the derivative of the activation function $g$ evaluated with the input values given by $z^{(l)}$.

The g-prime derivative terms can also be written out as:

$$$
g'(z^{(l)}) = a^{(l)}\ .*\ (1 - a^{(l)})

This can be shown and proved in calculus.

$$$
g(z) = \frac{1}{1 + e^{-z}}

The full backpropagation equation for the inner nodes is then:

$$$
\delta^{(l)} = ((\Theta^{(l)})^T \delta^{(l+1)})\ .*\ a^{(l)}\ .*\ (1 - a^{(l)})

* **Backpropagation Intuition**

The cost function is:

$$$
\begin{gather*}
J(\theta) = - \frac{1}{m} \left[ \sum_{t=1}^m \sum_{k=1}^K y^{(t)}_k \ \log (h_\theta (x^{(t)}))_k + (1 - y^{(t)}_k)\ \log (1 - h_\theta(x^{(t)})_k)\right] + \frac{\lambda}{2m}\sum_{l=1}^{L-1} \sum_{i=1}^{s_l} \sum_{j=1}^{s_l+1} ( \theta_{j,i}^{(l)})^2
\end{gather*}

If we consider simple non-multiclass classification (k = 1) and disregard regularization, the cost is computed with:

$$$
cost(t) =y^{(t)} \ \log (h_\theta (x^{(t)})) + (1 - y^{(t)})\ \log (1 - h_\theta(x^{(t)}))

More intuitively you can think of that equation roughly as:

$$$
cost(t) \approx (h_\theta(x^{(t)})-y^{(t)})^2

Intuitively, $\delta_j^{(l)}$ is the "error" for $a^{(l)}_j$ (unit $j$ in layer $l$)

More formally, the delta values are actually the derivative of the cost function:

$$$
\delta_j^{(l)} = \dfrac{\partial}{\partial z_j^{(l)}} cost(t)

Recall that our derivative is the slope of a line tangent to the cost function, so the steeper the slope the more incorrect we are.

* **Gradient Checking**

Gradient checking will assure that our backpropagation works as intended.

We can approximate the derivative of our cost function with:

$$$
\dfrac{\partial}{\partial\Theta}J(\Theta) \approx \dfrac{J(\Theta + \epsilon) - J(\Theta - \epsilon)}{2\epsilon}

With multiple theta matrices, we can approximate the derivative **with respect to** $\Theta_j$ as follows:

$$$
\dfrac{\partial}{\partial\Theta_j}J(\Theta) \approx \dfrac{J(\Theta_1, \dots, \Theta_j + \epsilon, \dots, \Theta_n) - J(\Theta_1, \dots, \Theta_j - \epsilon, \dots, \Theta_n)}{2\epsilon}

A good small value for ${\epsilon}$ (epsilon), garantee the math above to become true. If the value be much smaller, may we will end up with numerical problems. Proposed value would be ${\epsilon = 10^{-4}}$

We are only adding or subtracting epsilon to the $\Theta_j$ matrix.

Once you've verified **once** that your backpropagation algorithm is correct, then you don't need to compute gradApprox again. The code to compute gradApprox is very slow.

* **Random Initialization**

Initializing all theta weights to zero does not work with neural networks. When we backpropagate, all nodes will update to the same value repeatedly.

Instead we can randomly initialize our weights:

Initialize each $\Theta^{(l)}_{ij}$ to a random value between $[-\epsilon,\epsilon]$:

$$$
\epsilon = \dfrac{\sqrt{6}}{\sqrt{\mathrm{Loutput} + \mathrm{Linput}}}
\Theta^{(l)} =  2 \epsilon \; \mathrm{rand}(\mathrm{Loutput}, \mathrm{Linput} + 1) - \epsilon

Note: this epsilon is unrelated to the epsilon from Gradient Checking

* **Putting it Together**

First, pick a network architecture; choose the layout of your neural network, including how many hidden units in each layer and how many layers total.

  * Number of input units = dimension of features $x^{(i)}$
  * Number of output units = number of classes
  * Number of hidden units per layer = usually more the better (must balance with cost of computation as it increases with more hidden units)
  * Defaults: 1 hidden layer. If more than 1 hidden layer, then the same number of units in every hidden layer.

**Training a Neural Network**

1. Randomly initialize the weights
1. Implement forward propagation to get $h_\theta(x^{(i)})$
1. Implement the cost function
1. Implement backpropagation to compute partial derivatives
1. Use gradient checking to confirm that your backpropagation works. Then disable gradient checking.
1. Use gradient descent or a built-in optimization function to minimize the cost function with the weights in theta.

When we perform forward and back propagation, we loop on every training example.

#### Advice for Applying Machine Learning

For more information, please refer to the Coursera wiki (login required): https://share.coursera.org/wiki/index.php/ML:Advice_for_Applying_Machine_Learning

### Unsupervised Learning

Unsupervised learning, on the other hand, allows us to approach problems with little or no idea what our results should look like. We can derive structure from data where we don't necessarily know the effect of the variables.
We can derive this structure by **clustering** the data based on relationships among the variables in the data.
With unsupervised learning there is no feedback based on the prediction results, i.e., there is no teacher to correct you. It’s not just about clustering. For example, associative memory is unsupervised learning.

This terminology is applied to both linear and logistic regression.

**Example**:

*Clustering*: Take a collection of 1000 essays written on the US Economy, and find a way to automatically group these essays into a small number that are somehow similar or related by different variables, such as word frequency, sentence length, page count, and so on.
Another, non-Clustering example, is the "Cocktail Party Algorithm" which can find structure in messy data-like identifying individual voices and music from a mesh of sounds at a cocktail party

## Algorithms

### K-nearest neighbors

http://www.statsoft.com/textbook/k-nearest-neighbors test