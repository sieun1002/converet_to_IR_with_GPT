; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i8*, align 8

declare void @sub_1400018F0()
declare void @loc_140001420(void ()*)

define void @sub_140001940() {
entry:
  %base.ptr = load i8*, i8** @off_1400043B0, align 8
  %base.i64p = bitcast i8* %base.ptr to i64*
  %slot0 = load i64, i64* %base.i64p, align 8
  %ecx0 = trunc i64 %slot0 to i32
  %cmp.minus1 = icmp eq i32 %ecx0, -1
  br i1 %cmp.minus1, label %sentinel, label %test_ecx_entry

sentinel:
  br label %find_zero

find_zero:
  %eax.phi = phi i32 [ 0, %sentinel ], [ %r8d, %find_zero_continue ]
  %r8d = add i32 %eax.phi, 1
  %r8.zext = zext i32 %r8d to i64
  %offset = mul i64 %r8.zext, 8
  %addr = getelementptr i8, i8* %base.ptr, i64 %offset
  %addr.ptr = bitcast i8* %addr to i8**
  %val = load i8*, i8** %addr.ptr, align 8
  %is.not.null = icmp ne i8* %val, null
  br i1 %is.not.null, label %find_zero_continue, label %to_test_ecx_from_sentinel

find_zero_continue:
  br label %find_zero

to_test_ecx_from_sentinel:
  br label %test_ecx

test_ecx_entry:
  br label %test_ecx

test_ecx:
  %ecx.phi = phi i32 [ %eax.phi, %to_test_ecx_from_sentinel ], [ %ecx0, %test_ecx_entry ]
  %is.zero = icmp eq i32 %ecx.phi, 0
  br i1 %is.zero, label %after_call, label %prep_calls

prep_calls:
  %eax1 = add i32 %ecx.phi, 0
  %ecx.minus1 = add i32 %ecx.phi, -1
  %rax1.zext = zext i32 %eax1 to i64
  %rbx.offset = mul i64 %rax1.zext, 8
  %rbx.ptr = getelementptr i8, i8* %base.ptr, i64 %rbx.offset
  %ecx.minus1.zext = zext i32 %ecx.minus1 to i64
  %rax.sub = sub i64 %rax1.zext, %ecx.minus1.zext
  %rsi.off.times8 = mul i64 %rax.sub, 8
  %rsi.addr.pre = getelementptr i8, i8* %base.ptr, i64 %rsi.off.times8
  %rsi.addr = getelementptr i8, i8* %rsi.addr.pre, i64 -8
  br label %call_loop

call_loop:
  %rbx.phi = phi i8* [ %rbx.ptr, %prep_calls ], [ %rbx.prev.minus8, %call_loop ]
  %rsi.phi = phi i8* [ %rsi.addr, %prep_calls ], [ %rsi.phi, %call_loop ]
  %fn.ptr.ptr = bitcast i8* %rbx.phi to i8**
  %fn.ptr = load i8*, i8** %fn.ptr.ptr, align 8
  %fn.typed = bitcast i8* %fn.ptr to void ()*
  call void %fn.typed()
  %rbx.prev.minus8 = getelementptr i8, i8* %rbx.phi, i64 -8
  %cmp.rbx.rsi = icmp ne i8* %rbx.prev.minus8, %rsi.phi
  br i1 %cmp.rbx.rsi, label %call_loop, label %after_call

after_call:
  tail call void @loc_140001420(void ()* @sub_1400018F0)
  ret void
}