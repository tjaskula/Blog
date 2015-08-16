@{
    Layout = "page";
    Title = "C# Language learning notes. Only things I have to remember.";
    Date = "2015-07-23T15:57:27";
    Tags = "C#";
    Description = "C# language learning notes. C# (pronounced as see sharp) is a multi-paradigm programming language encompassing strong typing, " +
    			  " imperative, declarative, functional, generic, object-oriented (class-based), and component-oriented programming disciplines. " +
    			  "It was developed by Microsoft within its .NET initiative and later approved as a standard by Ecma (ECMA-334) and ISO (ISO/IEC 23270:2006). " +
    			  "C# is one of the programming languages designed for the Common Language Infrastructure.";
}

# C# Language

## Object Orientation
Object-orientation paradigm, includes:

* encapsulation
* inheritance
* polymorphisme

### Inheritance

A class can *inherit* from another class to extend or customize the original class.

### Encapsulation
Means creating a boundary around *object*, to separate external (public) behavior from its internal (private) implementation details.

### Polymporphisme

* An instance of type x can refer to the object that subclasses x
* Upcast : => to the reference of the base class (Implicit)
* Downcast : => to the reference of the subclass (Explicit)

## Characteristics of C#
C# is:

* Type-safe : cannot interact with `string` as it was an `integer`
* Staticly-typed : language enforces type safety at compile time
* Strongly-types : cannot get around the restrictions the constraints of the type system like for example calling a function that's designed to accept an integer with a floating-point number, unless you first *explicitly* convert floating-point number to an integer.

## Object

### Value and Reference Types

*Value types* : numeric types, `char` type, `bool` type, `struc` and `enum` types.

*Reference types* : all class, array, delegate and interface types.

#### Value types
The content of a *value type* variable or constant is simply a value.

Numeric types

* Integral : `sbyte` (8bits), `short` (16 bits), `int` (32 bits), `long` (64 bits).
* Real : `float` (32 bits, $10^{-45}$ to $10^{38}$), `double` (64 bits, $10^{-324}$ to $10^{308}$), `decimal` (128 bits, $10^{-28}$ to $10^{28}$)

`decimal` is non-native to processor (about 10 times slower than `double`)

> The arithmetic operators (+, -, *, /, %) are definied for all numeric types except the 8- and 16-bit integral types. So C# converts them to larger types as required.

#### Reference types
Reference types have two parts: an *object* and the *reference* to that object. The content of a reference-type variable or constant is a reference to an object that contains the value.
Reference types requires spearate allocations of membory for the reference and the object. The object consumes as many bytes as its fields plus aditional administrative overhead.


#### The Stack and the Heap

*Stack* is a block of memory for storing local variables and parameters. the stack logically grows and shrinks as a function is entered and exited.

*Heap* is a block of memory where `objects` (i.e., reference-type instances) reside. GC scans only heap.

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

* Interfaces and Boxing

Casting a struct to an interface causes boxing. Callin an implicitly implemented member on a struct des not cause boxing.

### Unboxing : reference type => value-type

## Creating types

### Constructors

Constructor with optional parameters may be problematic if it is instantiated from another assemblie. If we add another optional parameter we have to recompile all consuming assemblies because they will continue to call the non existing constructor and fail at runtime. the subtler problem is when we change a value of one of the optional parameters, the callers will continue to call with the old value until they are recompiled. Hence **avoid optional parameters in public functions**.

A static constructor executes once per *type*, rather than once per *instance*. A type can define only one static constructor, and it must be parameterless and have the same name as thr type. The constructor is triggerted either by:

* Instantiating the type
* Accessing a static member in the type

If type has static fields, they will be initialized *before* the static constructor.

### Abstract classes

A class declared as *abstract* can never be instantiated. Instead, only its concrete *subclasses* can be instantiated.

### Structs

A `struct` is similar to a class with the following key differences:

* A struct is a value type, whereas a class is a reference type.
* A struct does not support inheritance (other than implicitly deriving from `object`, or more precisely, `System.ValueType`).

A struct can have all the mebers a class can, except the following:

* A parameterless constructor
* A finalizer
* Virtual members

Struct can implement interfaces.

### Constants

Difference between `consts` and `static readonly`: A `static readonly` field is avantageous when exposing to other assemblies a value that might change in a later version. For instance, suppose assembly X exposes a constant as follows: `public const int MaximumThreads = 20;`. If assembly Y references X and uses this constant, the value 20 will be baked into the assembly Y when compiled. This means that if X is later recompiled with the constant set to 50, Y will still use the old value *until* Y is *recompiled*. A `static readonly` field avoids this problem. 

### Enums

Numeric constants grouped and named. By default its underlying values are of type `int`. You may specify an alternative integral type (`byte`, `long`, etc.)
`[Flag]` enums can combine enum members. To prevent ambiguities, members of a combinable enum require explicitly assigned values, typically in powers of two.

### Nested types

Can access the private members of containing type.

### Generics

* Types templates
* type safety and reduction of boxing/unboxing

#### Covariance and Contravariance

As of C# 4.0 generic interfaces permit covariance (as do generic delegates), but generic classes do not. Arrays also support covariance. Contravariance is only supported with the generic interfaces.

* Covariant for OUT Subclass to Base
* Contravarient for IN Base to Subclass

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