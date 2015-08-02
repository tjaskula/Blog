@{
    Layout = "page";
    Title = "API Security";
    Date = "2015-07-28T17:15:27";
    Tags = "API, Security";
    Description = "API security and the application of standards such as OAuth and OpenID Connect. " +
    			  "API Access Control and API Federation and its interaction with enterprise infrastructure, social identity and application developers.";
}

# API Security

## Protocols

### OpenId

#### OpenId Connect

* Extends OAuth 2.0
* Describes user_info, ID token based on JWT
* Web friendly and modern alternative to SAML web browser SSO

## OAuth

* [Resources and specifications](http://tools.ietf.org/wg/oauth/)

## Token based authentication

Why?

* Stateless and scalable servers
* Mobile application ready
* Pass authentication to other applications
* Extra security

Details about how [tokens came around](https://scotch.io/tutorials/the-ins-and-outs-of-token-based-authentication)

As web is stateless...

Before we had

* a server that had to remeber user details in session and send a cookie

Problems:

* Sessions need to be stored by the server (scalability and performance problems)
* Scalability
* CORS: As we want to expand our application to let our data be used across multiple mobile devices, we have to worry about cross-origin resource sharing (CORS). When using AJAX calls to grab resources from another domain (mobile to our API server), we could run into problems with forbidden requests.
* CSRF: We will also have protection against cross-site request forgery (CSRF). Users are susceptible to CSRF attacks since they can already be authenticated with say a banking site and this could be taken advantage of when visiting other sites.

**Token based authentication is stateless**. We are not storing any information about our user on the server or in a session.

Benefits of tokens

* Stateless and Scalable
* Security
* Extensibility (Friend of A Friend and Permissions)
* Multiple Platforms and Domains by `Access-Control-Allow-Origin: *`
* Standards Based (JSON Web Tokens)

### JSON Web Tokens

[Details](https://scotch.io/tutorials/the-anatomy-of-a-json-web-token)

Whar are JSON Web Tokens

* JSON Web Tokens work across different programming languages
* JWTs are self-contained
* JWTs can be passed around easily
