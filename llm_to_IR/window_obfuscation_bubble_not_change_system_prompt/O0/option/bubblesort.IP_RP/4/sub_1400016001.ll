; ModuleID = 'sub_140001600'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002710(i32)
declare i32 @sub_140002600(i8*, i8*, i8*, i8*, ...)

@aArgumentSingul = external constant i8
@aArgumentDomain = external constant i8
@aPartialLossOfS = external constant i8
@aOverflowRangeE = external constant i8
@aTheResultIsToo = external constant i8
@aTotalLossOfSig = external constant i8
@aUnknownError = external constant i8
@aMatherrSInSGGR = external constant i8

define dso_local void @sub_140001600(i8* %0) {
entry:
  %typep = bitcast i8* %0 to i32*
  %type = load i32, i32* %typep, align 4
  switch i32 %type, label %sw.default [
    i32 0, label %sw.default
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case2:                                            ; case 2
  %p_case2 = getelementptr i8, i8* @aArgumentSingul, i64 0
  br label %select

case1:                                            ; case 1
  %p_case1 = getelementptr i8, i8* @aArgumentDomain, i64 0
  br label %select

case6:                                            ; case 6
  %p_case6 = getelementptr i8, i8* @aPartialLossOfS, i64 0
  br label %select

case3:                                            ; case 3
  %p_case3 = getelementptr i8, i8* @aOverflowRangeE, i64 0
  br label %select

case4:                                            ; case 4
  %p_case4 = getelementptr i8, i8* @aTheResultIsToo, i64 0
  br label %select

case5:                                            ; case 5
  %p_case5 = getelementptr i8, i8* @aTotalLossOfSig, i64 0
  br label %select

sw.default:                                       ; default and case 0
  %p_default = getelementptr i8, i8* @aUnknownError, i64 0
  br label %select

select:
  %msg = phi i8* [ %p_case2, %case2 ], [ %p_case1, %case1 ], [ %p_case6, %case6 ], [ %p_case3, %case3 ], [ %p_case4, %case4 ], [ %p_case5, %case5 ], [ %p_default, %sw.default ]
  %fn_ptr_addr = getelementptr i8, i8* %0, i64 8
  %fn_ptr_ptr = bitcast i8* %fn_ptr_addr to i8**
  %fn = load i8*, i8** %fn_ptr_ptr, align 8
  %a1_addr = getelementptr i8, i8* %0, i64 16
  %a1_ptr = bitcast i8* %a1_addr to double*
  %a1 = load double, double* %a1_ptr, align 8
  %a2_addr = getelementptr i8, i8* %0, i64 24
  %a2_ptr = bitcast i8* %a2_addr to double*
  %a2 = load double, double* %a2_ptr, align 8
  %ret_addr = getelementptr i8, i8* %0, i64 32
  %ret_ptr = bitcast i8* %ret_addr to double*
  %retval = load double, double* %ret_ptr, align 8
  %fmt = getelementptr i8, i8* @aMatherrSInSGGR, i64 0
  %fh = call i8* @sub_140002710(i32 2)
  %call = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* %fh, i8* %fmt, i8* %msg, i8* %fn, double %a1, double %a2, double %retval)
  ret void
}