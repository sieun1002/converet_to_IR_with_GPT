; ModuleID = 'sub_140001600'
target triple = "x86_64-pc-windows-msvc"

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_140002600(i8*, i8*, ...)

@aArgumentSingul = external constant i8
@aMatherrSInSGGR = external constant i8
@aArgumentDomain = external constant i8
@aPartialLossOfS = external constant i8
@aOverflowRangeE = external constant i8
@aTheResultIsToo = external constant i8
@aTotalLossOfSig = external constant i8
@aUnknownError = external constant i8

define dso_local i32 @sub_140001600(i8* %rcx) {
entry:
  %tagptr = bitcast i8* %rcx to i32*
  %tag = load i32, i32* %tagptr, align 4
  switch i32 %tag, label %sw.default [
    i32 0, label %sw.case0
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case0:                                          ; case 0
  br label %join

sw.case1:                                          ; case 1
  br label %join

sw.case2:                                          ; case 2
  br label %join

sw.case3:                                          ; case 3
  br label %join

sw.case4:                                          ; case 4
  br label %join

sw.case5:                                          ; case 5
  br label %join

sw.case6:                                          ; case 6
  br label %join

sw.default:                                        ; default
  br label %join

join:
  %errstr = phi i8* [ @aUnknownError, %sw.case0 ],
                   [ @aArgumentDomain, %sw.case1 ],
                   [ @aArgumentSingul, %sw.case2 ],
                   [ @aOverflowRangeE, %sw.case3 ],
                   [ @aTheResultIsToo, %sw.case4 ],
                   [ @aTotalLossOfSig, %sw.case5 ],
                   [ @aPartialLossOfS, %sw.case6 ],
                   [ @aUnknownError, %sw.default ]

  %fnptr.addr.i8 = getelementptr inbounds i8, i8* %rcx, i64 8
  %fnptr.ptr = bitcast i8* %fnptr.addr.i8 to i8**
  %fnptr = load i8*, i8** %fnptr.ptr, align 8

  %d1.addr.i8 = getelementptr inbounds i8, i8* %rcx, i64 16
  %d1.ptr = bitcast i8* %d1.addr.i8 to double*
  %d1 = load double, double* %d1.ptr, align 8

  %d2.addr.i8 = getelementptr inbounds i8, i8* %rcx, i64 24
  %d2.ptr = bitcast i8* %d2.addr.i8 to double*
  %d2 = load double, double* %d2.ptr, align 8

  %d3.addr.i8 = getelementptr inbounds i8, i8* %rcx, i64 32
  %d3.ptr = bitcast i8* %d3.addr.i8 to double*
  %d3 = load double, double* %d3.ptr, align 8

  %stream = call i8* @__acrt_iob_func(i32 2)
  %call = call i32 (i8*, i8*, ...) @sub_140002600(i8* %stream, i8* @aMatherrSInSGGR, i8* %errstr, i8* %fnptr, double %d1, double %d2, double %d3)
  ret i32 0
}