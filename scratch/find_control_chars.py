import os

docs_dir = 'docs'
corrupted_files = {}

for root, dirs, files in os.walk(docs_dir):
    for file in files:
        if file.endswith('.md'):
            path = os.path.join(root, file).replace('\\', '/')
            try:
                with open(path, 'rb') as f:
                    content = f.read()
                
                # Check for control characters: \x07 (\a), \x08 (\b), \x0c (\f), \x0b (\v)
                # and maybe \x09 (\t) and \x0d (\r) in unexpected places, but let's focus on \x07, \x08, \x0c, \x0b first
                ctrls = {}
                for b in [7, 8, 11, 12]: # \a, \b, \v, \f
                    count = content.count(bytes([b]))
                    if count > 0:
                        ctrls[b] = count
                
                # Also check for \r followed by a non-newline character, or \n followed by weird patterns
                # Wait, let's look at how \n replaced n. If \n was written as \n, it becomes a newline.
                # So the letter 'n' became a newline byte (0x0a). It is harder to detect 0x0a because newlines are normal.
                # But if we have backspace, bell, form feed, we can definitely see them!
                
                if ctrls:
                    corrupted_files[path] = ctrls
            except Exception as e:
                print(f"Error reading {path}: {e}")

print(f"Found {len(corrupted_files)} files with control characters:")
for path, ctrls in corrupted_files.items():
    details = ", ".join(f"0x{b:02x} ({count})" for b, count in ctrls.items())
    print(f"  {path}: {details}")
