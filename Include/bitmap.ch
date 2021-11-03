/*----------------------------------------------------------------------------//
!short: BITMAP */

#xcommand @ <nRow>, <nCol> BITMAP [ <oBmp> ] ;
     [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
     [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
     [ <NoBorder:NOBORDER, NO BORDER> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     [ <lClick: ON CLICK, ON LEFT CLICK> <uLClick> ] ;
     [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
     [ <scroll: SCROLL> ] ;
     [ <adjust: ADJUST> ] ;
     [ CURSOR <oCursor> ] ;
     [ <pixel: PIXEL>   ] ;
     [ MESSAGE <cMsg>   ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <uWhen> ] ;
     [ VALID <uValid> ] ;
     [ <lDesign: DESIGN> ] ;
     => ;
   [ <oBmp> := ] TBitmap():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
     <cResName>, <cBmpFile>, <.NoBorder.>, <oWnd>,;
     [\{ |nRow,nCol,nKeyFlags| <uLClick> \} ],;
     [\{ |nRow,nCol,nKeyFlags| <uRClick> \} ], <.scroll.>,;
     <.adjust.>, <oCursor>, <cMsg>, <.update.>,;
     <{uWhen}>, <.pixel.>, <{uValid}>, <.lDesign.> )

#xcommand DEFINE BITMAP [<oBmp>] ;
     [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
     [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     => ;
   [ <oBmp> := ] TBitmap():Define( <cResName>, <cBmpFile>, <oWnd> )

/*----------------------------------------------------------------------------//
