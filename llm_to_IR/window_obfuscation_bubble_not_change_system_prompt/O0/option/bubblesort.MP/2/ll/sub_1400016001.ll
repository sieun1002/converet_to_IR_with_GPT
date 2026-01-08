target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002710(i32)
declare i32 @sub_140002600(i8*, i8*, i8*, i8*, ...)

@aArgumentSingul = external global i8
@aArgumentDomain = external global i8
@aPartialLossOfS = external global i8
@aOverflowRangeE = external global i8
@aTheResultIsToo = external global i8
@aTotalLossOfSig = external global i8
@aUnknownError = external global i8
@aMatherrSInSGGR = external global i8

define i32 @sub_140001600(i8* %0) {
entry:
  %1 = bitcast i8* %0 to i32*
  %2 = load i32, i32* %1, align 4
  switch i32 %2, label %case0_or_default [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case2:
  br label %common.msg.arg_singul

case1:
  br label %common.msg_arg_domain

case6:
  br label %common.msg_partial_loss

case3:
  br label %common.msg_overflow

case4:
  br label %common.msg_result_too

case5:
  br label %common.msg_total_loss

case0_or_default:
  br label %common.msg_unknown

common.msg.arg_singul:
  br label %common

common.msg_arg_domain:
  br label %common

common.msg_partial_loss:
  br label %common

common.msg_overflow:
  br label %common

common.msg_result_too:
  br label %common

common.msg_total_loss:
  br label %common

common.msg_unknown:
  br label %common

common:
  %3 = phi i8* [ @aArgumentSingul, %common.msg.arg_singul ],
               [ @aArgumentDomain, %common.msg_arg_domain ],
               [ @aPartialLossOfS, %common.msg_partial_loss ],
               [ @aOverflowRangeE, %common.msg_overflow ],
               [ @aTheResultIsToo, %common.msg_result_too ],
               [ @aTotalLossOfSig, %common.msg_total_loss ],
               [ @aUnknownError, %common.msg_unknown ]
  %4 = getelementptr i8, i8* %0, i64 8
  %5 = bitcast i8* %4 to i8**
  %6 = load i8*, i8** %5, align 8
  %7 = getelementptr i8, i8* %0, i64 16
  %8 = bitcast i8* %7 to double*
  %9 = load double, double* %8, align 8
  %10 = getelementptr i8, i8* %0, i64 24
  %11 = bitcast i8* %10 to double*
  %12 = load double, double* %11, align 8
  %13 = getelementptr i8, i8* %0, i64 32
  %14 = bitcast i8* %13 to double*
  %15 = load double, double* %14, align 8
  %16 = call i8* @sub_140002710(i32 2)
  %17 = call i32 (i8*, i8*, i8*, i8*, ...) @sub_140002600(i8* %16, i8* @aMatherrSInSGGR, i8* %3, i8* %6, double %9, double %12, double %15)
  ret i32 0
}