; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = internal unnamed_addr constant [21 x i8] c"Argument singularity\00", align 1
@aArgumentDomain = internal unnamed_addr constant [22 x i8] c"Argument domain error\00", align 1
@aPartialLossOfS = internal unnamed_addr constant [30 x i8] c"Partial loss of significance\00", align 1
@aOverflowRangeE = internal unnamed_addr constant [21 x i8] c"Overflow range error\00", align 1
@aTheResultIsToo = internal unnamed_addr constant [24 x i8] c"The result is too large\00", align 1
@aTotalLossOfSig = internal unnamed_addr constant [28 x i8] c"Total loss of significance\00", align 1
@aUnknownError = internal unnamed_addr constant [14 x i8] c"Unknown error\00", align 1
@aMatherrSInSGGR = internal unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @sub_140002AD0(i32)
declare i32 @sub_1400029C0(i8*, i8*, ...)

define i32 @sub_1400019D0(i8* %rcx) local_unnamed_addr {
entry:
  %codeptr = bitcast i8* %rcx to i32*
  %code = load i32, i32* %codeptr, align 4
  switch i32 %code, label %sw.default [
    i32 1, label %sw.bb1
    i32 2, label %sw.bb2
    i32 3, label %sw.bb3
    i32 4, label %sw.bb4
    i32 5, label %sw.bb5
    i32 6, label %sw.bb6
  ]

sw.bb1:                                            ; case 1
  %p1 = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %sw.epilog

sw.bb2:                                            ; case 2
  %p2 = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %sw.epilog

sw.bb3:                                            ; case 3
  %p3 = getelementptr inbounds [21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %sw.epilog

sw.bb4:                                            ; case 4
  %p4 = getelementptr inbounds [24 x i8], [24 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %sw.epilog

sw.bb5:                                            ; case 5
  %p5 = getelementptr inbounds [28 x i8], [28 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %sw.epilog

sw.bb6:                                            ; case 6
  %p6 = getelementptr inbounds [30 x i8], [30 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %sw.epilog

sw.default:                                        ; default and case 0
  %pd = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %sw.epilog

sw.epilog:
  %msg = phi i8* [ %p2, %sw.bb2 ], [ %p1, %sw.bb1 ], [ %p3, %sw.bb3 ], [ %p4, %sw.bb4 ], [ %p5, %sw.bb5 ], [ %p6, %sw.bb6 ], [ %pd, %sw.default ]
  %off8 = getelementptr i8, i8* %rcx, i64 8
  %pp = bitcast i8* %off8 to i8**
  %fname = load i8*, i8** %pp, align 8
  %off16 = getelementptr i8, i8* %rcx, i64 16
  %dptr1 = bitcast i8* %off16 to double*
  %arg1 = load double, double* %dptr1, align 8
  %off24 = getelementptr i8, i8* %rcx, i64 24
  %dptr2 = bitcast i8* %off24 to double*
  %arg2 = load double, double* %dptr2, align 8
  %off32 = getelementptr i8, i8* %rcx, i64 32
  %dptr3 = bitcast i8* %off32 to double*
  %retval = load double, double* %dptr3, align 8
  %file = call i8* @sub_140002AD0(i32 2)
  %fmtptr = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 (i8*, i8*, ...) @sub_1400029C0(i8* %file, i8* %fmtptr, i8* %msg, i8* %fname, double %arg1, double %arg2, double %retval)
  ret i32 0
}