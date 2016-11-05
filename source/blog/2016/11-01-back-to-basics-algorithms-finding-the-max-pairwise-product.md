@{
    Layout = "post";
    Title = "Back to basics: Algorithms - finding the max pairwise product";
    Date = "2016-11-01T12:05:56";
    Tags = "F#, Algorithms";
    Description = "Learning F# through the implementaton of basic algorithms";
}

<div class="row">
<div class="medium-8 columns">

Once you've acquired some experience using your favorite programming language, doing somme cool apps, even if they are complicated, I think it's always good to go back to the roots and start implementing some algorithms. Why is that? Algorithms have some interesting properties that will require to look at the problem at hand from a different point of view. They will force you to use your language in a different way because you'll need to fulfill those properties. So what are the properties I'm talking about?

</div>
</div>

<!-- more -->

It depends, on the problem at hand, on the algorithm, on the data structure. But generally speaking it's about time and space complexity expressed as Big-O. So sometimes you'll give up on nice recursive structure, because the iterrative one is faster. Another time you'll use a mutable array instead of immutable list and so on and so forth.

The goal is to start with a very simple problems and learn how it can be solved with F#. Let's try with the first problem.

## Problem: Maximum Pairwise Product

Given a sequence of non-negative integers $a_0, \dots, a_{n-1}$, find the maximum pairwise product, that is, the largest integer that can be obtained by multiplying two different elements from the sequence.

### Input Constraints

The number of elements $n$ of the input is $2 \le n \le 2\cdot10^5$ and the range of elements spread from $0 \le a_0, \dots, a_{n-1} \le 10^5$

### Output

Single number - the maximum pairwise product

### Samples

Input:

	[7; 5; 14; 2; 8; 8; 10; 1; 2; 3]

Output:

	140 // (14 * 10)

Input:

	[7; 5; 14; 2; 15; 15; 10; 1; 2; 3]

Output:

	225 // (15 * 15)

Input:

	[100000; 90000]

Output:

	9000000000 // (100000 * 90000)

Hint: Watch out the Integer overflow when multiplying two numbers together.

> #time
- l |> Array.ofList |> getMaxPariwiseProduct
- #time
- ;;

--> Timing now on

Real: 00:04:17.058, CPU: 00:04:15.764, GC gen0: 0, gen1: 0
val it : int64 = 9999700002L

--> Timing now off


--> Timing now on

Real: 00:00:00.052, CPU: 00:00:00.052, GC gen0: 0, gen1: 0
val it : int64 = 9999700002L

--> Timing now off

> #time
- l |> findTwoMax
- #time
- ;;

--> Timing now on

Real: 00:00:04.632, CPU: 00:00:04.663, GC gen0: 5, gen1: 0
val it : int64 = 9999700002L

--> Timing now off