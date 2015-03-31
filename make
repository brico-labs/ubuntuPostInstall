#!/bin/bash

export SRCFILE="ubuntuTrustyPostInstall"
export SRCDIR="src/"
export OUTDIR="out/"

# Generate README.md from source
pandoc --from markdown --to markdown_github --output=README.md $SRCDIR$SRCFILE.md

pandoc --from markdown --to mediawiki --output=$OUTDIR$SRCFILE.mw  $SRCDIR$SRCFILE.md
pandoc --smart --standalone --from markdown --to latex --latex-engine=xelatex --output=$OUTDIR$SRCFILE.pdf  $SRCDIR$SRCFILE.md
pandoc --smart --from markdown --to latex --output=$OUTDIR$SRCFILE.tex  $SRCDIR$SRCFILE.md
pandoc --from markdown --to markdown --output=$OUTDIRtest.md  $SRCDIR$SRCFILE.md
