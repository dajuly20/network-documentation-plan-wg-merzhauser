MMD_FILES := $(wildcard diagrams/*.mmd)
PNG_FILES := $(MMD_FILES:.mmd=.png)
SVG_FILES := $(MMD_FILES:.mmd=.svg)

all: diagrams

diagrams: $(PNG_FILES) $(SVG_FILES)
	@echo "✔ Alle Diagramme wurden generiert."

diagrams/%.png: diagrams/%.mmd
	mmdc -i $< -o $@

diagrams/%.svg: diagrams/%.mmd
	mmdc -i $< -o $@

clean:
	rm -f diagrams/*.png diagrams/*.svg
	@echo "✔ Diagramme bereinigt."
