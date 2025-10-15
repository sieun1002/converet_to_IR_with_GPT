; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = dso_local unnamed_addr constant [21 x i8] c"argument singularity\00"
@aArgumentDomain = dso_local unnamed_addr constant [22 x i8] c"argument domain error\00"
@aPartialLossOfS = dso_local unnamed_addr constant [29 x i8] c"partial loss of significance\00"
@aOverflowRangeE = dso_local unnamed_addr constant [21 x i8] c"overflow range error\00"
@aTheResultIsToo = dso_local unnamed_addr constant [24 x i8] c"the result is too large\00"
@aTotalLossOfSig = dso_local unnamed_addr constant [27 x i8] c"total loss of significance\00"
@aUnknownError = dso_local unnamed_addr constant [14 x i8] c"unknown error\00"
@aMatherrSInSGGR = dso_local unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00"

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_1400029C0(i8*, i8*, i8*, i8*, ...)

define dso_local i32 @sub_1400019D0(i8* %rcx) local_unnamed_addr {
entry:
  %sel.ptr = bitcast i8* %rcx to i32*
  %sel = load i32, i32* %sel.ptr, align 4
  switch i32 %sel, label %sw.default [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case2:                                            ; case 2: argument singularity
  %err2 = getelementptr inbounds [21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0
  br label %common

case1:                                            ; case 1: argument domain error
  %err1 = getelementptr inbounds [22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0
  br label %common

case6:                                            ; case 6: partial loss of significance
  %err6 = getelementptr inbounds [29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0
  br label %common

case3:                                            ; case 3: overflow range error
  %err3 = getelementptr inbounds [21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0
  br label %common

case4:                                            ; case 4: the result is too large
  %err4 = getelementptr inbounds [24 x i8], [24 x i8]* @aTheResultIsToo, i64 0, i64 0
  br label %common

case5:                                            ; case 5: total loss of significance
  %err5 = getelementptr inbounds [27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0
  br label %common

sw.default:                                       ; default and case 0: unknown error
  %errd = getelementptr inbounds [14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0
  br label %common

common:
  %errStr = phi i8* [ %err2, %case2 ], [ %err1, %case1 ], [ %err6, %case6 ], [ %err3, %case3 ], [ %err4, %case4 ], [ %err5, %case5 ], [ %errd, %sw.default ]
  %p8 = getelementptr inbounds i8, i8* %rcx, i64 8
  %func.pp = bitcast i8* %p8 to i8**
  %func = load i8*, i8** %func.pp, align 8
  %p16 = getelementptr inbounds i8, i8* %rcx, i64 16
  %d1p = bitcast i8* %p16 to double*
  %x6 = load double, double* %d1p, align 8
  %p24 = getelementptr inbounds i8, i8* %rcx, i64 24
  %d2p = bitcast i8* %p24 to double*
  %x7 = load double, double* %d2p, align 8
  %p32 = getelementptr inbounds i8, i8* %rcx, i64 32
  %d3p = bitcast i8* %p32 to double*
  %x8 = load double, double* %d3p, align 8
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_1400029C0(i8* %stream, i8* %fmt, i8* %errStr, i8* %func, double %x6, double %x7, double %x8)
  ret i32 0
}