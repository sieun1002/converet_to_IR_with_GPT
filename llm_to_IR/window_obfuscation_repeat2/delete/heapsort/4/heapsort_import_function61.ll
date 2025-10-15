; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct.rec = type { i32, i8*, double, double, double }

@aArgumentSingul = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@aArgumentDomain = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@aOverflowRangeE = private unnamed_addr constant [23 x i8] c"overflow (range error)\00", align 1
@aTheResultIsToo = private unnamed_addr constant [42 x i8] c"the result is too small to be represented\00", align 1
@aTotalLossOfSig = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@aPartialLossOfS = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@aUnknownError = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1
@aMatherrSInSGGR = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @sub_140002AD0(i32)
declare i32 @sub_1400029C0(i8*, i8*, i8*, i8*, ...)

define i32 @sub_1400019D0(%struct.rec* nocapture readonly %rcx) local_unnamed_addr {
entry:
  %tag.ptr = getelementptr inbounds %struct.rec, %struct.rec* %rcx, i32 0, i32 0
  %tag = load i32, i32* %tag.ptr, align 4
  switch i32 %tag, label %sw.default [
    i32 0, label %sw.default
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case2:                                           ; case 2: aArgumentSingul
  %selmsg.case2 = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %common

sw.case1:                                           ; case 1: aArgumentDomain
  %selmsg.case1 = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %common

sw.case6:                                           ; case 6: aPartialLossOfS
  %selmsg.case6 = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %common

sw.case3:                                           ; case 3: aOverflowRangeE
  %selmsg.case3 = getelementptr inbounds [23 x i8], [23 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %common

sw.case4:                                           ; case 4: aTheResultIsToo
  %selmsg.case4 = getelementptr inbounds [42 x i8], [42 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %common

sw.case5:                                           ; case 5: aTotalLossOfSig
  %selmsg.case5 = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %common

sw.default:                                         ; default and case 0: aUnknownError
  %selmsg.default = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %common

common:
  %selmsg = phi i8* [ %selmsg.case2, %sw.case2 ], [ %selmsg.case1, %sw.case1 ], [ %selmsg.case6, %sw.case6 ], [ %selmsg.case3, %sw.case3 ], [ %selmsg.case4, %sw.case4 ], [ %selmsg.case5, %sw.case5 ], [ %selmsg.default, %sw.default ]
  %retval.ptr = getelementptr inbounds %struct.rec, %struct.rec* %rcx, i32 0, i32 4
  %retval = load double, double* %retval.ptr, align 8
  %arg2.ptr = getelementptr inbounds %struct.rec, %struct.rec* %rcx, i32 0, i32 3
  %arg2 = load double, double* %arg2.ptr, align 8
  %arg1.ptr = getelementptr inbounds %struct.rec, %struct.rec* %rcx, i32 0, i32 2
  %arg1 = load double, double* %arg1.ptr, align 8
  %func.ptr.ptr = getelementptr inbounds %struct.rec, %struct.rec* %rcx, i32 0, i32 1
  %func.ptr = load i8*, i8** %func.ptr.ptr, align 8
  %buf = call i8* @sub_140002AD0(i32 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_1400029C0(i8* %buf, i8* %fmt, i8* %selmsg, i8* %func.ptr, double %arg1, double %arg2, double %retval)
  ret i32 0
}