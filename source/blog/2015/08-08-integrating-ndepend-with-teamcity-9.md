@{
    Layout = "post";
    Title = "Integrating NDepend with TeamCity 9";
    Date = "2015-08-08T02:51:22";
    Tags = "NDepend, TeamCity";
    Description = "The goal of this post is to check how easy is the integration of NDepend plugin into the TeamCity 9 build server.";
}

<div class="row">
<div class="medium-8 columns">

The [NDepend 6](http://www.ndepend.com) was released a couple of weeks ago. It comes along with really exciting new features like for example Visual Studio 2015 integration, analysis enhancements, async support, etc. Take a look at NDepend website to have a full list of new features. The feature I'm interested in is the [TeamCity](https://www.jetbrains.com/teamcity/) integration which should be very easy to do according to NDepend team.

</div>
</div>

<!-- more -->

If you use C# as your main programming language and you have already worked on a quite big project you know how painful is to enforce coding rules and to query about dependencies without a right tool. NDepend is a static analysis tool that helps you digging into your code in a very easy and effective way to carry-out code rules checks, code quality checks, comparing two versions of code base and browsing for differences and many more. This is something that you should have in your tool belt. If you're working on medium to large project you are supposed to have a build server and a sort of Continous Integration process. I'm using TeamCity 9 for my projects. It would be nice to take advantage of NDepend static code base analysis inside your CI build. It was always possible to integrate NDepend into your build process in TeamCity but it was quite tedious. NDepend 6 comes with this new shiny TeamCity plugin (for TeamCity 8 and 9) and I decided to give it a shot. Let's try it out and check if this is easier to do than before.

## NDepend TeamCity plugin installation

I have followed the installation steps described at [NDepend documentation](http://www.ndepend.com/docs/teamcity-integration-ndepend) so there is no need to rewrite it here. However, **I'll highlight some of the differences** in the process that I found on my specific environment compared to the official documentation.

First of all, finding the TeamCity plugin folder was not straightforward as my environment variable **TEAMCITY\_DATA\_PATH** was not definied. After checking the official [TeamCity documentation](https://confluence.jetbrains.com/display/TCD9/TeamCity+Data+Directory) we can read the following:

> **Before TeamCity 9.1**, the TeamCity Windows installer configured the TeamCity data directory during installation by setting the **TEAMCITY\_DATA\_PATH** environment variable. The default path suggested for the directory is: *%ALLUSERSPROFILE%\JetBrains\TeamCity*. 
<br />
> **Since TeamCity 9.1**, installer does not ask for the TeamCity data directory and it can be configured on the first TeamCity start.

Obviously I have installed the TeamCity server v9.1 and I don't have the **TEAMCITY\_DATA\_PATH** set. The best way to check where your data directory is located, is to check it directly in the TeamCity web interface. Browse to **Administration -> Global Settings** and check the value of **Data directory:**. The mine is located in *C:\TeamCity\.BuildServer*. You can now copy/paste the NDepend plugin and follow the instructions at [NDepend documentation](http://www.ndepend.com/docs/teamcity-integration-ndepend). At the end, you should be able to display NDepend step in the TeamCity server.

![NDepend step in TeamCity](http://www.ndepend.com/Doc/CI_TeamCity/NDependBuildStep.png)

## NDepend TeamCity plugin configuration

If you follow [NDepend documentation](http://www.ndepend.com/docs/teamcity-integration-ndepend) setting up the NDepend build step is rather strightforward. Don't forget to change paths inside your NDepend project from absolute to relative. Remember that your build server may have different paths than those definied on your development machine. That's why relative paths are very handy. You can achieve it very easily, by going to your Ndepend project properties, then clicking on the **Paths Referenced** tab and then right clicking on absolute paths and selecting **Set as Path Relative** option from the menu.

![NDepend menu](img/NDependMenuAbsToRelPath.png)

Once the change is done and commited, I've add NDepend build step to my build process

<a href="img/TeamCityNDependBuildStep.png"><img alt="TeamCity NDepend build step" src="img/TeamCityNDependBuildStep.png" width="600"></a>

## Running the first build

