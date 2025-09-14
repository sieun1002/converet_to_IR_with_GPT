; ModuleID = 'mix_columns.ll'
declare i8 @xtime(i32)

define void @mix_columns(i8* %state) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i
  br label %loop.cond

loop.cond:
  %i.val = load i32, i32* %i
  %cmp = icmp sle i32 %i.val, 3
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %idx0 = shl i32 %i.val, 2
  %idx1 = add i32 %idx0, 1
  %idx2 = add i32 %idx0, 2
  %idx3 = add i32 %idx0, 3

  %idx0.i64 = zext i32 %idx0 to i64
  %idx1.i64 = zext i32 %idx1 to i64
  %idx2.i64 = zext i32 %idx2 to i64
  %idx3.i64 = zext i32 %idx3 to i64

  %p0 = getelementptr i8, i8* %state, i64 %idx0.i64
  %p1 = getelementptr i8, i8* %state, i64 %idx1.i64
  %p2 = getelementptr i8, i8* %state, i64 %idx2.i64
  %p3 = getelementptr i8, i8* %state, i64 %idx3.i64

  %a = load i8, i8* %p0, align 1
  %b = load i8, i8* %p1, align 1
  %c = load i8, i8* %p2, align 1
  %d = load i8, i8* %p3, align 1

  %ab = xor i8 %a, %b
  %cd = xor i8 %c, %d
  %t = xor i8 %ab, %cd

  ; new0 = a ^ xtime(a^b) ^ t
  %ab.z = zext i8 %ab to i32
  %xt0 = call i8 @xtime(i32 %ab.z)
  %tmp0 = xor i8 %xt0, %t
  %new0 = xor i8 %a, %tmp0
  store i8 %new0, i8* %p0, align 1

  ; new1 = b ^ xtime(b^c) ^ t
  %bc = xor i8 %b, %c
  %bc.z = zext i8 %bc to i32
  %xt1 = call i8 @xtime(i32 %bc.z)
  %tmp1 = xor i8 %xt1, %t
  %new1 = xor i8 %b, %tmp1
  store i8 %new1, i8* %p1, align 1

  ; new2 = c ^ xtime(c^d) ^ t
  %cd2 = xor i8 %c, %d
  %cd2.z = zext i8 %cd2 to i32
  %xt2 = call i8 @xtime(i32 %cd2.z)
  %tmp2 = xor i8 %xt2, %t
  %new2 = xor i8 %c, %tmp2
  store i8 %new2, i8* %p2, align 1

  ; new3 = d ^ xtime(d^a) ^ t
  %da = xor i8 %d, %a
  %da.z = zext i8 %da to i32
  %xt3 = call i8 @xtime(i32 %da.z)
  %tmp3 = xor i8 %xt3, %t
  %new3 = xor i8 %d, %tmp3
  store i8 %new3, i8* %p3, align 1

  %i.next = add i32 %i.val, 1
  store i32 %i.next, i32* %i
  br label %loop.cond

loop.end:
  ret void
}