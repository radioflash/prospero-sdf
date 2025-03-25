.PHONY: view
view: prospero.png
	start prospero.png

prospero.png: prospero.ppm
	magick $< $@

prospero.ppm: render.lua prospero.lua
	luajit $<

prospero.lua: compile.lua prospero.vm
	luajit $<

