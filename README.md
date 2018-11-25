# Boxerboy

This is the beginnings of a game builder for old-school pixelated games.
The idea was from my son, and although he really wanted it to run on his 3DS,
we are taking small steps to get this done.

<img width="1091" alt="screen shot 2018-11-25 at 12 24 48 pm" src="https://user-images.githubusercontent.com/48086/48982195-38567a00-f0ad-11e8-8adb-406f78e79ba8.png">

My son, Hayden, has designed a game called Boxerboy.  Boxerboy is an imaginative
combination of old school RPG like Dragon's Quest (or Warrior) and
Final Fantasy, with newer games like Pokemon, Yokai Watch and Mario Maker.

The on-paper version of Boxerboy has littered our living room with
characters, and their abilities, as well as created several _quests_
for these boxerboys to accomplish.

This project is the humble beginnings of a game builder, to help
him bring his game to life with maps, and quests, and characters
and challenges.

At present, it's a simple pixel editor, but with the great
imagination of child it will become so much more.

<img width="1160" alt="screen shot 2018-11-25 at 12 26 13 pm" src="https://user-images.githubusercontent.com/48086/48982208-515f2b00-f0ad-11e8-819e-94053d1f6357.png">

Above, we see a color palette at the top of the screen, and then a pixelated
grid where you can draw your character.  To _erase_ simply color the entry
white.

When you are ready to save, give your character and name and off you go.

NOTE: Characters (and terrains and maps) are globally defined, which
allows anyone and everyone the ability to make changes.  In a future
release, there would be some notion of ownership around these assets.


## Getting Started

To run boxerboy, you will need Erlang and Elixir.
You will also need Node to complie the assets.

This has only be tested on the following versions,
on a Mac OSX (Mojave) and within Chrome.

```
$ elixir -v
Erlang/OTP 21 [erts-10.1.1] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe] [dtrace]

Elixir 1.7.1 (compiled with Erlang/OTP 21)
```

Node is used to compile the assets (JavaScript, SCSS), so _any_ modern
version should work. Here the version of node that was used on the test machine.

```
$ node -v
v7.3.0
```

To install the application from scratch, run the following

```
cd /tmp # or somewhere
git clone git@github.com:spawnfest/boxerboyapp.git
cd boxerboyapp/boxerboy
mix deps.get
(cd assets && npm install)
mix compile
```

### Restoring the Database

If you want to see your local environment with a
terrains, maps and characters then run the following

```
cd /tmp/boxerboyapp # or the correct root of the project
cp ./sampledb/*.tab ./boxerboy/
```

The above will see your local environment with a `terrains.tab`,
`maps.tab` and a `characters.tab`.

### Launching The Web App

You are now ready to start the application, by running the following

```
cd /tmp/boxerboyapp # or the correct root of the project
cd boxerboy
iex -S mix phx.server
```

The above will give you an interactive shell (for debugging),
as well as will start the webserver on port `4000`.

If things go well, you should see something similar to the following

```
Erlang/OTP 21 [erts-10.1.1] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe] [dtrace]

[info] Running BoxerboyWeb.Endpoint with cowboy 2.6.0 at http://localhost:4000
Interactive Elixir (1.7.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
Webpack is watching the files…

Hash: 916d2a19cb26673aa447
Version: webpack 4.4.0
Time: 2855ms
Built at: 11/25/2018 10:24:08 AM
                            Asset       Size       Chunks             Chunk Names
                   ../css/app.css    198 KiB  ./js/app.js  [emitted]  ./js/app.js
                           app.js    335 KiB  ./js/app.js  [emitted]  ./js/app.js
../images/plus-circle-outline.svg  346 bytes               [emitted]
            ../images/phoenix.png   13.6 KiB               [emitted]
                   ../favicon.ico   1.23 KiB               [emitted]
           ../images/brush-nw.svg   1.75 KiB               [emitted]
                    ../robots.txt  202 bytes               [emitted]
[./css/app.scss] 39 bytes {./js/app.js} [built]
[./js sync recursive \.js$] ./js sync \.js$ 204 bytes {./js/app.js} [built]
[./js/app.js] 472 bytes {./js/app.js} [built]
[./js/pixel.js] 5.37 KiB {./js/app.js} [built]
[./js/socket.js] 2.2 KiB {./js/app.js} [optional] [built]
   [0] multi ./js/app.js 28 bytes {./js/app.js} [built]
    + 4 hidden modules
Child mini-css-extract-plugin node_modules/css-loader/index.js??ref--5-1!node_modules/sass-loader/lib/loader.js??ref--5-2!css/app.scss:
    [./node_modules/css-loader/index.js??ref--5-1!./node_modules/sass-loader/lib/loader.js??ref--5-2!./css/app.scss] ./node_modules/css-loader??ref--5-1!./node_modules/sass-loader/lib/loader.js??ref--5-2!./css/app.scss 204 KiB {mini-css-extract-plugin} [built]
        + 1 hidden module
```

And now the web application should be up and running at

```
http://localhost:4000
```

### Running Tests

All tests are against the `pixeldb` application.

To run the tests, we will need to grab the dependencies,
and then use `mix` to run the tests.

```
cd /tmp/boxerboyapp # or the correct root of the project
cd pixeldb
mix deps.get
mix test
```

The output should look similar to

```
Compiling 1 file (.ex)
Excluding tags: [external: true]

.............

Finished in 0.1 seconds
13 tests, 0 failures

Randomized with seed 863648
```

### Playing in iEX

When you started the web app, you also started an interactive shell (iEX).

This is started using

