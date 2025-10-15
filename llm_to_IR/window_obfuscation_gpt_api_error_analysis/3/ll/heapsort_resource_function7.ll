; ModuleID = 'sub_140001450'
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* %arr, i64 %n) {
entry:
  %cmp_n1 = icmp ule i64 %n, 1
  br i1 %cmp_n1, label %ret, label %build_start

build_start:
  %half = lshr i64 %n, 1
  br label %build_header

build_header:
  %i_curr = phi i64 [ %half, %build_start ], [ %i_dec, %after_sift_build ]
  %is_zero = icmp eq i64 %i_curr, 0
  br i1 %is_zero, label %post_build, label %do_dec

do_dec:
  %i_dec = add i64 %i_curr, -1
  br label %sift_entry_build

sift_entry_build:
  br label %sift_build

sift_build:
  %k_build = phi i64 [ %i_dec, %sift_entry_build ], [ %k_next_build, %do_swap_build ]
  %shl_build = shl i64 %k_build, 1
  %c1_build = add i64 %shl_build, 1
  %c1_ge_n_build = icmp uge i64 %c1_build, %n
  br i1 %c1_ge_n_build, label %after_sift_build, label %have_c1_build

have_c1_build:
  %c2_build = add i64 %c1_build, 1
  %c2_in_build = icmp ult i64 %c2_build, %n
  br i1 %c2_in_build, label %check_c2_build, label %set_j_c1_build

check_c2_build:
  %ptr_c1_b = getelementptr inbounds i32, i32* %arr, i64 %c1_build
  %val_c1_b = load i32, i32* %ptr_c1_b, align 4
  %ptr_c2_b = getelementptr inbounds i32, i32* %arr, i64 %c2_build
  %val_c2_b = load i32, i32* %ptr_c2_b, align 4
  %c2_gt_c1_b = icmp sgt i32 %val_c2_b, %val_c1_b
  br i1 %c2_gt_c1_b, label %set_j_c2_build, label %set_j_c1_build

set_j_c2_build:
  br label %after_choose_j_build

set_j_c1_build:
  br label %after_choose_j_build

after_choose_j_build:
  %j_build = phi i64 [ %c2_build, %set_j_c2_build ], [ %c1_build, %set_j_c1_build ]
  %ptr_k_b = getelementptr inbounds i32, i32* %arr, i64 %k_build
  %val_k_b = load i32, i32* %ptr_k_b, align 4
  %ptr_j_b = getelementptr inbounds i32, i32* %arr, i64 %j_build
  %val_j_b = load i32, i32* %ptr_j_b, align 4
  %k_lt_j_b = icmp slt i32 %val_k_b, %val_j_b
  br i1 %k_lt_j_b, label %do_swap_build, label %after_sift_build

do_swap_build:
  store i32 %val_j_b, i32* %ptr_k_b, align 4
  store i32 %val_k_b, i32* %ptr_j_b, align 4
  %k_next_build = add i64 %j_build, 0
  br label %sift_build

after_sift_build:
  br label %build_header

post_build:
  %end_init = add i64 %n, -1
  br label %extract_header

extract_header:
  %endvar = phi i64 [ %end_init, %post_build ], [ %end_minus1, %extract_after_sift_or_stop ]
  %end_gt0 = icmp ne i64 %endvar, 0
  br i1 %end_gt0, label %extract_do, label %ret

extract_do:
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %val0 = load i32, i32* %ptr0, align 4
  %ptr_end = getelementptr inbounds i32, i32* %arr, i64 %endvar
  %val_end = load i32, i32* %ptr_end, align 4
  store i32 %val_end, i32* %ptr0, align 4
  store i32 %val0, i32* %ptr_end, align 4
  br label %sift_extract

sift_extract:
  %k2 = phi i64 [ 0, %extract_do ], [ %k2_next, %do_swap_extract ]
  %shl2 = shl i64 %k2, 1
  %c1_2 = add i64 %shl2, 1
  %c1_ge_end = icmp uge i64 %c1_2, %endvar
  br i1 %c1_ge_end, label %extract_after_sift_or_stop, label %have_c1_extract

have_c1_extract:
  %c2_2 = add i64 %c1_2, 1
  %c2_in_2 = icmp ult i64 %c2_2, %endvar
  br i1 %c2_in_2, label %check_c2_extract, label %set_j_c1_extract

check_c2_extract:
  %ptr_c1_2 = getelementptr inbounds i32, i32* %arr, i64 %c1_2
  %val_c1_2 = load i32, i32* %ptr_c1_2, align 4
  %ptr_c2_2 = getelementptr inbounds i32, i32* %arr, i64 %c2_2
  %val_c2_2 = load i32, i32* %ptr_c2_2, align 4
  %c2_gt_c1_2 = icmp sgt i32 %val_c2_2, %val_c1_2
  br i1 %c2_gt_c1_2, label %set_j_c2_extract, label %set_j_c1_extract

set_j_c2_extract:
  br label %after_choose_j_extract

set_j_c1_extract:
  br label %after_choose_j_extract

after_choose_j_extract:
  %j2 = phi i64 [ %c2_2, %set_j_c2_extract ], [ %c1_2, %set_j_c1_extract ]
  %ptr_k2 = getelementptr inbounds i32, i32* %arr, i64 %k2
  %val_k2 = load i32, i32* %ptr_k2, align 4
  %ptr_j2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %val_j2 = load i32, i32* %ptr_j2, align 4
  %k_ge_j = icmp sge i32 %val_k2, %val_j2
  br i1 %k_ge_j, label %extract_after_sift_or_stop, label %do_swap_extract

do_swap_extract:
  store i32 %val_j2, i32* %ptr_k2, align 4
  store i32 %val_k2, i32* %ptr_j2, align 4
  %k2_next = add i64 %j2, 0
  br label %sift_extract

extract_after_sift_or_stop:
  %end_minus1 = add i64 %endvar, -1
  br label %extract_header

ret:
  ret void
}