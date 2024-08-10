DB = minnesota.db

SU = poetry run sqlite-utils

BBOX = -97.3,43.5,-89.5,49.4

# https://maps.protomaps.com/builds/
TODAY = $(shell date +%Y%m%d)
PMTILES_BUILD = https://build.protomaps.com/$(TODAY).pmtiles

install:
	poetry install --no-root
	npm ci

build:
	docker build . -t srccon-maps:latest

container:
	docker run --rm -it srccon-maps:latest

tiles: public/minnesota.pmtiles

fonts:
	wget https://github.com/protomaps/basemaps-assets/archive/refs/heads/main.zip
	unzip main.zip
	mv basemaps-assets-main/fonts public/fonts
	rm -r basemaps-assets-main main.zip

run:
	# https://docs.datasette.io/en/stable/settings.html#configuration-directory-mode
	npm run dev -- --open & poetry run datasette serve . --load-extension spatialite -h 0.0.0.0

samples: data/shp_env_feedlots.zip data/shp_env_wetland_mosquito_wet_areas.zip

ds:
	poetry run datasette serve . --load-extension spatialite -h 0.0.0.0

clean:
	rm -rf $(DB) $(DB)-shm $(DB)-wal public/*.pmtiles public/*.mbtiles public/fonts

$(DB):
	$(SU) create-database $@ --enable-wal --init-spatialite

public/minnesota.pmtiles:
	pmtiles extract $(PMTILES_BUILD) $@ --bbox="$(BBOX)"

data:
	mkdir -p data

data/shp_env_feedlots.zip: data
	wget -O $@ https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_pca/env_feedlots/shp_env_feedlots.zip

data/shp_env_wetland_mosquito_wet_areas.zip: data
	wget -O $@ https://resources.gisdata.mn.gov/pub/gdrs/data/pub/org_mmcd/env_wetland_mosquito_wet_areas/shp_env_wetland_mosquito_wet_areas.zip
