# Getting Started with Python

## Installation
The best way to get started with Python is to install the [Anaconda Distribution](https://www.anaconda.com/products/individual). 

This will install python itself, as well as the main numerical libraries --- such as numpy --- that you will need to get started.

Once installed, you can launch the Anaconda Navigator from your start menu or applications folder.  

## Writing code
To start writing code we have two options:
1. using an IDE (integrated developement environment);
2. jupyter notebooks. 

An *IDE* is what most of you will be familiar with if you've used Stata, Matlab or R before. Anaconda comes shipped with [Spyder IDE](https://www.spyder-ide.org/) so you can open it from the Anaconda Navigator. In Syder you'll be able to write scripts, see what variables are in memory, and browse those variables/data. Another popular IDE is [PyCharm](https://www.jetbrains.com/pycharm/).  

[Jupyter notebooks](https://jupyter.org/) are browser based notebooks where you are combine text and math, execuatable code, and outputs all in one place. Anaconda also ships with Jupyer Notebooks (and JupyterLab which makes it easier to work on many notebooks). We will use notebooks in the rest of this tutorial, so now is a good time to open a notebook from Anaconda Navigator. You can also download this GitHub repository to your computer and use the folder navigation to open our first notebook. 

Notebooks are a fantastic tool for keeping all your work in one place: you could even write your problem sets using them! They can also be turned easily into html and websites using [GithubPages](https://evanwill.github.io/go-go-ghpages-b/content/1-intro.html).

**Note: it might also be possible for us to host the notebooks online (Google Colab) where the students can run them straight away.**

## Installing packages
While Anaconda comes with most of what you need, there are many open source packages you may want to install. Anaconda will manage the dependencies of all these nicely. 

To install a package called *packagename*, open the *Powershell Prompt* from the Navigator and type `conda install packagename`. 

You can also create Conda *environments* that have different versions of Python and/or packages installed in them. This can be useful for making sure everyone on a project can run code, or to make you computer's dependecies the same as a servers. 

The default is the base environment. Let's create an environment for this class using `conda create econ-env`.

We can see our environments using `conda info --envs` and activate our new environment using `conda activate --econ-env`.

If a package isn't available in the conda repository, you might also need to install via pip `pip install packagename`. For example,  useful set of packages for economics are provided by *qunatecon* so you can go ahead and try `pip install quantecon`.

Now lets get started with our first notebook. 
