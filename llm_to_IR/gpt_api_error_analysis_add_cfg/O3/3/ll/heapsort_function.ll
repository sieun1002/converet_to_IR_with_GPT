; ModuleID = 'heap_sort_module'
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
loc_1189:
  %var_68 = alloca i32*, align 8
  %var_70 = alloca i64, align 8
  %var_50 = alloca i64, align 8
  %var_48 = alloca i64, align 8
  %var_18 = alloca i64, align 8
  %var_10 = alloca i64, align 8
  %var_8 = alloca i64, align 8
  %var_54 = alloca i32, align 4
  %var_5C = alloca i32, align 4
  %var_58 = alloca i32, align 4
  %var_40 = alloca i64, align 8
  %var_38 = alloca i64, align 8
  %var_30 = alloca i64, align 8
  %var_28 = alloca i64, align 8
  %var_20 = alloca i64, align 8
  store i32* %arr, i32** %var_68, align 8
  store i64 %n, i64* %var_70, align 8
  %n_load0 = load i64, i64* %var_70, align 8
  %cmp_u_le_1 = icmp ule i64 %n_load0, 1
  br i1 %cmp_u_le_1, label %loc_1448, label %loc_after_119e

loc_after_119e:
  %n_load1 = load i64, i64* %var_70, align 8
  %shr1 = lshr i64 %n_load1, 1
  store i64 %shr1, i64* %var_50, align 8
  br label %loc_12C4

loc_11B4:
  %v50_load_11b4 = load i64, i64* %var_50, align 8
  store i64 %v50_load_11b4, i64* %var_48, align 8
  br label %loc_11BC

loc_11BC:
  %v48_load_11bc = load i64, i64* %var_48, align 8
  %tmp_dbl_11bc = add i64 %v48_load_11bc, %v48_load_11bc
  %tmp_add1_11bc = add i64 %tmp_dbl_11bc, 1
  store i64 %tmp_add1_11bc, i64* %var_18, align 8
  %val18_load_11cb = load i64, i64* %var_18, align 8
  %n_load_11cf = load i64, i64* %var_70, align 8
  %cmp_jnb_11d3 = icmp uge i64 %val18_load_11cb, %n_load_11cf
  br i1 %cmp_jnb_11d3, label %loc_12C0, label %loc_after_11d3

loc_after_11d3:
  %val18_load_11d9 = load i64, i64* %var_18, align 8
  %add1_11dd = add i64 %val18_load_11d9, 1
  store i64 %add1_11dd, i64* %var_10, align 8
  %v10_load_11e5 = load i64, i64* %var_10, align 8
  %n_load_11e9 = load i64, i64* %var_70, align 8
  %cmp_jnb_11ed = icmp uge i64 %v10_load_11e5, %n_load_11e9
  br i1 %cmp_jnb_11ed, label %loc_1223, label %loc_after_11ed

loc_after_11ed:
  %arr_load_11fb = load i32*, i32** %var_68, align 8
  %idx10_load_11ef = load i64, i64* %var_10, align 8
  %elem10ptr_11f3 = getelementptr inbounds i32, i32* %arr_load_11fb, i64 %idx10_load_11ef
  %edx_1202 = load i32, i32* %elem10ptr_11f3, align 4
  %arr_load_1210 = load i32*, i32** %var_68, align 8
  %idx18_load_1204 = load i64, i64* %var_18, align 8
  %elem18ptr_1214 = getelementptr inbounds i32, i32* %arr_load_1210, i64 %idx18_load_1204
  %eax_1217 = load i32, i32* %elem18ptr_1214, align 4
  %cmp_jle_121b = icmp sle i32 %edx_1202, %eax_1217
  br i1 %cmp_jle_121b, label %loc_1223, label %loc_121D

loc_121D:
  %v10_load_121d = load i64, i64* %var_10, align 8
  br label %loc_1227

loc_1223:
  %v18_load_1223 = load i64, i64* %var_18, align 8
  br label %loc_1227

loc_1227:
  %phi_rax_1227 = phi i64 [ %v10_load_121d, %loc_121D ], [ %v18_load_1223, %loc_1223 ]
  store i64 %phi_rax_1227, i64* %var_8, align 8
  %arr_load_1237 = load i32*, i32** %var_68, align 8
  %v48_load_122b = load i64, i64* %var_48, align 8
  %elem48ptr_123b = getelementptr inbounds i32, i32* %arr_load_1237, i64 %v48_load_122b
  %edx_123e = load i32, i32* %elem48ptr_123b, align 4
  %arr_load_124c = load i32*, i32** %var_68, align 8
  %v8_load_1240 = load i64, i64* %var_8, align 8
  %elem8ptr_1250 = getelementptr inbounds i32, i32* %arr_load_124c, i64 %v8_load_1240
  %eax_1253 = load i32, i32* %elem8ptr_1250, align 4
  %cmp_jge_1257 = icmp sge i32 %edx_123e, %eax_1253
  br i1 %cmp_jge_1257, label %loc_12C3, label %loc_after_1257

