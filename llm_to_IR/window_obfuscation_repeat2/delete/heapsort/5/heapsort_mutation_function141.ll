; ModuleID = 'recovered'
source_filename = "recovered.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@aArgumentDomain = private unnamed_addr constant [22 x i8] c"argument domain error\00", align 1
@aPartialLossOfS = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@aOverflowRangeE = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@aTheResultIsToo = private unnamed_addr constant [24 x i8] c"the result is too small\00", align 1
@aTotalLossOfSig = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@aUnknownError   = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1
@aMatherrSInSGGR = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_1400029C0(i8*, i8*, ...)

define dso_local i32 @sub_1400019D0(i8* %rcx) {
entry:
  %typeptr = bitcast i8* %rcx to i32*
  %type = load i32, i32* %typeptr, align 4
  switch i32 %type, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case1:                                           ; case 1 -> aArgumentDomain
  br label %select.end

sw.case2:                                           ; case 2 -> aArgumentSingul
  br label %select.end

sw.case3:                                           ; case 3 -> aOverflowRangeE
  br label %select.end

sw.case4:                                           ; case 4 -> aTheResultIsToo
  br label %select.end

sw.case5:                                           ; case 5 -> aTotalLossOfSig
  br label %select.end

sw.case6:                                           ; case 6 -> aPartialLossOfS
  br label %select.end

sw.default:                                         ; default and case 0 -> aUnknownError
  br label %select.end

select.end:
  %msg = phi i8* [ bitcast ([22 x i8]* @aArgumentDomain to i8*), %sw.case1 ],
                 [ bitcast ([21 x i8]* @aArgumentSingul to i8*), %sw.case2 ],
                 [ bitcast ([21 x i8]* @aOverflowRangeE to i8*), %sw.case3 ],
                 [ bitcast ([24 x i8]* @aTheResultIsToo to i8*), %sw.case4 ],
                 [ bitcast ([27 x i8]* @aTotalLossOfSig to i8*), %sw.case5 ],
                 [ bitcast ([29 x i8]* @aPartialLossOfS to i8*), %sw.case6 ],
                 [ bitcast ([14 x i8]* @aUnknownError to i8*), %sw.default ]
  %name.ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 8
  %name.pp = bitcast i8* %name.ptr.i8 to i8**
  %name = load i8*, i8** %name.pp, align 8
  %arg1.ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 16
  %arg1.p = bitcast i8* %arg1.ptr.i8 to double*
  %arg1 = load double, double* %arg1.p, align 8
  %arg2.ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 24
  %arg2.p = bitcast i8* %arg2.ptr.i8 to double*
  %arg2 = load double, double* %arg2.p, align 8
  %retval.ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 32
  %retval.p = bitcast i8* %retval.ptr.i8 to double*
  %retval = load double, double* %retval.p, align 8
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt = bitcast [43 x i8]* @aMatherrSInSGGR to i8*
  %call = call i32 (i8*, i8*, ...) @sub_1400029C0(i8* %stream, i8* %fmt, i8* %msg, i8* %name, double %retval, double %arg2, double %arg1)
  ret i32 0
}