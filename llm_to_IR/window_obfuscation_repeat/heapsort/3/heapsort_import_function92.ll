; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external dso_local global i32 (i8**)*, align 8

declare dso_local i8* @sub_140002B68(i32, i32)
declare dso_local void @sub_1400024E0()

define dso_local i32 @sub_140002080(i8** %ctx) local_unnamed_addr {
entry:
  %rdx = load i8*, i8** %ctx, align 8
  %i32ptr = bitcast i8* %rdx to i32*
  %status = load i32, i32* %i32ptr, align 4
  %masked = and i32 %status, 553648127
  %cmp = icmp eq i32 %masked, 541606723
  br i1 %cmp, label %checkflag, label %main

checkflag:
  %flagptr = getelementptr inbounds i8, i8* %rdx, i64 4
  %flagbyte = load i8, i8* %flagptr, align 1
  %fmask = and i8 %flagbyte, 1
  %iszero = icmp eq i8 %fmask, 0
  br i1 %iszero, label %ret_minus1, label %main

main:
  %fp = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %isnullfp = icmp eq i32 (i8**)* %fp, null
  br i1 %isnullfp, label %ret_zero, label %calltail

calltail:
  %res = call i32 %fp(i8** %ctx)
  ret i32 %res

ret_minus1:
  ret i32 -1

ret_zero:
  ret i32 0
}