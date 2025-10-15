; ModuleID = 'sub_1400029C0'
target triple = "x86_64-pc-windows-msvc"

declare i64 @llvm.read_register.i64(metadata) nounwind readnone

define void @sub_1400029C0() nounwind {
entry:
  %raxval = call i64 @llvm.read_register.i64(metadata !"rax")
  %rspval = call i64 @llvm.read_register.i64(metadata !"rsp")
  %sptr = inttoptr i64 %rspval to i8*
  %base = getelementptr i8, i8* %sptr, i64 16
  %cmp = icmp ult i64 %raxval, 4096
  br i1 %cmp, label %less, label %loop

loop:
  %rcx.cur = phi i8* [ %base, %entry ], [ %rcx.next, %loop ]
  %rax.cur = phi i64 [ %raxval, %entry ], [ %rax.next, %loop ]
  %rcx.next = getelementptr i8, i8* %rcx.cur, i64 -4096
  %ptr64 = bitcast i8* %rcx.next to i64*
  %ld = load volatile i64, i64* %ptr64, align 1
  store volatile i64 %ld, i64* %ptr64, align 1
  %rax.next = sub i64 %rax.cur, 4096
  %cond = icmp ugt i64 %rax.next, 4096
  br i1 %cond, label %loop, label %less

less:
  %rcx.phi = phi i8* [ %base, %entry ], [ %rcx.next, %loop ]
  %rax.phi = phi i64 [ %raxval, %entry ], [ %rax.next, %loop ]
  %neg = sub i64 0, %rax.phi
  %rcx.final = getelementptr i8, i8* %rcx.phi, i64 %neg
  %ptr64f = bitcast i8* %rcx.final to i64*
  %ld2 = load volatile i64, i64* %ptr64f, align 1
  store volatile i64 %ld2, i64* %ptr64f, align 1
  ret void
}