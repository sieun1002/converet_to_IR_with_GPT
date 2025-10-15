; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = INF\0A\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@aNoPathFromZuTo = private unnamed_addr constant [25 x i8] c"no path from %zu to %zu\0A\00", align 1
@aPathZuZu = private unnamed_addr constant [17 x i8] c"path %zu -> %zu:\00", align 1
@asc_140004059 = private unnamed_addr constant [4 x i8] c" ->\00", align 1
@unk_14000405D = private unnamed_addr constant [1 x i8] c"\00", align 1
@aZuS = private unnamed_addr constant [7 x i8] c" %zu%s\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @dijkstra(i32*, i64, i64, i32*, i32*)

define dso_local i32 @main() {
entry:
  %N = alloca i64, align 8
  %src = alloca i64, align 8
  %dest = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %cnt = alloca i64, align 8
  %k = alloca i64, align 8
  %cur = alloca i32, align 4
  %patharr = alloca [6 x i64], align 8
  %matrix = alloca [36 x i32], align 16
  %dist = alloca [6 x i32], align 16
  %prev = alloca [6 x i32], align 16
  store i64 6, i64* %N, align 8
  store i64 0, i64* %i, align 8
  br label %init_loop

init_loop:                                        ; preds = %init_body, %entry
  %i_val = load i64, i64* %i, align 8
  %N_val = load i64, i64* %N, align 8
  %NN = mul i64 %N_val, %N_val
  %cond = icmp ult i64 %i_val, %NN
  br i1 %cond, label %init_body, label %init_end

init_body:                                        ; preds = %init_loop
  %idx = load i64, i64* %i, align 8
  %matptr0 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %idx
  store i32 -1, i32* %matptr0, align 4
  %i_inc = add i64 %idx, 1
  store i64 %i_inc, i64* %i, align 8
  br label %init_loop

init_end:                                         ; preds = %init_loop
  store i64 0, i64* %j, align 8
  br label %diag_loop

diag_loop:                                        ; preds = %diag_body, %init_end
  %j_val = load i64, i64* %j, align 8
  %N_val2 = load i64, i64* %N, align 8
  %cmpj = icmp ult i64 %j_val, %N_val2
  br i1 %cmpj, label %diag_body, label %diag_end

diag_body:                                        ; preds = %diag_loop
  %N_plus1 = add i64 %N_val2, 1
  %idxd = mul i64 %j_val, %N_plus1
  %matptrd = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %idxd
  store i32 0, i32* %matptrd, align 4
  %j_inc = add i64 %j_val, 1
  store i64 %j_inc, i64* %j, align 8
  br label %diag_loop

diag_end:                                         ; preds = %diag_loop
  %N3 = load i64, i64* %N, align 8
  %pN = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %N3
  store i32 7, i32* %pN, align 4
  %twoN = mul i64 %N3, 2
  %p2N = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %twoN
  store i32 9, i32* %p2N, align 4
  %threeN = mul i64 %N3, 3
  %p3N = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %threeN
  store i32 10, i32* %p3N, align 4
  %Nplus3 = add i64 %N3, 3
  %pNplus3 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %Nplus3
  store i32 15, i32* %pNplus3, align 4
  %threeNplus1 = add i64 %threeN, 1
  %p3Nplus1 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %threeNplus1
  store i32 15, i32* %p3Nplus1, align 4
  %twoNplus3 = add i64 %twoN, 3
  %p2Nplus3 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %twoNplus3
  store i32 11, i32* %p2Nplus3, align 4
  %threeNplus2 = add i64 %threeN, 2
  %p3Nplus2 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %threeNplus2
  store i32 11, i32* %p3Nplus2, align 4
  %threeNplus4 = add i64 %threeN, 4
  %p3Nplus4 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %threeNplus4
  store i32 6, i32* %p3Nplus4, align 4
  %fourN = mul i64 %N3, 4
  %fourNplus3 = add i64 %fourN, 3
  %p4Nplus3 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %fourNplus3
  store i32 6, i32* %p4Nplus3, align 4
  %fourNplus5 = add i64 %fourN, 5
  %p4Nplus5 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %fourNplus5
  store i32 9, i32* %p4Nplus5, align 4
  %fiveN = mul i64 %N3, 5
  %fiveNplus4 = add i64 %fiveN, 4
  %p5Nplus4 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %fiveNplus4
  store i32 9, i32* %p5Nplus4, align 4
  store i64 0, i64* %src, align 8
  %matptr = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 0
  %distptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 0
  %prevptr = getelementptr inbounds [6 x i32], [6 x i32]* %prev, i64 0, i64 0
  %N_arg = load i64, i64* %N, align 8
  %src_arg = load i64, i64* %src, align 8
  call void @dijkstra(i32* %matptr, i64 %N_arg, i64 %src_arg, i32* %distptr, i32* %prevptr)
  store i64 0, i64* %i, align 8
  br label %dist_loop

dist_loop:                                        ; preds = %after_print, %diag_end
  %i2 = load i64, i64* %i, align 8
  %N4 = load i64, i64* %N, align 8
  %cond2 = icmp ult i64 %i2, %N4
  br i1 %cond2, label %dist_body, label %dist_end

dist_body:                                        ; preds = %dist_loop
  %di_ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %i2
  %di_val = load i32, i32* %di_ptr, align 4
  %thresh = icmp sgt i32 %di_val, 1061109566
  br i1 %thresh, label %print_inf, label %print_val

print_inf:                                        ; preds = %dist_body
  %src2 = load i64, i64* %src, align 8
  %i2_for_printf = load i64, i64* %i, align 8
  %fmt_inf_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt_inf_ptr, i64 %src2, i64 %i2_for_printf)
  br label %after_print

