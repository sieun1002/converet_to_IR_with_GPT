; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i8* @loc_140002710(i32)
declare i32 @sub_140002600(i8*, i8*, i8*, i8*, ...)

@aArgumentSingul = external constant i8
@aArgumentDomain = external constant i8
@aPartialLossOfS = external constant i8
@aOverflowRangeE = external constant i8
@aTheResultIsToo = external constant i8
@aTotalLossOfSig = external constant i8
@aUnknownError    = external constant i8
@aMatherrSInSGGR  = external constant i8

define i32 @sub_140001600(i8* %0) {
entry:
  %1 = bitcast i8* %0 to i32*
  %2 = load i32, i32* %1, align 4
  switch i32 %2, label %sw.default [
    i32 1, label %sw.bb1
    i32 2, label %sw.bb2
    i32 3, label %sw.bb3
    i32 4, label %sw.bb4
    i32 5, label %sw.bb5
    i32 6, label %sw.bb6
  ]

sw.bb1:                                           ; case 1
  br label %select

sw.bb2:                                           ; case 2
  br label %select

sw.bb3:                                           ; case 3
  br label %select

sw.bb4:                                           ; case 4
  br label %select

sw.bb5:                                           ; case 5
  br label %select

sw.bb6:                                           ; case 6
  br label %select

sw.default:                                       ; case 0 and default
  br label %select

select:
  %3 = phi i8* [ @aArgumentDomain, %sw.bb1 ],
               [ @aArgumentSingul, %sw.bb2 ],
               [ @aOverflowRangeE, %sw.bb3 ],
               [ @aTheResultIsToo, %sw.bb4 ],
               [ @aTotalLossOfSig, %sw.bb5 ],
               [ @aPartialLossOfS, %sw.bb6 ],
               [ @aUnknownError,  %sw.default ]
  %4 = getelementptr inbounds i8, i8* %0, i64 8
  %5 = bitcast i8* %4 to i8**
  %6 = load i8*, i8** %5, align 8
  %7 = getelementptr inbounds i8, i8* %0, i64 16
  %8 = bitcast i8* %7 to double*
  %9 = load double, double* %8, align 8
  %10 = getelementptr inbounds i8, i8* %0, i64 24
  %11 = bitcast i8* %10 to double*
  %12 = load double, double* %11, align 8
  %13 = getelementptr inbounds i8, i8* %0, i64 32
  %14 = bitcast i8* %13 to double*
  %15 = load double, double* %14, align 8
  %16 = call i8* @loc_140002710(i32 2)
  %17 = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* %16, i8* @aMatherrSInSGGR, i8* %3, i8* %6, double %9, double %12, double %15)
  ret i32 0
}