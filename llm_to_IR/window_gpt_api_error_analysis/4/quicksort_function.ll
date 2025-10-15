; ModuleID = 'qs'
source_filename = "qs"
target triple = "x86_64-pc-windows-msvc"

define void @quick_sort(i32* %arr, i32 %lo, i32 %hi) {
entry:
  br label %outer.cond

outer.cond:
  %lo.cur = phi i32 [ %lo, %entry ], [ %lo.next, %skip.left ], [ %lo.next2, %skip.right ]
  %hi.cur = phi i32 [ %hi, %entry ], [ %hi.next, %skip.left ], [ %hi.next2, %skip.right ]
  %cmp0 = icmp slt i32 %lo.cur, %hi.cur
  br i1 %cmp0, label %outer.body, label %ret

outer.body:
  %sub1 = sub nsw i32 %hi.cur, %lo.cur
  %div2 = sdiv i32 %sub1, 2
  %mid = add nsw i32 %lo.cur, %div2
  %mid64 = sext i32 %mid to i64
  %ptrmid = getelementptr inbounds i32, i32* %arr, i64 %mid64
  %pivot = load i32, i32* %ptrmid, align 4
  br label %part.head

part.head:
  %i.start = phi i32 [ %lo.cur, %outer.body ], [ %i.next2, %part.cont ]
  %j.start = phi i32 [ %hi.cur, %outer.body ], [ %j.next2, %part.cont ]
  br label %i.loop

i.loop:
  %i.cur = phi i32 [ %i.start, %part.head ], [ %i.inc, %incI ]
  %i.idx64 = sext i32 %i.cur to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %i.val = load i32, i32* %i.ptr, align 4
  %cmpI = icmp slt i32 %i.val, %pivot
  br i1 %cmpI, label %incI, label %i.done

incI:
  %i.inc = add nsw i32 %i.cur, 1
  br label %i.loop

i.done:
  br label %j.loop

j.loop:
  %j.cur = phi i32 [ %j.start, %i.done ], [ %j.dec, %decJ ]
  %j.idx64 = sext i32 %j.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %j.val = load i32, i32* %j.ptr, align 4
  %cmpJ = icmp sgt i32 %j.val, %pivot
  br i1 %cmpJ, label %decJ, label %j.done

decJ:
  %j.dec = add nsw i32 %j.cur, -1
  br label %j.loop

j.done:
  %cmpIJ = icmp sle i32 %i.cur, %j.cur
  br i1 %cmpIJ, label %do.swap, label %part.exit

do.swap:
  %tmp1 = load i32, i32* %i.ptr, align 4
  %tmp2 = load i32, i32* %j.ptr, align 4
  store i32 %tmp2, i32* %i.ptr, align 4
  store i32 %tmp1, i32* %j.ptr, align 4
  %i.next2 = add nsw i32 %i.cur, 1
  %j.next2 = add nsw i32 %j.cur, -1
  br label %part.cont

part.cont:
  br label %part.head

part.exit:
  %leftLen = sub nsw i32 %j.cur, %lo.cur
  %rightLen = sub nsw i32 %hi.cur, %i.cur
  %cmpLen = icmp slt i32 %leftLen, %rightLen
  br i1 %cmpLen, label %do.leftFirst, label %do.rightFirst

do.leftFirst:
  %condL = icmp slt i32 %lo.cur, %j.cur
  br i1 %condL, label %call.left, label %after.left.call

call.left:
  call void @quick_sort(i32* %arr, i32 %lo.cur, i32 %j.cur)
  br label %after.left.call

after.left.call:
  %lo.next = add nsw i32 %i.cur, 0
  %hi.next = add nsw i32 %hi.cur, 0
  br label %skip.left

skip.left:
  br label %outer.cond

do.rightFirst:
  %condR = icmp slt i32 %i.cur, %hi.cur
  br i1 %condR, label %call.right, label %after.right.call

call.right:
  call void @quick_sort(i32* %arr, i32 %i.cur, i32 %hi.cur)
  br label %after.right.call

after.right.call:
  %lo.next2 = add nsw i32 %lo.cur, 0
  %hi.next2 = add nsw i32 %j.cur, 0
  br label %skip.right

skip.right:
  br label %outer.cond

ret:
  ret void
}