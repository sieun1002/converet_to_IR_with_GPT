# 빌드 코드
from ll_build_module import build_and_run_two_ll

result = build_and_run_two_ll(
    "/path/to/A.ll",
    "/path/to/A_main.ll",
    out_dir="/path/to/build",   # 생략하면 A.ll과 같은 폴더에 생성
    opt_level="O0",
    run_timeout_sec=15,
)

# 지피티 수정 코드
from ir_fix_module import rewrite_ir

bad = open("broken.ll","r",encoding="utf-8").read()
err = open("compile.err","r",encoding="utf-8").read()

good_IR = rewrite_ir(bad, err, model="gpt-5")


# 지피티 생성 코드
from txt_to_ll_module import generate_ll_from_txt

result = generate_ll_from_txt(
    "/path/to/input.txt",
    output_dir="./build_ll",
    model="gpt-5",
)
# result: {"ll_path": ".../build_ll/input.ll", "elapsed_sec": 1.234567, "error": None}
print(result)