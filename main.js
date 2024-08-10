import maplibregl from "maplibre-gl";
import * as pmtiles from "pmtiles";
import layers from "protomaps-themes-base";

const protocol = new pmtiles.Protocol();

maplibregl.addProtocol("pmtiles", protocol.tile);

const style = {
  version: 8,
  glyphs: "./fonts/{fontstack}/{range}.pbf",
  sources: {
    protomaps: {
      type: "vector",
      url: "pmtiles://" + "minnesota.pmtiles",
      attribution:
        '<a href="https://protomaps.com">Protomaps</a> © <a href="https://openstreetmap.org">OpenStreetMap</a>',
    },

    // load any other data you have
    /* some-other-data: {
      type: "vector",
      url: "pmtiles://" + "...",
    },
    */
  },

  // this builds a set of layers matching the OpenMapTiles schema, using "protomaps" as a source ID
  layers: layers("protomaps", "light"),
};

const srccon = [-93.2274753, 44.9749363];

const map = new maplibregl.Map({
  container: "map",
  style,
  maxBounds: [-97.3, 43.5, -89.5, 49.4],
  hash: true,
  center: [-76.6055754, 39.2835701],
  zoom: 12,
});

map.once("load", (e) => {
  const firstSymbolLayer = map
    .getStyle()
    .layers.find((layer) => layer.type === "symbol");
});

window.map = map;