print_val:                                        ; preds = %dist_body
  %src3 = load i64, i64* %src, align 8
  %i3 = load i64, i64* %i, align 8
  %di_val2 = load i32, i32* %di_ptr, align 4
  %fmt_val_ptr = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt_val_ptr, i64 %src3, i64 %i3, i32 %di_val2)
  br label %after_print

after_print:                                      ; preds = %print_val, %print_inf
  %i_next = add i64 %i2, 1
  store i64 %i_next, i64* %i, align 8
  br label %dist_loop

dist_end:                                         ; preds = %dist_loop
  store i64 5, i64* %dest, align 8
  %dest_idx = load i64, i64* %dest, align 8
  %dest_d_ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %dest_idx
  %dest_d_val = load i32, i32* %dest_d_ptr, align 4
  %is_inf = icmp sgt i32 %dest_d_val, 1061109566
  br i1 %is_inf, label %print_no_path, label %has_path

print_no_path:                                    ; preds = %dist_end
  %src4 = load i64, i64* %src, align 8
  %dest4 = load i64, i64* %dest, align 8
  %fmt_np = getelementptr inbounds [25 x i8], [25 x i8]* @aNoPathFromZuTo, i64 0, i64 0
  %callnp = call i32 (i8*, ...) @printf(i8* %fmt_np, i64 %src4, i64 %dest4)
  br label %ret

has_path:                                         ; preds = %dist_end
  store i64 0, i64* %cnt, align 8
  %dest_i32 = trunc i64 %dest_idx to i32
  store i32 %dest_i32, i32* %cur, align 4
  br label %build_loop

build_loop:                                       ; preds = %build_body, %has_path
  %curv = load i32, i32* %cur, align 4
  %neq = icmp ne i32 %curv, -1
  br i1 %neq, label %build_body, label %build_end

build_body:                                       ; preds = %build_loop
  %count = load i64, i64* %cnt, align 8
  %cur_sext = sext i32 %curv to i64
  %path_slot = getelementptr inbounds [6 x i64], [6 x i64]* %patharr, i64 0, i64 %count
  store i64 %cur_sext, i64* %path_slot, align 8
  %count_next = add i64 %count, 1
  store i64 %count_next, i64* %cnt, align 8
  %cur_idx64 = sext i32 %curv to i64
  %prev_ptr_i32 = getelementptr inbounds [6 x i32], [6 x i32]* %prev, i64 0, i64 %cur_idx64
  %prev_val_i32 = load i32, i32* %prev_ptr_i32, align 4
  store i32 %prev_val_i32, i32* %cur, align 4
  br label %build_loop

build_end:                                        ; preds = %build_loop
  %src5 = load i64, i64* %src, align 8
  %dest5 = load i64, i64* %dest, align 8
  %fmt_path = getelementptr inbounds [17 x i8], [17 x i8]* @aPathZuZu, i64 0, i64 0
  %callpath = call i32 (i8*, ...) @printf(i8* %fmt_path, i64 %src5, i64 %dest5)
  store i64 0, i64* %k, align 8
  br label %print_path_loop

print_path_loop:                                  ; preds = %print_path_body, %build_end
  %kval = load i64, i64* %k, align 8
  %cntv = load i64, i64* %cnt, align 8
  %condk = icmp ult i64 %kval, %cntv
  br i1 %condk, label %print_path_body, label %after_path

print_path_body:                                  ; preds = %print_path_loop
  %tmp1 = sub i64 %cntv, %kval
  %tmp2 = sub i64 %tmp1, 1
  %pelem_ptr = getelementptr inbounds [6 x i64], [6 x i64]* %patharr, i64 0, i64 %tmp2
  %pelem = load i64, i64* %pelem_ptr, align 8
  %kplus1 = add i64 %kval, 1
  %cmpk = icmp ult i64 %kplus1, %cntv
  %arrow_then = getelementptr inbounds [4 x i8], [4 x i8]* @asc_140004059, i64 0, i64 0
  %arrow_else = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000405D, i64 0, i64 0
  %arrow = select i1 %cmpk, i8* %arrow_then, i8* %arrow_else
  %fmt_elem = getelementptr inbounds [7 x i8], [7 x i8]* @aZuS, i64 0, i64 0
  %callelem = call i32 (i8*, ...) @printf(i8* %fmt_elem, i64 %pelem, i8* %arrow)
  %k_next = add i64 %kval, 1
  store i64 %k_next, i64* %k, align 8
  br label %print_path_loop

after_path:                                       ; preds = %print_path_loop
  %nl = call i32 @putchar(i32 10)
  br label %ret

ret:                                              ; preds = %after_path, %print_no_path
  ret i32 0
}