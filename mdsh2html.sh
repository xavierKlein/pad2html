#!/bin/bash

	#echo "Please indicate your directory where Hotglue is install"
	#read MAINURL

  MAINURL=http://www.lafkon.net/xk/

  PADNAMEURL=CompteRenduMarathonTypoLibre2

  FUNCTIONS=i/sh/html.functions
  source $FUNCTIONS

  TMPDIR=tmp
  EMPTYLINE="EMPTY-LINE-EMPTY-LINE-EMPTY-LINE-TEMPORARY-NOT"

  PADDUMP=$TMPDIR/pad.md
  PADURL=http://lite4.framapad.org/p/CompteRenduMarathonTypoLibre2/export/txt
  PADHTML=$TMPDIR/pad.html

  #PADINFODUMP=$TMPDIR/padinfo.md
  #PADINFOURL=http://note.pad.constantvzw.org:8000/p/conversations.informations/export/txt

  #PADGLOBAL2DUMP=$TMPDIR/padglobal2.md
  #PADGLOBAL2URL=http://note.pad.constantvzw.org:8000/p/conversations/export/txt


HTMLFILE=$TMPDIR/pad.html



# COPY THE GENERAL HEADER
# --------------------------------------------------------------------------- #
  #cp i/canvas/*.box tmp/


# DOWNLOAD THE PAD
# --------------------------------------------------------------------------- #
  wget --no-check-certificate -O $PADDUMP $PADURL
  #wget --no-check-certificate -O $PADINFODUMP $PADINFOURL
  #wget --no-check-certificate -O $PADGLOBAL2DUMP $PADGLOBAL2URL



# MODIFY STRUCTURE
# --------------------------------------------------- #
# SAVE EMPTYLINES THROUGH PLACEHOLDER
  #sed -i "s/^ *$/$EMPTYLINE/g"               $PADDUMP

# CONVERT FOOTNOTES TO COMMANDS
# sed -i 's/\[^\]{/\n% SIDENOTE:/g'          $PADDUMP
  sed -i 's/\[^\]{/\[FT\]\n% SIDENOTE:/g'    $PADDUMP
  sed -i '/^% SIDENOTE/s/}/\n/'              $PADDUMP
# CONVERT BIBREFERENCES TO COMMANDS
  sed -i 's/\[@/\n% BIBITEM:/g'              $PADDUMP
  sed -i '/^% BIBITEM/s/]/\n/'               $PADDUMP

# REMOVE CONSECUTIVE (BLANK) LINES
  sed -i '$!N; /^\(.*\)\n\1$/!P; D'          $PADDUMP


# SET HOTGLUE STANDARD AND START VALUES
# --------------------------------------------------------------------------- #
  XPOSSTANDARD=50
  WIDTHSTANDARD=550

  XPOS=$XPOSSTANDARD ; YPOS=210 ; WIDTH=$WIDTHSTANDARD ;  HEIGHT=0

# COLORSTANDARD="255,255,255"
  BOXCOLORSTANDARD="none"
  BOXCOLOR=$COLORSTANDARD

  TEXTCOLORSTANDARD="0,0,0"
  TEXTCOLOR=$TEXTCOLORSTANDARD

  CHARPERLINESTANDARD=55
  CHARPERLINE=$CHARPERLINESTANDARD

  LINEHEIGHT=10 # 'REAL' HEIGHT FOR BOX CALCULATION
  FOOTNOTECOUNT=1

  FOOTNOTEPOS=0
 YFOOTNOTEPOS=0

  IMGNAME=0


 # --------------------------------------------------------------------------- #
 # MAKE THE SPEAKERS PRESENTATION
 # --------------------------------------------------------------------------- #

  # --------------------------------------------------- #
  # GET THE INITIALS OF THE SPEAKERS
 #`grep "% NOWSPEAKING:" $PADDUMP | cut -d ":" -f2 | sort | uniq  |\
 # sed  's/ //' | sed  '/^$/d'                              >$TMPDIR/SPEAKERLIST`




  #MENULOOP1
  #LASTYPOS1=`cat $LASTPOSY`
  #echo "Last position for part1:$LASTYPOS1"

  #MENULOOP2 $LASTYPOS1
  #LASTYPOS1=`cat $LASTPOSY`
  #echo "Last position for part2:$LASTYPOS1"

  #MENULOOP3 $LASTYPOS1
  #LASTYPOS1=`cat $LASTPOSY`
  #echo "Last position for part3:$LASTYPOS1"

  #HEADER $LASTYPOS1





 # --------------------------------------------------- #
 # LOOP FOR MAKE EACH BOXES
  # cat $TMPDIR/SPEAKERLIST |{ while read INITIAL
  # do

  # if [ "$INITIAL" = "X" ]
    # then
    # continue
  # fi

  # YPOS=`expr $YPOS + 20`
  # echo  "Les initiaux sont $INITIAL"

  # WHO $INITIAL $YPOS
  # done



 # --------------------------------------------------- #
 # LOOP FOR MAKING EACH URL CLICKABLE
  NOMBEROFLINK=`grep -o -c  http.* $PADDUMP`


  for ((i=1 ; i<=$NOMBEROFLINK ; i=i+1))
   do
   LINK=`grep -o -m$i http.* $PADDUMP | tail -n1`
   STOPLINK=`grep  -m$i http.* $PADDUMP |tail -1|cut -d ":" -f1`
   echo $LINK
   #sed "s/$Vd/<a href=$Vd>$Vd<\/a>/g"
   if [ "$STOPLINK" == "% WWWGRAFIK" ]
     then
     continue
   else
   grep $LINK $PADDUMP | sed -i "s|$LINK|<a href=\"$LINK\" target=\"_blank\">Lien</a>|g" $PADDUMP
   fi

  done


