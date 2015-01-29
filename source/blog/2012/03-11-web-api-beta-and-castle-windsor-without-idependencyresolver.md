@{
    Layout = "post";
    Title = "Web Api (beta) and Castle.Windsor…without IDependencyResolver ?";
    Date = "2012-03-11T10:58:47";
    Tags = "ASP.NET Web Api, Castle.Windsor, DI, IoC";
    Description = "Attempts to make work ASP.NET Web Api (beta) with IDependencyResolver";
}

<div class="row">
<div class="medium-8 columns">

I've been reading through several blog post about how people configure DI support in the new [ASP.NET Web Api](http://www.asp.net/web-api). For example you can read about it here :

</div>
</div>

<!-- more -->

 - Official "[Using the Web API Dependency Resolver](http://www.asp.net/web-api/overview/extensibility/using-the-web-api-dependency-resolver)"
 - "[Autofac ASP.NET Web API (Beta) Integration](http://alexmg.com/post/2012/03/08/Autofac-ASPNET-Web-API-(Beta)-Integration.aspx)"
 - "[Web Api and Ninject](http://wildermuth.com/2012/2/26/WebAPI_and_Ninject)"

What stands out is that every implementation relays on `System.Web.Http.Services.IDependencyResolver` interface which is similar to the one introduced in the ASP.NET MVC 3 and which lives in the `System.Web.Mvc` namespace to avoid confusion. Let's look at its implementation details :

	[lang=csharp]
	public interface IDependencyResolver
    {
    	object GetService(System.Type serviceType);
        IEnumerable<object> GetServices(System.Type serviceType);
    }

Since it was introduced in MVC 3 I've never used it because of its lack of "Release" method and the fact that there is no way cleaning-up resolved services from you DI container. If it's not a problem for all DI containers, it is certainly a problem for Castle.Windsor which tracks resolved components. [Mike Hadlow](http://mikehadlow.blogspot.com/) already spotted it was a problem and wrote a blog post "[The MVC 3.0 IDependencyResolver interface is broken. Don't use it with Windsor.](http://mikehadlow.blogspot.com/2011/02/mvc-30-idependencyresolver-interface-is.html)" I think that this problem still remains with a WebApi `IDependencyResolver` interface and that’s why I decided to not use it. But will I manage to do it ?

## Self Hosting

My current WebApi project is using self hosting feature and for the moment I won't be interested in IIS hosting. After all, there should not be significant differences between two hosting options on adding IoC container support. We will check it after.

Given that in ASP.NET MVC 3 we weren't compelled to implement `IDependencyResolver` at all I started to figure out what other hooks WebApi offers in order to set up my [Composition Root](http://blog.ploeh.dk/2011/07/28/CompositionRoot.aspx). After few minutes of inspecting WebApi's API, I found `IHttpControllerFactory` in the `System.Web.Http.Dispatcher` namespace which seems to me like a viable seam for connecting my own implementation. This interface is quite similar to the one from the `System.Web.Mvc` namespace and is all what I need.

	[lang=csharp]
	public interface IHttpControllerFactory
    {
    	IHttpController CreateController(HttpControllerContext controllerContext, 
    										string controllerName);
   		void ReleaseController(IHttpController controller);
    }

As you noticed, there is "Create" and "Release" controller methods which allows me to use it with Castle.Windsor. Let's look at it :

	[lang=csharp]
	public class WindsorHttpControllerFactory : IHttpControllerFactory
    {
    	private readonly IWindsorContainer _windsorContainer;
   
        public WindsorHttpControllerFactory(IWindsorContainer windsorContainer)
        {
            if (windsorContainer == null)
                throw new ArgumentNullException("windsorContainer", 
                                "The instance of the container cannot be null.");
    
            _windsorContainer = windsorContainer;
        }
    
        public IHttpController CreateController(HttpControllerContext controllerContext, 
        										string controllerName)
        {
        	var controllerFullName = string.Format("{0}.{1}{2}", 
                       typeof(OrderController).Namespace, 
                       controllerName, ControllerSuffix);
            var controllerType = Type.GetType(controllerFullName);
    
            return _windsorContainer.Resolve(controllerType) as IHttpController;
        }
    
        public void ReleaseController(IHttpController controller)
        {
        	var disposableController = controller as IDisposable;
            if (disposableController != null)
                disposableController.Dispose();
    
            _windsorContainer.Release(controller);
        }
	}

Straightforward implementation that doesn't need any comments. Next step is to register it in the WebApi framework.

## First Fail : Registration

I really should start from there... Looking into the WebApi's API I can't really find where to register my own implementation into the framework. It seems that there is nothing similar to `ControllerBuilder.Current.SetControllerFactory`. My current startup code is like this :

	[lang=csharp]
	var config = new HttpSelfHostConfiguration("http://localhost:6666");
    config.Routes.MapHttpRoute("defualt", "{controller}/{id}", 
                                    new {id = RouteParameter.Optional});
    var server = new HttpSelfHostServer(config);
     
    server.OpenAsync().Wait();

Once again, standard initialization. But there is nothing on the `HttpSelfHostConfiguration` class that allows defining your own `IHttpControllerFactory` implementation. The only thing I can see is `HttpSelfHostConfiguration.ServiceResolver.SetResolver` methods with it's overrides. It seems that there is no way to avoid implementing `IDependencyResolver` interface. So let's do it.

## Rolling out my own Dependency Resolver

As my unique solution is to implement my own `IDependencyResolver` so let's do it :

	[lang=csharp]
	public class WindsorDependencyResolver : IDependencyResolver
    {
    	private readonly WindsorContainer _windsorContainer;
   
        public WindsorDependencyResolver(WindsorContainer windsorContainer)
        {
            if (windsorContainer == null)
                throw new ArgumentNullException("windsorContainer", 
                            "The instance of the container cannot be null.");
    
            _windsorContainer = windsorContainer;
        }
    
        public object GetService(Type serviceType)
        {
        	try
            {
            	return _windsorContainer.Resolve(serviceType);
            }
            catch (ComponentNotFoundException)
            {
            	return null;
            }
        }
    
        public IEnumerable<object> GetServices(Type serviceType)
        {
        	try
            {
            	return _windsorContainer.ResolveAll(serviceType).Cast<object>();
            }
            catch (ComponentNotFoundException)
            {
                return new List<object>();
            }
        }
    }

Then we have to register it as follows :

	[lang=csharp]
	static void Main(string[] args)
	{
		var container = new WindsorContainer();
        container.Install(FromAssembly.This());
     
        var config = new HttpSelfHostConfiguration("http://localhost:6666");
        config.ServiceResolver.SetResolver
                            (new WindsorDependencyResolver(container));
        config.Routes.MapHttpRoute("defualt", 
                   "{controller}/{id}", new { id = RouteParameter.Optional });
       
        using (var server = new HttpSelfHostServer(config))
        {
            server.OpenAsync().Wait();
    
            Console.WriteLine("The server is running.");
            Console.ReadLine();
        }
    
        container.Dispose();
    }

This is not sufficient because of the problem described at the beginning of this post (the lack of the "Release" method and thus being unable to release components resolved with Castle.Windsor). The next step is to figure out how to register our implementation of `IHttpControllerFactory`. The good news is that that framework WebApi calls every time to our implementation of `IDependencyResolver` in the hope that it could find a service for every seam that is try to resolve. One of that seams is `IHttpControllerFactory` so it easy to register our own implementation with Castle.Windsor :

	[lang=csharp]
	public class ControllerFactoryInstaller : IWindsorInstaller
    {
    	public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<IHttpControllerFactory>().Instance(
                    new WindsorHttpControllerFactory(container)));
        }
    }

