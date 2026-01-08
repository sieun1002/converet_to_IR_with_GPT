; ModuleID = 'sub_140001600'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002710(i32 noundef)

@aArgumentSingul = external constant i8
@aArgumentDomain = external constant i8
@aPartialLossOfS = external constant i8
@aOverflowRangeE = external constant i8
@aTheResultIsToo = external constant i8
@aTotalLossOfSig = external constant i8
@aUnknownError = external constant i8

define void @sub_140001600(i8* noundef %rcx) {
entry:
  %t0 = bitcast i8* %rcx to i32*
  %t1 = load i32, i32* %t0, align 4
  switch i32 %t1, label %sw.unknown [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case2:                                          ; case 2
  br label %cont

sw.case1:                                          ; case 1
  br label %cont

sw.case6:                                          ; case 6
  br label %cont

sw.case3:                                          ; case 3
  br label %cont

sw.case4:                                          ; case 4
  br label %cont

sw.case5:                                          ; case 5
  br label %cont

sw.unknown:                                        ; default and case 0
  br label %cont

cont:
  %msg = phi i8* [ @aArgumentSingul, %sw.case2 ],
                 [ @aArgumentDomain, %sw.case1 ],
                 [ @aPartialLossOfS, %sw.case6 ],
                 [ @aOverflowRangeE, %sw.case3 ],
                 [ @aTheResultIsToo, %sw.case4 ],
                 [ @aTotalLossOfSig, %sw.case5 ],
                 [ @aUnknownError, %sw.unknown ]
  %t2 = getelementptr i8, i8* %rcx, i64 8
  %t3 = bitcast i8* %t2 to i8**
  %t4 = load i8*, i8** %t3, align 8
  %t5 = getelementptr i8, i8* %rcx, i64 16
  %t6 = bitcast i8* %t5 to double*
  %t7 = load double, double* %t6, align 8
  %t8 = getelementptr i8, i8* %rcx, i64 24
  %t9 = bitcast i8* %t8 to double*
  %t10 = load double, double* %t9, align 8
  %t11 = getelementptr i8, i8* %rcx, i64 32
  %t12 = bitcast i8* %t11 to double*
  %t13 = load double, double* %t12, align 8
  call void @sub_140002710(i32 noundef 2)
  ret void
}