# --------------------------------------------------- #
# LOOP FOR INTEGRATE % SIDENOTE INTO THE TEXT

  NOMBEROFNOTE=`grep -o -c  "% SIDENOTE:*" $PADDUMP`


  for ((i=1 ; i<=$NOMBEROFNOTE ; i=i+1))
   do
   NOTE=`grep -o -m$i "% SIDENOTE:.*" $PADDUMP | tail -n1 | sed "s/% SIDENOTE://g"`
   #sed "s/$Vd/<a href=$Vd>$Vd<\/a>/g"
   sed -i "s|$NOTE|<span class=\"NOTE\">[XN]$NOTE</span>|g" $PADDUMP
  done

  sed -i "s/% SIDENOTE://g" $PADDUMP

# --------------------------------------------------- #
# MAKING THE HEADER AND CREATING THE CSS FILE
  HTMLHEADER
  CSS

# --------------------------------------------------------------------------- #
# PARSE MDSH AND SPLIT THE CONTENT IN SEPARATE PARTS FOR SPEAKERS
# --------------------------------------------------------------------------- #
  FILENAME=4000100
  FILE=$TMPDIR/$FILENAME



  if [ -f $FILE ]; then rm $FILE ; fi


  for LINE in `cat $PADDUMP | sed -e 's/ /djqteDF34/g'`
   do
     # RESTORE SPACES ON CURRENT LINE
       LINE=`echo $LINE | sed 's/djqteDF34/ /g'`



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
     # APPEND LINE TO HOTGLUE FILE
       echo "$LINE" | \
       sed "s/^$/jdsN36Fgc/g" | \
       pandoc -r markdown -w html | \
       sed -e 's/<blockquote>/<i>/' -e 's/<\/blockquote>/<\/i>/' \
           -e 's/<strong>/<b>/' -e 's/<\/strong>/<\/b>/' \
           -e 's/<p>//g' -e 's/<\/p>//g' \
           -e 's/<em>/<b>/g' -e 's/<\/em>/<\/b>/g' \
       >> ${FILE}.dump
       fi
     # --------------------------------------------------- #





 done


# --------------------------------------------------------------------------- #
# FLUSH (EXECUTE A LAST TIME THE NOWSPEAKING COMMAND)
  NOWSPEAKING
# CLEAN UP
   #rm $TMPDIR/*.dump $TMPDIR/*.md


#sed -i "s/^object-height:.*$/object-height:${FULLHEIGHT}px/" $TMPDIR/strokeV.box
#sed -i "s/HH/H/" $TMPDIR/*.box
#sed -i "s/ALA/AL/" $TMPDIR/*.box

NOTETOTAL=`grep -o "\[FT\]" $HTMLFILE | wc -l`
INITNOTE=0

cat $PADDUMP | grep -o  "FT" | while read FT
do

INITNOTE=`expr $INITNOTE + 1`
sed -i "0,/\[$FT\]/s//<b>\[${INITNOTE}\]<\/b>/" $HTMLFILE
done

NOTETOTAL2=$NOMBEROFNOTE
INITNOTE2=0

cat $PADDUMP | grep -o  "XN" | while read XN
do

INITNOTE2=`expr $INITNOTE2 + 1`
sed -i "0,/\[$XN\]/s//<b>\[${INITNOTE2}\]<\/b>/" $HTMLFILE

done


HTMLFOOTER


exit 0;


# --------------------------------------------------------------------------- #
# UPLOAD TO AN EXISTING HOTGLUE INSTALLATION
# --------------------------------------------------------------------------- #

  if [ "$PADNAMEURL" == "fsnelting+mfuller" ]
    then
    PADNAMEURL=fsnelting-mfuller
  fi

  echo  "$PADNAMEURL"
  CANVASNAME=$PADNAMEURL

  HOTGLUEBASE=hotglue/content
  HOTGLUECONTENT=$HOTGLUEBASE/$CANVASNAME/head
  HOTGLUESHARED=$HOTGLUEBASE/$CANVASNAME/shared

  ACCESS=`head -n 1 conf/ftp.conf`
    HOST=`tail -n 1 conf/ftp.conf`

  FTPTMP=$TMPDIR/ftp.input
  if [ -f $FILE ]; then rm $TMPDIR/*.md ; fi

# UPLOAD VIA FTP (CONTROL FILE USED LATER)

# LOGIN DATA
# --------------------------------------------------------------------------- #
  echo "$ACCESS"                                                   >  $FTPTMP
# RECURSIVELY CREATE DIRECTORIES
# --------------------------------------------------------------------------- #





# CLEAR GENERATED FILES ONLINE
# --------------------------------------------------------------------------- #
  echo "mdelete $HOTGLUECONTENT/*"                                >> $FTPTMP


# UPLOAD FILES
# --------------------------------------------------------------------------- #

    # UPLOAD VIA FTP (CONTROL FILE USED LATER)
      PAGE=`basename $TMPDIR/pad.html | cut -d "." -f 1`
      echo "put $TMPDIR/$PAGE / "               >> $FTPTMP




# EXIT COMMAND
# --------------------------------------------------------------------------- #
  echo "bye"                                                       >> $FTPTMP

# EXECUTE COMMAND FILE
# --------------------------------------------------------------------------- #
  ftp -i -p -n $HOST  < $FTPTMP
  rm $FTPTMP
  #rm $TMPDIR/*





exit 0;
