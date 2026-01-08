target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = external constant i8
@aArgumentDomain = external constant i8
@aPartialLossOfS = external constant i8
@aOverflowRangeE = external constant i8
@aTheResultIsToo = external constant i8
@aTotalLossOfSig = external constant i8
@aUnknownError = external constant i8

declare void @sub_140002710(i32)

define void @sub_140001600(i8* %rcx) {
entry:
  %rcx_i32 = bitcast i8* %rcx to i32*
  %sel = load i32, i32* %rcx_i32, align 4
  switch i32 %sel, label %def [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case2:
  br label %join

case1:
  br label %join

case6:
  br label %join

case3:
  br label %join

case4:
  br label %join

case5:
  br label %join

def:
  br label %join

join:
  %rbxptr = phi i8* [ @aArgumentSingul, %case2 ], [ @aArgumentDomain, %case1 ], [ @aPartialLossOfS, %case6 ], [ @aOverflowRangeE, %case3 ], [ @aTheResultIsToo, %case4 ], [ @aTotalLossOfSig, %case5 ], [ @aUnknownError, %def ]
  %p20 = getelementptr i8, i8* %rcx, i64 32
  %p20d = bitcast i8* %p20 to double*
  %xmm8v = load double, double* %p20d, align 8
  %p18 = getelementptr i8, i8* %rcx, i64 24
  %p18d = bitcast i8* %p18 to double*
  %xmm7v = load double, double* %p18d, align 8
  %p10 = getelementptr i8, i8* %rcx, i64 16
  %p10d = bitcast i8* %p10 to double*
  %xmm6v = load double, double* %p10d, align 8
  %p8 = getelementptr i8, i8* %rcx, i64 8
  %p8q = bitcast i8* %p8 to i8**
  %rsi = load i8*, i8** %p8q, align 8
  call void @sub_140002710(i32 2)
  ret void
}