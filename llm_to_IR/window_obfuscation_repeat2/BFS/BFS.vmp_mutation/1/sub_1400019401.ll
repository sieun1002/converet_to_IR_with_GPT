; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i8*

declare i32 @j__crt_atexit(void ()*)
declare void @sub_1400018F0()

define i32 @sub_140001940() {
entry:
  %base.ptr = load i8*, i8** @off_1400043B0, align 8
  %first.qword.ptr = bitcast i8* %base.ptr to i64*
  %first.qword = load i64, i64* %first.qword.ptr, align 8
  %first32 = trunc i64 %first.qword to i32
  %is.m1 = icmp eq i32 %first32, -1
  br i1 %is.m1, label %scan.init, label %count.direct

scan.init:
  br label %scan.loop

scan.loop:
  %rax.phi = phi i64 [ 0, %scan.init ], [ %r8.next, %scan.loop.cont ]
  %r8.next = add i64 %rax.phi, 1
  %ecx.from.rax = trunc i64 %rax.phi to i32
  %r8.bytes = shl i64 %r8.next, 3
  %addr.r8 = getelementptr i8, i8* %base.ptr, i64 %r8.bytes
  %addr.r8.i64p = bitcast i8* %addr.r8 to i64*
  %val.r8 = load i64, i64* %addr.r8.i64p, align 8
  %nz = icmp ne i64 %val.r8, 0
  br i1 %nz, label %scan.loop.cont, label %test.count.from.scan

scan.loop.cont:
  br label %scan.loop

count.direct:
  br label %test.count.direct

test.count.direct:
  %ecx.direct = phi i32 [ %first32, %count.direct ]
  br label %test.count

test.count.from.scan:
  br label %test.count

test.count:
  %count = phi i32 [ %ecx.from.rax, %test.count.from.scan ], [ %ecx.direct, %test.count.direct ]
  %is.zero = icmp eq i32 %count, 0
  br i1 %is.zero, label %register.atexit, label %have.count

have.count:
  %count64 = zext i32 %count to i64
  %bytes = shl i64 %count64, 3
  %rbx.start = getelementptr i8, i8* %base.ptr, i64 %bytes
  br label %call.loop

call.loop:
  %rbx.phi = phi i8* [ %rbx.start, %have.count ], [ %rbx.dec, %call.loop ]
  %fptr.loc = bitcast i8* %rbx.phi to i64*
  %fptr.val = load i64, i64* %fptr.loc, align 8
  %func = inttoptr i64 %fptr.val to void ()*
  call void %func()
  %rbx.dec = getelementptr i8, i8* %rbx.phi, i64 -8
  %cont = icmp ne i8* %rbx.dec, %base.ptr
  br i1 %cont, label %call.loop, label %register.atexit

register.atexit:
  %retv = call i32 @j__crt_atexit(void ()* @sub_1400018F0)
  ret i32 %retv
}