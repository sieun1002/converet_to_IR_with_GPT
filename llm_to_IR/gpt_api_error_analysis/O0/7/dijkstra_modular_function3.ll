; target
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; externs
declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(i8*, i32)
declare void @add_edge(i8*, i32, i32, i32, i32)

; format strings
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1

; int read_graph(void* g, int* n_ptr, int* src_ptr)
define i32 @read_graph(i8* %g, i32* %n_ptr, i32* %src_ptr) local_unnamed_addr {
entry:
  %m.addr = alloca i32, align 4
  %i.addr = alloca i32, align 4
  %u.addr = alloca i32, align 4
  %v.addr = alloca i32, align 4
  %w.addr = alloca i32, align 4
  %ret.addr = alloca i32, align 4
  %fmt2.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str3, i64 0, i64 3
  %scan1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2.ptr, i32* %n_ptr, i32* %m.addr)
  %cmp.scan1 = icmp eq i32 %scan1, 2
  br i1 %cmp.scan1, label %check_nm, label %set_err1

set_err1:
  store i32 -1, i32* %ret.addr, align 4
  br label %retblock

check_nm:
  %n.load1 = load i32, i32* %n_ptr, align 4
  %cmp.n.gt0 = icmp sgt i32 %n.load1, 0
  br i1 %cmp.n.gt0, label %check_n_le_100, label %set_err2

set_err2:
  store i32 -1, i32* %ret.addr, align 4
  br label %retblock

check_n_le_100:
  %n.load2 = load i32, i32* %n_ptr, align 4
  %cmp.n.le100 = icmp sle i32 %n.load2, 100
  br i1 %cmp.n.le100, label %check_m_ge0, label %set_err3

set_err3:
  store i32 -1, i32* %ret.addr, align 4
  br label %retblock

check_m_ge0:
  %m.load1 = load i32, i32* %m.addr, align 4
  %cmp.m.ge0 = icmp sge i32 %m.load1, 0
  br i1 %cmp.m.ge0, label %init_graph_block, label %set_err4

set_err4:
  store i32 -1, i32* %ret.addr, align 4
  br label %retblock

init_graph_block:
  %n.load3 = load i32, i32* %n_ptr, align 4
  call void @init_graph(i8* %g, i32 %n.load3)
  store i32 0, i32* %i.addr, align 4
  br label %loop.header

loop.header:
  %i.cur = load i32, i32* %i.addr, align 4
  %m.load2 = load i32, i32* %m.addr, align 4
  %cmp.i.m = icmp slt i32 %i.cur, %m.load2
  br i1 %cmp.i.m, label %read_edge, label %post_loop

read_edge:
  %fmt3.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str3, i64 0, i64 0
  %scan3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3.ptr, i32* %u.addr, i32* %v.addr, i32* %w.addr)
  %cmp.scan3 = icmp eq i32 %scan3, 3
  br i1 %cmp.scan3, label %check_u_ge0, label %set_err5

set_err5:
  store i32 -1, i32* %ret.addr, align 4
  br label %retblock

check_u_ge0:
  %u.load1 = load i32, i32* %u.addr, align 4
  %cmp.u.ge0 = icmp sge i32 %u.load1, 0
  br i1 %cmp.u.ge0, label %check_u_lt_n, label %set_err6

set_err6:
  store i32 -1, i32* %ret.addr, align 4
  br label %retblock

check_u_lt_n:
  %n.load4 = load i32, i32* %n_ptr, align 4
  %cmp.u.ltn = icmp slt i32 %u.load1, %n.load4
  br i1 %cmp.u.ltn, label %check_v_ge0, label %set_err7

set_err7:
  store i32 -1, i32* %ret.addr, align 4
  br label %retblock

check_v_ge0:
  %v.load1 = load i32, i32* %v.addr, align 4
  %cmp.v.ge0 = icmp sge i32 %v.load1, 0
  br i1 %cmp.v.ge0, label %check_v_lt_n, label %set_err8

set_err8:
  store i32 -1, i32* %ret.addr, align 4
  br label %retblock

check_v_lt_n:
  %n.load5 = load i32, i32* %n_ptr, align 4
  %cmp.v.ltn = icmp slt i32 %v.load1, %n.load5
  br i1 %cmp.v.ltn, label %add_edge_block, label %set_err9

set_err9:
  store i32 -1, i32* %ret.addr, align 4
  br label %retblock

add_edge_block:
  %w.load1 = load i32, i32* %w.addr, align 4
  call void @add_edge(i8* %g, i32 %u.load1, i32 %v.load1, i32 %w.load1, i32 1)
  %i.cur2 = load i32, i32* %i.addr, align 4
  %i.next = add nsw i32 %i.cur2, 1
  store i32 %i.next, i32* %i.addr, align 4
  br label %loop.header

post_loop:
  %fmt1.ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str1, i64 0, i64 0
  %scan.src = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1.ptr, i32* %src_ptr)
  %cmp.scan.src = icmp eq i32 %scan.src, 1
  br i1 %cmp.scan.src, label %check_src_ge0, label %set_err10

set_err10:
  store i32 -1, i32* %ret.addr, align 4
  br label %retblock

check_src_ge0:
  %src.load1 = load i32, i32* %src_ptr, align 4
  %cmp.src.ge0 = icmp sge i32 %src.load1, 0
  br i1 %cmp.src.ge0, label %check_src_lt_n, label %set_err11

set_err11:
  store i32 -1, i32* %ret.addr, align 4
  br label %retblock

check_src_lt_n:
  %n.load6 = load i32, i32* %n_ptr, align 4
  %cmp.src.ltn = icmp slt i32 %src.load1, %n.load6
  br i1 %cmp.src.ltn, label %success, label %set_err12

set_err12:
  store i32 -1, i32* %ret.addr, align 4
  br label %retblock

success:
  store i32 0, i32* %ret.addr, align 4
  br label %retblock

retblock:
  %retv = load i32, i32* %ret.addr, align 4
  ret i32 %retv
}