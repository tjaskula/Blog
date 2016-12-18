@{
    Layout = "post";
    Title = "Data structures and algorithms - helping Santa Claus find his road to San Francisco";
    Date = "2016-12-19T10:35:01";
    Tags = "F#, Algorithms, Graphs, Data structures, Priority Queue, Binary Heap, Dijkstra shortest path, functional programming, FP";
    Description = "F# implementation of Dijkstra shortest path algorithm and mutable priority queue data structure";
}

<div class="row">
<div class="medium-8 columns">

It's almost a Christmas time and very soon Santa Claus will pull out his sleigh along with the herd of reindeers. But how his gonna find his way to all the places he is supposed to visit? Well, asuming his not going to buy any GPS device we will try to help him out writing the shortest path algorithm from scratch with the underlying data structures. The goal of this article is to understand the nitty-gritty details about the algorithms and underlying data structures and not how to write code in functional style. That's why I'm not going to use the functional data structures and style (most of the time) but bear with me, this is just to set everyone one on the same page and give the basic understanding of the topic. I want also to give some intuition about the choices that has been made in terms of runing time and space complexity.

</div>
</div>

<!-- more -->

I mentioned Santa Claus but what about San Francisco? To check the correctness of my algorithm I wanted to run it against the real datasets with millions of nodes and edges. I googled for some public datasets and found the "[9th DIMACS Implementation Challenge - Shortest Paths](http://www.dis.uniroma1.it/challenge9/competition.shtml)" California and Nevada large road networks datasets. Perfect for the task at hand. So let's say Santa Claus has to find his way to Golden Gate Bridge in San Francisco from any point in California and Nevada. Of course following the roads on his sleigh (yeah, this kills the whole magic).

## The shortest path algorithm

The road network can be seen as the big graph of nodes connected by the edges. As many of you know, the most popular algorithm to find the shortest path between two nodes in a graph is [Dijkstra algorithm](https://en.wikipedia.org/wiki/Dijkstra's_algorithm). The algorithm exists in many variants; Dijkstra's original variant found the shortest path between two nodes, but a more common variant fixes a single node as the "source" node and finds shortest paths from the source to all other nodes in the graph. This is the approach I'm going to use in this article.

Let's look at the example from [Dijkstra algorithm](https://en.wikipedia.org/wiki/Dijkstra's_algorithm) wikipedia page:

![Dijkstra algorithm](img/Dijkstra_Animation.gif)

From the animated image below we see that the "source" node **a (1)** is fixed and distances are calculated to each node in the graph. The shortest path to the destination node **b (5)** is calculated and is equlat to **20**. It passes through the nodes **3** and **6** which is the shortest path indeed.

### The pseudo code

