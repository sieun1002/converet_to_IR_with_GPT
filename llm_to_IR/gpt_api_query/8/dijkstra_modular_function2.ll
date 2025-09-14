; ModuleID = 'add_edge'
source_filename = "add_edge"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @add_edge(i32* %base, i32 %i, i32 %j, i32 %val, i32 %sym) {
entry:
  %i.neg = icmp slt i32 %i, 0
  %j.neg = icmp slt i32 %j, 0
  %any.neg = or i1 %i.neg, %j.neg
  br i1 %any.neg, label %exit, label %store

store:
  %i64 = sext i32 %i to i64
  %j64 = sext i32 %j to i64
  %row.off = mul nsw i64 %i64, 100
  %idx = add nsw i64 %row.off, %j64
  %ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 %val, i32* %ptr, align 4
  %sym.zero = icmp eq i32 %sym, 0
  br i1 %sym.zero, label %exit, label %store_sym

store_sym:
  %row.off.sym = mul nsw i64 %j64, 100
  %idx.sym = add nsw i64 %row.off.sym, %i64
  %ptr.sym = getelementptr inbounds i32, i32* %base, i64 %idx.sym
  store i32 %val, i32* %ptr.sym, align 4
  br label %exit

exit:
  ret void
}