loc_after_1257:
  %arr_load_1265 = load i32*, i32** %var_68, align 8
  %v48_load_1259 = load i64, i64* %var_48, align 8
  %elem48ptr_1269 = getelementptr inbounds i32, i32* %arr_load_1265, i64 %v48_load_1259
  %eax_126c = load i32, i32* %elem48ptr_1269, align 4
  store i32 %eax_126c, i32* %var_54, align 4
  %arr_load_127d = load i32*, i32** %var_68, align 8
  %v8_load_1271 = load i64, i64* %var_8, align 8
  %elem8ptr_1281 = getelementptr inbounds i32, i32* %arr_load_127d, i64 %v8_load_1271
  %val_from_v8_1297 = load i32, i32* %elem8ptr_1281, align 4
  %arr_load_1290 = load i32*, i32** %var_68, align 8
  %v48_load_1284 = load i64, i64* %var_48, align 8
  %elem48ptr_1294 = getelementptr inbounds i32, i32* %arr_load_1290, i64 %v48_load_1284
  store i32 %val_from_v8_1297, i32* %elem48ptr_1294, align 4
  %arr_load_12a7 = load i32*, i32** %var_68, align 8
  %v8_load_129b = load i64, i64* %var_8, align 8
  %elem8ptr_12ab = getelementptr inbounds i32, i32* %arr_load_12a7, i64 %v8_load_129b
  %tmp54_12ae = load i32, i32* %var_54, align 4
  store i32 %tmp54_12ae, i32* %elem8ptr_12ab, align 4
  %v8_load_12b3 = load i64, i64* %var_8, align 8
  store i64 %v8_load_12b3, i64* %var_48, align 8
  br label %loc_11BC

loc_12C0:
  br label %loc_12C4

loc_12C3:
  br label %loc_12C4

loc_12C4:
  %v50_load_12c4 = load i64, i64* %var_50, align 8
  %rdx_sub1_12c8 = add i64 %v50_load_12c4, -1
  store i64 %rdx_sub1_12c8, i64* %var_50, align 8
  %test_nz_12d0 = icmp ne i64 %v50_load_12c4, 0
  br i1 %test_nz_12d0, label %loc_11B4, label %loc_after_12d3

loc_after_12d3:
  %n_load_12d9 = load i64, i64* %var_70, align 8
  %sub1_12dd = add i64 %n_load_12d9, -1
  store i64 %sub1_12dd, i64* %var_40, align 8
  br label %loc_143B

loc_12EA:
  %arr_load_12ea = load i32*, i32** %var_68, align 8
  %elem0ptr_12ee = getelementptr inbounds i32, i32* %arr_load_12ea, i64 0
  %val0_12ee = load i32, i32* %elem0ptr_12ee, align 4
  store i32 %val0_12ee, i32* %var_5C, align 4
  %arr_load_12ff = load i32*, i32** %var_68, align 8
  %idx40_load_12f3 = load i64, i64* %var_40, align 8
  %elem40ptr_1303 = getelementptr inbounds i32, i32* %arr_load_12ff, i64 %idx40_load_12f3
  %edx_1306 = load i32, i32* %elem40ptr_1303, align 4
  %arr_load_1308 = load i32*, i32** %var_68, align 8
  %elem0ptr_130c = getelementptr inbounds i32, i32* %arr_load_1308, i64 0
  store i32 %edx_1306, i32* %elem0ptr_130c, align 4
  %arr_load_131a = load i32*, i32** %var_68, align 8
  %idx40_load_130e = load i64, i64* %var_40, align 8
  %elem40ptr_131e = getelementptr inbounds i32, i32* %arr_load_131a, i64 %idx40_load_130e
  %val5c_1321 = load i32, i32* %var_5C, align 4
  store i32 %val5c_1321, i32* %elem40ptr_131e, align 4
  store i64 0, i64* %var_38, align 8
  br label %loc_132E

loc_132E:
  %v38_load_132e = load i64, i64* %var_38, align 8
  %dbl_1332 = add i64 %v38_load_132e, %v38_load_132e
  %add1_1335 = add i64 %dbl_1332, 1
  store i64 %add1_1335, i64* %var_30, align 8
  %v30_load_133d = load i64, i64* %var_30, align 8
  %v40_load_1341 = load i64, i64* %var_40, align 8
  %cmp_jnb_1345 = icmp uge i64 %v30_load_133d, %v40_load_1341
  br i1 %cmp_jnb_1345, label %loc_1432, label %loc_after_1345