The pseudo code of Dijkstra algorithm looks something like this:

	initialize graph
	initialize Q // some structure to store the grpah nodes
	Q.insertAll(graph.getVertices())

	while (pq is not empty)
	  node = Q.extract_minimum() // this determines the speed of the algorithm
	  edges = node.getEdges()

	  for all edges {
	    destination = edge.getDestination()
	    newDistance = edge.getLength() + vertex.getDistance()
	    if (newDistance < destination.getDistance()) {
	      destination.setShortestDistance(newDistance)
	      Q.decrease_key(destination) // this also determines the speed of the algorithm

When inserting the graph into the structure `Q` the starting node's shortes distance is set to `0.0` while the other nodes' shortest distances are set to `infinity`. Remove from the `Q` the min element and explore all of it's edges. Compare the shortest distances with all adjacent nodes and if any distance is less than the shortest distance on the current node, update adjacent node shortest distance inside the `Q`. Continue until `Q` is not empty. Nodes which got no edges will finish with the shortest distance of infinity because it is not possible "get to them" from the starting node. However, they will be still removed from the `Q`. 

### The runing time

The original variant of the algorithm uses **linked list** or an **array** to store all the nodes of the graph. The **extract_minimum** operation is simply a linear search through all nodes (vertices) in `Q` and in that case the runing time is $O(|V|^2)$ where $|V|$ is the number of nodes (vertices).

Depending on how `Q` is implemented the runing time can be $O(|E| \cdot T_{dk} + |V| \cdot T_{em})$ where $T_{dk}$ and $T_{em}$ are the complexities of the **decrease_key** and **extract_minimum** operations in `Q` respectively.

Now that we have a basic understanding on how the Dijkstra shortest path aglorithm works we need to implement our data structure `Q`. One of the approaches of speeding up the algorithm is to use a **Priority Queue" and that is what I'm going to implement next.

## Priority Queue

What is a Queue? A queue is an abstract data type supporting two operation `Enqueue` to the rear of the collection of elements and `Dequeue` from the front of the collection of elements. This makes it a FIFO data structure, the first element added to the queue will be the first one to be removed.

What is a Priority Queue? A priority queue is a generalization of a queue where each element is assigned a priority and elements come out in order by priority.

Typical uses cases are:

* Scheduling jobs
* Dijkstra’s algorithm: finding a shortest path in a graph
* Prim's algorithm: constructing a minimum spanning tree of a graph
* Huffman's algorithm: constructing an optimum prefix-free encoding of a string
* Heap sort: sorting a given sequence

Supported operations:

* `Insert(p)` adds a new element with a priority `p`.
* `Extract()` extracts an element with the minimum or maximum priority (depending if it's a Min or Max priority queue)

For simplicity I'm using in my code `Enqueue` and `Dequeue` respectively.

Additionaly others operations like `TryDequeue()`, `Delete(element)` and `ChangePriority(p)` can be implemented.

### Naive implementation considerations

If the priority queue is implemented with **unsorted array/list**, what are the costs of different operations?

* `Enqueue(e)` adds `e` to the end. Running time $O(1)$
* `Dequeue()` scans the array/list for the min/max element. Running time $O(n)$

If the priority queue is implemented with **sorted array**, what are the costs of different operations?

* `Enqueue(e)` finds a position for `e` $O(\log n)$ by using binary search, shift all elements to the
right of it by 1 $O(n)$, insert `e` $O(1)$. Running time $O(n)$
* `Dequeue()` Extracts the last element. Running time $O(1)$

If the priority queue is implemented with **sorted list**, what are the costs of different operations?

* `Enqueue(e)` finds a position for `e` $O(n)$ cannot use binary search, insert `e` $O(1)$. Running time $O(n)$
* `Dequeue()` Extracts the last element. Running time $O(1)$

Is there a better data structure? Yes, **binary heap**

* `Enqueue(e)` Running time $O(\log n)$
* `Dequeue()` Running time $O(\log n)$

### Priority Queue with Binary Heap

Binary max-heap is a binary tree (each node has zero, one, or two children) where the value of each node is at least the values of
its children. In other words, for each edge of the tree, the value of the parent is at least the value of the child. Binary min-heap is the other way round.

My implementation should support the following operations

* `TryDequeue()` Retruns the root element without removing the node. Running time $O(1)$
* `Enqueue e` Attach a new node to any leaf. This however my violate the heap property. To fix this we let the new element to `siftUp`.
* `private siftUp i` it swaps the problematic node (indexed `i`) with its parent until the property of the heap is satisfied. Invariant: heap property is violated on at most one edge. This edge gets closer to the root while sifting-up. Running time $O(H)$ where $H$ is the height of the tree.
* `Dequeue()` replace the root with any leaf but again this may viloate the heap property. To fix it, we let the problematic node `siftDown`.
* `private siftDown i` it swaps the problematic node with larger child until the heap property is satisfied. We swap with the larger child which automatically fixes one of the two bad edges. Running time $O(H)$ where $H$ is the height of the tree.

As most of the operations works in time $O(H)$ where $H$ is the height of the tree, we definitely want a tree to be shallow.

How to keep a tree shallow? Making it a complete binary tree. A binary tree is complete if all its levels are filled except possibly the last one which is filled from left to right. **The first advantage** is that a complete binary tree with $n$ nodes has height at most $O(\log n)$. **The second advantage** is that it can be easily stored as array. How to find the **parent**, **leftChild** and **rightChild** of the node stored in array? This is the simple formulas for `0` based indexed array:

	let parent i = (i - 1) / 2
    let leftChild i = 2 * i + 1
    let rightChild i = 2 * i + 2

This is the mutable implementation of priority queue using `System.Collections.Generic.List<'T>` (which is baked by an array):

	type PriorityQueue<'T when 'T : comparison>(values: seq<'T>, isDescending: bool) =
        let heap : System.Collections.Generic.List<'T> = System.Collections.Generic.List<'T>(values)
    
        let isGreater x y =
            if isDescending then x > y else x < y

        let isLower x y = not (isGreater x y)

        let mutable size = heap.Count

        let shrinkHeap() =
            let shouldShrink = size < heap.Count / 2
            if shouldShrink then heap.RemoveRange(size, heap.Count - size - 1)

        let parent i = (i - 1) / 2
        let leftChild i = 2 * i + 1
        let rightChild i = 2 * i + 2

        let swap i maxIndex =
            let temp = heap.[i]
            heap.[i] <- heap.[maxIndex]
            heap.[maxIndex] <- temp

        let siftUp i =
            let mutable indx = i
            while indx > 0 && isLower heap.[parent indx] heap.[indx] do
                swap (parent indx) indx
                indx <- parent indx

        let rec siftDown i =
            let l = leftChild i
            let r = rightChild i
            let maxIndexLeft = if l < size && isGreater heap.[l] heap.[i] then l else i
            let maxIndex = if r < size && isGreater heap.[r] heap.[maxIndexLeft] then r else maxIndexLeft
            if i <> maxIndex then
                swap i maxIndex
                siftDown maxIndex
            else ()
    
        let build() =
            for i = size / 2 downto 0 do
                siftDown i
    
        do build()

        new (values) = PriorityQueue<'T>(values, true)
        new () = PriorityQueue<'T>([], true)

        member this.IsEmpty = size = 0

        member this.Count = size

        member this.Dequeue() =
            if this.IsEmpty then raise (new Exception("No more elements to dequeue"))
            let result = heap.[0]
            heap.[0] <- heap.[size - 1]
            // we limit the boundary but the last element stays in memory
            // we could use heap.Remove but it's O(n) operation so too slow
            size <- size - 1
            shrinkHeap()
            siftDown 0
            result

        member this.Enqueue p =
            if heap.Count = size then
                heap.Add(p)
            else
                heap.[size] <- p
            size <- size + 1
            siftUp (size - 1)

All the operations are described above. As you can see it is very simple and strightforward. The resulting implementation is:

* **Fast**: all operations work in time $O(\log n)$
* **Space efficient**: elements are stored in the list. Parent-child connections are not stored but are computed on the fly.
* **Easy to implement**: just few lines of code.
* **Not functional friendly**: mutable structures can be sometimes useful, but this implementation doesn't help with functional style and immutability.

The interesting bits are the `build()` function which allows to turn an array into the heap. We repair the heap property going from bottom to top. Initially, the heap property is satisfied in all the leaves (i.e., subtrees of depth 0) then start repairing the heap property in all subtrees of depth 1. When we reach the root, the heap property is satisfied in the whole tree. Running time is $O(n \log n)$ since we call `siftDown` for $O(n)$