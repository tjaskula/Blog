@{
    Layout = "post";
    Title = "My 2 weeks trip from OOP to FP with F#";
    Date = "2013-08-14T04:16:51";
    Tags = "F#, FP, Functional Programming, OOP";
    Description = "Relating a developer's experience of changing paradigms from OOP to functional using F#";
}

<div class="row">
<div class="medium-8 columns">

I have been programming using an OOP language since a long, long time. Really? Since the very first betas of .NET Framework I've been always using C# to accomplish almost every programming task. Working for companies that mainly used .NET platform and C# didn't help me to push me in another direction... It's not that I was not interested in other languages...it's that I was afraid that the learning curve will be so high and that I will never have enough time to learn everything to know in order to be efficient and to write a code that follows the best practices for a given language.

</div>
</div>

<!-- more -->

I know that OOP paradigm is not inherent to C# but my goal was not to learn another OOP language but to try something different. Moreover, if you have spent so much time on trying to improve your programming skills applied to OOP paradigm (like AOP, DI, Unit Tests, DDD tactical patterns, etc.), you start to think about how I'd do it with another language, another platform or programming paradigm? That's maybe the main reason that hold me back from trying something else. And a lack of time of course...

And I'm not talking about just trying a "Hello world" or playing around with some basic stuff and nothing more. I'm talking about trying to make a real app even not very big, but to see how one can deal with aspects like domain logic, infra, cross cutting concerns, etc.

And the time came that I was able to invest 2 weeks of my time to learn something else in a real world project. I had to stay on the .NET platform but I've picked a language that has always attracted me : F#

## First contact

The task I had to accomplish was to write an algorithm based on CF (Collaborative Filtering) for building recommendations (for my polish startup [RocketCv](https://www.rocketcv.pl)). I thought it was a great opportunity for learning F# and trying to build something useful. I won't go into too much details in this post about all the impediments I've encountered. This will be for the next series of posts. In this installment I would talk about my first contact with the language, the FP paradigm.

## Tools

You don't need any IDE to program with F# (the same applies for every language, technology on the .NET platform) but I stuck with Visual Studio 2012 for simplicity.

What's great with F# environment is the [REPL](http://en.wikipedia.org/wiki/Read–eval–print_loop) (Read Eval Print Loop) console. You can try immediately to write some code and to check the outcome without recompiling all the stuff. That's very handy. This way you can try very quickly different options and the move to code to unit test project as the first draft.

	Microsoft (R) F# Interactive version 11.0.60610.1
	Copyright (c) Microsoft Corporation. All Rights Reserved.

	For help type #help;;

	> let simpleList a = [ for i in 1..10 do
	                          yield i * a ];;

	val simpleList : a:int -> int list

	> let initializedList = simpleList 10
	;;

	val initializedList : int list = [10; 20; 30; 40; 50; 60; 70; 80; 90; 100]

	>

Here I'm defining a function that will produce a list by multiplying a passed parameter by the current value in for-in loop. As you can see the code is straightforward and easy to understand. Even if there is no real value in this snippet, the F# Interactive (repl console) allows you to tests your code.

## FP Paradigm

Everybody has already heard about the principles of Functional Programming paradigm and is more or less aware of it. I've also heard about it and knew about the most common ones like immutability, functions, values, function composition, higher-order functions, declarative programming, etc. But when you come from the OOP world, the mind shift is not obvious. You have to put aside all you could learn before and try to start from the blank page. It's better to not think about other side aspects related to programming like AOP, DI, etc.

### Immutability

Even though you can use in F# whatever is available in .NET Framework like mutable data structures (Dictionary, List) you're not supposed to do it. You'd better off not touch it because it's supposed to be there for interoperability concerns between languages on the .NET platform or it may be useful in some narrow scenarios.

Immutability is one of the linchpins of FP paradigm so you'd better stick with it. Use all immutable data structures supported in F# like `seq`, `list`, `record types`, `discriminated unions` (not even types as it's easy for beginner to mess everything up because of what you could learn in OOP world).

### Declarative vs Imperative style

The main difference between the two styles is boiled down to "what" and "how" words. The imperative style of OOP programming tells the machine "how" to do stuff and on the other hand the functional programming style tell "what" you want to do. The OOP style is an **execution of statements** because the program is expressed as a **sequence of commands which specify how to achieve the end result**. The functional style we talk about **evaluation of expressions** because **the program code is the expression that specifies the properties of the object we want to get as the end result**. You should strive hard to embrace declarative style in functional code. Let's compare two simple code snippets. What we want to get is the list of the products that are concerned by the current promotion.

In C# this could be done like that without LINQ:

	[lang=csharp]
	public List<string> GetPromotionalProducts(List<Product> products)
	{
		var filteredProductsInfos = new List<string>();
		foreach (var product in products)
		{
			if (product.IsPromotion)
				filteredProductsInfos.Add(
					string.Format("Product name : {0} 
						| UT = {1}", product.Label, product.UnitPrice));
		}

		return filteredProductsInfos;
	}

The code is the basic set of imperative commands telling **how** the goal should be achieved by giving the machine instructions on how to do it.

The same could be written with a functional style using LINQ:

	[lang=csharp]
	public IEnumerable<string> GetPromotionalProducts(List<Product> products)
	{
		return from product in products
			   where product.IsPromotion
			   select string.Format("Product name : {0} 
			   			| UT = {1}", product.Label, product.UnitPrice);
	}

The difference is obvious because now we are telling **what** we want. So the intention is more explicit.

### Function = value

Another important aspect of FP is that the function is the value. I'll write more about it in the next posts but let's see a little snippets that illustrates the general idea:

	Microsoft (R) F# Interactive version 11.0.60610.1
	Copyright (c) Microsoft Corporation. All Rights Reserved.

	For help type #help;;

	> let rec fib n = if n < 2 then 1 else fib (n-2) + fib(n-1);;

	val fib : n:int -> int

	> let printIt valueToPrint = printfn "%d" valueToPrint;;

	val printIt : valueToPrint:int -> unit

	> printIt (fib 10);;
	89
	val it : unit = ()
	>

In the first step we've defined a fibonacci function that takes as a parameter an integer and returns also and integer. In the second step we've defined another function that just prints the result. At the end we're passing as argument a fibonacci function to the print function which prints the final result.

This is not a big deal and in C# you can also achieve the same with delegates. But there is a subtle difference between F# where a function passed as parameter is a value and in C# it would be a delegate.

### Composition

The main building block in FP are values and functions. The composition is done with higher-level functions that takes other functions as parameters. Because the function is the relation between the input parameters and output result it's easier to think about the composition in FP than in OOP where we talk about composition on the object level. I'll write more about it in the next post.

### Parallelizing immutable programs

I didn't had enough time to explore this field but as you functions are immutable and there is no a shared state so parallelizing is easier. I'll write more about it in the next post.

## In Closing

When you switch from one paradigm to another there you start to think about what you knew from a different perspective. Even if I'm not en experienced F# developer or rather I'm a real nob there are so many advantages of using FP that learning it is a real pleasure.

What F# could offer to C# developer?

1. Rapid prototyping and experimenting with the code as well for exploring how .NET libraries work. With REPL console it's very easy and you can quickly write some sketch of the code. You'll save much time.
2. F# libraries can be easily referenced from C# code so you can write a part of the solution in F# and there is no reason to get rid  of C# if you start to develop a parts of the system in F#.

And you? What's your experience in switching from OOP to FP?