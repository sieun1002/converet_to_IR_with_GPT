; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

declare void @sub_1400FD86C()

define void @sub_140001562() {
entry:
  %shiftc = and i8 244, 31
  %lt8 = icmp ult i8 %shiftc, 8
  br i1 %lt8, label %shl_ok, label %shl_big

shl_ok:                                           ; preds = %entry
  %v_ok = shl i8 1, %shiftc
  br label %after

shl_big:                                          ; preds = %entry
  br label %after

after:                                            ; preds = %shl_big, %shl_ok
  %res = phi i8 [ %v_ok, %shl_ok ], [ 0, %shl_big ]
  %signbit = and i8 %res, -128
  %sf_is_zero = icmp eq i8 %signbit, 0
  br i1 %sf_is_zero, label %jns_taken, label %fallthrough

jns_taken:                                        ; preds = %after
  ret void

fallthrough:                                      ; preds = %after
  call void asm sideeffect "syscall", "~{dirflag},~{fpsr},~{flags}"()
  call void @sub_1400FD86C()
  ret void
}