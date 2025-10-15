target triple = "x86_64-pc-windows-msvc"

define dso_local void @heap_sort(i32* %arr, i64 %n) {
entry:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %child = alloca i64, align 8
  %right = alloca i64, align 8
  %largest = alloca i64, align 8
  %tmp = alloca i32, align 4
  %end = alloca i64, align 8
  %parent = alloca i64, align 8
  %child2 = alloca i64, align 8
  %right2 = alloca i64, align 8
  %largest2 = alloca i64, align 8
  %saved_root = alloca i32, align 4
  %tmp2 = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i64 %n, i64* %n.addr, align 8
  %0 = icmp ule i64 %n, 1
  br i1 %0, label %epilog, label %build_init

build_init:                                        ; preds = %entry
  %1 = lshr i64 %n, 1
  store i64 %1, i64* %i, align 8
  br label %build_dec

build_dec:                                         ; preds = %build_break_to_dec, %build_after_choose_largest, %build_init
  %2 = load i64, i64* %i, align 8
  %3 = add i64 %2, -1
  store i64 %3, i64* %i, align 8
  %4 = icmp ne i64 %2, 0
  br i1 %4, label %build_startBody, label %build_done

build_startBody:                                   ; preds = %build_dec
  %5 = load i64, i64* %i, align 8
  store i64 %5, i64* %j, align 8
  br label %build_sift_loop_cond

build_sift_loop_cond:                              ; preds = %build_do_swap, %build_startBody
  %6 = load i64, i64* %j, align 8
  %7 = shl i64 %6, 1
  %8 = add i64 %7, 1
  store i64 %8, i64* %child, align 8
  %9 = load i64, i64* %child, align 8
  %10 = load i64, i64* %n.addr, align 8
  %11 = icmp ult i64 %9, %10
  br i1 %11, label %build_has_child, label %build_break_to_dec

build_break_to_dec:                                ; preds = %build_after_choose_largest, %build_sift_loop_cond
  br label %build_dec

build_has_child:                                   ; preds = %build_sift_loop_cond
  %12 = load i64, i64* %child, align 8
  %13 = add i64 %12, 1
  store i64 %13, i64* %right, align 8
  %14 = load i64, i64* %right, align 8
  %15 = load i64, i64* %n.addr, align 8
  %16 = icmp ult i64 %14, %15
  br i1 %16, label %build_compare_children, label %build_set_largest_child

build_compare_children:                            ; preds = %build_has_child
  %17 = load i32*, i32** %arr.addr, align 8
  %18 = load i64, i64* %right, align 8
  %19 = getelementptr inbounds i32, i32* %17, i64 %18
  %20 = load i32, i32* %19, align 4
  %21 = load i32*, i32** %arr.addr, align 8
  %22 = load i64, i64* %child, align 8
  %23 = getelementptr inbounds i32, i32* %21, i64 %22
  %24 = load i32, i32* %23, align 4
  %25 = icmp sgt i32 %20, %24
  br i1 %25, label %build_set_largest_right, label %build_set_largest_child

build_set_largest_right:                           ; preds = %build_compare_children
  %26 = load i64, i64* %right, align 8
  store i64 %26, i64* %largest, align 8
  br label %build_after_choose_largest

build_set_largest_child:                           ; preds = %build_compare_children, %build_has_child
  %27 = load i64, i64* %child, align 8
  store i64 %27, i64* %largest, align 8
  br label %build_after_choose_largest

build_after_choose_largest:                        ; preds = %build_set_largest_child, %build_set_largest_right
  %28 = load i32*, i32** %arr.addr, align 8
  %29 = load i64, i64* %j, align 8
  %30 = getelementptr inbounds i32, i32* %28, i64 %29
  %31 = load i32, i32* %30, align 4
  %32 = load i32*, i32** %arr.addr, align 8
  %33 = load i64, i64* %largest, align 8
  %34 = getelementptr inbounds i32, i32* %32, i64 %33
  %35 = load i32, i32* %34, align 4
  %36 = icmp slt i32 %31, %35
  br i1 %36, label %build_do_swap, label %build_break_to_dec

build_do_swap:                                     ; preds = %build_after_choose_largest
  store i32 %31, i32* %tmp, align 4
  %37 = load i32*, i32** %arr.addr, align 8
  %38 = getelementptr inbounds i32, i32* %37, i64 %29
  store i32 %35, i32* %38, align 4
  %39 = load i32*, i32** %arr.addr, align 8
  %40 = getelementptr inbounds i32, i32* %39, i64 %33
  %41 = load i32, i32* %tmp, align 4
  store i32 %41, i32* %40, align 4
  store i64 %33, i64* %j, align 8
  br label %build_sift_loop_cond

build_done:                                        ; preds = %build_dec
  %42 = add i64 %n, -1
  store i64 %42, i64* %end, align 8
  br label %extract_loop_check

extract_loop_check:                                ; preds = %extract_endof_loop, %build_done
  %43 = load i64, i64* %end, align 8
  %44 = icmp ne i64 %43, 0
  br i1 %44, label %extract_body, label %epilog

extract_body:                                      ; preds = %extract_loop_check
  %45 = load i32*, i32** %arr.addr, align 8
  %46 = load i32, i32* %45, align 4
  store i32 %46, i32* %saved_root, align 4
  %47 = load i32*, i32** %arr.addr, align 8
  %48 = load i64, i64* %end, align 8
  %49 = getelementptr inbounds i32, i32* %47, i64 %48
  %50 = load i32, i32* %49, align 4
  %51 = load i32*, i32** %arr.addr, align 8
  store i32 %50, i32* %51, align 4
  %52 = load i32*, i32** %arr.addr, align 8
  %53 = load i64, i64* %end, align 8
  %54 = getelementptr inbounds i32, i32* %52, i64 %53
  %55 = load i32, i32* %saved_root, align 4
  store i32 %55, i32* %54, align 4
  store i64 0, i64* %parent, align 8
  br label %extract_sift_loop_cond

extract_sift_loop_cond:                            ; preds = %extract_do_swap, %extract_body
  %56 = load i64, i64* %parent, align 8
  %57 = shl i64 %56, 1
  %58 = add i64 %57, 1
  store i64 %58, i64* %child2, align 8
  %59 = load i64, i64* %child2, align 8
  %60 = load i64, i64* %end, align 8
  %61 = icmp ult i64 %59, %60
  br i1 %61, label %extract_has_child, label %extract_endof_loop

extract_has_child:                                 ; preds = %extract_sift_loop_cond
  %62 = load i64, i64* %child2, align 8
  %63 = add i64 %62, 1
  store i64 %63, i64* %right2, align 8
  %64 = load i64, i64* %right2, align 8
  %65 = load i64, i64* %end, align 8
  %66 = icmp ult i64 %64, %65
  br i1 %66, label %extract_compare_children, label %extract_set_largest_child

extract_compare_children:                          ; preds = %extract_has_child
  %67 = load i32*, i32** %arr.addr, align 8
  %68 = load i64, i64* %right2, align 8
  %69 = getelementptr inbounds i32, i32* %67, i64 %68
  %70 = load i32, i32* %69, align 4
  %71 = load i32*, i32** %arr.addr, align 8
  %72 = load i64, i64* %child2, align 8
  %73 = getelementptr inbounds i32, i32* %71, i64 %72
  %74 = load i32, i32* %73, align 4
  %75 = icmp sgt i32 %70, %74
  br i1 %75, label %extract_set_largest_right, label %extract_set_largest_child

extract_set_largest_right:                         ; preds = %extract_compare_children
  %76 = load i64, i64* %right2, align 8
  store i64 %76, i64* %largest2, align 8
  br label %extract_after_choose_largest

extract_set_largest_child:                         ; preds = %extract_compare_children, %extract_has_child
  %77 = load i64, i64* %child2, align 8
  store i64 %77, i64* %largest2, align 8
  br label %extract_after_choose_largest

extract_after_choose_largest:                      ; preds = %extract_set_largest_child, %extract_set_largest_right
  %78 = load i32*, i32** %arr.addr, align 8
  %79 = load i64, i64* %parent, align 8
  %80 = getelementptr inbounds i32, i32* %78, i64 %79
  %81 = load i32, i32* %80, align 4
  %82 = load i32*, i32** %arr.addr, align 8
  %83 = load i64, i64* %largest2, align 8
  %84 = getelementptr inbounds i32, i32* %82, i64 %83
  %85 = load i32, i32* %84, align 4
  %86 = icmp sge i32 %81, %85
  br i1 %86, label %extract_break_to_after_percolate, label %extract_do_swap

extract_do_swap:                                   ; preds = %extract_after_choose_largest
  store i32 %81, i32* %tmp2, align 4
  %87 = load i32*, i32** %arr.addr, align 8
  %88 = getelementptr inbounds i32, i32* %87, i64 %79
  store i32 %85, i32* %88, align 4
  %89 = load i32*, i32** %arr.addr, align 8
  %90 = getelementptr inbounds i32, i32* %89, i64 %83
  %91 = load i32, i32* %tmp2, align 4
  store i32 %91, i32* %90, align 4
  store i64 %83, i64* %parent, align 8
  br label %extract_sift_loop_cond

extract_break_to_after_percolate:                  ; preds = %extract_after_choose_largest
  br label %extract_endof_loop

extract_endof_loop:                                ; preds = %extract_break_to_after_percolate, %extract_sift_loop_cond
  %92 = load i64, i64* %end, align 8
  %93 = add i64 %92, -1
  store i64 %93, i64* %end, align 8
  br label %extract_loop_check

epilog:                                            ; preds = %extract_loop_check, %entry
  ret void
}