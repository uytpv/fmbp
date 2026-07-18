import os

docs_dir = 'docs'
report = []

for root, dirs, files in os.walk(docs_dir):
    for file in files:
        if file.endswith('.md'):
            path = os.path.join(root, file)
            size = os.path.getsize(path)
            # Read first few lines to see status and title
            status = 'Unknown'
            title = 'Unknown'
            lines_count = 0
            try:
                with open(path, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    lines_count = len(lines)
                    # Check metadata
                    for line in lines[:15]:
                        if line.startswith('Title:'):
                            title = line.split('Title:')[1].strip()
                        elif line.startswith('Status:'):
                            status = line.split('Status:')[1].strip()
            except Exception as e:
                pass
            
            report.append({
                'path': path.replace('\\', '/'),
                'size': size,
                'title': title,
                'status': status,
                'lines': lines_count
            })

# Sort by path
report.sort(key=lambda x: x['path'])

with open('scratch/docs_status.txt', 'w', encoding='utf-8') as out:
    out.write(f"{'Path':<60} | {'Lines':<5} | {'Size':<6} | {'Status':<10} | {'Title'}\n")
    out.write("-" * 120 + "\n")
    for r in report:
        out.write(f"{r['path']:<60} | {r['lines']:<5} | {r['size']:<6} | {r['status']:<10} | {r['title']}\n")
print("Done writing report to scratch/docs_status.txt")
