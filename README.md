extend etherpad's collaborative writing approach with optional commandline magic.

Within the etherpad (e.g. http://lgru.pad.constantvzw.org:8000/197) 
you may define commands (lines starting with a %) that will be
executed while converting the etherpad to pdf using pdflatex.

Commands are defined in [i/bash/*.functions](). To render 
a pdf file run ./etherpad2pdf.sh (you may provide an additional
function file)


