# Boxerboy

<img width="1145" alt="screen shot 2018-11-25 at 11 56 33 am" src="https://user-images.githubusercontent.com/48086/48981896-38547b00-f0a9-11e8-8f1f-0549516c99c9.png">


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

Here the version of node that was used on the test machine

```
$ node -v
v7.3.0
```

To install the application from nothing, run the following

```
cd /tmp # or somewhere
git clone git@github.com:spawnfest/boxerboyapp.git
cd boxerboyapp/boxerboy
mix deps.get
(cd assets && npm install)
```

If you want to see your local environment with a
terrains, maps and characters then run the following

```
cd /tmp/boxerboyapp # or the correct root of the project
cp ./sampledb/*.tab ./boxerboy/
```

The above will see your local environment with a `terrains.tab`,
`maps.tab` and a `characters.tab`.


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

### Deleting Pixels

You can delete through the UI now, but just in case you
wanted to know more about running commands from the `iex` shell.

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

Normally, we would have created two separate projects.  Here for
simplicity, we kept it in one.  That said, we are not big fans
of umbrella application, as we find it difficult to extract
an embedded application if in the future we wanted it as a standalone.


### pixeldb

This is a simple data structure for describing a bitmap of "pixels".

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

The database is stored in ETS files ()

The library can also export values to BITMAPs for _easier_ rendering.

```
pixel |> Pixeldb.to_bmp()
```

Would output a compatible BMP binary which can be rendered within
your browser (or image editor).  A huge thank you to
[alchemist.camp](https://alchemist.camp/episodes/bitmaps-elixir) as
they went through the [technical details of a bitmap](http://www.fileformat.info/format/bmp/egff.htm)
for us.


### boxerboy

This is the beginnings of a game builder for old-school pixelated games.  The idea was from my son, and although he really wanted it to run on his 3DS, we are taking small steps to get this done.

The application at present, allows you to manage terrain, build maps and develop characters (both friends, and foes).

## Next Steps

* Delete terrains, maps and characters
* Include interactive editing using Phoenix Channels (and Presence)
* Add HTTPS support using [site_encrypt](https://github.com/sasa1977/site_encrypt)
* Deploy to Digital Ocean using [doex](https://hex.pm/packages/doex)
* Expand pixeldb to support additional attributes
* Allow editing additional character information
* Allow characters to interact on a map
* Allow attacks between characters
* Allow the creation of quests
* Allow quest game play





