; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

; extern data (addresses taken)
@aArgumentSingul = external dso_local global i8
@aMatherrSInSGGR = external dso_local global i8
@aArgumentDomain = external dso_local global i8
@aPartialLossOfS = external dso_local global i8
@aOverflowRangeE = external dso_local global i8
@aTheResultIsToo = external dso_local global i8
@aTotalLossOfSig = external dso_local global i8
@aUnknownError    = external dso_local global i8

; extern functions referenced
declare dso_local i8* @sub_140002710(i32 noundef)
declare dso_local i32 @sub_140002600(i8* noundef, i8* noundef, i8* noundef, i8* noundef, ...)

define dso_local void @sub_140001600(i8* noundef %rcx) {
entry:
  %code.ptr = bitcast i8* %rcx to i32*
  %code = load i32, i32* %code.ptr, align 4
  br label %sw.dispatch

sw.dispatch:
  switch i32 %code, label %sw.default [
    i32 0, label %sw.default
    i32 1, label %sw.case1
    i32 2, label %sw.case2
    i32 3, label %sw.case3
    i32 4, label %sw.case4
    i32 5, label %sw.case5
    i32 6, label %sw.case6
  ]

sw.case2:  ; case 2: aArgumentSingul
  br label %select.join

sw.case1:  ; case 1: aArgumentDomain
  br label %select.join

sw.case6:  ; case 6: aPartialLossOfS
  br label %select.join

sw.case3:  ; case 3: aOverflowRangeE
  br label %select.join

sw.case4:  ; case 4: aTheResultIsToo
  br label %select.join

sw.case5:  ; case 5: aTotalLossOfSig
  br label %select.join

sw.default: ; default and case 0: aUnknownError
  br label %select.join

select.join:
  %msg.ptr = phi i8* [ @aArgumentSingul, %sw.case2 ],
                     [ @aArgumentDomain, %sw.case1 ],
                     [ @aPartialLossOfS, %sw.case6 ],
                     [ @aOverflowRangeE, %sw.case3 ],
                     [ @aTheResultIsToo, %sw.case4 ],
                     [ @aTotalLossOfSig, %sw.case5 ],
                     [ @aUnknownError,  %sw.default ]
  %p20 = getelementptr inbounds i8, i8* %rcx, i64 32
  %p20d = bitcast i8* %p20 to double*
  %val_ret = load double, double* %p20d, align 8
  %p18 = getelementptr inbounds i8, i8* %rcx, i64 24
  %p18d = bitcast i8* %p18 to double*
  %val_y = load double, double* %p18d, align 8
  %p10 = getelementptr inbounds i8, i8* %rcx, i64 16
  %p10d = bitcast i8* %p10 to double*
  %val_x = load double, double* %p10d, align 8
  %p8 = getelementptr inbounds i8, i8* %rcx, i64 8
  %p8p = bitcast i8* %p8 to i8**
  %funcname = load i8*, i8** %p8p, align 8
  %call2710 = call i8* @sub_140002710(i32 noundef 2)
  %fmt = bitcast i8* @aMatherrSInSGGR to i8*
  %call2600 = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* noundef %call2710, i8* noundef %fmt, i8* noundef %msg.ptr, i8* noundef %funcname, double %val_x, double %val_y, double %val_ret)
  ret void
}