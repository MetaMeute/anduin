Anduin – a Frontend for the Git-based Gollum-Wiki
=============

Working Title of the new MetaMeute homepage containing the meutewiki which is powered by gollum
(https://github.com/github/gollum).
A at least roughly up to date version is running at http://anduin.metameute.de/

For a more recent version of the webpage (random branches from here merged at will) see http://anduintest.metameute.de/
If you want to have a branch merged into the testing instance, contact [johnyb](https://github.com/johnyb).

Development
-----------

If you want to have something changed, please fork, commit your changes with a decent commit message and send us
a pull-request.

To setup a development environment, clone the project and run the `bundle` command.

After that you need to init a git repository for development. The default installation uses `db/meutewiki.git` as
a location for the wiki.
To init a git repository there, do the following in your rails root:

```
mkdir db/meutewiki.git
cd db/meutewiki.git
git init --bare
```

After that you can run `rails s` and point your browser to [http://localhost:3000/](http://localhost:3000) to see this
thing in action.

When running in development or test environment, signing in using any value as Nick and the password "secure!" should create
a new session with the given user.

