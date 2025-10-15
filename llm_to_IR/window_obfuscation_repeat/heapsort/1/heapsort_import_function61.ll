; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i8*, double, double, double }

@aArgumentSingul = private unnamed_addr constant [21 x i8] c"Argument singularity\00", align 1
@aArgumentDomain = private unnamed_addr constant [22 x i8] c"Argument domain error\00", align 1
@aPartialLossOfS = private unnamed_addr constant [29 x i8] c"Partial loss of significance\00", align 1
@aOverflowRangeE = private unnamed_addr constant [21 x i8] c"Overflow range error\00", align 1
@aTheResultIsToo = private unnamed_addr constant [24 x i8] c"The result is too small\00", align 1
@aTotalLossOfSig = private unnamed_addr constant [27 x i8] c"Total loss of significance\00", align 1
@aUnknownError = private unnamed_addr constant [14 x i8] c"Unknown error\00", align 1
@aMatherrSInSGGR = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @sub_140002AD0(i32)
declare void @sub_1400029C0(i8*, i8*, i8*, i8*, double, double, double)

define i32 @sub_1400019D0(%struct.S* %rec) {
entry:
  %codeptr = getelementptr inbounds %struct.S, %struct.S* %rec, i64 0, i32 0
  %code = load i32, i32* %codeptr, align 4
  switch i32 %code, label %sw.default [
    i32 0, label %sw.default
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

sw.default:                                       ; default and case 0
  %pdef = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %cont

case1:                                            ; case 1
  %p1 = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %cont

case2:                                            ; case 2
  %p2 = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %cont

case3:                                            ; case 3
  %p3 = getelementptr inbounds [21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %cont

case4:                                            ; case 4
  %p4 = getelementptr inbounds [24 x i8], [24 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %cont

case5:                                            ; case 5
  %p5 = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %cont

case6:                                            ; case 6
  %p6 = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %cont

cont:
  %msg = phi i8* [ %pdef, %sw.default ], [ %p1, %case1 ], [ %p2, %case2 ], [ %p3, %case3 ], [ %p4, %case4 ], [ %p5, %case5 ], [ %p6, %case6 ]
  %nameptr = getelementptr inbounds %struct.S, %struct.S* %rec, i64 0, i32 1
  %name = load i8*, i8** %nameptr, align 8
  %a1ptr = getelementptr inbounds %struct.S, %struct.S* %rec, i64 0, i32 2
  %a1 = load double, double* %a1ptr, align 8
  %a2ptr = getelementptr inbounds %struct.S, %struct.S* %rec, i64 0, i32 3
  %a2 = load double, double* %a2ptr, align 8
  %retptr = getelementptr inbounds %struct.S, %struct.S* %rec, i64 0, i32 4
  %retval = load double, double* %retptr, align 8
  %buf = call i8* @sub_140002AD0(i32 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  call void @sub_1400029C0(i8* %buf, i8* %fmt, i8* %msg, i8* %name, double %a1, double %a2, double %retval)
  ret i32 0
}