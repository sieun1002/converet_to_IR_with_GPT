; ModuleID = 'linear_search'
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* %arr, i32 %len, i32 %key) local_unnamed_addr nounwind {
addr_1180:
  br label %addr_1184

addr_1184:
  %test.and = and i32 %len, %len
  %test.zf = icmp eq i32 %test.and, 0
  %test.sf = icmp slt i32 %test.and, 0
  %sf.xor.of = xor i1 %test.sf, false
  %jle.cond = or i1 %test.zf, %sf.xor.of
  br i1 %jle.cond, label %addr_11a0, label %addr_1188

addr_1188:
  %len64 = sext i32 %len to i64
  br label %addr_118b

addr_118b:
  %idx0 = xor i64 0, 0
  br label %addr_118d

addr_118d:
  br label %addr_1199

addr_118f:
  unreachable

addr_1190:
  %idx.inc = add i64 %idx.1199, 1
  br label %addr_1194

addr_1194:
  %cmp.eq = icmp eq i64 %idx.inc, %len64
  br label %addr_1197

addr_1197:
  br i1 %cmp.eq, label %addr_11a0, label %addr_1199

addr_1199:
  %idx.1199 = phi i64 [ %idx0, %addr_118d ], [ %idx.inc, %addr_1197 ]
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.1199
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp.eq2 = icmp eq i32 %elem, %key
  br label %addr_119c

addr_119c:
  %cond.jnz = xor i1 %cmp.eq2, true
  br i1 %cond.jnz, label %addr_1190, label %addr_119e

addr_119e:
  %ret.idx = trunc i64 %idx.1199 to i32
  ret i32 %ret.idx

addr_119f:
  unreachable

addr_11a0:
  %minus1 = add i32 -1, 0
  br label %addr_11a5

addr_11a5:
  ret i32 %minus1
}