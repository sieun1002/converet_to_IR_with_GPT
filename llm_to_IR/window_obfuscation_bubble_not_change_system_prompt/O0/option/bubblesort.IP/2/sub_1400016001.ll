; ModuleID = 'sub_140001600'
target triple = "x86_64-pc-windows-msvc"

declare i8* @loc_140002710(i32)
declare i32 @sub_140002600(i8*, i8*, ...)

@aArgumentSingul = external constant i8
@aArgumentDomain = external constant i8
@aPartialLossOfS = external constant i8
@aOverflowRangeE = external constant i8
@aTheResultIsToo = external constant i8
@aTotalLossOfSig = external constant i8
@aUnknownError = external constant i8
@aMatherrSInSGGR = external constant i8

define dso_local i32 @sub_140001600(i8* %rcx) {
entry:
  %tagptr = bitcast i8* %rcx to i32*
  %tag = load i32, i32* %tagptr
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
  br label %cont

sw.case1:                                          ; case 1
  br label %cont

sw.case2:                                          ; case 2
  br label %cont

sw.case3:                                          ; case 3
  br label %cont

sw.case4:                                          ; case 4
  br label %cont

sw.case5:                                          ; case 5
  br label %cont

sw.case6:                                          ; case 6
  br label %cont

sw.default:                                        ; default
  br label %cont

cont:
  %msg = phi i8* [ @aUnknownError, %sw.case0 ], [ @aArgumentDomain, %sw.case1 ], [ @aArgumentSingul, %sw.case2 ], [ @aOverflowRangeE, %sw.case3 ], [ @aTheResultIsToo, %sw.case4 ], [ @aTotalLossOfSig, %sw.case5 ], [ @aPartialLossOfS, %sw.case6 ], [ @aUnknownError, %sw.default ]
  %ptr8 = getelementptr i8, i8* %rcx, i64 8
  %p_rsi_ptr = bitcast i8* %ptr8 to i8**
  %p_rsi = load i8*, i8** %p_rsi_ptr
  %ptr16 = getelementptr i8, i8* %rcx, i64 16
  %d1ptr = bitcast i8* %ptr16 to double*
  %d1 = load double, double* %d1ptr
  %ptr24 = getelementptr i8, i8* %rcx, i64 24
  %d2ptr = bitcast i8* %ptr24 to double*
  %d2 = load double, double* %d2ptr
  %ptr32 = getelementptr i8, i8* %rcx, i64 32
  %d3ptr = bitcast i8* %ptr32 to double*
  %d3 = load double, double* %d3ptr
  %retbuf = call i8* @loc_140002710(i32 2)
  %call = call i32 (i8*, i8*, ...) @sub_140002600(i8* %retbuf, i8* @aMatherrSInSGGR, i8* %msg, i8* %p_rsi, double %d1, double %d2, double %d3)
  ret i32 0
}