```
cd /tmp/boxerboyapp # or the correct root of the project
cd boxerboy
iex -S mix phx.server
```

(if you don't want to run the web server just run `iex -S mix`).

From there you can get help for the Pixeldb API.

```
iex> h Pixeldb
```

<img width="1358" alt="screen shot 2018-11-25 at 3 48 24 pm" src="https://user-images.githubusercontent.com/48086/48984436-92653880-f0c9-11e8-908a-62262a7d7b1f.png">

Or, you can get help on any particular function

```
iex> h Pixeldb.delete
```

<img width="1047" alt="screen shot 2018-11-25 at 3 49 23 pm" src="https://user-images.githubusercontent.com/48086/48984447-b4f75180-f0c9-11e8-8b21-139ed036c83c.png">

It is much more convenient to create pixels in the webapp, so let's
run through an example of deleting from the terminal.

First, list the pixels, and then delete them.  You will need to lookup
by the named list.  For example

```
iex> Pixeldb.ls(:terrains)
["a", "ab", "abc", "flag", "grass", "road", "t1", "test"]

iex> Pixeldb.delete("a", :terrains)
%Pixeldb.Pixel{
  columns: 10,
  name: "a",
  pixels: [
    [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, "#55efc4", "#55efc4", nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, "#55efc4", nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, "#55efc4", "#55efc4", nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, "#55efc4", "#55efc4", nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, "#55efc4", nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  ],
  rows: 10
}
```

Or, to delete a map

```
iex> Pixeldb.ls(:maps)
["level1", "level2", "level3", "t1", "test"]

iex> Pixeldb.delete("t1", :maps)
```

Or, to delete a character

```
iex> Pixeldb.ls(:characters)
["boxerboy", "sparkboy", "x"]

iex> Pixeldb.delete("x", :characters)
```

## Application Design

The repository is comprised of two separate projects

* boxerboy [the web application]
* pixeldb [a database using persisted ETS]

Normally, we would have created two separate projects in
two separate repositories.  Despite being told we could have
multiple repos for @spawnfest, at the onset we were not sure
how many projects we would be creating so thought it best to
stick with one repository.

We are not big fans of umbrella applications. We
find it very inconvenient to extract an embedded application
if in the future we wanted to re-use it in a separate app,
so we kept the two separate.  Should we move forward with
this project, then the first refactor will be to `gitfu`
the one repo into two.


### pixeldb

We are also not a huge fan of embedding too much logic
in our phoenix applications (we _always_ `--no-etco` when
creating a new phoenix app :-).  We also didn't need a full fledged
database for this first iteration of boxerboy.

Our plan was to keep a separate library for managing our `pixel`
art.  Here is the current data structure for describing an
element of boxerboy.

```
pixel = %Pixel{
  name: "river",
  rows: 13,
  columns: 3,
  pixels: [
    ["#55efc4", "#55efc5", nil],
    ["#55efc6", "#55efc7", nil],
    ["#55efc6", "#55efc7", nil],
    ["#55efc6", "#55efc7", nil],
    [nil, nil, nil],
    [nil, nil, nil],
    [nil, nil, nil],
    [nil, nil, nil],
    [nil, nil, nil],
    [nil, nil, nil],
    [nil, nil, nil],
    [nil, nil, nil],
    [nil, nil, nil]
  ]
}
```

In the example above we have a 3 x 13 matrix of colors.  But
the data within the pixels could be anything (letters, for
text based adventures), or references to other `named` pixels
(as we have done in boxerboy for creating maps).

We are using an ETS database, wrapped with
[persistent_ets](https://hex.pm/packages/persistent_ets)
for storage on disk.

The `pixeldb` library can also export pixels in a bitmap format,
which can make screen rendering much simpler.

Simply pipe your pixel into `to_bmp()` to generate the output

```
pixel |> Pixeldb.to_bmp()
```

The above is useful in the web application to stream the image
over HTTP, so there is no need to persist the BMP to file. A huge thank you to
[alchemist.camp](https://alchemist.camp/episodes/bitmaps-elixir) as
they went through the [technical details of a bitmap](http://www.fileformat.info/format/bmp/egff.htm)
for us.

Should you wish to save it to file, then you can do so with

```
Pixeldb.Bitmap.save("/tmp/myfile.bmp", pixel)
```

### boxerboy

This is a Phoenix web application (version 1.4).  It is augmented with

* [Webpack](https://webpack.js.org/) (the new default asset management)
* [JQuery](https://jquery.com/) (mostly for AJAX requests, but some server side rendering)
* [SCSS](https://sass-lang.com/) (instead of basic CSS)
* [Bulma](https://bulma.io/) (SCSS ported grid framework)

I was really hoping to integrate Channels for interactive editing
(as it's few little _extra_ code), but in the end was not able to find the time.
the intention was that *creator* of an artefact would own it, and if others
tried to edit an existig artefact they would need to be granted permission.
If owner accepted, and was online, then they would work together.  If the
owner was not online, or declined, then that second user could create their
own character (or terrain, or map).

I wanted to keep permissions very light to promote easy sharing of ideas, and
later would work to provide snapshots of the data should someone maliciously
start defacing other peoples work.

## Next Steps

Lots of things to consider working on

* Interactive editing using Phoenix Channels (and Presence)
* HTTPS support using [site_encrypt](https://github.com/sasa1977/site_encrypt)
* Deploy to Digital Ocean using [doex](https://hex.pm/packages/doex)
* Expand pixeldb to support additional attributes
* Allow editing additional character information
* Allow characters to interact on a map
* Allow attacks between characters
* Allow the creation of quests
* Allow quest game play





