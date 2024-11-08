# iterate through md files in _posts subfolder

import os
from markdownify import markdownify as md

for filename in os.listdir("_posts"):
    if filename.endswith(".html"):
        with open("_posts/" + filename, "r") as f:
            print(f'Processing {f}')
            content = f.read()
            # Use markdownify library to convert each html file to markdown
            markdown_content = md(content)
            print(markdown_content.replace('\\', ''))
            # Write back the content into a file with the same name but extension .md
            with open("_posts/" + filename.replace(".html", ".md"), "w") as f:
                f.write(markdown_content.replace('\\', ''))