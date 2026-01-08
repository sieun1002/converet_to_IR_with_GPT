; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002710(i32) noreturn

@aArgumentSingul = external global i8
@aArgumentDomain = external global i8
@aPartialLossOfS = external global i8
@aOverflowRangeE = external global i8
@aTheResultIsToo = external global i8
@aTotalLossOfSig = external global i8
@aUnknownError = external global i8

define void @sub_140001600(i8* %rcx) {
entry:
  %p_dword = bitcast i8* %rcx to i32*
  %v = load i32, i32* %p_dword, align 4
  br label %sw

sw:
  switch i32 %v, label %sw.default [
    i32 1, label %case1
    i32 2, label %case2
    i32 3, label %case3
    i32 4, label %case4
    i32 5, label %case5
    i32 6, label %case6
  ]

case2:
  %rbx_case2 = getelementptr i8, i8* @aArgumentSingul, i64 0
  br label %common

case1:
  %rbx_case1 = getelementptr i8, i8* @aArgumentDomain, i64 0
  br label %common

case6:
  %rbx_case6 = getelementptr i8, i8* @aPartialLossOfS, i64 0
  br label %common

case3:
  %rbx_case3 = getelementptr i8, i8* @aOverflowRangeE, i64 0
  br label %common

case4:
  %rbx_case4 = getelementptr i8, i8* @aTheResultIsToo, i64 0
  br label %common

case5:
  %rbx_case5 = getelementptr i8, i8* @aTotalLossOfSig, i64 0
  br label %common

sw.default:
  %rbx_default = getelementptr i8, i8* @aUnknownError, i64 0
  br label %common

common:
  %p20 = getelementptr i8, i8* %rcx, i64 32
  %p20d = bitcast i8* %p20 to double*
  %x20 = load volatile double, double* %p20d, align 8
  %p18 = getelementptr i8, i8* %rcx, i64 24
  %p18d = bitcast i8* %p18 to double*
  %x18 = load volatile double, double* %p18d, align 8
  %p10 = getelementptr i8, i8* %rcx, i64 16
  %p10d = bitcast i8* %p10 to double*
  %x10 = load volatile double, double* %p10d, align 8
  %p8 = getelementptr i8, i8* %rcx, i64 8
  %p8p = bitcast i8* %p8 to i8**
  %rsi_load = load volatile i8*, i8** %p8p, align 8
  call void @sub_140002710(i32 2)
  unreachable
}