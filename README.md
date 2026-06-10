# Alegreya

This file provides detailed information on the Alegreya Font Software.

This information should be distributed along with the Alegreya fonts and any derivative works.

### Font Information

Alegreya is a typeface originally intended for literature. Among its crowning characteristics, it conveys a dynamic and varied rhythm which facilitates the reading of long texts. Also, it provides freshness to the page while referring to the calligraphic letter, not as a literal interpretation, but rather in a contemporary typographic language.

The italic has just as much care and attention to detail in the design as the roman. The bold weights are strong, and the Black weights are really experimental for the genre. There is also a Small Caps sister family.

Not only does Alegreya provide great performance, but also achieves a strong and harmonious text by means of elements designed in an atmosphere of diversity.

The Alegreya type system is a "super family", originally intended for literature, and includes serif and sans serif sister families.

It supports expert latin, greek and cyrillic character sets and provides advanced typography OpenType features such as small caps, dynamic ligatures and fractions, four set of figures, super and subscript characters, ordinals, localized accent forms for spanish, catalan, guaraní, dutch, turkish, romanian, serbian among others.


Alegreya was chosen at the ATypI Letter2 competition in September 2011, and one of the top 14 text type systems. It was also selected in the 2nd Bienal Iberoamericana de Diseño, competition held in Madrid in 2010 and Tipos Latinos.

Designed by Juan Pablo del Peral for [Huerta Tipográfica](http://www.huertatipografica.com/).


#### Requirements

- Glyphs 3 (for editing sources)
- Python 3.11 (for building fonts)


#### Build

The build script (`build.sh`) handles environment setup automatically — it creates a virtual environment and installs dependencies on first run.

**Full build from Glyphs sources**

Converts `.glyphs` files to UFOs (saved in `sources/`) then builds all fonts into `fonts/`:

```bash
bash build.sh
```

**Build from existing UFOs (recommended for iterating)**

Skips the Glyphs conversion and builds directly from the UFOs already in `sources/`. Use this when you have not changed the source `.glyphs` files and want a faster build:

```bash
bash build.sh --from-ufo
```

Both commands produce the same output in `fonts/`: static TTF, OTF, and variable fonts, including Small Caps variants.
