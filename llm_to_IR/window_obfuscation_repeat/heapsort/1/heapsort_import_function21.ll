; ModuleID = 'heapsort'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* %a, i64 %n) {
entry:
  %cmp_le1 = icmp ule i64 %n, 1
  br i1 %cmp_le1, label %ret, label %build_init

build_init:                                        ; preds = %entry
  %half = lshr i64 %n, 1
  %has_build = icmp ne i64 %half, 0
  br i1 %has_build, label %build_outer.header, label %phase2.prest

build_outer.header:                                ; preds = %build_init
  %i0 = add i64 %half, -1
  br label %build_outer.loop

build_outer.loop:                                  ; preds = %dec_i, %build_outer.header
  %i = phi i64 [ %i0, %build_outer.header ], [ %i.dec, %dec_i ]
  br label %build_sift.loop

build_sift.loop:                                   ; preds = %build_sift.afterSwap, %build_outer.loop
  %j = phi i64 [ %i, %build_outer.loop ], [ %m, %build_sift.afterSwap ]
  %j2 = shl i64 %j, 1
  %k = add i64 %j2, 1
  %cmp_k_n = icmp ult i64 %k, %n
  br i1 %cmp_k_n, label %childcheck, label %build_sift.end

childcheck:                                        ; preds = %build_sift.loop
  %r = add i64 %k, 1
  %r_in = icmp ult i64 %r, %n
  br i1 %r_in, label %load_children, label %choose_k

load_children:                                     ; preds = %childcheck
  %gep_r = getelementptr inbounds i32, i32* %a, i64 %r
  %val_r = load i32, i32* %gep_r, align 4
  %gep_k = getelementptr inbounds i32, i32* %a, i64 %k
  %val_k = load i32, i32* %gep_k, align 4
  %cmp_rk = icmp sgt i32 %val_r, %val_k
  br i1 %cmp_rk, label %choose_r, label %choose_k

choose_r:                                          ; preds = %load_children
  br label %after_choose

choose_k:                                          ; preds = %load_children, %childcheck
  br label %after_choose

after_choose:                                      ; preds = %choose_k, %choose_r
  %m = phi i64 [ %r, %choose_r ], [ %k, %choose_k ]
  %gep_j = getelementptr inbounds i32, i32* %a, i64 %j
  %val_j = load i32, i32* %gep_j, align 4
  %gep_m = getelementptr inbounds i32, i32* %a, i64 %m
  %val_m = load i32, i32* %gep_m, align 4
  %cmp_jm = icmp slt i32 %val_j, %val_m
  br i1 %cmp_jm, label %do_swap, label %build_sift.end

do_swap:                                           ; preds = %after_choose
  store i32 %val_m, i32* %gep_j, align 4
  store i32 %val_j, i32* %gep_m, align 4
  br label %build_sift.afterSwap

build_sift.afterSwap:                              ; preds = %do_swap
  br label %build_sift.loop

build_sift.end:                                    ; preds = %after_choose, %build_sift.loop
  br label %build_outer.afterSift

build_outer.afterSift:                             ; preds = %build_sift.end
  %is_zero = icmp eq i64 %i, 0
  br i1 %is_zero, label %phase2.prest, label %dec_i

dec_i:                                             ; preds = %build_outer.afterSift
  %i.dec = add i64 %i, -1
  br label %build_outer.loop

phase2.prest:                                      ; preds = %build_outer.afterSift, %build_init
  %nm1 = add i64 %n, -1
  br label %phase2.cond

phase2.cond:                                       ; preds = %phase2.afterExtract, %phase2.prest
  %heap_end = phi i64 [ %nm1, %phase2.prest ], [ %heap_end.dec, %phase2.afterExtract ]
  %cond = icmp ne i64 %heap_end, 0
  br i1 %cond, label %phase2.body, label %ret

phase2.body:                                       ; preds = %phase2.cond
  %gep0 = getelementptr inbounds i32, i32* %a, i64 0
  %val0 = load i32, i32* %gep0, align 4
  %gepend = getelementptr inbounds i32, i32* %a, i64 %heap_end
  %valend = load i32, i32* %gepend, align 4
  store i32 %valend, i32* %gep0, align 4
  store i32 %val0, i32* %gepend, align 4
  br label %phase2.sift.loop

phase2.sift.loop:                                  ; preds = %phase2.do_swap, %phase2.body
  %j_b = phi i64 [ 0, %phase2.body ], [ %m_b, %phase2.do_swap ]
  %j2_b = shl i64 %j_b, 1
  %k_b = add i64 %j2_b, 1
  %cmp_k_end = icmp ult i64 %k_b, %heap_end
  br i1 %cmp_k_end, label %phase2.childcheck, label %phase2.sift.end

phase2.childcheck:                                 ; preds = %phase2.sift.loop
  %r_b = add i64 %k_b, 1
  %r_in_b = icmp ult i64 %r_b, %heap_end
  br i1 %r_in_b, label %phase2.load_children, label %phase2.choose_k

phase2.load_children:                              ; preds = %phase2.childcheck
  %gep_r_b = getelementptr inbounds i32, i32* %a, i64 %r_b
  %val_r_b = load i32, i32* %gep_r_b, align 4
  %gep_k_b = getelementptr inbounds i32, i32* %a, i64 %k_b
  %val_k_b = load i32, i32* %gep_k_b, align 4
  %cmp_rk_b = icmp sgt i32 %val_r_b, %val_k_b
  br i1 %cmp_rk_b, label %phase2.choose_r, label %phase2.choose_k

phase2.choose_r:                                   ; preds = %phase2.load_children
  br label %phase2.after_choose

phase2.choose_k:                                   ; preds = %phase2.load_children, %phase2.childcheck
  br label %phase2.after_choose

phase2.after_choose:                               ; preds = %phase2.choose_k, %phase2.choose_r
  %m_b = phi i64 [ %r_b, %phase2.choose_r ], [ %k_b, %phase2.choose_k ]
  %gep_j_b = getelementptr inbounds i32, i32* %a, i64 %j_b
  %val_j_b = load i32, i32* %gep_j_b, align 4
  %gep_m_b = getelementptr inbounds i32, i32* %a, i64 %m_b
  %val_m_b = load i32, i32* %gep_m_b, align 4
  %cmp_jm_b = icmp slt i32 %val_j_b, %val_m_b
  br i1 %cmp_jm_b, label %phase2.do_swap, label %phase2.sift.end

phase2.do_swap:                                    ; preds = %phase2.after_choose
  store i32 %val_m_b, i32* %gep_j_b, align 4
  store i32 %val_j_b, i32* %gep_m_b, align 4
  br label %phase2.sift.loop

phase2.sift.end:                                   ; preds = %phase2.after_choose, %phase2.sift.loop
  br label %phase2.afterExtract

phase2.afterExtract:                               ; preds = %phase2.sift.end
  %heap_end.dec = add i64 %heap_end, -1
  br label %phase2.cond

ret:                                               ; preds = %phase2.cond, %entry
  ret void
}