; ModuleID = 'insertion_sort.ll'
source_filename = "insertion_sort"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @insertion_sort(i32* %arr, i64 %n) {
entry:
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %key = alloca i32, align 4
  store i64 1, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.body.end, %entry
  %i.val = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.val, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %idxptr = getelementptr inbounds i32, i32* %arr, i64 %i.val
  %elem = load i32, i32* %idxptr, align 4
  store i32 %elem, i32* %key, align 4
  store i64 %i.val, i64* %j, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.body
  %j.val = load i64, i64* %j, align 8
  %j.gt.zero = icmp ugt i64 %j.val, 0
  br i1 %j.gt.zero, label %while.check, label %while.end

while.check:                                      ; preds = %while.cond
  %j.minus1 = add i64 %j.val, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %arr.jm1 = load i32, i32* %ptr.jm1, align 4
  %k.cur = load i32, i32* %key, align 4
  %need.shift = icmp slt i32 %k.cur, %arr.jm1
  br i1 %need.shift, label %while.body, label %while.end

while.body:                                       ; preds = %while.check
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.val
  store i32 %arr.jm1, i32* %ptr.j, align 4
  %j.dec = add i64 %j.val, -1
  store i64 %j.dec, i64* %j, align 8
  br label %while.cond

while.end:                                        ; preds = %while.check, %while.cond
  %j.fin = load i64, i64* %j, align 8
  %ptr.j.fin = getelementptr inbounds i32, i32* %arr, i64 %j.fin
  %k.fin = load i32, i32* %key, align 4
  store i32 %k.fin, i32* %ptr.j.fin, align 4
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}