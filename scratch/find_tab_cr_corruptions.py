import os

docs_dir = 'docs'

for root, dirs, files in os.walk(docs_dir):
    for file in files:
        if file.endswith('.md'):
            path = os.path.join(root, file).replace('\\', '/')
            try:
                with open(path, 'rb') as f:
                    content = f.read()
                
                # Check for \x09 (tab) and \x0d (carriage return not followed by \x0a)
                # Tab is normal for indentation, so we only print if tab is followed by an alphanumeric character
                idx = 0
                while True:
                    idx = content.find(b'\x09', idx)
                    if idx == -1:
                        break
                    # check if followed by alphanumeric
                    if idx + 1 < len(content) and chr(content[idx+1]).isalnum():
                        start = max(0, idx - 20)
                        end = min(len(content), idx + 20)
                        print(f"TAB corruption in {path} (pos {idx}): {repr(content[start:end])}")
                    idx += 1
                
                # Carriage return not followed by \x0a
                idx = 0
                while True:
                    idx = content.find(b'\x0d', idx)
                    if idx == -1:
                        break
                    if idx + 1 < len(content) and content[idx+1] != 0x0a:
                        start = max(0, idx - 20)
                        end = min(len(content), idx + 20)
                        print(f"CR corruption in {path} (pos {idx}): {repr(content[start:end])}")
                    idx += 1
            except Exception as e:
                print(f"Error reading {path}: {e}")
