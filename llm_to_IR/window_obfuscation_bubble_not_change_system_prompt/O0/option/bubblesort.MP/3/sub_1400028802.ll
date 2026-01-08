; ModuleID = 'translated'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global <4 x i32>, align 16
@xmmword_140004020 = external global <4 x i32>, align 16
@unk_140004000 = external global i8, align 1

declare void @sub_140001520()
declare i32 @sub_1400025A0(i8*, i32)
declare i32 @sub_140002730(i32)

define i32 @sub_140002880() {
entry:
  %arr = alloca [10 x i32], align 16
  call void @sub_140001520()
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %vsrc0 = load <4 x i32>, <4 x i32>* @xmmword_140004010, align 16
  %vdst0 = bitcast i32* %arr.base to <4 x i32>*
  store <4 x i32> %vsrc0, <4 x i32>* %vdst0, align 16
  %off4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  %vsrc1 = load <4 x i32>, <4 x i32>* @xmmword_140004020, align 16
  %vdst1 = bitcast i32* %off4 to <4 x i32>*
  store <4 x i32> %vsrc1, <4 x i32>* %vdst1, align 16
  %idx8ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %idx8ptr, align 4
  br label %outer

outer:
  %limit = phi i64 [ 10, %entry ], [ %newlimit, %outer_continue ]
  %i.init = phi i64 [ 1, %entry ], [ 1, %outer_continue ]
  %p.init = phi i32* [ %arr.base, %entry ], [ %arr.base, %outer_continue ]
  %lastSwap.init = phi i64 [ 0, %entry ], [ 0, %outer_continue ]
  br label %inner

inner:
  %i = phi i64 [ %i.init, %outer ], [ %i.next, %cont ]
  %p = phi i32* [ %p.init, %outer ], [ %p.next, %cont ]
  %lastSwap = phi i64 [ %lastSwap.init, %outer ], [ %lastSwap.updated, %cont ]
  %x = load i32, i32* %p, align 4
  %p1 = getelementptr inbounds i32, i32* %p, i64 1
  %y = load i32, i32* %p1, align 4
  %islt = icmp slt i32 %y, %x
  br i1 %islt, label %swap, label %noswap

swap:
  store i32 %y, i32* %p, align 4
  store i32 %x, i32* %p1, align 4
  br label %cont

noswap:
  br label %cont

cont:
  %lastSwap.sel = phi i64 [ %i, %swap ], [ %lastSwap, %noswap ]
  %lastSwap.updated = add i64 %lastSwap.sel, 0
  %i.next = add i64 %i, 1
  %p.next = getelementptr inbounds i32, i32* %p, i64 1
  %cont.cond = icmp ne i64 %i.next, %limit
  br i1 %cont.cond, label %inner, label %outer_latch

outer_latch:
  %lastSwap.final = phi i64 [ %lastSwap.updated, %cont ]
  %cmp.le1 = icmp ule i64 %lastSwap.final, 1
  br i1 %cmp.le1, label %print_pre, label %outer_continue

outer_continue:
  %newlimit = add i64 %lastSwap.final, 0
  br label %outer

print_pre:
  %p.print = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %end.print = getelementptr inbounds i32, i32* %p.print, i64 10
  br label %print

print:
  %pphi = phi i32* [ %p.print, %print_pre ], [ %p.next2, %print ]
  %val = load i32, i32* %pphi, align 4
  %fmt = getelementptr inbounds i8, i8* @unk_140004000, i64 0
  %call = call i32 @sub_1400025A0(i8* %fmt, i32 %val)
  %p.next2 = getelementptr inbounds i32, i32* %pphi, i64 1
  %loop.cont = icmp ne i32* %p.next2, %end.print
  br i1 %loop.cont, label %print, label %afterprint

afterprint:
  %call2 = call i32 @sub_140002730(i32 10)
  ret i32 0
}