Note, that the default liftetime when unspecified is Singleton.

We're ready to test.

## Second Fail : Testing in Fiddler

To my surprise, when calling my service I end up with the following error (sorry for the French) :

_{"ExceptionType":"System.NullReferenceException","Message":"La référence d’objet n’est pas définie à une instance d’un objet.","StackTrace":"   à System.Web.Http.ApiController.ExecuteAsync(HttpControllerContext controllerContext, CancellationToken cancellationToken)u000du000a   à System.Web.Http.Dispatcher.HttpControllerDispatcher.SendAsyncInternal(HttpRequestMessage request, CancellationToken cancellationToken)u000du000a   à System.Web.Http.Dispatcher.HttpControllerDispatcher.SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)"}_

For me it brakes the [POLA](http://en.wikipedia.org/wiki/Principle_of_least_astonishment). After wandering on Internet I didn't find anything helpful. I decompiled some WebApi code sources, debugged once again and found that the instance of `HttpControllerContext` passed to my controller factory was a bit strange. In fact `ControllerDescriptor` and Controller properties was not assigned. By trial and error I ended up modifying my implementation like this :

	[lang=csharp]
	public IHttpController CreateController(HttpControllerContext controllerContext, 
                                                                string controllerName)
    {
        var controllerFullName = string.Format("{0}.{1}{2}", 
                                                    typeof(OrderController).Namespace, 
                                                    controllerName, ControllerSuffix);
        var controllerType = Type.GetType(controllerFullName);
     
        controllerContext.ControllerDescriptor = 
                    new HttpControllerDescriptor(controllerContext.Configuration, 
                                                        controllerName, controllerType);
        controllerContext.Controller = 
                        _windsorContainer.Resolve(controllerType) as IHttpController;
     
        return controllerContext.Controller;
    }

Now everything works as expected. It's a bit weird as these properties seem to be optional from the point of view of the API, or at least they should be provided with the instance of `HttpControllerContext`.

## In Closing

As you see, there is no way to get rid of `IDependencyResolver` in the WebApi compared to MVC. It's a pity because it puts another burden on the developer to implement an interface that doesn't act as a composition root. In fact our composition root is resolved from the implementation of `IDependencyResolver` so it's a bit confusing. It's understandable from the point of view of ASP.NET team which wanted to make `IDependencyResolver` a central piece of IoC support in the WebApi framework but for me it presents some design flaws as the API is not clear enough which seams should be used and how exactly implement them.

In the next post I'll do the test implementing it in IIS hosting environment.