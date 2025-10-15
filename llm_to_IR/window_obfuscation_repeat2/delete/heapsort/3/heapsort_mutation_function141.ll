; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@aArgumentDomain = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@aArgumentSingul = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@aOverflowRangeE = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@aTheResultIsToo = private unnamed_addr constant [24 x i8] c"the result is too large\00", align 1
@aTotalLossOfSig = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@aPartialLossOfS = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@aUnknownError = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1
@aMatherrSInSGGR = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*, i8*, i8*, double, double, double)

define dso_local i32 @sub_1400019D0(i8* %rcx.ptr) {
entry:
  %hdr.i32ptr = bitcast i8* %rcx.ptr to i32*
  %typeval = load i32, i32* %hdr.i32ptr, align 4
  switch i32 %typeval, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:                                          ; case 1: argument domain
  br label %cont

sw.case2:                                          ; case 2: argument singularity
  br label %cont

sw.case3:                                          ; case 3: overflow range
  br label %cont

sw.case4:                                          ; case 4: result too large
  br label %cont

sw.case5:                                          ; case 5: total loss of significance
  br label %cont

sw.case6:                                          ; case 6: partial loss of significance
  br label %cont

sw.default:                                        ; default and case 0: unknown error
  br label %cont

cont:
  %msg.phi = phi i8* [
    getelementptr inbounds ([22 x i8], [22 x i8]* @aArgumentDomain, i64 0, i64 0), %sw.case1
  ], [
    getelementptr inbounds ([21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0), %sw.case2
  ], [
    getelementptr inbounds ([21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0), %sw.case3
  ], [
    getelementptr inbounds ([24 x i8], [24 x i8]* @aTheResultIsToo, i64 0, i64 0), %sw.case4
  ], [
    getelementptr inbounds ([27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0), %sw.case5
  ], [
    getelementptr inbounds ([29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0), %sw.case6
  ], [
    getelementptr inbounds ([14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0), %sw.default
  ]

  %fn.ptr.addr = getelementptr inbounds i8, i8* %rcx.ptr, i64 8
  %fn.ptr.ptr = bitcast i8* %fn.ptr.addr to i8**
  %fn.ptr = load i8*, i8** %fn.ptr.ptr, align 8

  %arg1.addr = getelementptr inbounds i8, i8* %rcx.ptr, i64 16
  %arg1.ptr = bitcast i8* %arg1.addr to double*
  %arg1 = load double, double* %arg1.ptr, align 8

  %arg2.addr = getelementptr inbounds i8, i8* %rcx.ptr, i64 24
  %arg2.ptr = bitcast i8* %arg2.addr to double*
  %arg2 = load double, double* %arg2.ptr, align 8

  %arg3.addr = getelementptr inbounds i8, i8* %rcx.ptr, i64 32
  %arg3.ptr = bitcast i8* %arg3.addr to double*
  %arg3 = load double, double* %arg3.ptr, align 8

  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt.ptr = getelementptr inbounds ([43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0)
  %call = call i32 @sub_1400029C0(i8* %stream, i8* %fmt.ptr, i8* %msg.phi, i8* %fn.ptr, double %arg1, double %arg2, double %arg3)
  ret i32 0
}