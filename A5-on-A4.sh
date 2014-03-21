#!/bin/bash

# http://ospublish.constantvzw.org/blog/tools/how-to-print-a-booklet-in-16-steps

PRINTER=HL4150CDN_BR-Script3

PDF=latest.pdf
PAGENUM=`pdfinfo $PDF | grep ^Pages | cut -d ":" -f 2`

I=$PDF ; O=${I%%.*}_PDFTOPS.ps
pdftops -paper match $I $O

I=$O ; O=${I%%.*}_PSBOOK.ps
psbook -s$PAGENUM $I $O
rm $I

I=$O ; O=${I%%.*}_PSNUP.ps
psnup -2 -s1 -pA4 $I $O
rm $I

I=$O ; O=${PDF%%.*}_A4-PRINT.pdf
ps2pdf -sPAPERSIZE=a4 -dAutoRotatePages=/None $I $O
rm $I


echo "lpr -o sides=two-sided-short-edge -P $PRINTER ${PDF%%.*}_A4-PRINT.pdf"



exit 0;
