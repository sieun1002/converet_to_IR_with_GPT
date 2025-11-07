; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

; externals observed in the binary
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

; external data referenced by address in the binary
@xmmword_2010 = external global <4 x i32>, align 16
@xmmword_2020 = external global <4 x i32>, align 16
@unk_2004     = external global i8, align 1
@unk_2008     = external global i8, align 1

define i32 @main() {
entry:
  ; stack canary save
  %canary.slot = alloca i64, align 8
  %canary.init = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  store i64 %canary.init, i64* %canary.slot, align 8

  ; ... (program body omitted) ...

  ; stack canary check
  %canary.end = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %canary.saved = load i64, i64* %canary.slot, align 8
  %canary.ok = icmp eq i64 %canary.saved, %canary.end
  br i1 %canary.ok, label %ok, label %fail

ok:
  ret i32 0

fail:
  call void @___stack_chk_fail()
  unreachable
}

; memset intrinsic (may be unused)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)