; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@aArgumentSingul = internal unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@aArgumentDomain = internal unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@aPartialLossOfS = internal unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@aOverflowRangeE = internal unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@aTheResultIsToo = internal unnamed_addr constant [24 x i8] c"the result is too small\00", align 1
@aTotalLossOfSig = internal unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@aUnknownError = internal unnamed_addr constant [14 x i8] c"unknown error\00", align 1
@aMatherrSInSGGR = internal unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*, i8*, i8*, ...)

define i32 @sub_1400019D0(i8* %rcx) local_unnamed_addr nounwind {
entry:
  %idxptr = bitcast i8* %rcx to i32*
  %val = load i32, i32* %idxptr, align 4
  switch i32 %val, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
    i32 0, label %sw.default
  ]

sw.case2: ; case 2 -> argument singularity
  %msg2.gep = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %cont

sw.case1: ; case 1 -> argument domain error
  %msg1.gep = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %cont

sw.case6: ; case 6 -> partial loss of significance
  %msg6.gep = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %cont

sw.case3: ; case 3 -> overflow range error
  %msg3.gep = getelementptr inbounds [21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %cont

sw.case4: ; case 4 -> the result is too small
  %msg4.gep = getelementptr inbounds [24 x i8], [24 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %cont

sw.case5: ; case 5 -> total loss of significance
  %msg5.gep = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %cont

sw.default: ; default and case 0 -> unknown error
  %msgd.gep = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %cont

cont:
  %msg = phi i8* [ %msg2.gep, %sw.case2 ], [ %msg1.gep, %sw.case1 ], [ %msg6.gep, %sw.case6 ], [ %msg3.gep, %sw.case3 ], [ %msg4.gep, %sw.case4 ], [ %msg5.gep, %sw.case5 ], [ %msgd.gep, %sw.default ]
  %name.addr.byte = getelementptr inbounds i8, i8* %rcx, i64 8
  %name.addr = bitcast i8* %name.addr.byte to i8**
  %name = load i8*, i8** %name.addr, align 8
  %a.addr.byte = getelementptr inbounds i8, i8* %rcx, i64 16
  %a.addr = bitcast i8* %a.addr.byte to double*
  %a = load double, double* %a.addr, align 8
  %b.addr.byte = getelementptr inbounds i8, i8* %rcx, i64 24
  %b.addr = bitcast i8* %b.addr.byte to double*
  %b = load double, double* %b.addr, align 8
  %ret.addr.byte = getelementptr inbounds i8, i8* %rcx, i64 32
  %ret.addr = bitcast i8* %ret.addr.byte to double*
  %retv = load double, double* %ret.addr, align 8
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt.gep = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_1400029C0(i8* %stream, i8* %fmt.gep, i8* %msg, i8* %name, double %a, double %b, double %retv)
  ret i32 0
}