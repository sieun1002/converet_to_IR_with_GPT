; ModuleID = 'sub_140001870.ll'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external dso_local global i64, align 8

declare dso_local i32 @j__crt_atexit(void ()*)
declare dso_local void @sub_140001820()

define dso_local i32 @sub_140001870() {
entry:
  %v0 = load i64, i64* @off_140004390, align 8
  %v0tr = trunc i64 %v0 to i32
  %cmpneg1 = icmp eq i32 %v0tr, -1
  br i1 %cmpneg1, label %scan.pre, label %usecount

scan.pre:
  br label %scan.loop

scan.loop:
  %idx.phi = phi i64 [ 1, %scan.pre ], [ %idx.next, %scan.loop ]
  %ptr.loop = getelementptr i64, i64* @off_140004390, i64 %idx.phi
  %val.loop = load i64, i64* %ptr.loop, align 8
  %nonzero = icmp ne i64 %val.loop, 0
  %idx.next = add i64 %idx.phi, 1
  br i1 %nonzero, label %scan.loop, label %scan.end

scan.end:
  %n.from.scan = sub i64 %idx.phi, 1
  br label %after

usecount:
  %n.zext = zext i32 %v0tr to i64
  br label %after

after:
  %n.phi = phi i64 [ %n.zext, %usecount ], [ %n.from.scan, %scan.end ]
  %notzero = icmp ne i64 %n.phi, 0
  %start.p = getelementptr i64, i64* @off_140004390, i64 %n.phi
  br i1 %notzero, label %call.loop, label %register

call.loop:
  %p.phi = phi i64* [ %start.p, %after ], [ %p.next, %call.latch ]
  %faddr = load i64, i64* %p.phi, align 8
  %fptr = inttoptr i64 %faddr to void ()*
  call void %fptr()
  %p.next = getelementptr i64, i64* %p.phi, i64 -1
  %base.ptr = getelementptr i64, i64* @off_140004390, i64 0
  %cmp.cont = icmp ne i64* %p.next, %base.ptr
  br i1 %cmp.cont, label %call.latch, label %register

call.latch:
  br label %call.loop

register:
  %atexit.res = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %atexit.res
}