C MEMBER CRETRV
C  (from old member FCCSRSET)
C
C DESC 'IN-CORE SORTING PACKAGE FOR CARRYOVER USED IN CGDEF COMMAND'
C.......................................................................
C                             LAST UPDATE: 07/27/95.12:12:15 BY $WC21DT
C
      SUBROUTINE CRETRV(C,NC,ISLOT,NSAVE,NARAYS,ARAY1,LARAY1,ARAY2,
     .  LARAY2,ARAY3,LARAY3,ARAY4,LARAY4,ARAY5,LARAY5,ARAY6,LARAY6,
     .  ARAY7,LARAY7,ARAY8,LARAY8,ARAY9,LARAY9,ARAY10,LARA10,IER)
C
C  IN-CORE SORTING PACKAGE USED TO SORT C ARRAYS DURING CARRYOVER
C  GROUP DEFINITION.  THE ORIGINAL PACKAGE HAD THREE ROUTINES --
C    1.CSRSET -- MUST BE CALLED FIRST TO SET UP THE BOOKKEEPING
C                ARRAYS FOR LATER CALLS.
C    2.CSAVE  -- USED TO PLACE A C ARRAY INTO A SPECIFIED SLOT IN
C                CORE FOR LATER RETRIEVAL.
C    3.CRETRV -- USED TO RETRIEVE A PREVIOUSLY SAVED C ARRAY.
C
C  ALL ARGUMENTS TO ALL THREE ENTRIES RETAIN THE SAME MEANING.
C
C  ARGUMENT  DESCRIPTION
C  --------  ----------------------------------------------------------
C  C         C ARRAY
C  NC        LENGTH OF C ARRAY. MUST BE UNCHANGED IN CALLS TO CSAVE AND
C            CRESTR AFTER CSRSET IS CALLED TO SET UP BOOKKEEPING FOR A
C            SPECIFIC SIZE C ARRAY.
C  ISLOT     SLOT TO SAVE OR RETRIEVE C ARRAY INTO/FROM.(NOT USED IN
C            ENTRY CSRSET)
C  NSAVE     MAX NUMBER OF SLOTS TO BE SAVED.  MUST NOT BE ALTERED
C            AFTER CSRSET IS CALLED.
C  ARAY*     WORKING STORAGE ARRAY *   THESE ROUTINES ARE WRITTEN TO
C            USE UP TO 10 WORKING STORAGE ARRAYS(IF NEEDED) OF ANY
C            AVAILABLE SIZE.  OF COURSE, THE CALLS TO CSRSET, CSAVE,
C            AND CRESTR MUST HAVE EXACTLY THE SAME WORKING STORAGE
C            ARRAYS IN EXACTLY THE SAME ORDER.
C  LARAY*    LENGTH OF THE *-TH WORKING STORAGE ARRAY.(VALUE OF ZERO
C            IS LEGAL)
C  IER       SET TO 0 FOR NORMAL RETURN, =1 IF ERROR OCCURS.
C
C  ROUTINE ORIGINALLY WRITTEN BY --
C    ED JOHNSON -- HRL -- 14 NOV 1979
C.......................................................................
      DIMENSION C(NC)
      DIMENSION ARAY1(NSAVE,1),ARAY2(NSAVE,1),ARAY3(NSAVE,1)
      DIMENSION ARAY4(NSAVE,1),ARAY5(NSAVE,1),ARAY6(NSAVE,1)
      DIMENSION ARAY7(NSAVE,1),ARAY8(NSAVE,1),ARAY9(NSAVE,1)
      DIMENSION ARAY10(NSAVE,1)
C NUSEAR IS NUMBER OF POSITIONS USED IN EACH ARRAY
CC AV      DIMENSION NUSEAR(10)
C IDEFIN(I)=1 IF CSAVE CALLED WITH ISLOT=I
CC AV      DIMENSION IDEFIN(30)
C
      INCLUDE 'common/fdbug'
      INCLUDE 'common/ionum'
      INCLUDE 'common/crsort'
C
cc AV pgf90 port 7/3/01      COMMON  /CRSORT/ NUSEAR,IDEFIN,MSAVE,MC
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_top/RCS/cretrv.f,v $
     . $',                                                             '
     .$Id: cretrv.f,v 1.3 2002/02/11 20:25:43 dws Exp $
     . $' /
C    ===================================================================
C
C
ccAV      DATA NUSEAR/10*0/
ccAV      DATA IDEFIN/30*0/
C VALUES OF MSAVE AND MC SET ON CALL TO CSRSET TO NSAVE AND NC
ccAV      DATA MSAVE/-1/,MC/-1/
C
C  DEBUG FLAG = 'CGDF'
C
      DATA BUGOPT/4HCGDF/
C
      IER=0
      IF(ITRACE.GE.2)WRITE(IODBUG,907)
 907  FORMAT(19H *** CRETRV ENTERED)
      IF(IFBUG(BUGOPT).NE.1)GO TO 310
      WRITE(IODBUG,803)NC,ISLOT,NSAVE
 803  FORMAT(29H --IN CRETRV, NC,ISLOT,NSAVE=,3(1X,I7))
 310  IF(NC.EQ.MC.AND.NSAVE.EQ.MSAVE.AND.ISLOT.GT.0.AND.ISLOT.LE.NSAVE)
     .  GO TO 320
      WRITE(IPR,908)
 908  FORMAT('0**ERROR** IN CRETRV')
      WRITE(IPR,906)NC,MC,NSAVE,MSAVE,ISLOT
 906  FORMAT(1H ,11X,25HEITHER LENGTH OF C ARRAY(,I6,
     .  30H) CHANGED FROM CALL TO CSRSET(,I6,5H), OR,/,
     .  1H ,11X,21HNUMBER OF DAYS SAVED(,I6,19H) CHANGED FROM CALL ,
     .  10HTO CSRSET(,I6,5H), OR,/,
     .  1H ,11X,19HISLOT OUT OF RANGE(,I6,1H))
      IER=1
      CALL ERROR
 320  IF(IDEFIN(ISLOT).EQ.1)GO TO 330
      WRITE(IPR,909)ISLOT
 909  FORMAT('0**ERROR** IN CRESTR, ATTEMPT TO RETRIEVE SLOT ',
     .  I4,22H WHICH WAS NEVER SAVED)
      IER=1
      CALL ERROR
 330  IF(IER.EQ.1)RETURN
      IC1=0
      DO 360 I=1,NARAYS
      N=NUSEAR(I)
      IF(N.LE.0)GO TO 360
      DO 350 J=1,N
      GO TO (331,332,333,334,335,336,337,338,339,340),I
 331  C(IC1+J)=ARAY1(ISLOT,J)
      GO TO 350
 332  C(IC1+J)=ARAY2(ISLOT,J)
      GO TO 350
 333  C(IC1+J)=ARAY3(ISLOT,J)
      GO TO 350
 334  C(IC1+J)=ARAY4(ISLOT,J)
      GO TO 350
 335  C(IC1+J)=ARAY5(ISLOT,J)
      GO TO 350
 336  C(IC1+J)=ARAY6(ISLOT,J)
      GO TO 350
 337  C(IC1+J)=ARAY7(ISLOT,J)
      GO TO 350
 338  C(IC1+J)=ARAY8(ISLOT,J)
      GO TO 350
 339  C(IC1+J)=ARAY9(ISLOT,J)
      GO TO 350
 340  C(IC1+J)=ARAY10(ISLOT,J)
      GO TO 350
 350  CONTINUE
      IC1=IC1+N
 360  CONTINUE
      IER=0
      RETURN
      END
