; ModuleID = 'xtime'
source_filename = "xtime"

define dso_local zeroext i8 @xtime(i8 zeroext %x) local_unnamed_addr {
entry:
  %x32 = zext i8 %x to i32
  %twice = add i32 %x32, %x32
  %msb0 = lshr i32 %x32, 7
  %msb1 = and i32 %msb0, 1
  %t1 = add i32 %msb1, %msb1        ; 2*msb
  %t2 = add i32 %t1, %msb1          ; 3*msb
  %t3 = shl i32 %t2, 3              ; 24*msb
  %mul27 = add i32 %t2, %t3         ; 27*msb
  %res32 = xor i32 %mul27, %twice
  %res8 = trunc i32 %res32 to i8
  ret i8 %res8
}