@{
    Layout = "post";
    Title = "Some thoughts on ASP.NET ThreadPool Threads, asynchronous execution and TPL";
    Date = "2012-04-06T06:01:50";
    Tags = "ASP.NET, TPL";
    Description = "Some facts about threading, TPL and ASP.NET";
}

<div class="row">
<div class="medium-8 columns">

I've been always confused whenever you should or not implement asynchronous execution for "lengthy" operations when it comes to the ASP.NET platform. It has to be said that there is many factors that come into play. The way ASP.NET concurrent request are handled not only has changed over the different version of Framework .NET but also you have to consider how ASP.NET deals with threads and ThreadPool in general.

</div>
</div>

<!-- more -->

Since the very beginning I hear people saying to make usage of your own threads if you don't want to starve the ThreadPool in ASP.NET process by queuing too many work items. It will prevent ASP.NET from processing further requests. Some confusion has been added with the recent release of TPL library and its usage inside the asynchronous pages/controllers/handlers in regards to the threads and ThreadPool consumption. All the more there is no clear guidance or rather no easy one to find. So let me now sum up all this when it comes to the latest .NET Framework (4/4.5).

## ASP.NET ThreadPool facts

- ASP.NET uses threads from a common language runtime (CLR) thread pool to process requests. As long as there are threads available in the thread pool, ASP.NET has no trouble dispatching incoming requests.
- Async delegates use the threads from ThreadPool.

## When you should start thinking about implementing asynchronous execution?

- When your application performs relatively lengthy I/O operations (database queries, Web service calls, and other I/O operations).
- If you want to do I/O work, then you should be using an I/O thread (I/O Completion Port) and specifically you should be using the async callbacks supported by whatever library class you're using. Theirs names start with the words `Begin` and `End`.
- If requests are computationally cheap to process, then parallelism is probably an unnecessary overhead.
- If the incoming request rate is high, then adding more parallelism will likely yield few benefits and could actually decrease performance, since the incoming rate of work may be high enough to keep the CPUs busy.

## Should I create new Threads?

- Avoid creating new threads like you would avoid the plague.
- If you are actually queuing enough work items to prevent ASP.NET from processing further requests, then you should be starving the thread pool! If you are running literally hundreds of CPU-intensive operations at the same time, what good would it do to have another worker thread to serve an ASP.NET request, when the machine is already overloaded.

## What about the TPL and async await? Does it solve my problems?

- TPL can adapt to use available resources within a process. If the server is already loaded, the TPL can use as little as one worker and make forward progress. If the server is mostly free, they can grow to use as many workers as the ThreadPool can spare.
- Tasks use threadpool threads to execute.
- When async/await will not consume an additional ThreadPool thread ? Only in the case you are using BCL Async methods. that uses an IOCP thread to execute the IO bound operation.

If you are trying to **async execute some sync code or your own library code**, that code will probably **use an additional ThreadPool thread** unless you explicitly use the IOCP ThreadPool or your own ThreadPool. But as far as I know you can't chose whatever you want to use a IOCP thread, and making correct implementation of the ThreadPool is not worth the effort. I doubt someone does a better one that already exists.

I scratched only the surface but if you have more suggestions don't hesitate to leave me a comment.