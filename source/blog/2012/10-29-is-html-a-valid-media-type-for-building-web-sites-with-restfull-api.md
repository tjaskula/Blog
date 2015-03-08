@{
    Layout = "post";
    Title = "Is HTML a valid media-type for building web sites with RESTful API ?";
    Date = "2012-10-29T06:01:50";
    Tags = "ASP.NET Web Api, REST, RESTful API";
    Description = "In this installement I try to find out if HTML can be a valid media-type for building RESTful Api";
}

<div class="row">
<div class="medium-8 columns">

This is the question I've been asking myself while confronted to a problem of building a web site and RESTful API at the same time. I've been told that I can't build one and have both. Why? HTML is just another media-type but what is generally used when building web sites is the capacity of **templated view generation** which is much more then simple HTML resource representation.

</div>
</div>

<!-- more -->

And yes, I know, the ambiguity is even more emphasized when we try to chose a right framework for the task at hand. In short, the guideline is; if you want HTML based web site then use ASP.NET MVC and for JSON/XML support use rather ASP.NET Web API or another framework like Nancy (I'm speaking here for the .NET world). Well, I don't want make my choice based on that criteria. Let's go deeper to see what options we have.

Almost all the "RESTful" web service I've seen until now are constructed around two main media-types; JSON and XML. Less employed but still interesting in some scenarios is Atom. The most prevailing is the JSON media-type because of the increasing number of Js frameworks that have showed up since few years for building client side web sites.

## But what about HTML?

HTML is here since the very beginning of the web but still not very used in RESTful api as media-type. When we look back on the recent framework releases for building RESTful API in the .NET world we notice that HTML templated view generation is not supported OOTB. While for example [ASP.NET Web API](http://www.asp.net/web-api) or [Nancy](http://nancyfx.org) allows you to do what you want by bending a little bit a framework (Nancy just have another Nuget package) you still have a feeling that HTML is something that doesn't fit very well to the RESTful API design.

HTML from the very beginning was meant to represent informative documents that contains links to related documents which perfectly fit to the principle of media-type for REST API design. As identified by R. Fielding related to the "Web architectural style", one of the six constraints that has to be respected is **Uniform Interface**. The interactions between clients, servers and other network based intermediaries depends on the uniformity of their interfaces. If any of the components stray from the established standards, then the Web's communication system breaks down.

### HTML and Uniform interface

The uniform interface boils down to the four constraints identified by R. Fielding :

1. Identification of resources
2. Manipulation of resources through representations
3. Self-descriptive messages
4. Hypermedia as the engine of application state (HATEOAS)

Let's see how it is related to the HTML media-type.

#### Identification of resources

Each resource should be addressed by a unique identifier such as a URI. So this constraint is not directly related to the HTML media-type.

#### Manipulation of resources through representations

Clients manipulate representations of resources. The same exact resource can be represented to different clients in different ways. For example, a document might be represented as HTML to a web browser, and as JSON to an automated program. **The key idea here is that the representation is a way to interact with the resource but it is not the resource itself**. This conceptual distinction allows the resource to be represented in different ways and formats without ever changing its identifier. The HTML is a valid representation of resource.

#### Self-descriptive messages

A resource's desired state can be represented within a client's request message. A resource's current state may be represented within the response message that comes back from a server. The **self-descriptive** messages may include metadata to convey additional details regarding the resource state, the representation format and size, and the message itself. Moreover through the HTTP headers it’s possible to organize the various types of metadata into uniform fields. The HTML is a valid media-type as self-descriptive message.

#### Hypermedia as the engine of application state (HATEOAS)

A resource's state representation includes links to related resources. Links are the threads that weave the Web together by allowing users to traverse information and applications in a meaningful and directed manner. The presence, or absence, of a link on a page is an important part of the resource's current state. HTML has hyperlinks so this constraint is also valid.

There is no point to prove that HTML is valid as representation of the resource. It's from the very beginning of the web. After all, if your web browser couldn't render HTML documents, the human Web would have been stunted from the start. Typically, resource representations such as HTML *are meant for human consumption via a web browser*. Browsers are the most common computer agents on the Web today. Another software agent consumes the *XML or JSON representations as part of a business-to-business process*.

## RESTful API and templated view generation

Here we go straight to the point. The main confusion among the developer community is not the HTML as a media-type but the constraints that are directly related to the web sites view construction. I talk here about .NET platform but I think the same constraints apply everywhere.

Templated view generation is a mean of transforming html templates for web pages filling them with data (often from different sources) into HTML pages. The problem is that :

> HTML page != HTML representation of the resource

What does this statement imply? In fact very much. Because when we're building a web site, what we're used to see in our browser is not just a simple HTML representation of a specific resource but often very complex HTML view construction mixing up the data from different sources and using child html views for the name of reusability. This means :

- MasterPages/Layouts are used to guarantee a consistent look and feel of the rendered HTML.
- PartialViews are used for keeping in one place common html code and using it in different parent views.
- URI is not used as resource identification but as handler of page generation using very often mixed resources of different kind or different data view projection to present user with the UI for the functional use case at hand (dashbord, shoping cart, item detail page, etc.)
- Web site navigation is here for broader user experience of the web site, not just for the purpose of the resource state transformation (HATEOAS).
- The presentation of the HTML is altered with CSS.
- Other client frameworks like js are used.
- Many other reasons.

Going further with the analysis we see that achieving both i.e building RESTful API and html based web site is almost impossible. If we would like to go down this path it means that underlying framework we use to build our RESTful api with, in all the cases, is just returning resource representation in Json/Xml/Html with it's hypermedia links. But in the case of the web site the page construction (master pages, and content page composition, etc.) should be handled by something else that is not of the responsibility of the RESTful API framework and that is used later in the pipeline. Well, as far as I know this doesn't exist yet.

## Can I build one to have both?

Or, could I use HTML as the representation of the resource to build a web site with. Moreover, thanks to the content-negotiation I would also have a RESTful API. That is a fair question to answer. I think that I we go down the path of ASP.NET API and Nancy, templated view generation is far more complex than just a resource representation in the given format like HTML for example. A REST resource has it's own semantics and business meaning that doesn't necessarily align with the UI considerations and especially doesn't care about how it is presented to the user.

I understand now why ASP.NET Web Api has it's own existence compared to ASP.NET. Many people were ranting after the release of the ASP.NET Web Api that Microsoft is confusing the developer community because both ASP.NET MVC and API seemed to handle many common responsibilities. But in fact no.

This means that for me bothering with HTML as media-type has no value. I still want build one and have both. That's why my choice will be to build a RESTFul API with a framework like ASP.NET Web API, Nancy or event Node.js serving a JSON/XML. I want use a templated view generation on the server side. I'd rather use a view composition on the client side with JS framework like AngularJs. I would have then the best of two worlds; less code to write and greater encapsulation of responsibilities i.e APIs serves just resources, view and templates are composed on the client.