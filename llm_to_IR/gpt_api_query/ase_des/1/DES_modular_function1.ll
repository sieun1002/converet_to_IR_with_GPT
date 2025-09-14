; ModuleID = 'permute'
source_filename = "permute.ll"
target triple = "x86_64-unknown-linux-gnu"

define i64 @permute(i64 %x, i32* %arr, i32 %n, i32 %base) {
entry:
  br label %loop.head

loop.head:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %out = phi i64 [ 0, %entry ], [ %out.next, %loop.body ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %ret

loop.body:
  %idx64 = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %arrval = load i32, i32* %ptr, align 4
  %t = sub i32 %base, %arrval
  %t.zext = zext i32 %t to i64
  %shamt = and i64 %t.zext, 63
  %sh = lshr i64 %x, %shamt
  %bit = and i64 %sh, 1
  %out.shl = shl i64 %out, 1
  %out.next = or i64 %out.shl, %bit
  %i.next = add i32 %i, 1
  br label %loop.head

ret:
  ret i64 %out
}