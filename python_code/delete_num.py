import os

def rename_files_in_folder(folder_path):
    for root, dirs, files in os.walk(folder_path):
        for filename in files:
            name, ext = os.path.splitext(filename)
            
            # 이름이 비어있지 않고 마지막 글자가 숫자인 경우
            if name and name[-1].isdigit():
                new_name = name[:-1] + ext
                old_path = os.path.join(root, filename)
                new_path = os.path.join(root, new_name)
                
                # 파일 이름 변경
                os.rename(old_path, new_path)
                print(f"Renamed: {filename} -> {new_name}")

if __name__ == "__main__":
    folder = r"/root/workspace/converet_to_IR_with_GPT/llm_to_IR/Meta_compiler_13b_ftd_1/O3/5"  # 수정해서 사용하세요
    rename_files_in_folder(folder)
