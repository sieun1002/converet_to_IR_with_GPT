; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*, i8*, i8*, double, double, double)

@aArgumentSingul = external constant i8
@aMatherrSInSGGR = external constant i8
@aArgumentDomain = external constant i8
@aPartialLossOfS = external constant i8
@aOverflowRangeE = external constant i8
@aTheResultIsToo = external constant i8
@aTotalLossOfSig = external constant i8
@aUnknownError = external constant i8

define i32 @sub_140001600(i8* %rcx) {
entry:
  %caselptr = bitcast i8* %rcx to i32*
  %caseval = load i32, i32* %caselptr, align 4
  switch i32 %caseval, label %sw.default [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case2:
  br label %sw.epilog

sw.case1:
  br label %sw.epilog

sw.case6:
  br label %sw.epilog

sw.case3:
  br label %sw.epilog

sw.case4:
  br label %sw.epilog

sw.case5:
  br label %sw.epilog

sw.default:
  br label %sw.epilog

sw.epilog:
  %msg = phi i8* [ @aArgumentSingul, %sw.case2 ],
               [ @aArgumentDomain, %sw.case1 ],
               [ @aPartialLossOfS, %sw.case6 ],
               [ @aOverflowRangeE, %sw.case3 ],
               [ @aTheResultIsToo, %sw.case4 ],
               [ @aTotalLossOfSig, %sw.case5 ],
               [ @aUnknownError, %sw.default ]
  %p8 = getelementptr i8, i8* %rcx, i64 8
  %p8pp = bitcast i8* %p8 to i8**
  %rsi = load i8*, i8** %p8pp, align 8
  %p32 = getelementptr i8, i8* %rcx, i64 32
  %p32d = bitcast i8* %p32 to double*
  %x = load double, double* %p32d, align 8
  %p24 = getelementptr i8, i8* %rcx, i64 24
  %p24d = bitcast i8* %p24 to double*
  %y = load double, double* %p24d, align 8
  %p16 = getelementptr i8, i8* %rcx, i64 16
  %p16d = bitcast i8* %p16 to double*
  %retval = load double, double* %p16d, align 8
  %ctx = call i8* @sub_140002710(i32 2)
  call void @sub_140002600(i8* %ctx, i8* @aMatherrSInSGGR, i8* %msg, i8* %rsi, double %x, double %y, double %retval)
  ret i32 0
}