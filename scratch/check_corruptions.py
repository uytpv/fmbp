import os

docs_dir = 'docs'

for root, dirs, files in os.walk(docs_dir):
    for file in files:
        if file.endswith('.md'):
            path = os.path.join(root, file).replace('\\', '/')
            try:
                with open(path, 'rb') as f:
                    content = f.read()
                
                # Find positions of control characters \x07, \x08, \x0b, \x0c
                for b in [7, 8, 11, 12]:
                    idx = 0
                    while True:
                        idx = content.find(bytes([b]), idx)
                        if idx == -1:
                            break
                        # Print context
                        start = max(0, idx - 30)
                        end = min(len(content), idx + 30)
                        context = content[start:end]
                        print(f"{path} (pos {idx}, char 0x{b:02x}):")
                        print(f"  Raw: {repr(context)}")
                        # Try to print as string, replacing control chars with hex
                        str_context = ""
                        for x in context:
                            if x in [7, 8, 11, 12]:
                                str_context += f"[0x{x:02x}]"
                            elif x == 13:
                                str_context += "\\r"
                            elif x == 10:
                                str_context += "\\n"
                            elif x >= 32 and x < 127:
                                str_context += chr(x)
                            else:
                                str_context += f"\\x{x:02x}"
                        print(f"  Str: {str_context}")
                        idx += 1
            except Exception as e:
                print(f"Error reading {path}: {e}")
