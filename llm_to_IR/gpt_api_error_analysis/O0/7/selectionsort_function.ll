define void @selection_sort(i32* %arr, i32 %n) {
entry:
  %cmp.n1 = icmp sgt i32 %n, 1
  br i1 %cmp.n1, label %for.i, label %exit

for.i:
  %i = phi i32 [ 0, %entry ], [ %i.next, %end.i ]
  %i.plus1 = add nsw i32 %i, 1
  br label %for.j.cond

for.j.cond:
  %min.ph = phi i32 [ %i, %for.i ], [ %min.sel, %for.j.body.end ]
  %j = phi i32 [ %i.plus1, %for.i ], [ %j.next, %for.j.body.end ]
  %cmp.j = icmp slt i32 %j, %n
  br i1 %cmp.j, label %for.j.body, label %for.j.exit

for.j.body:
  %j.ext = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %aj = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %min.ph to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %amin = load i32, i32* %min.ptr, align 4
  %cmp.min = icmp slt i32 %aj, %amin
  br i1 %cmp.min, label %for.j.then, label %for.j.else

for.j.then:
  br label %for.j.body.end

for.j.else:
  br label %for.j.body.end

for.j.body.end:
  %min.sel = phi i32 [ %j, %for.j.then ], [ %min.ph, %for.j.else ]
  %j.next = add nsw i32 %j, 1
  br label %for.j.cond

for.j.exit:
  %min.final = phi i32 [ %min.ph, %for.j.cond ]
  %i.ext = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %ai = load i32, i32* %i.ptr, align 4
  %min2.ext = sext i32 %min.final to i64
  %min2.ptr = getelementptr inbounds i32, i32* %arr, i64 %min2.ext
  %amin2 = load i32, i32* %min2.ptr, align 4
  store i32 %amin2, i32* %i.ptr, align 4
  store i32 %ai, i32* %min2.ptr, align 4
  %i.next = add nsw i32 %i, 1
  br label %end.i

end.i:
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i.next, %n.minus1
  br i1 %cmp.outer, label %for.i, label %exit

exit:
  ret void
}