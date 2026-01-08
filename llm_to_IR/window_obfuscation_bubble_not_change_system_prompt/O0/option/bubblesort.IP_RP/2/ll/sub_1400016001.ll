; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@aArgumentSingul = external global i8
@aArgumentDomain = external global i8
@aPartialLossOfS = external global i8
@aOverflowRangeE = external global i8
@aTheResultIsToo = external global i8
@aTotalLossOfSig = external global i8
@aUnknownError = external global i8
@aMatherrSInSGGR = external global i8

declare i8* @sub_140002710(i32)
declare i32 @sub_140002600(i8*, i8*, ...)

define void @sub_140001600(i8* %rcx_param) {
entry:
  %tagptr = bitcast i8* %rcx_param to i32*
  %tag = load i32, i32* %tagptr, align 4
  switch i32 %tag, label %case_default [
    i32 1, label %case_1
    i32 2, label %case_2
    i32 3, label %case_3
    i32 4, label %case_4
    i32 5, label %case_5
    i32 6, label %case_6
  ]

case_2:                                             ; case 2 -> aArgumentSingul
  br label %select_done

case_1:                                             ; case 1 -> aArgumentDomain
  br label %select_done

case_6:                                             ; case 6 -> aPartialLossOfS
  br label %select_done

case_3:                                             ; case 3 -> aOverflowRangeE
  br label %select_done

case_4:                                             ; case 4 -> aTheResultIsToo
  br label %select_done

case_5:                                             ; case 5 -> aTotalLossOfSig
  br label %select_done

case_default:                                       ; default (and case 0) -> aUnknownError
  br label %select_done

select_done:
  %msg = phi i8* [ @aArgumentSingul, %case_2 ], [ @aArgumentDomain, %case_1 ], [ @aPartialLossOfS, %case_6 ], [ @aOverflowRangeE, %case_3 ], [ @aTheResultIsToo, %case_4 ], [ @aTotalLossOfSig, %case_5 ], [ @aUnknownError, %case_default ]
  %p8 = getelementptr inbounds i8, i8* %rcx_param, i64 8
  %p8_as_ptrptr = bitcast i8* %p8 to i8**
  %sname = load i8*, i8** %p8_as_ptrptr, align 8
  %p16 = getelementptr inbounds i8, i8* %rcx_param, i64 16
  %p16_as_d = bitcast i8* %p16 to double*
  %d0 = load double, double* %p16_as_d, align 8
  %p24 = getelementptr inbounds i8, i8* %rcx_param, i64 24
  %p24_as_d = bitcast i8* %p24 to double*
  %d1 = load double, double* %p24_as_d, align 8
  %p32 = getelementptr inbounds i8, i8* %rcx_param, i64 32
  %p32_as_d = bitcast i8* %p32 to double*
  %d2 = load double, double* %p32_as_d, align 8
  %ctx = call i8* @sub_140002710(i32 2)
  %call = call i32 (i8*, i8*, ...) @sub_140002600(i8* %ctx, i8* @aMatherrSInSGGR, i8* %msg, i8* %sname, double %d0, double %d1, double %d2)
  ret void
}