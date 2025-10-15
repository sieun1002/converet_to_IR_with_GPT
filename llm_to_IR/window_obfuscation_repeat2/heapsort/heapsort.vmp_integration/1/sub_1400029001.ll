; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002A70(i32)
declare i8** @sub_1400029B0()
declare i8* @sub_140002A88(i8*, i8*, i8*, i32, i8*)

define dso_local i8* @sub_140002900(i8* %rcx_param, i8* %rdx_param, i8* %r8_param, i64 %r9_param) {
entry:
  %blk = alloca [4 x i64], align 8
  %blk_gep0 = getelementptr inbounds [4 x i64], [4 x i64]* %blk, i64 0, i64 0
  %rdx_i64 = ptrtoint i8* %rdx_param to i64
  store i64 %rdx_i64, i64* %blk_gep0, align 8
  %blk_gep1 = getelementptr inbounds [4 x i64], [4 x i64]* %blk, i64 0, i64 1
  %r8_i64 = ptrtoint i8* %r8_param to i64
  store i64 %r8_i64, i64* %blk_gep1, align 8
  %blk_gep2 = getelementptr inbounds [4 x i64], [4 x i64]* %blk, i64 0, i64 2
  store i64 %r9_param, i64* %blk_gep2, align 8
  %blk_ptr_i8 = bitcast [4 x i64]* %blk to i8*
  %blk_ptr_i64 = ptrtoint i8* %blk_ptr_i8 to i64
  %blk_gep3 = getelementptr inbounds [4 x i64], [4 x i64]* %blk, i64 0, i64 3
  store i64 %blk_ptr_i64, i64* %blk_gep3, align 8
  %call1 = call i8* @sub_140002A70(i32 1)
  %call2 = call i8** @sub_1400029B0()
  %rcx_for3 = load i8*, i8** %call2, align 8
  %call3 = call i8* @sub_140002A88(i8* %rcx_for3, i8* %call1, i8* %rcx_param, i32 0, i8* %blk_ptr_i8)
  ret i8* %call3
}