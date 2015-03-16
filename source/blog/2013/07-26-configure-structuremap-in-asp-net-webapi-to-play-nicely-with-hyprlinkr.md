@{
    Layout = "post";
    Title = "Configure StructureMap in ASP.NET WebApi to play nicely with HyprLinkr";
    Date = "2013-07-26T10:00:11";
    Tags = "ASP.NET Web Api, DI, HyprLinkr, IoC, StructureMap";
    Description = "If you want to know more how automatically generate hypermedia links using HyprLinkr, and how to register it with StructureMap DI, please read on";
}

<div class="row">
<div class="medium-8 columns">

There are plenty of blog posts about how to configure StructureMap with ASP.NET WebApi so I won't go into much details about that.

</div>
</div>

<!-- more -->

The goal of this post is to show you how to configure [HyprLinkr](https://github.com/ploeh/Hyprlinkr) to be correctly injected into your web api controllers. For those who don't know what [HyprLinkr](https://github.com/ploeh/Hyprlinkr) is, here is a little description taken from the project wiki page https://github.com/ploeh/Hyprlinkr

> Hyprlinkr is a small and very focused helper library for the ASP.NET Web API. It does one thing only: it creates URIs according to the application's route configuration in a type-safe manner.

Let’s set up some context of how HyprLinkr is used.

## Usage context

The main component in HyprLinkr is `RouteLinker` which implements `IResourceLinker` interface and that I want to inject inside my web api constructor.

	[lang=csharp]
	public class ItemsController : ApiController
	{
		private readonly IItemsRepository _itemsRepository;
		private readonly IResourceLinker _resourceLinker;

		public ItemsController(IItemsRepository itemsRepository, IResourceLinker resourceLinker)
		{
			if (itemsRepository == null) throw new ArgumentNullException("itemsRepository");
			if (resourceLinker == null) throw new ArgumentNullException("resourceLinker");

			_itemsRepository = itemsRepository;
			_resourceLinker = resourceLinker;
		}

	        // some stuff here
	}

## What doesn't work?

If you follow the best practices, the composition root of ASP.NET WebApi would be a custom controller activator (implementation of `IHttpControllerActivator`). In my case it’s based on StructureMap and is defined as follows :

	[lang=csharp]
	public class StructureMapControllerActivator : IHttpControllerActivator
	{
		private readonly Container _container;

		public StructureMapControllerActivator(Container container)
		{
			if (container == null) throw new ArgumentNullException("container");
			_container = container;
		}

		public IHttpController Create(HttpRequestMessage request, 
				HttpControllerDescriptor controllerDescriptor, Type controllerType)
		{
			try
			{
				return (IHttpController)_container.GetInstance(controllerType);
			}
			catch (Exception e)
			{
				// TODO : Logging
				throw e;
			}
		}
	}

The registration of `IResourceLinker` in StructureMap is simple like that :

	[lang=csharp]
	For<IResourceLinker>().Use<RouteLinker>();

The problem is when you run this code and when the first request hits `ItemsController`,  StructureMap throws an exception saying that the mapping for `HttpRequestMessage` is not defined and thus the `IResourceLinker` instance cannot be resolved.

When you look into the `RouteLinker` code you understand the error. You have to pass at least an instance of `HttpRequestMessage` to the constructor of `RouteLinker`. This is understandable as `RouteLinker` needs a request context in order to generate urls for the links.

## How to make it work?

The main issue is that we need to provide an `HttpRequestMessage` instance before the controller is resolved. The only place where we have an instance of `HttpRequestMessage` is in the controller activator. So we need to kind of inject the instance of `HttpRequestMessage` into the StructureMap container before the controller is resolved. Fortunately StrucureMap has such a feature and we could do something like this in the `StrucureMapControllerActivator` :

	[lang=csharp]
	public IHttpController Create(HttpRequestMessage request, 
			HttpControllerDescriptor controllerDescriptor, Type controllerType)
	{
		try
		{
			_container.Inject(typeof(HttpRequestMessage), request);
			return (IHttpController)scopedContainer.GetInstance(controllerType);
		}
		catch (Exception e)
		{
			// TODO : Logging
			throw e;
		}
	}

This might be a good idea at first sight, except that is not…

Do you spot an eventual issue?

What could happen with concurrent requests? The container instance is shared between requests. It means that when an instance of `HttpRequestMessage` is injected into the container, and before the container resolves the controller, another request could come in and inject HIS instance of `HttpRequestMessage`. Then when the first controller is resolved, the wrong instance of `HttpRequestMessage` would be passed into the `RouteLinked` constructor.

Another point that I that maybe StructureMap doesn't allow multiple injection of the same instance type. I haven't checked that. But anyways i wouldn't work for the first reason I mentioned.

## StructureMap and nested containers

One handy feature of StructureMap are nested containers. If you don't know what the nested containers are, please read Jeremy Miller post about it when it was introduced in StructureMap http://codebetter.com/jeremymiller/2010/02/10/nested-containers-in-structuremap-2-6-1/. To sum up we want to create a nested container on each incoming request and to inject there an instance of `HttpRequestMessage`. Each request will have it's own nested container from which the controller and all dependencies will be pulled. Let's refactor our `StructureMapControllerActivator` :
	
	[lang=csharp]
	public IHttpController Create(HttpRequestMessage request, 
			HttpControllerDescriptor controllerDescriptor, Type controllerType)
	{
		try
		{
			var scopedContainer = _container.GetNestedContainer();
			scopedContainer.Inject(typeof(HttpRequestMessage), request);
			request.RegisterForDispose(scopedContainer);
			return (IHttpController)scopedContainer.GetInstance(controllerType);
		}
		catch (Exception e)
		{
			// TODO : Logging
			throw e;
		}
	}

As you can see, all dependencies are pulled from the nested container. However you might wonder why we need this line?

	[lang=csharp]
	request.RegisterForDispose(scopedContainer);

In fact nested containers has some feature that you might not be aware of.

> The nested container will track all of the transient objects that it creates.  When the nested container itself is disposed, it will call Dispose() on any of the transient objects that it created. A normal StructureMap Container does not track the transient objects that it creates

This is important because it means that if you don't dispose of your nested container you may encounter some memory leaks as it track the resolution of all transient components. Fortunately the web api framework allows us to register our nested container for dispose.

There is a last thing to do. We have to change our `IResourceLinker` registration in StructureMap in order to tell which constructor we want to use when `RouteLinker` will be constructed. By default StructureMap selects most "greedy" constructor which means with most of the arguments.

	[lang=csharp]
	For<IResourceLinker>().Use(ctx => new RouteLinker(ctx.GetInstance<HttpRequestMessage>()));

Now when you run the application, everything works as expected.