#!/bin/bash

# THIS IS A FRAGILE SYSTEM, HANDLE WITH CARE.                                 #
# --------------------------------------------------------------------------- #
#                                                                             #
#  Copyright (C) 2014 LAFKON/Christoph Haag                                   #
#                                                                             #
#  This file is part of the 'Operating Systems' Workshop at LGM 2014          #
#                                                                             #
#  etherpad2pdf.sh is free software: you can redistribute it and/or modify    #
#  it under the terms of the GNU General Public License as published by       #
#  the Free Software Foundation, either version 3 of the License, or          #
#  (at your option) any later version.                                        #
#                                                                             #
#  etherpad2pdf.sh is distributed in the hope that it will be useful,         #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                       #
#  See the GNU General Public License for more details.                       #
#                                                                             #
# --------------------------------------------------------------------------- #

  PADBASE=http://lgru.pad.constantvzw.org:8000
  PADNAME=etherpash
  PAD2HTMLURL=$PADBASE/ep/pad/export/$PADNAME/latest?format=txt
  PADDUMP=dump.tex

  OUTDIR=.
  PDFDIR=o/pdf
  TMPDIR=tmp

  EMPTYLINE="EMPTY-LINE-EMPTY-LINE-EMPTY-LINE-TEMPORARY-NOT"


  FUNCTIONS=collect.functions
  FNCTSBASIC=i/bash/common.functions
  cat $FNCTSBASIC > $FUNCTIONS
# APPEND OPTIONAL FUNCTION SET (IF GIVEN)
  if [[ ! -z "$1" ]]; then cat $1 >> $FUNCTIONS ; fi
# --------------------------------------------------------------------------- #
# INCLUDE FUNCTIONS
# --------------------------------------------------------------------------- #
  source $FUNCTIONS
# --------------------------------------------------------------------------- #
  function writeTeXsrc() { echo "$1" >> $TMPTEX ; }
# --------------------------------------------------------------------------- #


# --------------------------------------------------------------------------- #
# DUMP AND CONVERT PAD 
# --------------------------------------------------------------------------- #

  wget -q -O  - $PAD2HTMLURL --no-check-certificate | # DOWNLOAD PAD
  sed 's/^%/zDf7WV362LoP/g' |                         # SAVE FROM PANDOC
  sed '/zDf7WV362LoP/s/$/\n\n/g' |                    # ADD NEWLINE IF START %
  sed '/zDf7WV362LoP/s/"/hFg76VCdJueW/g' |            # SAVE FROM PANDOC IF START %
  sed '/zDf7WV362LoP/s/ /c8SJu53LDCNN/g' |            # SAVE FROM PANDOC
  sed '/zDf7WV362LoP/s/\\/SlasH328d1G/g' |            # SAVE FROM PANDOC
  pandoc -r markdown -w latex |                       # MD TO LATEX
  sed 's/hFg76VCdJueW/"/g' |                          # BACK TO ORIGINAL
  sed '/zDf7WV362LoP/s/\\//g' |                       # REMOVE ESCAPES FROM FUNCTIONS
  sed 's/zDf7WV362LoP/\n%/g' |                          # BACK TO ORIGINAL
  sed '/^%/{N;s/\n.*//;}'  |                          # REMOVE NEWLINES FROM FUNCTIONS (?)
  sed '/^%/s/c8SJu53LDCNN/ /g' |                      # BACK TO ORIGINAL
  sed '/^%/s/SlasH328d1G/\\/g' |                      # BACK TO ORIGINAL
  sed "s/^ *$/$EMPTYLINE/g"    > $PADDUMP             # FILL EMPTY LINES WITH PLACEHOLDER


# --------------------------------------------------------------------------- #
# PARSE COMMANDS 
# --------------------------------------------------------------------------- #

  TEXBODY=${PADDUMP%%.*}.tmp
  TMPTEX=$TEXBODY
  if [ -f $TMPTEX ]; then rm $TMPTEX ; fi


  for LINE in `cat $PADDUMP | sed 's, ,DieW73NaS03J,g'`
   do 
      # --------------------------------------------------- # 
      # RESTORE SPACES
        LINE=`echo $LINE | sed 's,DieW73NaS03J, ,g'`

      # --------------------------------------------------- #  
      # CHECK IF LINE STARTS WITH A %
        ISCMD=`echo $LINE | grep ^% | wc -l` 

      # --------------------------------------------------- # 
      # IF LINE STARTS WITH A %
        if [ $ISCMD -ge 1 ]; then
 
           CMD=`echo $LINE | \
                cut -d "%" -f 2 | \
                cut -d ":" -f 1 | \
                sed 's, ,,g'`
           ARG=`echo $LINE | cut -d ":" -f 2-`

      # --------------------------------------------------- # 
      # CHECK IF COMMAND EXISTS

           CMDEXISTS=`grep "^function ${CMD}()" $FUNCTIONS |\
                      wc -l`

      # --------------------------------------------------- # 
      # IF COMMAND EXISTS 

        if [ $CMDEXISTS -ge 1 ]; then

         # EXECUTE COMMAND
           $CMD $ARG

        fi
      # --------------------------------------------------- # 
      # IF LINE DOES NOT START WITH % (= SIMPLE MARKDOWN)
        else

      # --------------------------------------------------- # 
      # APPEND LINE TO TEX FILE

          echo "$LINE" >> $TEXBODY

        fi
      # --------------------------------------------------- # 
  done


# --------------------------------------------------------------------------- #
# GENERATE PDF
# --------------------------------------------------------------------------- #

  TEXCOMPLETE=tmptex.tex
  TMPTEX=$TEXCOMPLETE
  if [ -f $TMPTEX ]; then rm $TMPTEX ; fi

  writeTeXsrc "\documentclass[8pt,cleardoubleempty]{scrbook}"
  writeTeXsrc "\usepackage[utf8]{inputenc}"
  writeTeXsrc "\usepackage{i/sty/basic}"
  writeTeXsrc "\usepackage{i/sty/functions}"

  writeTeXsrc "\begin{document}"
  cat $TEXBODY | sed "s/$EMPTYLINE/ /g" >> $TMPTEX
  writeTeXsrc "\end{document}"

  pdflatex -interaction=nonstopmode \
           -output-directory $OUTDIR \
            $TMPTEX > /dev/null

# DEBUG
# pdflatex -interaction=nonstopmode \
#          -output-directory $OUTDIR \
#           $TMPTEX
#
  cp $TMPTEX debug.tex

# --------------------------------------------------------------------------- #
# CLEAN UP
# --------------------------------------------------------------------------- #

  cp ${TMPTEX%.*}.pdf latest.pdf
  mv ${TMPTEX%.*}.pdf $PDFDIR/`date +%s`.pdf
  rm ${TMPTEX%.*}.* ${PADDUMP%%.*}.* $FUNCTIONS

#  if [ `find $TMPDIR -name "*.*" | grep -v .gitignore | wc -l` -gt 0 ] 
#  then
#  rm $TMPDIR/*.*
#  fi


exit 0;
