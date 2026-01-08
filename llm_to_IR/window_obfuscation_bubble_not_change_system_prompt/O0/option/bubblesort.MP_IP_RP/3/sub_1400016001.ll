; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002710(i32, ...)

@aArgumentSingul = external constant i8
@aArgumentDomain = external constant i8
@aPartialLossOfS = external constant i8
@aOverflowRangeE = external constant i8
@aTheResultIsToo = external constant i8
@aTotalLossOfSig = external constant i8
@aUnknownError = external constant i8

define void @sub_140001600(i8* %rcx) {
entry:
  %rcx_i32ptr = bitcast i8* %rcx to i32*
  %switchval = load i32, i32* %rcx_i32ptr, align 4
  switch i32 %switchval, label %sw.default [
    i32 1, label %sw.bb1
    i32 2, label %sw.bb2
    i32 3, label %sw.bb3
    i32 4, label %sw.bb4
    i32 5, label %sw.bb5
    i32 6, label %sw.bb6
  ]

sw.bb2:                                           ; case 2
  br label %common

sw.bb1:                                           ; case 1
  br label %common

sw.bb6:                                           ; case 6
  br label %common

sw.bb3:                                           ; case 3
  br label %common

sw.bb4:                                           ; case 4
  br label %common

sw.bb5:                                           ; case 5
  br label %common

sw.default:                                       ; default (includes case 0 and >6)
  br label %common

common:
  %msg = phi i8* [ @aArgumentSingul, %sw.bb2 ],
               [ @aArgumentDomain, %sw.bb1 ],
               [ @aPartialLossOfS, %sw.bb6 ],
               [ @aOverflowRangeE, %sw.bb3 ],
               [ @aTheResultIsToo, %sw.bb4 ],
               [ @aTotalLossOfSig, %sw.bb5 ],
               [ @aUnknownError, %sw.default ]
  %ptr8 = getelementptr i8, i8* %rcx, i64 8
  %qword8ptr = bitcast i8* %ptr8 to i64*
  %qword8 = load i64, i64* %qword8ptr, align 8
  %ptr16 = getelementptr i8, i8* %rcx, i64 16
  %dbl16ptr = bitcast i8* %ptr16 to double*
  %dbl16 = load double, double* %dbl16ptr, align 8
  %ptr24 = getelementptr i8, i8* %rcx, i64 24
  %dbl24ptr = bitcast i8* %ptr24 to double*
  %dbl24 = load double, double* %dbl24ptr, align 8
  %ptr32 = getelementptr i8, i8* %rcx, i64 32
  %dbl32ptr = bitcast i8* %ptr32 to double*
  %dbl32 = load double, double* %dbl32ptr, align 8
  call void (i32, ...) @sub_140002710(i32 2)
  ret void
}