#!/bin/bash

# --------------------------------------------------------------------------- #
# THIS IS FRAGILE, HANDLE WITH CARE
#
#
# --------------------------------------------------------------------------- #

   FUNCTIONS=tempfncts.functions
  FNCTSBASIC=i/bash/basic.functions

  cat $FNCTSBASIC > $FUNCTIONS
  if [[ ! -z "$1" ]]; then cat $1 >> $FUNCTIONS ; fi

# INCLUDE FUNCTIONS
  source $FUNCTIONS

  PADBASE=http://lgru.pad.constantvzw.org:8000
  PAD2HTMLURL=$PADBASE/ep/pad/export/197/latest?format=txt
  PADDUMP=dump.md

  OUTDIR=.
  PDFDIR=o/pdf



# --------------------------------------------------------------------------- #
# DUMP AND CONVERT PAD 
# --------------------------------------------------------------------------- #

  wget -q -O  - $PAD2HTMLURL --no-check-certificate | \
  sed 's/^%/zDf7WV362LoP/g' | \
  sed '/zDf7WV362LoP/s/$/\n\n/g' | \
  sed '/zDf7WV362LoP/s/"/hFg76VCdJueW/g' | \
  pandoc --strict -r markdown -w latex | \
  sed 's/hFg76VCdJueW/"/g' | \
  sed 's/zDf7WV362LoP/%/g' > $PADDUMP



# --------------------------------------------------------------------------- #
# PARSE COMMANDS 
# --------------------------------------------------------------------------- #

  PROCESSED=${PADDUMP%%.*}.tmp
  if [ -f $PROCESSED ]; then rm $PROCESSED ; fi


  for LINE in `cat $PADDUMP | sed 's/ /DieW73NaS03J/g'`
   do 
      # --------------------------------------------------- # 
      # RESTORE SPACES
        LINE=`echo $LINE | sed 's/DieW73NaS03J/ /g'`

      # --------------------------------------------------- #  
      # CHECK IF LINE STARTS WITH A %
        ISCMD=`echo $LINE | grep ^% | wc -l` 

      # --------------------------------------------------- # 
      # IF LINE STARTS WITH A %
        if [ $ISCMD -ge 1 ]; then
 
           CMD=`echo $LINE | \
                cut -d "%" -f 2 | \
                cut -d ":" -f 1 | \
                sed 's/ //g'`
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

          echo "$LINE" >> $PROCESSED

        fi
      # --------------------------------------------------- # 
  done



# --------------------------------------------------------------------------- #
# GENERATE PDF
# --------------------------------------------------------------------------- #

  TMPTEX=temptex.tex  

  echo "\documentclass[8pt,cleardoubleempty]{scrbook}"            >  $TMPTEX
  echo "\usepackage[utf8]{inputenc}"                              >> $TMPTEX
  echo "\usepackage{i/sty/A5}"                                    >> $TMPTEX
  echo "\usepackage{i/sty/140129}"                                >> $TMPTEX
  echo "\setlength\textheight{170mm}"                             >> $TMPTEX
  echo "\setlength\topmargin{-17mm}"                              >> $TMPTEX

  echo "\setlength\textwidth{95mm}"                               >> $TMPTEX
  echo "\setlength\oddsidemargin{0mm}"                            >> $TMPTEX
  echo "\setlength\evensidemargin{0mm}"                           >> $TMPTEX

  echo "\parindent=0pt"                                           >> $TMPTEX

  echo "\begin{document}"                                         >> $TMPTEX

  echo "\titlepages{%"                                            >> $TMPTEX
  echo "\url{$PAD2HTMLURL}}"                                      >> $TMPTEX
  echo "{}{}"                                                     >> $TMPTEX
  echo "\hardpagebreak"                                           >> $TMPTEX

  cat $PROCESSED                                                  >> $TMPTEX

  echo "\end{document}"                                           >> $TMPTEX

  pdflatex -interaction=nonstopmode \
           -output-directory $OUTDIR \
            $TMPTEX

# --------------------------------------------------------------------------- #
# CLEAN UP
# --------------------------------------------------------------------------- #

  cp ${TMPTEX%.*}.pdf latest.pdf
  mv ${TMPTEX%.*}.pdf $PDFDIR/`date +%s`.pdf
  rm ${TMPTEX%.*}.* ${PADDUMP%%.*}.* $FUNCTIONS


exit 0;
