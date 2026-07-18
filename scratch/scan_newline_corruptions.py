import os

docs_dir = 'docs'
suffixes = [
    b'ame', b'utrition_info', b'ew_value', b'pm ', b'avigation', 
    b'otification', b'etwork', b'otes', b'ormal', b'umber', b'ode'
]

for root, dirs, files in os.walk(docs_dir):
    for file in files:
        if file.endswith('.md'):
            path = os.path.join(root, file).replace('\\', '/')
            try:
                with open(path, 'rb') as f:
                    lines = f.readlines()
                
                for idx, line in enumerate(lines):
                    # Check if line starts with any of the suffixes
                    # (allowing for leading spaces if it's a list item, but usually it's at the start of a line because of the newline)
                    stripped = line.lstrip()
                    for suffix in suffixes:
                        if stripped.startswith(suffix):
                            # Print the previous line and current line
                            prev_line = lines[idx-1] if idx > 0 else b""
                            print(f"{path}:{idx+1}:")
                            print(f"  Prev: {repr(prev_line)}")
                            print(f"  Curr: {repr(line)}")
            except Exception as e:
                print(f"Error reading {path}: {e}")
