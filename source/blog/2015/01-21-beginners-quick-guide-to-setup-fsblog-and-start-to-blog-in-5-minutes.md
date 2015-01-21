@{
    Layout = "post";
    Title = "Beginners quick guide to setup FsBlog and start to blog in 5 minutes";
    Date = "2015-01-21T11:55:09";
    Tags = "F#, FsBlog";
    Description = "If you would like to blog on GitHub pages but you don't want to deep dive to much into" +
                  " documentation and you don't want to waste your time, just keep on reading. " +
                  "In this post you will learn how to set up quickly FsBlog, a static web page generator " +
                  "written in F# for GitHub pages. But, don't be scared. You don't need to know F# in order to use it.";
}

<div class="row">
<div class="medium-8 columns">

If you would like to blog on GitHub pages but you don't want to deep dive to much into documentation and you don't want to waste your time, just keep on reading. In this post you will learn how to set up quickly FsBlog, a static web page generator written in F# for GitHub pages. But, don't be scared. You don't need to know F# in order to use it.

</div>
</div>

<!-- more -->

If your are a geek, blogging on [GitHub Pages](https://pages.github.com/) became a must in the last few months. If you're an F# geek, you have to use [FsBlog](https://github.com/fsprojects/FsBlog). We can read on the project page

> Inspired by the likes of **Jekyll** and **Octopress**...FsBlog gives the average F# and .NET hacker the tools they need to get a statically built website up and running quickly and hosted somewhere like GitHub Pages

Generating the static content of the blog boils down to using [FAKE](http://fsharp.github.io/FAKE/) commands. FAKE is a build automation system with capabilities which are similar to **make** and **rake**. So you don't need to know F# in order to use it. However the chance is that you already know it if you picked up FsBlog.

So here are steps that you may follow to setp up quickly a blogging platform without going deep in understanding of FsBlog and GitHub Pages.

1. Either go to [GitHub](https://github.com) and create a repository that will contain the 'source code' of your blog that you will use to generate the static output. You can call it whatever you want "Blog" or "MyBlog". It's not important. Or fork the [FsBlog project repo](https://github.com/fsprojects/FsBlog) that will contain your 'source code' of the blog. The advantage is that if you want to contribute you can then send the 'Pull Requests'. But if you do some changes in `layouts` folder for your own look and feel you'll have to filter it out. The same is true for your config settings and other personal parameters.
1. You have to activate GitHub pages. There are two choices I'm aware of:
    - Using "Automatic Page Generator" from repository "Settings" tab. This will create a new branch in your repository called `gh-pages` where you will push the output of your blog generation. The url will be like this: **http://username.github.io/*repositoryName***.
    - Create another GitHub repository called **username.github.io** where you'll push the output of your blog generation. Then you'll have only one `master` branch with url like this : **http://username.github.io/**. Whatever option you chose you have more detailled steps on [GitHub Pages](https://pages.github.com/) web site.

1. If you didn't fork the [FsBlog project repo](https://github.com/fsprojects/FsBlog) project and you have created a GitHub respository to host your blog sources, you can install a nuget package which will bring all the files that you need to modify and generate the static output for your blog. It also installs all the `fake` commands that you can use to build and generate the blog. To install the nuget package just type into the "Package Manager Console" in Visual Studio : `PM> Install-Package FsBlog -Pre`.
1. You can start to play with the default preview running the following commands:
    - `build` which will build fake tools (not needed if you installed the nuget package).
    - `fake` which will generate the static output and run a local web server to preview the blog.
1. At this point you should be able to define your own look and feel. Here are some default folders which contents have to be changed
    - `themes` if you have forked the project repo you can copy a default theme to for example "mytheme" folder and tweak it to your needs. Then you'll need to use `fake install theme="mytheme"` command to make it use the new theme while generating the static output with `fake` command or `fake generate` command. If you've installed the nuget package there is no "theme" folder. The content of "theme" folder is available on the root's path of the code source so keep on reading.
    - `layouts` contains a main razor files that you can modify. `post.cshtml` will be used when generating a static content as a template for your blog post page. When you run a command `fake new post="hello markdown"` this will add a markdown page to the `source` folder and when you'll run the `fake generate` command this template will display the content of the markdown pages. You can tweak this page to add for exemple a Disqus for comments or other social connectors you would like to have to promote your blog. You can also change the Razor code in order to have a different display than the one created by default. The same goes for other files contained in this folder i.e. `page.cshtml` and `default.cshtml`. The `page.cshtml` will be used while generating the content for markdown files added with `fake new page="my new page"` command. The `default.cshtml` contains general layout of your blog.
    - `stylesheets`, `javascripts`, `fonts` are other folders where you can personalize the look and feel of your blog.
    - `source` contains an `index.cshtml` file. You can personalize it as a default page that will be displayed on the home page.
    - `source\blog` contains also `index.cshtml` file used to personalize the displayed content when accessing the blog section of your web site.
1. Once you've personalized the look of your web site you can start to generate the content. All the content is written using the markdown pages *.md and stored in `source` folder described earlier. Generate markdown pages with `fake`.
    - to add a new post use `fake new post="hello markdown"` command
    - to add a new page use `fake new page="my new page"` command. Pages are additional content and you'll have to add a link to the page for example in the menu in order to access it. Pages might be for example "About Me", "Talks", "What I read", etc.
    - to add a new F# script use `fake new fsx="hello fsharp"`. This will create a .fsx file that you can use in your blog post.
1. The next step before going live is to set up your configuration. There is a file called `config.yml` which contains default folders described earlier that you might want to change or not. You may also change the title and the description but the most important are the following setting:
    - `url` is the url of your blog.
    - `gitlocation` is the url where the git will push the generated static files of your web blog.
    - `gitbranch` is the branch of your github repo definied by `gitlocation` parameter where git will push the output. Depending on which method you have used to install GitHub Pages on your repository it might be `master` or `gh-pages` branch.
1. If you have a DNS domain that you would like to use instead of **http://username.github.io/** one way is to add a CNAME file to the root path of the generated output files with just a name of your domain inside it . Then you'll have to redirect at your DNS provider level to the domain used by github. For full guidline please refer to [Setting up a custom domain with GitHub Pages](https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages/).
1. You're almost done. Run `fake` and check if everything is allright. If it's ok, push it with `fake GitPublish`. This will automaticaly commit and push your output generated files to the GitHub Pages web site according to the configuration from `config.yml`.

And that's it!

This guide does not explore every possible way of publishing to GitHub pages using FsBlog. It's just a quick ramp-up guide for newcomers that don't want to dive to much into FsBlog internals. For more information please check following links:
 - [FsBlog](https://github.com/fsprojects/FsBlog)
 - [GitHub Pages](https://pages.github.com/)
 
Happy blogging!