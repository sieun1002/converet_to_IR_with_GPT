; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = INF\0A\00"
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"
@aNoPathFromZuTo = private unnamed_addr constant [25 x i8] c"no path from %zu to %zu\0A\00"
@aPathZuZu = private unnamed_addr constant [17 x i8] c"path %zu -> %zu:\00"
@asc_140004059 = private unnamed_addr constant [4 x i8] c" ->\00"
@unk_14000405D = private unnamed_addr constant [1 x i8] zeroinitializer
@aZuS = private unnamed_addr constant [7 x i8] c" %zu%s\00"

declare void @dijkstra(i32* noundef, i64 noundef, i64 noundef, i8* noundef, i32* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %graph = alloca [36 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %dist = alloca [6 x i32], align 16
  %prev = alloca [6 x i32], align 16
  %source = alloca i64, align 8
  %iter = alloca i64, align 8
  %dest = alloca i64, align 8
  %pathcount = alloca i64, align 8
  %cur = alloca i32, align 4
  %path = alloca [16 x i64], align 16
  %tmp = alloca i64, align 8
  %k = alloca i64, align 8
  store i64 6, i64* %n, align 8
  store i64 0, i64* %i, align 8
  br label %loop_init

loop_init:                                        ; preds = %fill, %entry
  %i_val = load i64, i64* %i, align 8
  %n_val = load i64, i64* %n, align 8
  %mul = mul i64 %n_val, %n_val
  %cmp = icmp ult i64 %i_val, %mul
  br i1 %cmp, label %fill, label %after_fill

fill:                                             ; preds = %loop_init
  %graphptr0 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %i_val
  store i32 -1, i32* %graphptr0, align 4
  %i_inc = add i64 %i_val, 1
  store i64 %i_inc, i64* %i, align 8
  br label %loop_init

after_fill:                                       ; preds = %loop_init
  store i64 0, i64* %j, align 8
  br label %diag_loop

diag_loop:                                        ; preds = %diag_body, %after_fill
  %j_val = load i64, i64* %j, align 8
  %n_val2 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %j_val, %n_val2
  br i1 %cmp2, label %diag_body, label %after_diag

diag_body:                                        ; preds = %diag_loop
  %n_plus1 = add i64 %n_val2, 1
  %idx_diag = mul i64 %n_plus1, %j_val
  %graphptrd = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %idx_diag
  store i32 0, i32* %graphptrd, align 4
  %j_inc = add i64 %j_val, 1
  store i64 %j_inc, i64* %j, align 8
  br label %diag_loop

after_diag:                                       ; preds = %diag_loop
  %p1 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 1
  store i32 7, i32* %p1, align 4
  %n3 = load i64, i64* %n, align 8
  %pn = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %n3
  store i32 7, i32* %pn, align 4
  %p2 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 2
  store i32 9, i32* %p2, align 4
  %n4 = load i64, i64* %n, align 8
  %twon = add i64 %n4, %n4
  %p2n = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %twon
  store i32 9, i32* %p2n, align 4
  %p3 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 3
  store i32 10, i32* %p3, align 4
  %n5 = load i64, i64* %n, align 8
  %threen = add i64 %n5, %n5
  %threen2 = add i64 %threen, %n5
  %p3n = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %threen2
  store i32 10, i32* %p3n, align 4
  %n6 = load i64, i64* %n, align 8
  %n_plus3 = add i64 %n6, 3
  %pn3 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %n_plus3
  store i32 15, i32* %pn3, align 4
  %n7 = load i64, i64* %n, align 8
  %thn = add i64 %n7, %n7
  %thn3 = add i64 %thn, %n7
  %thn3p1 = add i64 %thn3, 1
  %p3n1 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %thn3p1
  store i32 15, i32* %p3n1, align 4
  %n8 = load i64, i64* %n, align 8
  %twon2 = add i64 %n8, %n8
  %twon2p3 = add i64 %twon2, 3
  %p2n3 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %twon2p3
  store i32 11, i32* %p2n3, align 4
  %n9 = load i64, i64* %n, align 8
  %thn_b = add i64 %n9, %n9
  %thn_b2 = add i64 %thn_b, %n9
  %thn_b2p2 = add i64 %thn_b2, 2
  %p3n2 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %thn_b2p2
  store i32 11, i32* %p3n2, align 4
  %n10 = load i64, i64* %n, align 8
  %thn_c = add i64 %n10, %n10
  %thn_c2 = add i64 %thn_c, %n10
  %thn_c2p4 = add i64 %thn_c2, 4
  %p3n4 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %thn_c2p4
  store i32 6, i32* %p3n4, align 4
  %n11 = load i64, i64* %n, align 8
  %four = shl i64 %n11, 2
  %fourp3 = add i64 %four, 3
  %p4n3 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %fourp3
  store i32 6, i32* %p4n3, align 4
  %n12 = load i64, i64* %n, align 8
  %four2 = shl i64 %n12, 2
  %four2p5 = add i64 %four2, 5
  %p4n5 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %four2p5
  store i32 9, i32* %p4n5, align 4
  %n13 = load i64, i64* %n, align 8
  %four3 = shl i64 %n13, 2
  %five_n = add i64 %four3, %n13
  %five_n_p4 = add i64 %five_n, 4
  %p5n4 = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 %five_n_p4
  store i32 9, i32* %p5n4, align 4
  store i64 0, i64* %source, align 8
  %graph_ptr = getelementptr inbounds [36 x i32], [36 x i32]* %graph, i64 0, i64 0
  %n_val_call = load i64, i64* %n, align 8
  %src_val = load i64, i64* %source, align 8
  %prev_ptr = getelementptr inbounds [6 x i32], [6 x i32]* %prev, i64 0, i64 0
  %rbp_proxy = bitcast i64* %n to i8*
  call void @dijkstra(i32* %graph_ptr, i64 %n_val_call, i64 %src_val, i8* %rbp_proxy, i32* %prev_ptr)
  store i64 0, i64* %iter, align 8
  br label %dist_loop

dist_loop:                                        ; preds = %dist_next, %after_diag
  %itv = load i64, i64* %iter, align 8
  %n_val3 = load i64, i64* %n, align 8
  %cmp_it = icmp ult i64 %itv, %n_val3
  br i1 %cmp_it, label %dist_body, label %after_dist_loop

dist_body:                                        ; preds = %dist_loop
  %dist_ptr_i = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %itv
  %dval = load i32, i32* %dist_ptr_i, align 4
  %th = icmp sle i32 %dval, 1061109566
  br i1 %th, label %dist_print_val, label %dist_print_inf

dist_print_inf:                                   ; preds = %dist_body
  %dst_idx_inf = load i64, i64* %iter, align 8
  %src0_inf = load i64, i64* %source, align 8
  %fmt_inf_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %call_inf = call i32 (i8*, ...) @printf(i8* %fmt_inf_ptr, i64 %src0_inf, i64 %dst_idx_inf)
  br label %dist_next

dist_print_val:                                   ; preds = %dist_body
  %dst_idx = load i64, i64* %iter, align 8
  %val_ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %dst_idx
  %val = load i32, i32* %val_ptr, align 4
  %src0 = load i64, i64* %source, align 8
  %fmt_val_ptr = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %call_val = call i32 (i8*, ...) @printf(i8* %fmt_val_ptr, i64 %src0, i64 %dst_idx, i32 %val)
  br label %dist_next

dist_next:                                        ; preds = %dist_print_val, %dist_print_inf
  %itv2 = load i64, i64* %iter, align 8
  %itv2_inc = add i64 %itv2, 1
  store i64 %itv2_inc, i64* %iter, align 8
  br label %dist_loop

after_dist_loop:                                  ; preds = %dist_loop
  store i64 5, i64* %dest, align 8
  %dest_idx = load i64, i64* %dest, align 8
  %dist_dest_ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %dest_idx
  %dist_dest = load i32, i32* %dist_dest_ptr, align 4
  %okcmp = icmp sle i32 %dist_dest, 1061109566
  br i1 %okcmp, label %has_path, label %no_path

no_path:                                          ; preds = %after_dist_loop
  %desti = load i64, i64* %dest, align 8
  %srcno = load i64, i64* %source, align 8
  %fmt_np = getelementptr inbounds [25 x i8], [25 x i8]* @aNoPathFromZuTo, i64 0, i64 0
  %call_np = call i32 (i8*, ...) @printf(i8* %fmt_np, i64 %srcno, i64 %desti)
  br label %ret_block

has_path:                                         ; preds = %after_dist_loop
  store i64 0, i64* %pathcount, align 8
  %dest_i32 = trunc i64 %dest_idx to i32
  store i32 %dest_i32, i32* %cur, align 4
  br label %path_build_loop

path_build_loop:                                  ; preds = %path_build_body, %has_path
  %cur_val = load i32, i32* %cur, align 4
  %cur_not_neg1 = icmp ne i32 %cur_val, -1
  br i1 %cur_not_neg1, label %path_build_body, label %after_path_build

path_build_body:                                  ; preds = %path_build_loop
  %pcnt = load i64, i64* %pathcount, align 8
  %pcnt_next = add i64 %pcnt, 1
  store i64 %pcnt_next, i64* %pathcount, align 8
  %cur_sext = sext i32 %cur_val to i64
  %path_slot = getelementptr inbounds [16 x i64], [16 x i64]* %path, i64 0, i64 %pcnt
  store i64 %cur_sext, i64* %path_slot, align 8
  %cur_idx = sext i32 %cur_val to i64
  %prev_elem_ptr = getelementptr inbounds [6 x i32], [6 x i32]* %prev, i64 0, i64 %cur_idx
  %prev_elem = load i32, i32* %prev_elem_ptr, align 4
  store i32 %prev_elem, i32* %cur, align 4
  br label %path_build_loop

after_path_build:                                 ; preds = %path_build_loop
  %src_path = load i64, i64* %source, align 8
  %dst_path = load i64, i64* %dest, align 8
  %fmt_path = getelementptr inbounds [17 x i8], [17 x i8]* @aPathZuZu, i64 0, i64 0
  %call_path = call i32 (i8*, ...) @printf(i8* %fmt_path, i64 %src_path, i64 %dst_path)
  store i64 0, i64* %k, align 8
  br label %print_path_loop

print_path_loop:                                  ; preds = %print_item, %after_path_build
  %kval = load i64, i64* %k, align 8
  %pcnt2 = load i64, i64* %pathcount, align 8
  %cmpk = icmp ult i64 %kval, %pcnt2
  br i1 %cmpk, label %print_path_body, label %after_print_path

print_path_body:                                  ; preds = %print_path_loop
  %pcnt3 = load i64, i64* %pathcount, align 8
  %sub1 = sub i64 %pcnt3, %kval
  %sub2 = sub i64 %sub1, 1
  %path_elem_ptr = getelementptr inbounds [16 x i64], [16 x i64]* %path, i64 0, i64 %sub2
  %path_elem = load i64, i64* %path_elem_ptr, align 8
  store i64 %path_elem, i64* %tmp, align 8
  %kadd1 = add i64 %kval, 1
  %cmp_end = icmp uge i64 %kadd1, %pcnt3
  br i1 %cmp_end, label %choose_empty, label %choose_arrow

choose_arrow:                                     ; preds = %print_path_body
  %sep_arrow = getelementptr inbounds [4 x i8], [4 x i8]* @asc_140004059, i64 0, i64 0
  br label %print_item

choose_empty:                                     ; preds = %print_path_body
  %sep_empty = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000405D, i64 0, i64 0
  br label %print_item

print_item:                                       ; preds = %choose_empty, %choose_arrow
  %phi_sep = phi i8* [ %sep_arrow, %choose_arrow ], [ %sep_empty, %choose_empty ]
  %fmt_item = getelementptr inbounds [7 x i8], [7 x i8]* @aZuS, i64 0, i64 0
  %val_print = load i64, i64* %tmp, align 8
  %call_item = call i32 (i8*, ...) @printf(i8* %fmt_item, i64 %val_print, i8* %phi_sep)
  %kinc = add i64 %kval, 1
  store i64 %kinc, i64* %k, align 8
  br label %print_path_loop

after_print_path:                                 ; preds = %print_path_loop
  %nl = call i32 @putchar(i32 10)
  br label %ret_block

ret_block:                                        ; preds = %after_print_path, %no_path
  ret i32 0
}