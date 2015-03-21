@{
    Layout = "post";
    Title = "How to integrate ASP.NET WebApi AttributeRouting with HyprLinkr";
    Date = "2013-08-12T02:02:46";
    Tags = "ASP.NET Web Api, AttributeRouting, DI, HyprLinkr, IoC, StructureMap";
    Description = "Integration of the library HyprLinkr for hypermedia link generation with ASP.NET Web Api and AttributeRouting";
}

<div class="row">
<div class="medium-8 columns">

In my last post, I showed you [how to configure ASP.NET WebApi, StructureMap and HyprLinkr](http://jaskula.fr//blog/2013/07-26-configure-structuremap-in-asp-net-webapi-to-play-nicely-with-hyprlinkr/index.html).

</div>
</div>

<!-- more -->

Today I would like to show you how to use [HyprLinkr](https://github.com/ploeh/Hyprlinkr) with [AttributeRouting](http://attributerouting.net/). HyprLinkr works with the standard route configuration created by the Visual Studio project template (route named "API Default"). If you would like to make it work with another routing framework you have to tweak somehow HyprLinkr. Hopefully, the API is very developer-friendly and Mark Seemann which is the creator of HyprLinkr has provided some means for doing it very easily. For those who don't know AttributeRouting, it allows to define route templates in attributes directly on the controllers and actions. It allows some extra features like hierarchical route definition and so on.

## Usage context

Once you've downloaded and configured AttributeRouting inside your WebApi application, your controllers might look something like this :

	[lang=csharp]
	[RoutePrefix("api/rest")]
	public class ItemsController : ApiController
	{
		private readonly IItemsRepository _itemsRepository;
		private readonly IResourceLinker _resourceLinker;

		public ItemsController(IItemsRepository itemsRepository, 
								IResourceLinker resourceLinker)
		{
			if (itemsRepository == null) 
				throw new ArgumentNullException("itemsRepository");
			if (resourceLinker == null) 
				throw new ArgumentNullException("resourceLinker");

			_itemsRepository = itemsRepository;
			_resourceLinker = resourceLinker;
		}

		[GET("items/{id}/{config?}")]
		public ItemRepresentation GetItem(int id, string config = "small")
		{
			var uri = _resourceLinker.GetUri<ItemsController>(
					a => a.GetRelatedItems(id, config, 1, 15)).ToString();
			return _itemsRepository.GetItem(id, config);
		}
	}

## Tweaking of HyprLinkr

If you recall from [my previous post](http://jaskula.fr/blog/2013/07-26-configure-structuremap-in-asp-net-webapi-to-play-nicely-with-hyprlinkr/index.html) StructureMap is configured to inject `IResourceLinker` in order to resolve url for hypermedia links. However with AttributeRouting it won't work. For that we need to implement our own `IRouteDispatcher` interface and to provide the implementation to the `IResourceLinker` instance being resolved by StructureMap. Here's the implementation of `IRouteDispatcher` for AttributeRouting framework :

	[lang=csharp]
	public class AttributeRoutingRouteDispatcher : IRouteDispatcher
	{
		private readonly HttpRequestMessage _httpRequestMessage;

		public AttributeRoutingRouteDispatcher(
					HttpRequestMessage httpRequestMessage)
		{
			if (httpRequestMessage == null) 
				throw new ArgumentNullException("httpRequestMessage");

			_httpRequestMessage = httpRequestMessage;
		}

		public Rouple Dispatch(MethodCallExpression method, 
						IDictionary<string, object> routeValues)
		{
			if (method == null) 
				throw new ArgumentNullException("method");

			var newRouteValues = 
					new Dictionary<string, object>(routeValues);

			var controllerName = method
				.Object
				.Type
				.Name
				.ToLowerInvariant()
				.Replace("controller", "");
			newRouteValues["controller"] = controllerName;

			var attributeRoute = method.Method
						.GetCustomAttributes(true)
						.Cast<HttpRouteAttribute>()
						.FirstOrDefault();

			string routeName = null;

			if (attributeRoute != null)
			{
				const string patterToMatch = "(:(.*?)*|(?)*)}";
				var strippedFromTokensUrl = 
					Regex.Replace(attributeRoute.RouteUrl, patterToMatch, "}");
				var matchedRoute = 
					_httpRequestMessage.GetConfiguration()
						.Routes.FirstOrDefault(x => 
							x.RouteTemplate.Contains(strippedFromTokensUrl)) 
							as HttpAttributeRoute;
				if (matchedRoute != null) 
					routeName = matchedRoute.RouteName;
			}

			return new Rouple(routeName, newRouteValues);
		}
	}


We need to return a `Rouple` object with a routeName and route values in order to allow HyprLinkr to generate the right url. As input we only need an instance of `HttpRequestMessage`. This is necessary to access the configured routes in the `RouteTable`. When the application is being run for the first time, the AttributeRouting framework scans all the controllers and extracts url templates from the attributes. Then it adds these to the Route table of WebApi configuration object. We need to match the template url extracted from the controller action attribute to the route configured in the route table and then get its name to construct our `Rouple` object. In order to match an url to the attribute's template we have to apply a regex that strips some special characters from the template (type definitions like ":int?", optional parameter "?", etc.)

## Configuring all

In order to construct our rouple object in the custom dispatcher, we need to tell to AttributeRouting framework to generate route names for each registered route (by default this is not done and we can't use it with HyprLinkr). The configuration can be done in WebApi registration section. `AutoGenerateRouteNames` should be set to `true` :

	[lang=csharp]
	var configuration = new HttpWebConfiguration
	{
	        AutoGenerateRouteNames = true
	};
	configuration.AddRoutesFromAssembly(Assembly.GetExecutingAssembly());
	config.Routes.MapHttpAttributeRoutes(configuration);

The last step consist of configuring StructureMap for passing the right dependencies inside our instance of `IResourceLinker` :

	[lang=csharp]
	For<IResourceLinker>()
		.Use(ctx => new RouteLinker(ctx.GetInstance<HttpRequestMessage>(), 
					ctx.GetInstance<AttributeRoutingRouteDispatcher>()));

## In closing

As you noticed, it's very straightforward to adapt HyprLinkr to work with other routes definition frameworks in WebApi. AttribouteRouting will be the next important feature of WebApi Next (V2) so it's important to know how to make it work with HyprLinkr if you're using it as your hypermedia links generating framework.