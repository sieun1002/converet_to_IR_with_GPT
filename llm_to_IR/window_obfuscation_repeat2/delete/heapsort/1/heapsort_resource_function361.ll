; ModuleID = 'stack_probe_module'
target triple = "x86_64-pc-windows-msvc"

define void @sub_1400028E0(i64 %size) {
entry:
  %sp = alloca i8, align 1
  br label %loop_check

loop_check:
  %szphi = phi i64 [ %size, %entry ], [ %sz1, %loop_body ]
  %rcxphi = phi i8* [ %sp, %entry ], [ %rcx1, %loop_body ]
  %cmp = icmp ugt i64 %szphi, 4096
  br i1 %cmp, label %loop_body, label %after_loop

loop_body:
  %rcx1 = getelementptr i8, i8* %rcxphi, i64 -4096
  %p64 = bitcast i8* %rcx1 to i64*
  %v = load volatile i64, i64* %p64, align 8
  store volatile i64 %v, i64* %p64, align 8
  %sz1 = sub i64 %szphi, 4096
  br label %loop_check

after_loop:
  %neg = sub i64 0, %szphi
  %rcx3 = getelementptr i8, i8* %rcxphi, i64 %neg
  %p64_2 = bitcast i8* %rcx3 to i64*
  %v2 = load volatile i64, i64* %p64_2, align 8
  store volatile i64 %v2, i64* %p64_2, align 8
  ret void
}