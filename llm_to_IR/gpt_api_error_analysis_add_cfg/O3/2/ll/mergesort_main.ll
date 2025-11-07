; ModuleID = 'fixed_module'
source_filename = "fixed_module.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ret i32 0
}