; ModuleID = 'insertion_sort'
source_filename = "insertion_sort"
target triple = "x86_64-unknown-linux-gnu"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:                                     ; i loop header
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %outer.body, label %exit

outer.body:                                     ; body of outer loop
  %elemptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %elemptr, align 4
  br label %inner.cond

inner.cond:                                     ; j loop header
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.body ]
  %j.iszero = icmp eq i64 %j, 0
  br i1 %j.iszero, label %inner.end, label %inner.check

inner.check:
  %jm1 = add i64 %j, -1
  %ptrjm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %valjm1 = load i32, i32* %ptrjm1, align 4
  %cmpkey = icmp slt i32 %key, %valjm1
  br i1 %cmpkey, label %inner.body, label %inner.end

inner.body:
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %valjm1, i32* %jptr, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

inner.end:
  %j.out = phi i64 [ %j, %inner.cond ], [ %j, %inner.check ]
  %outptr = getelementptr inbounds i32, i32* %arr, i64 %j.out
  store i32 %key, i32* %outptr, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:
  ret void
}