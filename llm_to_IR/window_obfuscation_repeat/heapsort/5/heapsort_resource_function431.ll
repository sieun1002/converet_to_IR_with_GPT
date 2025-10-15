; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

define i32 @main(i32 %argc, i8** %argv) {
entry:
  ret i32 0
}