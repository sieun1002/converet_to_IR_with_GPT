; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8*, i32, i8*)

@off_140004370 = external global i32*
@unk_140004BE0 = external global i64

define void @TlsCallback_0(i8* %h, i32 %reason, i8* %reserved) {
entry:
  %p_ptr = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %p_ptr, align 4
  %cmp2 = icmp eq i32 %val, 2
  br i1 %cmp2, label %check_reason, label %store2

store2:
  store i32 2, i32* %p_ptr, align 4
  br label %check_reason

check_reason:
  %is_attach = icmp eq i32 %reason, 2
  br i1 %is_attach, label %on_attach, label %check_detach

check_detach:
  %is_detach = icmp eq i32 %reason, 1
  br i1 %is_detach, label %jmp_func, label %ret

on_attach:
  %begin = getelementptr i64, i64* @unk_140004BE0, i64 0
  %stop = getelementptr i64, i64* @unk_140004BE0, i64 0
  %eq = icmp eq i64* %begin, %stop
  br i1 %eq, label %ret2, label %loop

loop:
  %cur = phi i64* [ %begin, %on_attach ], [ %next, %after ]
  %fp_i64 = load i64, i64* %cur, align 8
  %isnull = icmp eq i64 %fp_i64, 0
  br i1 %isnull, label %after, label %docall

docall:
  %fp = inttoptr i64 %fp_i64 to void (i8*, i32, i8*)*
  call void %fp(i8* %h, i32 %reason, i8* %reserved)
  br label %after

after:
  %next = getelementptr i64, i64* %cur, i64 1
  %done = icmp eq i64* %next, %stop
  br i1 %done, label %ret2, label %loop

jmp_func:
  tail call void @sub_1400023D0(i8* %h, i32 %reason, i8* %reserved)
  ret void

ret:
  ret void

ret2:
  ret void
}