; ModuleID = 'binsearch_main'
target triple = "x86_64-pc-linux-gnu"

@.fmt_found = private constant [21 x i8] c"key %d -> index %ld\0A\00"
@.fmt_not   = private constant [21 x i8] c"key %d -> not found\0A\00"

declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %arr.idx1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  %arr.idx2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  %arr.idx3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  %arr.idx4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  %arr.idx5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  %arr.idx6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  %arr.idx7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  %arr.idx8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 -10, i32* %arr.base, align 4
  store i32 -3,  i32* %arr.idx1, align 4
  store i32 0,   i32* %arr.idx2, align 4
  store i32 1,   i32* %arr.idx3, align 4
  store i32 2,   i32* %arr.idx4, align 4
  store i32 4,   i32* %arr.idx5, align 4
  store i32 8,   i32* %arr.idx6, align 4
  store i32 16,  i32* %arr.idx7, align 4
  store i32 32,  i32* %arr.idx8, align 4
  %keys.base = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %keys.idx1 = getelementptr inbounds i32, i32* %keys.base, i64 1
  %keys.idx2 = getelementptr inbounds i32, i32* %keys.base, i64 2
  store i32 8,  i32* %keys.base, align 4
  store i32 1,  i32* %keys.idx1, align 4
  store i32 -5, i32* %keys.idx2, align 4
  %p.begin = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %p.end = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 3
  br label %key.loop

key.loop:
  %p.cur = phi i32* [ %p.begin, %entry ], [ %p.next, %post.print ]
  %done = icmp eq i32* %p.cur, %p.end
  br i1 %done, label %exit, label %process.key

process.key:
  %k.load = load i32, i32* %p.cur, align 4
  br label %lower.bound

lower.bound:
  %lo.phi = phi i64 [ 0, %process.key ], [ %lo.next, %step.end ]
  %hi.phi = phi i64 [ 9, %process.key ], [ %hi.next, %step.end ]
  %cont = icmp ult i64 %lo.phi, %hi.phi
  br i1 %cont, label %step, label %lb.done

step:
  %diff = sub i64 %hi.phi, %lo.phi
  %half = lshr i64 %diff, 1
  %mid = add i64 %half, %lo.phi
  %mid.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %mid
  %mid.val = load i32, i32* %mid.ptr, align 4
  %cmp.k.gt = icmp sgt i32 %k.load, %mid.val
  br i1 %cmp.k.gt, label %set.lo, label %set.hi

set.lo:
  %mid.plus1 = add i64 %mid, 1
  br label %step.end

set.hi:
  br label %step.end

step.end:
  %lo.next = phi i64 [ %mid.plus1, %set.lo ], [ %lo.phi, %set.hi ]
  %hi.next = phi i64 [ %hi.phi, %set.lo ], [ %mid, %set.hi ]
  br label %lower.bound

lb.done:
  %in.range = icmp ule i64 %lo.phi, 8
  br i1 %in.range, label %maybe.equal, label %not.found

maybe.equal:
  %pos.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %lo.phi
  %pos.val = load i32, i32* %pos.ptr, align 4
  %is.eq = icmp eq i32 %k.load, %pos.val
  br i1 %is.eq, label %found, label %not.found

found:
  %fmt.f.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.fmt_found, i64 0, i64 0
  %call.f = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.f.ptr, i32 %k.load, i64 %lo.phi)
  br label %post.print

not.found:
  %fmt.n.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.fmt_not, i64 0, i64 0
  %call.n = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.n.ptr, i32 %k.load)
  br label %post.print

post.print:
  %p.next = getelementptr inbounds i32, i32* %p.cur, i64 1
  br label %key.loop

exit:
  ret i32 0
}