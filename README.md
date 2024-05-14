# [elm-training](https://github.com/lucamug/elm-training/)

Run 

```shell
git clone https://github.com/lucamug/elm-training.git
cd elm-training
npm install
```

Run one of these three options to start a development server:

* `cmd/reactor` (uses Elm Reactor included in the Elm binary, requires manual refresh, and does not support customized HTML)
* `cmd/go` (uses [elm-go](https://github.com/lucamug/elm-go), supports hot reloading and customized HTML)
* `cmd/watch` (uses [elm-watch](https://lydell.github.io/elm-watch/), supports hot reloading and customized HTML)

Then open http://localhost:8000/ in the browser and edit the file `src/Main.elm` to modify the Elm script

[Parcel](https://parceljs.org/languages/elm), [Vite](https://github.com/hmsk/vite-plugin-elm), and [other systems](https://www.lindsaykwardell.com/blog/setting-up-elm-in-2022) also support Elm.

To learn about Elm, refer to the [Official Elm Guide](https://guide.elm-lang.org/).

If something is not working, try installing these modules also globally:

```
npm install -g elm
npm install -g elm-format
npm install -g elm-watch
npm install -g elm-go
npm install -g elm-review
```