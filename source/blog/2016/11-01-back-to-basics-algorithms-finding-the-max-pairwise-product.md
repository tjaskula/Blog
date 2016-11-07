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

**Input 1:**

	[7; 5; 14; 2; 8; 8; 10; 1; 2; 3]

**Output 1:**

	140 // (14 * 10)

**Input 2:**

	[7; 5; 14; 2; 15; 15; 10; 1; 2; 3]

**Output 2:**

	225 // (15 * 15)

**Input 3:**

	[100000; 90000]

**Output 3:**

	9000000000 // (100000 * 90000)

Hint: Watch out the Integer overflow when multiplying two numbers together.

This is a very simple problem so many of us would go stright to the right solution but in many more complicated cases it is worth to consider writing *brute force* algorithm that is sure to work correctly and to give us the right answer. This algorithm will also help us in the debug process where the results of different implementations can be compared.

### Brut Force

What the Brute Force would be for this problem? The easiest thing would be to solve it iteratively with two nested loops. The outer loop would go from $i = 0$ to $n - 1$ while the inner loop would go from $i + 1$ to $n - 1$. This way we can compare the product of every pair of numbers to the last highest product and if its larger, we set the last highest product as the current product, if not we continue until the end of the list. The implementation would look something along these lines:

	let getMaxPariwiseProduct (numbers: int array): int64 =
	    let mutable result = 0L
	    let n = numbers.Length
	    for i in 0..(n - 1) do
	        for j in (i + 1)..(n - 1) do
	            if int64(numbers.[i]) * int64(numbers.[j]) > result then
	                result <- int64(numbers.[i]) * int64(numbers.[j])
	            else ()
	    result

This is not at all idiomatic to the functional approach but at least it works. The results are as expected for Input 1, 2 and 3 respectively:

	140L
	225L
	9000000000L

Unfortunatelly the time complexity is $\theta(n^2)$ which is not great at all. But we can do better.

### Recursive approach

Instead of using nested loops we may want to test another approach. We can iterate recursively throught the list, taking a maximum number and append it to the empty list that will contain only two maximum elements. Once the maximum number is found in the list, we have to remove it from the list and to iterate again on it until we find another maximum number that we will append to the list containing the first maximum number. The code looks like that:

	let rec removeFirst pred lst =
	    match lst with
	    | h::t when pred h -> t
	    | h::t -> h::removeFirst pred t
	    | _ -> []

	let findTwoMax l =
	    let rec twoMaxIter o l' =
	        match o with
	        | _ when List.isEmpty(l') -> o
	        | [x; y] -> o
	        | _ -> 
	            let m = List.max l'
	            l' 
	            |> removeFirst (fun e -> e = m)
	            |> twoMaxIter (m :: o)
	    twoMaxIter [] l 
	    |> List.map int64
	    |> List.reduce (*)

At line 17 we pass to `twoMaxiter` function an empty list which is supposed to contain two maximum numbers, and the input list of all numbers. Then we match on the empty list `o`, if the list `l'` is emtpty then we return the list `o`. If the `o` list has two elements, then we are also done, we have our two maximum numbers. Otherwise we take the maximum number from the list `l'` we remove it with `removeFirst` function (filtering would not work because if the list has two or more equals max numbers we want just to remove the first one) and then we recurse another one appending the max number to the result list `o` and the rest of the list `l'`.

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