loc_after_1345:
  %v30_load_134b = load i64, i64* %var_30, align 8
  %add1_1353 = add i64 %v30_load_134b, 1
  store i64 %add1_1353, i64* %var_28, align 8
  %v28_load_1357 = load i64, i64* %var_28, align 8
  %v40_load_135b = load i64, i64* %var_40, align 8
  %cmp_jnb_135f = icmp uge i64 %v28_load_1357, %v40_load_135b
  br i1 %cmp_jnb_135f, label %loc_1395, label %loc_after_135f

loc_after_135f:
  %arr_load_136d = load i32*, i32** %var_68, align 8
  %v28_load_1361 = load i64, i64* %var_28, align 8
  %elem28ptr_1371 = getelementptr inbounds i32, i32* %arr_load_136d, i64 %v28_load_1361
  %edx_1374 = load i32, i32* %elem28ptr_1371, align 4
  %arr_load_1382 = load i32*, i32** %var_68, align 8
  %v30_load_1376 = load i64, i64* %var_30, align 8
  %elem30ptr_1386 = getelementptr inbounds i32, i32* %arr_load_1382, i64 %v30_load_1376
  %eax_1389 = load i32, i32* %elem30ptr_1386, align 4
  %cmp_jle_138d = icmp sle i32 %edx_1374, %eax_1389
  br i1 %cmp_jle_138d, label %loc_1395, label %loc_138F_path

loc_138F_path:
  %v28_load_138f = load i64, i64* %var_28, align 8
  br label %loc_1399

loc_1395:
  %v30_load_1395 = load i64, i64* %var_30, align 8
  br label %loc_1399

loc_1399:
  %phi_rax_1399 = phi i64 [ %v28_load_138f, %loc_138F_path ], [ %v30_load_1395, %loc_1395 ]
  store i64 %phi_rax_1399, i64* %var_20, align 8
  %arr_load_13a9 = load i32*, i32** %var_68, align 8
  %v38_load_139d = load i64, i64* %var_38, align 8
  %elem38ptr_13ad = getelementptr inbounds i32, i32* %arr_load_13a9, i64 %v38_load_139d
  %edx_13b0 = load i32, i32* %elem38ptr_13ad, align 4
  %arr_load_13be = load i32*, i32** %var_68, align 8
  %v20_load_13b2 = load i64, i64* %var_20, align 8
  %elem20ptr_13c2 = getelementptr inbounds i32, i32* %arr_load_13be, i64 %v20_load_13b2
  %eax_13c5 = load i32, i32* %elem20ptr_13c2, align 4
  %cmp_jge_13c9 = icmp sge i32 %edx_13b0, %eax_13c5
  br i1 %cmp_jge_13c9, label %loc_1435, label %loc_after_13c9

loc_after_13c9:
  %arr_load_13d7 = load i32*, i32** %var_68, align 8
  %v38_load_13cb = load i64, i64* %var_38, align 8
  %elem38ptr_13db = getelementptr inbounds i32, i32* %arr_load_13d7, i64 %v38_load_13cb
  %eax_13de = load i32, i32* %elem38ptr_13db, align 4
  store i32 %eax_13de, i32* %var_58, align 4
  %arr_load_13ef = load i32*, i32** %var_68, align 8
  %v20_load_13e3 = load i64, i64* %var_20, align 8
  %elem20ptr_13f3 = getelementptr inbounds i32, i32* %arr_load_13ef, i64 %v20_load_13e3
  %val_from_v20_1409 = load i32, i32* %elem20ptr_13f3, align 4
  %arr_load_1402 = load i32*, i32** %var_68, align 8
  %v38_load_13f6 = load i64, i64* %var_38, align 8
  %elem38ptr_1406 = getelementptr inbounds i32, i32* %arr_load_1402, i64 %v38_load_13f6
  store i32 %val_from_v20_1409, i32* %elem38ptr_1406, align 4
  %arr_load_1419 = load i32*, i32** %var_68, align 8
  %v20_load_140d = load i64, i64* %var_20, align 8
  %elem20ptr_141d = getelementptr inbounds i32, i32* %arr_load_1419, i64 %v20_load_140d
  %tmp58_1420 = load i32, i32* %var_58, align 4
  store i32 %tmp58_1420, i32* %elem20ptr_141d, align 4
  %v20_load_1425 = load i64, i64* %var_20, align 8
  store i64 %v20_load_1425, i64* %var_38, align 8
  br label %loc_132E

loc_1432:
  br label %loc_1436

loc_1435:
  br label %loc_1436

loc_1436:
  %v40_load_1436 = load i64, i64* %var_40, align 8
  %dec_1436 = add i64 %v40_load_1436, -1
  store i64 %dec_1436, i64* %var_40, align 8
  br label %loc_143B

loc_143B:
  %v40_load_143b = load i64, i64* %var_40, align 8
  %cmp_nz_1440 = icmp ne i64 %v40_load_143b, 0
  br i1 %cmp_nz_1440, label %loc_12EA, label %loc_after_1440

loc_after_1440:
  br label %loc_1449

loc_1448:
  br label %loc_1449

loc_1449:
  ret void
}