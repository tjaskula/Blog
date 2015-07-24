@{
    Layout = "page";
    Title = "C# Language learning notes";
    Date = "2015-07-23T15:57:27";
    Tags = "C#";
    Description = "C# language learning notes. C# (pronounced as see sharp) is a multi-paradigm programming language encompassing strong typing, " +
    			  " imperative, declarative, functional, generic, object-oriented (class-based), and component-oriented programming disciplines. " +
    			  "It was developed by Microsoft within its .NET initiative and later approved as a standard by Ecma (ECMA-334) and ISO (ISO/IEC 23270:2006). " +
    			  "C# is one of the programming languages designed for the Common Language Infrastructure.";
}

# C# Language

## Polymporphisme
* Une instance de type x peut se référer à un object qui souclasse x
* Upcast : => vers la référence de classe de base (Implicit)
* Downcast : => vers la référence dela souclasse (Explicit)

## Object
### Boxing : value-type => reference

[When does the implicit boxing occurs?](http://theburningmonk.com/2015/07/beware-of-implicit-boxing-of-value-types/)

* When you invoke a virtual method

Value types inherit from the `System.ValueType`, which itself inherits from `System.Object`. Amongst other things, `System.ValueType` provides an override for `Equals` that gives value types the default compare-by-value behaviour.
However, a value types is stored in memory without the Method Table Pointer so in order to dispatch a virtual method call it'll first have to be boxed into a reference type first.

* When you call `List<T>.Contains`

When you call `List<T>.Contains`, an instance of `EqualityComparer<T>` will be used to compare the argument against every element of the list.
This eventually causes a new `EqualityComparer<T>` to be created.
In the default case where the struct doesn't implement the `IEquatable<T>` interface, the `ObjectEqualityComparer<T>` will be returned. And it is in here, that the overridden/inherited `Equals(object other)` method will be used and causes boxing to occur for every comparison!
If, on the other hand, struct implements the `IEquatable<T>` interface then the outcome will be very different. This allows some clever logic to kick in and use the overloaded `Equals(MyStruct other)` instead.

* When you invoke an interface method

Like virtual methods, in order to dispatch an interface method you also need the *Method Table Pointer*, which means boxing is required.
Fortunately, the CLR is able to short-circuit this by calling the method directly if the compile-time type is resolved to the actual value type (e.g. MyStruct) rather than the interface type.

* When `Dictionary<T>` invokes `GetHashCode`

`GetHashCode` is used by hash-based collection types, the most common being `Dictionary<TKey, TValue>` and `HashSet<T>`.
In both cases, it's invoked through the `IEqualityComparer<T>` type we talked earlier, and in both cases the comparer is also initialized through `EqualityComparer<T>.Default` and the `CreateComparer` method.
`GetHashCode` is invoked in many places within `Dictionary<TKey, TValue>` - on `Add`, `ContainsKey`, `Remove`, etc.

### Unboxing : reference type => value-type
### Struct : pas de constructeur sans paramètres, peut implémenter les interfaces mais pas hériter des classes
### Enum : constantes numériques goupées et nommées
### Nested types : peut accéder aux types privés du type contenant

## Generics
* templates de types
* type safety et réduction de boxing/unboxing
* covariant for OUT Subclass to Base
* contravarient for IN Base to Subclass

## Delegates
* découple l'appellant de la méthode cible
* delegate type : protocole auquelle la cible et l'appellant vont se conformer
* delegate instance : objet qui references une ou plusieurs methods à invoquer
* immutable

## Events
* subscriber/broadcaster model
* But est de prévenir souscripteurs d'inférer entre eux (suppression d'autres souscripteurs, invocations et breoadcast à d'autre) donc on a le mot clé event
* peuvent $etre virtuel, overridden, abstract, seald

## Lambda
* method sans nom écrite à la place de l'instance du délegué
* Closure : lambda qui capture les variables qui sont évaluées au runtime et non au moment de la capture

## Threading
* Contexte switching 6000 a 8000 cycles processeur. Intérvient quand bcp de threads sont en concurence pour un core pour s'exécuter CPU bound
* APM : Asynchronous Programmming Model (Begin, End, IAsyncResult)
* EAP : Event based Asynchronous pattern (DownloadAsync, DownloadCompleted)
* TAP : Task based asynchrounous model
* async/await
* but d'utiliser threading : responsiveness, handling slow operations

## Collections
* Array : performant cat les éléments stockées dans un bloc continu en mémoire
* Comparaison : http://geekswithblogs.net/BlackRabbitCoder/archive/2011/06/16/c.net-fundamentals-choosing-the-right-collection-class.aspx		