# Setting up an Application Environment

## Learning Goals

- Recognize common Ruby application conventions
- Understand how to set up a `bin` file to run a Ruby application
- Understand how to set up an environment file to load things when a Ruby
  application starts

## Introduction

Most Ruby applications we'll be dealing with in this phase will use the command
line. Don't be fooled though — command-line apps may seem simple and less fancy
than a fully developed computer program with a graphical user interface, but CLI
apps can be just as robust and powerful, if not more so.

For the most part, Ruby CLI apps tend to start the same way — typing `ruby`
followed by a relative path to a Ruby file. In a complex application, though,
which file should be run? In addition to this, when we run the file, how do we
ensure all our necessary files are required?

There are two common conventions we're going to look at in this lesson that
address these questions: using a "run" file, and setting up the environment in
`environment.rb`.

## Using a Run File

In the previous lesson, we had Ruby code in two separate files, `lib/garden.rb`
and `lib/plant.rb`. We were able to require `plant.rb` from inside `garden.rb`.
This allowed us to run `ruby lib/garden.rb` without error. Doing it this way
works, but is a little sloppy. The `lib/garden.rb` file should only contain the
`Garden` class. It doesn't make sense to also make it the file that _runs_
everything.

Running an application is its own process and deserves its own file. This way,
we have a single place to start the application every time.

Sticking to conventions, a run file has already been created in this example,
`bin/run`, that has the following code:

```ruby
#!/usr/bin/env ruby

require_relative '../lib/garden'
require_relative '../lib/plant'

lawn = Garden.new(name: 'Front Lawn')

basil = Plant.new(name: 'Basil')
basil.garden = lawn

cucumber = Plant.new(name: 'Cucumber')
cucumber.garden = lawn

p lawn.plants
```

With the run file set up, we can run `ruby bin/run` and see the run
file in action. Let's step through this file briefly.

### The Shebang Line

The very first line of `bin/run` can be broadly ignored for our purposes. It is
known as a [_shebang_][] and is used to indicate what interpreter should be used
to read the code in this file. On Unix systems, with the proper configuration,
this file can run without having to write `ruby` before it in the command line.
Don't worry if this does not work for you, though. We can still run the file
using `ruby bin/run`. The shebang is just an optional line that makes this file
more functional.

Notice that the file _doesn't_ have the `.rb` extension. This file is designed
to be an executable and the lack of file extension indicates this. Some runner
files will still have the `.rb` extension — they may not be meant as an
executable file, but are still designed to be the point of entry into the
application.

[_shebang_]: https://en.wikipedia.org/wiki/Shebang_(Unix)

### Loading Files and Running Code

Run files act in some way to start an application. Before that, though, they
typically need to load up any necessary files. We can see this in
`bin/run`. In the first lines of recognizable Ruby code, we require
both our local files located in `lib`:

```ruby
require_relative '../lib/garden'
require_relative '../lib/plant'
```

With `Garden` and `Plant` loaded, we can proceed to run our very simple
application — relating a few `Plant` instances to a `Garden` instance.

```ruby
lawn = Garden.new(name: 'Front Lawn')

basil = Plant.new(name: 'Basil')
basil.garden = lawn

cucumber = Plant.new(name: 'Cucumber')
cucumber.garden = lawn

p lawn.plants
```

In this particular example, the run file does a few different things to show how
the setup works. Commonly, though, run files can have very little in them. A run
file may load up the necessary support files, then just call a class to handle
the logic of running the actual application.

## Using an Environment File

Whenever we run our simple application, we load the two files in `lib`. If we
wanted to add a third class in a new file, once created, we'd have to add a
_third_ `require_relative` for it in the run file. Seems easy enough so far.

With more complex applications, there may be multiple places where we need to
load the same application files. For example, if we added tests to this
application, we would load files like `lib/garden.rb` and `lib/plant.rb` into
our test files. That means we would need a _second set_ of `require_relative`
statements somewhere in the tests. Now, it isn't _terribly_ difficult to
maintain two sets of the same code, but why should we repeat ourselves? Better
if we can avoid doing that.

The common solution to this is to create one file that has all the
`require_relative` statements. Then, in the run file, we just require _that_
file. If we had tests, we could also _just require that file_. If we add more
classes, we only need to modify a single file, and any place in our application
requiring that file will automatically receive the updates!

In Ruby frameworks like Rails, this file is called `environment.rb` and is
located in the `config` folder. We'll follow this convention — a file with this
name already exists, all we need to do is copy the `require_relative` statements
from `bin/run` to `config/environment.rb`, then replace them,
requiring `config/environment.rb` in our run file.

For `config/environment.rb`, that would be:

```ruby
require_relative '../lib/garden'
require_relative '../lib/plant'
```

And for `bin/run`:

```ruby
#!/usr/bin/env ruby

require_relative '../config/environment'

lawn = Garden.new(name: 'Front Lawn')

basil = Plant.new(name: 'Basil')
basil.garden = lawn

cucumber = Plant.new(name: 'Cucumber')
cucumber.garden = lawn

p lawn.plants
```

In addition to requiring all necessary files, `config/environment.rb` is also a
common place for configuring application settings. This is an ideal location,
for instance, for configuring access to a database that an application can use.

## Conclusion

To recap, in this lesson, we looked at two components commonly found in Ruby
applications. The first is the run file, something that acts as the starting
point of the application. The second is the `environment.rb` file. Typically loaded
when an application is started or tests are run, this file loads any required
application files and handles any configuration that has to happen every time
the application starts.

Combining the two, we have a multi-file application that is starting to show
some complexity! With our set up, we can add whatever files we want to `lib`,
require those files in `config/environment.rb`, and they will be loaded every
time we run `bin/run`.
