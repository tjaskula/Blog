@{
    Layout = "post";
    Title = "Back to basics: Algorithms - finding the max pairwise product";
    Date = "2016-11-01T12:05:56";
    Tags = "F#, Algorithms, functional programming, FP";
    Description = "Learning F# through the implementaton of basic algorithms";
}

<div class="row">
<div class="medium-8 columns">

Once you've acquired some experience using your favorite programming language, doing somme cool apps, even if they are complicated, I think it's always good to go back to the roots and start implementing some algorithms. Why is that? Algorithms have some interesting properties that will require to look at the problem at hand from a different point of view. They will force you to use your language in a different way because you'll need to fulfill those properties. So what are the properties I'm talking about?

</div>
</div>

<!-- more -->

It depends, on the problem at hand, on the algorithm, on the data structure. But generally speaking it's about time and space complexity expressed as Big-O. So sometimes you'll give up on nice recursive structure, because the iterative one is faster. Another time you'll use a mutable array instead of immutable list and so on and so forth.

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

> Hint: Watch out the Integer overflow when multiplying two numbers together.

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

At line 17 we pass to `twoMaxiter` function as first parameter, an empty list which is supposed to contain two maximum numbers at the end, and as the second parameter, the input list of all numbers. Then we match on the empty list `o`. If the list `l'` is emtpty then we return the list `o`. If the `o` list has two elements, then we are also done, we have our two maximum numbers. Otherwise we take the maximum number from the list `l'` we remove it with `removeFirst` function (filtering would not work because if the list has two or more equals max numbers we want just to remove the first one) and then we recurse another time appending the max number to the result list `o` and passing also the rest of the list `l'`. At the end we compute the product of two maximum found numbers.

The results are as expected for Input 1, 2 and 3 respectively:

	140L
	225L
	9000000000L

The time complexity is much better then the brute force algorithm. We have `n` operations to find the first max, then we have `n` operations to remove the max found number from the end of the list, the next iteration finding the next one max number is `n - 1` operation and removing it from the rest of the list is also `n - 1`. Roughly speaking it is $\theta(4n)$. We could avoid removing the second time the maximum number from the rest of the list as we already have our two max numbers but this would be $\theta(3n)$. Dropping off the constant we can consider it as $\theta(n)$

But this problem can be easily solved using just one iteration ever the list of numbers.

### Folding the list

A nice approach to this problem would be using the `List.fold` function, passing in the empty list `state` and the input list containing all the elements. The fold operation moves through all the elements, if the state length is less then 2 we append the current element to the state, otherwise if the state has an element less then the current element we keep the max element in the state and append the current element. At the end we return the state which will hold two maximum elements. At the end we compute the product of two maximum found numbers. The algorithm looks like the following:

	let findTwoMaxFold l =
	    l |> List.fold (fun state elem -> 
	                    if List.length state < 2 then
	                        elem :: state
	                    elif List.exists (fun e -> e < elem) state then
	                        [(List.max state); elem]
	                    else state
	                    ) [] 
	      |> List.map int64
	      |> List.reduce (*)

The results are as expected for Input 1, 2 and 3 respectively:

	140L
	225L
	9000000000L

Estimating the runing time is easy. We iterate just once over the list of `n` elements. So it's $\theta(n)$. The operations on the state holding at most two elements are insignificant.

> Note: We could also take the same approach to solve the problem in the recursive algorithm

There is no difference in execution time when the input list are small as in the samples above. But the difference can be significant on very large inputs. Let's consider this

### Stress testing and mesuring time on large inputs

Let's consider the constraints. The number of elements `n` is between the following range $2 \le n \le 2\cdot10^5$.

Generating the input is very easy:

	open System
	let r = new Random(347)
	let n = 200001
	let l = [for i in 2..n do
	            yield r.Next(0, pown 10 5)]

This will produce a list of 200000 elements.

The first algorithm to test is the brute force approach

	> #time
	- l |> Array.ofList |> getMaxPariwiseProduct
	- #time
	- ;;


And the result is:


	--> Timing now on

	Real: 00:04:17.058, CPU: 00:04:15.764, GC gen0: 0, gen1: 0
	val it : int64 = 9999700002L

	--> Timing now off


It took more than 4 minutes to compute the result on my computer. Even if I'm doing an extra step of converting the list to an array, this doesn't have much of the inflence on the running time.

Let's look at the recursive approach:


	> #time
	- l |> findTwoMax
	- #time
	- ;;


And the result is:


	--> Timing now on

	Real: 00:00:04.632, CPU: 00:00:04.663, GC gen0: 5, gen1: 0
	val it : int64 = 9999700002L

	--> Timing now off


As you see, this is much better then the brut foce approach. We improved the runing time from over 4 minuts to 4 seconds. Let's see at the implementation using fold:


	> #time
	- l |> findTwoMaxFold
	- #time
	- ;;


And the result is:


	--> Timing now on

	Real: 00:00:00.052, CPU: 00:00:00.052, GC gen0: 0, gen1: 0
	val it : int64 = 9999700002L

	--> Timing now off


So this is really impressive. We improved the running time even better then the previous run going from over 4 seconds to 52 milliseconds. Even if asymptotically the running time of the recursive approach and the one using fold was $\theta(n)$, the real running time difference is huge.

## Conclusion

This simple problem showed how different algorithm implementations can greatly improve/decrease the overal running time. The important points to consider are:

 - brute force approach is always a good step to take as a base line for measuring time and correctness of the algorithm. It's often simpler to get it right and unless the runing time is reasonable (not taking hours or even more to run) it is very usefull.
 - The asympthotic runing times are not always equal in practice. We saw that the recursive algorithm and the fold have similar runing time expressed as $\theta(n)$ but in practice there is a huge difference.
 - always stress test your implementation under the muximum input you think your algorithm may run under.