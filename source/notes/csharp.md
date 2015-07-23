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
* Boxing : value-type => reference
* Unboxing : reference type => value-type
* Struct : pas de constructeur sans paramètres, peut implémenter les interfaces mais pas hériter des classes
* Enum : constantes numériques goupées et nommées
* Nested types : peut accéder aux types privés du type contenant

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