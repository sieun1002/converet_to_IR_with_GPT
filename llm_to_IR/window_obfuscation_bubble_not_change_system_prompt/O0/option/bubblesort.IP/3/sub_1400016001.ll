; ModuleID = 'sub_140001600'
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = external global i8
@aArgumentDomain = external global i8
@aPartialLossOfS = external global i8
@aOverflowRangeE = external global i8
@aTheResultIsToo = external global i8
@aTotalLossOfSig = external global i8
@aUnknownError = external global i8
@aMatherrSInSGGR = external global i8

declare i8* @loc_140002710(i32)
declare i32 @sub_140002600(i8*, i8*, ...)

define i32 @sub_140001600(i8* %rcx) local_unnamed_addr {
entry:
  %type.ptr = bitcast i8* %rcx to i32*
  %type = load i32, i32* %type.ptr
  %cmp = icmp ugt i32 %type, 6
  br i1 %cmp, label %sw.default, label %sw.range

sw.range:                                         ; preds = %entry
  switch i32 %type, label %sw.default [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case1:                                            ; preds = %sw.range
  br label %cont

case2:                                            ; preds = %sw.range
  br label %cont

case3:                                            ; preds = %sw.range
  br label %cont

case4:                                            ; preds = %sw.range
  br label %cont

case5:                                            ; preds = %sw.range
  br label %cont

case6:                                            ; preds = %sw.range
  br label %cont

sw.default:                                       ; preds = %sw.range, %entry
  br label %cont

cont:                                             ; preds = %sw.default, %case6, %case5, %case4, %case3, %case2, %case1
  %msg = phi i8* [ @aArgumentDomain, %case1 ],
                [ @aArgumentSingul, %case2 ],
                [ @aOverflowRangeE, %case3 ],
                [ @aTheResultIsToo, %case4 ],
                [ @aTotalLossOfSig, %case5 ],
                [ @aPartialLossOfS, %case6 ],
                [ @aUnknownError, %sw.default ]
  %name.ptr.ptr = getelementptr i8, i8* %rcx, i64 8
  %name.ptr.cast = bitcast i8* %name.ptr.ptr to i8**
  %name = load i8*, i8** %name.ptr.cast
  %arg1.ptr = getelementptr i8, i8* %rcx, i64 16
  %arg1.cast = bitcast i8* %arg1.ptr to double*
  %arg1 = load double, double* %arg1.cast
  %arg2.ptr = getelementptr i8, i8* %rcx, i64 24
  %arg2.cast = bitcast i8* %arg2.ptr to double*
  %arg2 = load double, double* %arg2.cast
  %retval.ptr = getelementptr i8, i8* %rcx, i64 32
  %retval.cast = bitcast i8* %retval.ptr to double*
  %retval = load double, double* %retval.cast
  %file = call i8* @loc_140002710(i32 2)
  %call = call i32 (i8*, i8*, ...) @sub_140002600(i8* %file, i8* @aMatherrSInSGGR, i8* %msg, i8* %name, double %arg1, double %arg2, double %retval)
  ret i32 0
}