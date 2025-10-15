; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@aArgumentDomain = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@aPartialLossOfS = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@aOverflowRangeE = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@aTheResultIsToo = private unnamed_addr constant [24 x i8] c"the result is too small\00", align 1
@aTotalLossOfSig = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@aUnknownError = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1
@aMatherrSInSGGR = private unnamed_addr constant [44 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*, i8*, i8*, ...)

define i32 @sub_1400019D0(i8* %rcx) {
entry:
  %kindptr = bitcast i8* %rcx to i32*
  %kind = load i32, i32* %kindptr
  switch i32 %kind, label %sw.default [
    i32 1, label %sw.bb1
    i32 2, label %sw.bb2
    i32 3, label %sw.bb3
    i32 4, label %sw.bb4
    i32 5, label %sw.bb5
    i32 6, label %sw.bb6
  ]

sw.bb1:                                           ; case 1
  %msg1 = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %after.sel

sw.bb2:                                           ; case 2
  %msg2 = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %after.sel

sw.bb3:                                           ; case 3
  %msg3 = getelementptr inbounds [21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %after.sel

sw.bb4:                                           ; case 4
  %msg4 = getelementptr inbounds [24 x i8], [24 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %after.sel

sw.bb5:                                           ; case 5
  %msg5 = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %after.sel

sw.bb6:                                           ; case 6
  %msg6 = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %after.sel

sw.default:                                       ; default (includes case 0 and >6)
  %msgd = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %after.sel

after.sel:
  %msg = phi i8* [ %msg2, %sw.bb2 ], [ %msg1, %sw.bb1 ], [ %msg3, %sw.bb3 ], [ %msg4, %sw.bb4 ], [ %msg5, %sw.bb5 ], [ %msg6, %sw.bb6 ], [ %msgd, %sw.default ]
  %fnameptr.raw = getelementptr i8, i8* %rcx, i64 8
  %fnameptr = bitcast i8* %fnameptr.raw to i8**
  %fname = load i8*, i8** %fnameptr
  %arg0ptr.raw = getelementptr i8, i8* %rcx, i64 16
  %arg0ptr = bitcast i8* %arg0ptr.raw to double*
  %arg0 = load double, double* %arg0ptr
  %arg1ptr.raw = getelementptr i8, i8* %rcx, i64 24
  %arg1ptr = bitcast i8* %arg1ptr.raw to double*
  %arg1 = load double, double* %arg1ptr
  %retptr.raw = getelementptr i8, i8* %rcx, i64 32
  %retptr = bitcast i8* %retptr.raw to double*
  %retval = load double, double* %retptr
  %fh = call i8* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [44 x i8], [44 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_1400029C0(i8* %fh, i8* %fmt, i8* %msg, i8* %fname, double %arg0, double %arg1, double %retval)
  ret i32 0
}