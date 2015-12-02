@{
    Layout = "post";
    Title = "Data Science tools in F# through univariante linear regression";
    Date = "2015-12-02T03:18:24";
    Tags = "Machine Learning, Data Science, F#, MathNet.Numerics, FSharp.Charting, XPlot";
    Description = "Exploration of the problem from Machine Learning field like the simple univariate linear regression, and solving it using available tools from F# community.";
}

<div class="row">
<div class="medium-8 columns">

Machine Learning is very interesting and inspiring filed. I've been interested in this topic for several years now, mainly focusing on theory (although I was able to implement a recommeder system for my startup) and having a little experience from the real-world problems. But several months ago I have started a real hardcore learning in Machine Learning, reading many books and following almost every course on Coursera and other MOOC portals. I know that those courses are aimed towards the newcomers like me and don't give you a solid knowledge as if you had a PhD in the field. However with a lot of practice, you can do many usefull things.

</div>
</div>

<!-- more -->

However, every time I read a book or follow a machine learning course, the tools and languages that are used are most often `R` and `Python` and theirs powerful set of packages and easy to use environments. This is for obvious reasons like historical reasons and because of the rich packages the comunity has built over the years that you can chose from to prototype very quickly and to explore the data.

I want to check what kind of tools are available to my prefered language at the moment which is `F#` of course.

## FsLab : the best place to start

If you follow the top F# folks you've certainly heard about the [fslab.org](http://fslab.org/). To quote from the FSlab

> FsLab is a collection of libraries for data-science. It provides a rapid development environment that lets you write advanced analysis with a few lines of production-quality code.

FsLab has many interesting libraries for data-science and the whole process of working with data. It encompasses data access, calulations, charting and producing final reports. You can even integrate `R` language through the data provider.This is very interesting.

For my problem at hand I don't need the whole FsLab package. What I want to is to pick whatever library I need. My additional constraint is to make it work on OSX and mono.

## Part 1: Linear regression with one variable

This sample is taken from the famous Machine Learning course from Stanford University on Coursera. The is the week 2 assignement on linear regression. I've taken this course because I already know the results so it will be easy for me to check against it my F# implementation. You don't need to be aware about machine learning because I'm more focused on libraries I use to achieve my goal rather then explaining the theory.

### The problem

The problem for the assignement is as follows. Suppose you are the CEO of a restaurant franchise and are considering different cities for opening a new outlet. The chain already has trucks in various cities and you have data for profits and populations from the cities. We will need this data to help you select which city to expand to next.

The training data is contained in the `data.csv` file. The first column is the population of a city and the second column is the profit of a food truck in that city. A negative value for profit indicates a loss. So we can have values like that:

	6.1101,17.592
	5.5277,9.1302
	8.5186,13.662
	7.0032,11.854
	...

### Data visualisation

Before starting on any task, it is often useful to understand the data by visualizing it. We can use a scatter plot to visualize the data, since it has only two properties to plot (profit and population). Many real-world problems are multi-dimentional and cannot be plotted on a 2-d plot. But for our simple problem at hand it will be enough.

What i need is a library that allow me to plot. I would like to use it on OSX and from F# interactive. This is important because it allows me to easily propotype and explore my data.

My first choice was [FSharp.Charting](http://fslab.org/FSharp.Charting/). It has been around since some time and it has all powerful features. There is also a package `FSharp.Charting.Gtk` to make it work on OSX with GTK. Unfortunatelly after spending few hours on trying to install `gtk-sharp` on my machine I gave up. I was able to display the form but instead of visualizing the plot it was empty.

My second choice was the other nice package for charting [XPlot](https://tahahachana.github.io/XPlot/). This is based on GoogleCharts and Plotly. Very nice features, I was also able to use it from F# interactive with [Suave.Io](http://suave.io/) support. However it lacks an important feature which is combining plots (scatter and line for example). Or I couldn't find one. So please leave me a comment if you know how to do it.

My third choice was finally to switch to Windows box and use FSharp.Charting.

This is the scatter plot for my training data:

![Scatter plot for training data](img/ScatterPlot.png)

So this looks pretty well. The code for generating the scatter plot is really simple:

	Chart.Point(points)
	    .WithXAxis(Title="Population of City in 10,000s", Min=4.0, Max=24.0)
	    .WithYAxis(Title="Profit in $10,000s")
	    .WithMarkers(Style=ChartTypes.MarkerStyle.Cross, Color=Drawing.Color.Red, Size=7)

The code is really strightforward. You can customize titles, markers' styles, axis scales, etc.

But before we could plot we had to get the data points from somewhere.

### Data calculation

The objective of linear regression is to minimize the cost function:

$$$
J(\theta_0, \theta_1) = \dfrac {1}{2m} \displaystyle \sum _{i=1}^m \left (h_\theta (x_{i}) - y_{i} \right)^2

where the hypothesis $h_\theta (x)$ is given by the linear model:

$$$
$h_\theta(x) = \theta_0 + \theta_1 x$

For this task I need a powerfull library that will alow to work with vectors and matrices. All the $\theta$ parameter should be updated at once and using matrices is very strighforward instead of loops. My first choice was [Math.NET Numerics](http://numerics.mathdotnet.com/) library. It works well on `mono` too.

To calculate the cost function `j` we can simply do this:

	let theta = vector [ 0.0; 0.0; ]
	// intercept parameter needed for calucation. Another feature.
	let xIntercept = x.InsertColumn(0, (Vector<double>.Build.Dense(m, 1.0)))

	let h = xIntercept * theta.ToColumnMatrix()
	let squaredErrors = h.Subtract(y).PointwisePower(2.0);
	let j = (1.0 / (2.0 * (m|> double))) * squaredErrors.ColumnSums();

Look how easy is to do any operation on vectors and matrices. Multiplying them, substracting and transforming is very easy with [Math.NET Numerics](http://numerics.mathdotnet.com/). Although the code is not idiomatic to F#, it's pretty readable.