; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@aArgumentSingul = private unnamed_addr constant [21 x i8] c"Argument singularity\00"
@aArgumentDomain = private unnamed_addr constant [22 x i8] c"Argument domain error\00"
@aPartialLossOfS = private unnamed_addr constant [29 x i8] c"Partial loss of significance\00"
@aOverflowRangeE = private unnamed_addr constant [21 x i8] c"Overflow range error\00"
@aTheResultIsToo = private unnamed_addr constant [42 x i8] c"The result is too small to be represented\00"
@aTotalLossOfSig = private unnamed_addr constant [27 x i8] c"Total loss of significance\00"
@aUnknownError = private unnamed_addr constant [14 x i8] c"Unknown error\00"
@aMatherrSInSGGR = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00"

declare i8* @sub_140002AD0(i32)
declare i32 @sub_1400029C0(i8*, i8*, i8*, i8*, ...)

define i32 @sub_1400019D0(i8* %0) {
entry:
  %1 = bitcast i8* %0 to i32*
  %2 = load i32, i32* %1, align 4
  switch i32 %2, label %sw.default [
    i32 0, label %sw.default
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:                                        ; case 1: Argument domain
  %3 = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %cont

sw.case2:                                        ; case 2: Argument singularity
  %4 = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %cont

sw.case3:                                        ; case 3: Overflow range error
  %5 = getelementptr inbounds [21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %cont

sw.case4:                                        ; case 4: The result is too small to be represented
  %6 = getelementptr inbounds [42 x i8], [42 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %cont

sw.case5:                                        ; case 5: Total loss of significance
  %7 = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %cont

sw.case6:                                        ; case 6: Partial loss of significance
  %8 = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %cont

sw.default:                                      ; default and case 0: Unknown error
  %9 = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %cont

cont:
  %10 = phi i8* [ %3, %sw.case1 ], [ %4, %sw.case2 ], [ %5, %sw.case3 ], [ %6, %sw.case4 ], [ %7, %sw.case5 ], [ %8, %sw.case6 ], [ %9, %sw.default ]
  %11 = getelementptr i8, i8* %0, i64 8
  %12 = bitcast i8* %11 to i8**
  %13 = load i8*, i8** %12, align 8
  %14 = getelementptr i8, i8* %0, i64 16
  %15 = bitcast i8* %14 to double*
  %16 = load double, double* %15, align 8
  %17 = getelementptr i8, i8* %0, i64 24
  %18 = bitcast i8* %17 to double*
  %19 = load double, double* %18, align 8
  %20 = getelementptr i8, i8* %0, i64 32
  %21 = bitcast i8* %20 to double*
  %22 = load double, double* %21, align 8
  %23 = call i8* @sub_140002AD0(i32 2)
  %24 = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %25 = call i32 (i8*, i8*, i8*, i8*, ...) @sub_1400029C0(i8* %23, i8* %24, i8* %10, i8* %13, double %22, double %19, double %16)
  ret i32 0
}