; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002AD0(i32)
declare void @sub_1400029C0(i8*, i8*, i8*, i8*, ...)

@aArgumentSingul = external dso_local global i8
@aArgumentDomain = external dso_local global i8
@aPartialLossOfS = external dso_local global i8
@aOverflowRangeE = external dso_local global i8
@aTheResultIsToo = external dso_local global i8
@aTotalLossOfSig = external dso_local global i8
@aUnknownError = external dso_local global i8
@aMatherrSInSGGR = external dso_local global i8

define dso_local i32 @sub_1400019D0(i8* %p) {
entry:
  %p_i32ptr = bitcast i8* %p to i32*
  %code = load i32, i32* %p_i32ptr, align 4
  %cmp = icmp ugt i32 %code, 6
  br i1 %cmp, label %def, label %switch

switch:                                           ; preds = %entry
  switch i32 %code, label %def [
    i32 0, label %case0
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case0:                                            ; preds = %switch
  br label %cont

case1:                                            ; preds = %switch
  br label %cont

case2:                                            ; preds = %switch
  br label %cont

case3:                                            ; preds = %switch
  br label %cont

case4:                                            ; preds = %switch
  br label %cont

case5:                                            ; preds = %switch
  br label %cont

case6:                                            ; preds = %switch
  br label %cont

def:                                              ; preds = %switch, %entry
  br label %cont

cont:                                             ; preds = %def, %case6, %case5, %case4, %case3, %case2, %case1, %case0
  %msg = phi i8* [ @aUnknownError, %def ],
               [ @aUnknownError, %case0 ],
               [ @aArgumentDomain, %case1 ],
               [ @aArgumentSingul, %case2 ],
               [ @aOverflowRangeE, %case3 ],
               [ @aTheResultIsToo, %case4 ],
               [ @aTotalLossOfSig, %case5 ],
               [ @aPartialLossOfS, %case6 ]
  %p_name_ptr = getelementptr inbounds i8, i8* %p, i64 8
  %p_name_pp = bitcast i8* %p_name_ptr to i8**
  %name = load i8*, i8** %p_name_pp, align 8
  %p_d6_ptrb = getelementptr inbounds i8, i8* %p, i64 16
  %p_d6_ptr = bitcast i8* %p_d6_ptrb to double*
  %d6 = load double, double* %p_d6_ptr, align 8
  %p_d7_ptrb = getelementptr inbounds i8, i8* %p, i64 24
  %p_d7_ptr = bitcast i8* %p_d7_ptrb to double*
  %d7 = load double, double* %p_d7_ptr, align 8
  %p_d8_ptrb = getelementptr inbounds i8, i8* %p, i64 32
  %p_d8_ptr = bitcast i8* %p_d8_ptrb to double*
  %d8 = load double, double* %p_d8_ptr, align 8
  %ctx = call i8* @sub_140002AD0(i32 2)
  call void (i8*, i8*, i8*, i8*, ...) @sub_1400029C0(i8* %ctx, i8* @aMatherrSInSGGR, i8* %msg, i8* %name, double %d6, double %d7, double %d8)
  ret i32 0
}