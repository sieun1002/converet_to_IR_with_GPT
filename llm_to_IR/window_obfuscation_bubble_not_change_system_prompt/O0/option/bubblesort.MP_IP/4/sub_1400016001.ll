; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.MATHERR = type { i32, i32, i8*, double, double, double }

declare i8* @sub_140002710(i32)
declare i32 @sub_140002600(i8*, i8*, i8*, i8*, double, double, double)

@aArgumentSingul   = external constant i8
@aArgumentDomain   = external constant i8
@aPartialLossOfS   = external constant i8
@aOverflowRangeE   = external constant i8
@aTheResultIsToo   = external constant i8
@aTotalLossOfSig   = external constant i8
@aUnknownError     = external constant i8
@aMatherrSInSGGR   = external constant i8

define i32 @sub_140001600(%struct.MATHERR* %rcx) {
entry:
  %type_ptr = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %rcx, i32 0, i32 0
  %type_val = load i32, i32* %type_ptr, align 4
  %cmp = icmp ugt i32 %type_val, 6
  br i1 %cmp, label %sw.default, label %sw.dispatch

sw.dispatch:                                       ; preds = %entry
  switch i32 %type_val, label %sw.case0 [
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
    i32 0, label %sw.case0
  ]

sw.case1:                                          ; preds = %sw.dispatch
  br label %cont

sw.case2:                                          ; preds = %sw.dispatch
  br label %cont

sw.case3:                                          ; preds = %sw.dispatch
  br label %cont

sw.case4:                                          ; preds = %sw.dispatch
  br label %cont

sw.case5:                                          ; preds = %sw.dispatch
  br label %cont

sw.case6:                                          ; preds = %sw.dispatch
  br label %cont

sw.case0:                                          ; preds = %sw.dispatch
  br label %cont

sw.default:                                        ; preds = %entry
  br label %cont

cont:                                              ; preds = %sw.default, %sw.case0, %sw.case6, %sw.case5, %sw.case4, %sw.case3, %sw.case2, %sw.case1
  %msg = phi i8* [ @aArgumentDomain, %sw.case1 ],
                [ @aArgumentSingul, %sw.case2 ],
                [ @aOverflowRangeE, %sw.case3 ],
                [ @aTheResultIsToo, %sw.case4 ],
                [ @aTotalLossOfSig, %sw.case5 ],
                [ @aPartialLossOfS, %sw.case6 ],
                [ @aUnknownError, %sw.case0 ],
                [ @aUnknownError, %sw.default ]
  %fname_ptr = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %rcx, i32 0, i32 2
  %fname = load i8*, i8** %fname_ptr, align 8
  %d10_ptr = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %rcx, i32 0, i32 3
  %d10 = load double, double* %d10_ptr, align 8
  %d18_ptr = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %rcx, i32 0, i32 4
  %d18 = load double, double* %d18_ptr, align 8
  %d20_ptr = getelementptr inbounds %struct.MATHERR, %struct.MATHERR* %rcx, i32 0, i32 5
  %d20 = load double, double* %d20_ptr, align 8
  %t = call i8* @sub_140002710(i32 2)
  %call = call i32 @sub_140002600(i8* %t, i8* @aMatherrSInSGGR, i8* %msg, i8* %fname, double %d20, double %d18, double %d10)
  ret i32 0
}