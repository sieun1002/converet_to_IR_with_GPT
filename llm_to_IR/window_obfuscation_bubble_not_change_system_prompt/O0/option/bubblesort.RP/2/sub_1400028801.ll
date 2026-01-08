; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external dso_local global [16 x i8], align 16
@xmmword_140004020 = external dso_local global [16 x i8], align 16
@Format = internal dso_local constant [4 x i8] c"%d \00", align 1

declare void @sub_140001520()
declare i32 @sub_1400025A0(i8*, i32)
declare i32 @putchar(i32)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define dso_local i32 @sub_140002880() {
entry:
  %arr = alloca [10 x i32], align 16
  call void @sub_140001520()
  %arr.i8 = bitcast [10 x i32]* %arr to i8*
  %g1 = bitcast [16 x i8]* @xmmword_140004010 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %arr.i8, i8* %g1, i64 16, i1 false)
  %arr.plus16 = getelementptr inbounds i8, i8* %arr.i8, i64 16
  %g2 = bitcast [16 x i8]* @xmmword_140004020 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %arr.plus16, i8* %g2, i64 16, i1 false)
  %idx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %idx8, align 4
  br label %outer.loop

outer.loop:
  %n.phi = phi i64 [ 10, %entry ], [ %n.next, %outer.end.swap ]
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  br label %inner.loop

inner.loop:
  %idx.phi = phi i64 [ 1, %outer.loop ], [ %idx.inc, %inner.join ]
  %ptr.phi = phi i32* [ %base, %outer.loop ], [ %ptr.inc, %inner.join ]
  %lastswap.phi = phi i64 [ 0, %outer.loop ], [ %lastswap.sel, %inner.join ]
  %a = load i32, i32* %ptr.phi, align 4
  %nextptr = getelementptr inbounds i32, i32* %ptr.phi, i64 1
  %b = load i32, i32* %nextptr, align 4
  %ge = icmp sge i32 %b, %a
  br i1 %ge, label %noswap, label %doswap

doswap:
  store i32 %b, i32* %ptr.phi, align 4
  store i32 %a, i32* %nextptr, align 4
  br label %inner.join

noswap:
  br label %inner.join

inner.join:
  %lastswap.sel = phi i64 [ %idx.phi, %doswap ], [ %lastswap.phi, %noswap ]
  %idx.inc = add i64 %idx.phi, 1
  %ptr.inc = getelementptr inbounds i32, i32* %ptr.phi, i64 1
  %cont = icmp ne i64 %idx.inc, %n.phi
  br i1 %cont, label %inner.loop, label %outer.end

outer.end:
  %done = icmp ule i64 %lastswap.sel, 1
  br i1 %done, label %print.init, label %outer.end.swap

outer.end.swap:
  %n.next = phi i64 [ %lastswap.sel, %outer.end ]
  br label %outer.loop

print.init:
  %start = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %end = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 10
  br label %print.loop

print.loop:
  %pcur = phi i32* [ %start, %print.init ], [ %pnext, %print.loop ]
  %val = load i32, i32* %pcur, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @Format, i64 0, i64 0
  %call = call i32 @sub_1400025A0(i8* %fmtptr, i32 %val)
  %pnext = getelementptr inbounds i32, i32* %pcur, i64 1
  %done.print = icmp eq i32* %pnext, %end
  br i1 %done.print, label %after.print, label %print.loop

after.print:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}