; Target: Windows x64 MSVC
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = external constant i8
@aArgumentDomain = external constant i8
@aPartialLossOfS = external constant i8
@aOverflowRangeE = external constant i8
@aTheResultIsToo = external constant i8
@aTotalLossOfSig = external constant i8
@aUnknownError = external constant i8
@aMatherrSInSGGR = external constant i8

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*, i8*, i8*, ...)

define void @sub_140001600(i8* %rcx) {
entry:
  %cmp_ptr = bitcast i8* %rcx to i32*
  %val = load i32, i32* %cmp_ptr, align 4
  switch i32 %val, label %bb_default [
    i32 1, label %bb_case1
    i32 2, label %bb_case2
    i32 3, label %bb_case3
    i32 4, label %bb_case4
    i32 5, label %bb_case5
    i32 6, label %bb_case6
  ]

bb_case1:
  br label %merge

bb_case2:
  br label %merge

bb_case3:
  br label %merge

bb_case4:
  br label %merge

bb_case5:
  br label %merge

bb_case6:
  br label %merge

bb_default:
  br label %merge

merge:
  %sel = phi i8* [ @aArgumentDomain, %bb_case1 ],
                 [ @aArgumentSingul, %bb_case2 ],
                 [ @aOverflowRangeE, %bb_case3 ],
                 [ @aTheResultIsToo, %bb_case4 ],
                 [ @aTotalLossOfSig, %bb_case5 ],
                 [ @aPartialLossOfS, %bb_case6 ],
                 [ @aUnknownError, %bb_default ]
  %p_funcname_ptr = getelementptr i8, i8* %rcx, i64 8
  %funcname_pp = bitcast i8* %p_funcname_ptr to i8**
  %funcname = load i8*, i8** %funcname_pp, align 8
  %p_x6 = getelementptr i8, i8* %rcx, i64 16
  %x6p = bitcast i8* %p_x6 to double*
  %x6 = load double, double* %x6p, align 8
  %p_x7 = getelementptr i8, i8* %rcx, i64 24
  %x7p = bitcast i8* %p_x7 to double*
  %x7 = load double, double* %x7p, align 8
  %p_x8 = getelementptr i8, i8* %rcx, i64 32
  %x8p = bitcast i8* %p_x8 to double*
  %x8 = load double, double* %x8p, align 8
  %r = call i8* @sub_140002710(i32 2)
  call void (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* %r, i8* @aMatherrSInSGGR, i8* %sel, i8* %funcname, double %x6, double %x7, double %x8)
  ret void
}