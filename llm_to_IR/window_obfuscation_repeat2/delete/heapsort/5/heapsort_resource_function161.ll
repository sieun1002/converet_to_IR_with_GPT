; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = private unnamed_addr constant [21 x i8] c"Argument singularity\00"
@aArgumentDomain = private unnamed_addr constant [22 x i8] c"Argument domain error\00"
@aOverflowRangeE = private unnamed_addr constant [21 x i8] c"Overflow range error\00"
@aTheResultIsToo = private unnamed_addr constant [42 x i8] c"The result is too small to be represented\00"
@aTotalLossOfSig = private unnamed_addr constant [27 x i8] c"Total loss of significance\00"
@aPartialLossOfS = private unnamed_addr constant [29 x i8] c"Partial loss of significance\00"
@aUnknownError = private unnamed_addr constant [14 x i8] c"Unknown error\00"
@aMatherrSInSGGR = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00"

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_1400029C0(i8*, i8*, i8*, i8*, ...)

define dso_local i32 @sub_1400019D0(i8* %rcx) {
entry:
  %type.ptr = bitcast i8* %rcx to i32*
  %type = load i32, i32* %type.ptr, align 4
  switch i32 %type, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:                                         ; case 1
  %msg1 = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %cont

sw.case2:                                         ; case 2
  %msg2 = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %cont

sw.case3:                                         ; case 3
  %msg3 = getelementptr inbounds [21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %cont

sw.case4:                                         ; case 4
  %msg4 = getelementptr inbounds [42 x i8], [42 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %cont

sw.case5:                                         ; case 5
  %msg5 = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %cont

sw.case6:                                         ; case 6
  %msg6 = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %cont

sw.default:                                       ; default (includes case 0)
  %msgd = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %cont

cont:
  %msg = phi i8* [ %msg1, %sw.case1 ], [ %msg2, %sw.case2 ], [ %msg3, %sw.case3 ], [ %msg4, %sw.case4 ], [ %msg5, %sw.case5 ], [ %msg6, %sw.case6 ], [ %msgd, %sw.default ]
  %name.ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 8
  %name.ptr = bitcast i8* %name.ptr.i8 to i8**
  %name = load i8*, i8** %name.ptr, align 8
  %arg1.ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 16
  %arg1.ptr = bitcast i8* %arg1.ptr.i8 to double*
  %arg1 = load double, double* %arg1.ptr, align 8
  %arg2.ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 24
  %arg2.ptr = bitcast i8* %arg2.ptr.i8 to double*
  %arg2 = load double, double* %arg2.ptr, align 8
  %retval.ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 32
  %retval.ptr = bitcast i8* %retval.ptr.i8 to double*
  %retval = load double, double* %retval.ptr, align 8
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_1400029C0(i8* %stream, i8* %fmt, i8* %msg, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}