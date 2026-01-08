; ModuleID = 'sub_140002880.ll'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global <16 x i8>
@xmmword_140004020 = external global <16 x i8>
@unk_140004000 = external global [0 x i8]

declare void @sub_140001520()
declare i32 @sub_1400025A0(i8*, i32)
declare i32 @sub_140002730(i32)

define i32 @sub_140002880() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %limit = alloca i32, align 4
  %lastSwap = alloca i32, align 4
  %i = alloca i32, align 4
  %p = alloca i32*, align 8
  call void @sub_140001520()
  %arr.vec = bitcast [10 x i32]* %arr to <16 x i8>*
  %v0 = load <16 x i8>, <16 x i8>* @xmmword_140004010, align 1
  store <16 x i8> %v0, <16 x i8>* %arr.vec, align 16
  %elem8.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %elem8.ptr, align 4
  %arr.i8 = bitcast [10 x i32]* %arr to i8*
  %off16 = getelementptr inbounds i8, i8* %arr.i8, i64 16
  %arr.vec2 = bitcast i8* %off16 to <16 x i8>*
  %v1 = load <16 x i8>, <16 x i8>* @xmmword_140004020, align 1
  store <16 x i8> %v1, <16 x i8>* %arr.vec2, align 16
  store i32 10, i32* %limit, align 4
  br label %outer

outer:
  store i32 0, i32* %lastSwap, align 4
  store i32 1, i32* %i, align 4
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32* %base, i32** %p, align 8
  br label %inner

inner:
  %i.val = load i32, i32* %i, align 4
  %limit.val = load i32, i32* %limit, align 4
  %cmp.cond = icmp ne i32 %i.val, %limit.val
  br i1 %cmp.cond, label %loop.body, label %after.inner

loop.body:
  %p.cur = load i32*, i32** %p, align 8
  %a = load i32, i32* %p.cur, align 4
  %p.next = getelementptr inbounds i32, i32* %p.cur, i64 1
  %b = load i32, i32* %p.next, align 4
  %need.swap = icmp slt i32 %b, %a
  br i1 %need.swap, label %do.swap, label %no.swap

do.swap:
  store i32 %b, i32* %p.cur, align 4
  store i32 %a, i32* %p.next, align 4
  store i32 %i.val, i32* %lastSwap, align 4
  br label %cont

no.swap:
  br label %cont

cont:
  %i.next = add i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  %p.inc = getelementptr inbounds i32, i32* %p.cur, i64 1
  store i32* %p.inc, i32** %p, align 8
  br label %inner

after.inner:
  %ls = load i32, i32* %lastSwap, align 4
  %le1 = icmp ule i32 %ls, 1
  br i1 %le1, label %print.setup, label %set.limit

set.limit:
  store i32 %ls, i32* %limit, align 4
  br label %outer

print.setup:
  %print.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %print.end = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 10
  br label %print.loop

print.loop:
  %cur = phi i32* [ %print.base, %print.setup ], [ %next, %after.print ]
  %done = icmp eq i32* %cur, %print.end
  br i1 %done, label %after.prints, label %do.print

do.print:
  %val = load i32, i32* %cur, align 4
  %fmt = getelementptr inbounds [0 x i8], [0 x i8]* @unk_140004000, i64 0, i64 0
  %call = call i32 @sub_1400025A0(i8* %fmt, i32 %val)
  %next = getelementptr inbounds i32, i32* %cur, i64 1
  br label %after.print

after.print:
  br label %print.loop

after.prints:
  %call2 = call i32 @sub_140002730(i32 10)
  ret i32 0
}