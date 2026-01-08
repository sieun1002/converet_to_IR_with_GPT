; ModuleID = 'sub_140002880_module'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external dso_local global [16 x i8], align 16
@xmmword_140004020 = external dso_local global [16 x i8], align 16
@unk_140004000 = external dso_local global i8, align 1

declare dso_local void @sub_140001520()
declare dso_local void @sub_1400025A0(i8* noundef, i32 noundef)
declare dso_local void @"loc_14000272D+3"(i32 noundef)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define dso_local i32 @sub_140002880() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @sub_140001520()
  %arr.i8 = bitcast i32* %arr.base to i8*
  %g1ptr = getelementptr inbounds [16 x i8], [16 x i8]* @xmmword_140004010, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %arr.i8, i8* align 1 %g1ptr, i64 16, i1 false)
  %arr4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  %arr4.i8 = bitcast i32* %arr4 to i8*
  %g2ptr = getelementptr inbounds [16 x i8], [16 x i8]* @xmmword_140004020, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %arr4.i8, i8* align 1 %g2ptr, i64 16, i1 false)
  %arr8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %arr8, align 4
  br label %outer.header

outer.header:                                     ; preds = %outer.back, %entry
  %limit.cur = phi i64 [ 10, %entry ], [ %last.end, %outer.back ]
  br label %inner.header

inner.header:                                     ; preds = %inner.latch, %outer.header
  %i.cur = phi i64 [ 1, %outer.header ], [ %i.next, %inner.latch ]
  %p.cur = phi i32* [ %arr.base, %outer.header ], [ %p.next, %inner.latch ]
  %last.cur = phi i64 [ 0, %outer.header ], [ %last.next, %inner.latch ]
  %cmp.i = icmp ne i64 %i.cur, %limit.cur
  br i1 %cmp.i, label %inner.body, label %outer.end

inner.body:                                       ; preds = %inner.header
  %a = load i32, i32* %p.cur, align 4
  %p.nextptr = getelementptr inbounds i32, i32* %p.cur, i64 1
  %b = load i32, i32* %p.nextptr, align 4
  %ge = icmp sge i32 %b, %a
  br i1 %ge, label %no.swap, label %do.swap

do.swap:                                          ; preds = %inner.body
  store i32 %b, i32* %p.cur, align 4
  store i32 %a, i32* %p.nextptr, align 4
  br label %inner.latch

no.swap:                                          ; preds = %inner.body
  br label %inner.latch

inner.latch:                                      ; preds = %no.swap, %do.swap
  %last.next = phi i64 [ %i.cur, %do.swap ], [ %last.cur, %no.swap ]
  %i.next = add i64 %i.cur, 1
  %p.next = getelementptr inbounds i32, i32* %p.cur, i64 1
  br label %inner.header

outer.end:                                        ; preds = %inner.header
  %last.end = phi i64 [ %last.cur, %inner.header ]
  %cont = icmp ugt i64 %last.end, 1
  br i1 %cont, label %outer.back, label %print.init

outer.back:                                       ; preds = %outer.end
  br label %outer.header

print.init:                                       ; preds = %outer.end
  %end.ptr = getelementptr inbounds i32, i32* %arr.base, i64 10
  br label %print.loop

print.loop:                                       ; preds = %print.latch, %print.init
  %p.print = phi i32* [ %arr.base, %print.init ], [ %p.next.print, %print.latch ]
  %done = icmp eq i32* %p.print, %end.ptr
  br i1 %done, label %after.print, label %print.body

print.body:                                       ; preds = %print.loop
  %val = load i32, i32* %p.print, align 4
  call void @sub_1400025A0(i8* noundef @unk_140004000, i32 noundef %val)
  br label %print.latch

print.latch:                                      ; preds = %print.body
  %p.next.print = getelementptr inbounds i32, i32* %p.print, i64 1
  br label %print.loop

after.print:                                      ; preds = %print.loop
  call void @"loc_14000272D+3"(i32 noundef 10)
  ret i32 0
}