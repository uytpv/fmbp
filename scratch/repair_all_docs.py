import os
import re

docs_dir = 'docs'
repaired_files = []

# List of files we expect to change
expected_files = [
    "docs/25-domain/DOC-250 Ingredient.md",
    "docs/25-domain/DOC-252 Menu.md",
    "docs/25-domain/DOC-253 Pantry.md",
    "docs/25-domain/DOC-254 Shopping.md",
    "docs/25-domain/DOC-255 Budget.md",
    "docs/25-domain/DOC-256 Family.md",
    "docs/30-design/DOC-305 Accessibility.md",
    "docs/40-platform/DOC-401 Firebase.md",
    "docs/40-platform/DOC-402 Firestore.md",
    "docs/40-platform/DOC-403 Cloud Function.md",
    "docs/40-platform/DOC-405 Security.md",
    "docs/50-infrastructure/DOC-553 Github Actions.md",
    "docs/70-admin/DOC-701 User.md",
    "docs/70-mobile/DOC-600 Flutter.md",
    "docs/70-mobile/DOC-602 State Management.md",
    "docs/75-web/DOC-750 Flutter Web.md",
    "docs/75-web/DOC-752 SEO.md",
    "docs/76-website/DOC-760 Landing.md",
    "docs/76-website/DOC-761 SEO.md",
    "docs/76-website/DOC-762 Blog.md",
    "docs/95-testing/DOC-951 Unit Test.md",
    "docs/95-testing/DOC-952 Widget Test.md",
    "docs/98-legal/DOC-980 Privacy Policy.md",
    "docs/98-legal/DOC-985 Third-party Licenses.md"
]

for root, dirs, files in os.walk(docs_dir):
    for file in files:
        if file.endswith('.md'):
            path = os.path.join(root, file).replace('\\', '/')
            try:
                with open(path, 'rb') as f:
                    original = f.read()
                
                content = original
                
                # 1. Replace control characters
                content = content.replace(b'\x07', b'a') # \a -> a
                content = content.replace(b'\x08', b'b') # \b -> b
                content = content.replace(b'\x0c', b'f') # \f -> f
                content = content.replace(b'\x0b', b'v') # \v -> v
                
                # 2. Replace carriage return \x0d not followed by \x0a with 'r'
                content = re.sub(b'\x0d(?!\x0a)', b'r', content)
                
                # 3. Replace tab \x09 followed by lowercase letter or underscore with 't'
                content = re.sub(b'\x09(?=[a-z_])', b't', content)
                
                # 4. Replace specific newline corruptions
                # Ingredient.md:
                content = content.replace(b'  - \r\name:', b'  - name:')
                content = content.replace(b'  - \name:', b'  - name:')
                content = content.replace(b'  - \r\nutrition_info:', b'  - nutrition_info:')
                content = content.replace(b'  - \nutrition_info:', b'  - nutrition_info:')
                
                # Family.md:
                content = content.replace(b'  - \r\name:', b'  - name:')
                content = content.replace(b'  - \name:', b'  - name:')
                
                # User.md:
                content = content.replace(b'old_value, \r\new_value', b'old_value, new_value')
                content = content.replace(b'old_value, \new_value', b'old_value, new_value')
                
                # Third-party Licenses.md:
                content = content.replace(b'Ch\xc3\xa0y \r\npm ', b'Ch\xc3\xa0y npm ')
                content = content.replace(b'Ch\xc3\xa0y \npm ', b'Ch\xc3\xa0y npm ')
                
                if content != original:
                    with open(path, 'wb') as f:
                        f.write(content)
                    print(f"Repaired: {path}")
                    repaired_files.append(path)
            except Exception as e:
                print(f"Error repairing {path}: {e}")

print(f"\nDone! Repaired {len(repaired_files)} files.")
