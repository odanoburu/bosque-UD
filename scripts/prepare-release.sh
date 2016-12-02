#!/bin/bash

if [ ! -e bosque.udep.workaround.conll ]; then
    echo "Missing bosque.udep.workaround.conll; run fix-errors.sh."
    exit 1
fi

# remove </s> tags, and fix the <s> comments.
cat bosque.udep.workaround.conll | grep -v "^#<ext" | grep -v "^#</ext>" | grep -v "^#</s>" | sed -e 's/#<s\(.*\)>/#\1/' | cat -s > pt.conllu

# remove leading whitespace
# http://www.linuxhowtos.org/System/sedoneliner.htm?ref=news.rdf
cat pt.conllu | sed '/./,$!d' > tmp && mv tmp pt.conllu

# remove empty line after the comment (flagged by the validation tool)
python3 fix-comments.py pt.conllu > tmp && mv tmp pt.conllu

# split pt.conllu in dev/test/train, using the percentages specified in the split3.py file
python3 split3.py pt.conllu release/pt-ud-dev.conllu release/pt-ud-test.conllu release/pt-ud-train.conllu
rm pt.conllu