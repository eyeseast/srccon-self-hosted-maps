# Self-hosted maps in a codespace

This repo contains a Dockerfile and dev container configuration that will build the tools necessary for self-hosted maps:

- `pmtiles` CLI
- `tippecanoe`
- NodeJS
- Python (to explore data with [datasette])

The `Makefile` includes build steps for a street map of the state of Minnesota. However, this map is unfinished, and it will be up to you how to complete it.

[Read more about self-hosted maps](https://www.muckrock.com/news/archives/2024/feb/13/release-notes-how-to-make-self-hosted-maps-that-work-everywhere-cost-next-to-nothing-and-might-even-work-in-airplane-mode/).

## Setup

This project will work with or without Docker. The easiest setup uses [Github's codespaces](https://docs.github.com/en/codespaces/overview). Locally, it can use a [development container](https://code.visualstudio.com/docs/devcontainers/containers) to create a consistent environment.

### Getting started via Github.com

1. Navigate to https://github.com/eyeseast/self-hosted-maps-codespace (you might already be here)
2. Click **Use this template**, then click **Open in a codespace**

See [Codespaces Quickstart](https://docs.github.com/en/codespaces/getting-started/quickstart) for more information.

Inside the codebase, you'll need to install Python and NodeJS dependencies to use Datasette or build the map. Running `make install` will get both.

### Working locally, using VSCode and docker

Assuming you've cloned this repository, open it in VS Code, and you should be prompted to reopen it inside a dev container. This will build a docker image with all dependencies installed.

For more detailed instructions, see [Developing inside a Container](https://code.visualstudio.com/docs/devcontainers/containers#_quick-start-open-an-existing-folder-in-a-container).

This will work on any system that can run Docker and should give you a consistent development environment regardless of your root operating system.

### Working locally on MacOS

I work on a MacBook, and if you don't mind installing things with Homebrew, you can work without a dev container.

```sh
brew install pmtiles
brew install tippecanoe
brew install libspatialite
```

(It's possible I'm forgetting something here. I don't recreate my laptop environment from scratch that often. Please open an issue if needed.)

Building the final map requires NodeJS. I recommend either downloading the [current LTS version](https://nodejs.org/en) or using a version manager like [`nodenv`](https://github.com/nodenv/nodenv).

To explore data with [datasette](https://datasette.io/), you'll need a working Python environment. You can follow my [recommended Python setup](https://chrisamico.com/blog/2023-01-14/python-setup/). This repo uses Poetry instead of Pipenv, so install that using `pipx install poetry`.

Once Python and NodeJS are configured, run `make install` to download dependencies for both environments.

## Building the map

tl;dr

```sh
make install
make tiles
make fonts
npm run dev
```

Running `make tiles` will extract a PMTiles file of OpenStreetMap data from today's [Protomaps build](https://maps.protomaps.com/builds/).

_NOTE: if you run into an error with `make tiles`, with a 404 error from `build.protomaps.com`, you may be one day ahead of the available protomap builds from https://maps.protomaps.com/builds/. To remedy, edit the `TODAY` variable in the `Makefile` to be a valid day that will call an available pmtiles set from https://maps.protomaps.com/builds/._

## Exploring data with Datasette

Running `make samples` will download two sample datasets you might visualize:

- [Feedlots in Minnesota](https://gisdata.mn.gov/dataset/env-feedlots)
- [Metro Wetlands and Wet Areas](https://gisdata.mn.gov/en_AU/dataset/org-mmcd-env-wetland-mosquito-wet-areas)

(Thanks to [Jake Steinberg](https://www.jakesteinberg.com/) for the data suggestions.)

Feel free to use another dataset of your choice for this demo. Experimentation, exploration and playfulness are part of the learning process.

If you want to dig into the data you've downloaded, you can build a SpatiaLite database and explore it with Datasette.

```sh
make minnesota.db # create a spatialite database

# load data using included tools
poetry run geojson-to-sqlite minnesota.db ...
poetry run shapefile-to-sqlite minnesota.db ...
make ds # run datasette
```

Have fun.

[datasette]: https://datasette.io/
