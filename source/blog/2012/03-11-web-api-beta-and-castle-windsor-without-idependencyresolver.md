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