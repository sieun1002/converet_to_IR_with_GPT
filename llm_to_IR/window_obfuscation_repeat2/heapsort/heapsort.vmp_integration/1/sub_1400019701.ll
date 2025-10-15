; ModuleID = 'sub_140001970_module'
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = private unnamed_addr constant [21 x i8] c"argument singularity\00", align 1
@aArgumentDomain = private unnamed_addr constant [16 x i8] c"argument domain\00", align 1
@aPartialLossOfS = private unnamed_addr constant [29 x i8] c"partial loss of significance\00", align 1
@aOverflowRangeE = private unnamed_addr constant [21 x i8] c"overflow range error\00", align 1
@aTheResultIsToo = private unnamed_addr constant [24 x i8] c"The result is too small\00", align 1
@aTotalLossOfSig = private unnamed_addr constant [27 x i8] c"total loss of significance\00", align 1
@aUnknownError = private unnamed_addr constant [14 x i8] c"unknown error\00", align 1
@aMatherrSInSGGR = private unnamed_addr constant [43 x i8] c"_matherr(): %s in %s(%g, %g)  (retval=%g)\0A\00", align 1

declare i8* @sub_140002A70(i32)
declare i32 @sub_140002960(i8*, i8*, i8*, i8*, ...)

define i32 @sub_140001970(i8* %rcx) {
entry:
  %valptr = bitcast i8* %rcx to i32*
  %val = load i32, i32* %valptr, align 4
  switch i32 %val, label %sw.default [
    i32 0, label %sw.default
    i32 1, label %sw.bb1
    i32 2, label %sw.bb2
    i32 3, label %sw.bb3
    i32 4, label %sw.bb4
    i32 5, label %sw.bb5
    i32 6, label %sw.bb6
  ]

sw.bb1:                                            ; case 1
  br label %cont

sw.bb2:                                            ; case 2
  br label %cont

sw.bb3:                                            ; case 3
  br label %cont

sw.bb4:                                            ; case 4
  br label %cont

sw.bb5:                                            ; case 5
  br label %cont

sw.bb6:                                            ; case 6
  br label %cont

sw.default:                                        ; default and case 0
  br label %cont

cont:
  %msg = phi i8* [ getelementptr inbounds ([16 x i8], [16 x i8]* @aArgumentDomain, i64 0, i64 0), %sw.bb1 ],
                 [ getelementptr inbounds ([21 x i8], [21 x i8]* @aArgumentSingul, i64 0, i64 0), %sw.bb2 ],
                 [ getelementptr inbounds ([21 x i8], [21 x i8]* @aOverflowRangeE, i64 0, i64 0), %sw.bb3 ],
                 [ getelementptr inbounds ([24 x i8], [24 x i8]* @aTheResultIsToo, i64 0, i64 0), %sw.bb4 ],
                 [ getelementptr inbounds ([27 x i8], [27 x i8]* @aTotalLossOfSig, i64 0, i64 0), %sw.bb5 ],
                 [ getelementptr inbounds ([29 x i8], [29 x i8]* @aPartialLossOfS, i64 0, i64 0), %sw.bb6 ],
                 [ getelementptr inbounds ([14 x i8], [14 x i8]* @aUnknownError, i64 0, i64 0), %sw.default ]
  %fnptr.addr = getelementptr inbounds i8, i8* %rcx, i64 8
  %fnptr.ptr = bitcast i8* %fnptr.addr to i8**
  %fn = load i8*, i8** %fnptr.ptr, align 8
  %x6.addr0 = getelementptr inbounds i8, i8* %rcx, i64 16
  %x6.ptr = bitcast i8* %x6.addr0 to double*
  %x6 = load double, double* %x6.ptr, align 8
  %x7.addr0 = getelementptr inbounds i8, i8* %rcx, i64 24
  %x7.ptr = bitcast i8* %x7.addr0 to double*
  %x7 = load double, double* %x7.ptr, align 8
  %x8.addr0 = getelementptr inbounds i8, i8* %rcx, i64 32
  %x8.ptr = bitcast i8* %x8.addr0 to double*
  %x8 = load double, double* %x8.ptr, align 8
  %stream = call i8* @sub_140002A70(i32 2)
  %fmt = getelementptr inbounds [43 x i8], [43 x i8]* @aMatherrSInSGGR, i64 0, i64 0
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002960(i8* %stream, i8* %fmt, i8* %msg, i8* %fn, double %x6, double %x7, double %x8)
  ret i32 0
}