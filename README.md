
Extend etherpad's collaborative writing approach with optional commandline magic.

On an etherpad (e.g. http://lgru.pad.constantvzw.org:8000/etherpash) 
you can use markdown and define commands (lines start with a %). 
The commands will be executed while the etherpad is converted to pdf 
using pdflatex.

Commands are defined in [i/bash/*.functions](). 

 
Execute ./etherpad2pdf.sh to render a pdf file.
You may provide an additional function file, e.g.
./etherpad2pdf.sh i/bash/my.functions


NEEDED SOFTWARE:

pandoc    
texlive-extra-utils     
texlive-generic-extra    
texlive-latex-extra    
texlive-fonts-extra    
texlive-fonts-recommended    
