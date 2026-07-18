import os

docs_dir = r"c:\Users\uytpv\works\fmpb\docs"

repaired_count = 0
skipped_count = 0
error_count = 0

for root, dirs, files in os.walk(docs_dir):
    for file in files:
        if file.endswith('.md'):
            file_path = os.path.join(root, file)
            try:
                # Read as utf-8
                with open(file_path, 'r', encoding='utf-8-sig') as f:
                    content = f.read()
                
                # Try to repair
                try:
                    repaired = content.encode('latin-1').decode('utf-8')
                    # Save back if changed
                    if repaired != content:
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(repaired)
                        print(f"Repaired: {file_path}")
                        repaired_count += 1
                    else:
                        skipped_count += 1
                except (UnicodeEncodeError, UnicodeDecodeError):
                    # Already correct or other encoding
                    skipped_count += 1
            except Exception as e:
                print(f"Error reading {file_path}: {e}")
                error_count += 1

print(f"Done! Repaired: {repaired_count}, Skipped: {skipped_count}, Errors: {error_count}")
