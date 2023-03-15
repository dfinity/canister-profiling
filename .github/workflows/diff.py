import sys
import pandas as pd
import markdown

if len(sys.argv) < 3:
    print("Usage: python extract_tables.py [current.md] [main.md]")
    sys.exit(1)

def read_tables(file):
    with open(file, "r") as f:
        md = f.read()
        html = markdown.markdown(md, extensions=['tables'])
        tables = pd.read_html(html, thousands = '_', index_col = 0)
        return tables

current = read_tables(sys.argv[1])
main = read_tables(sys.argv[2])

for i, (current, main) in enumerate(zip(current, main)):
    if current.shape == main.shape and all(current.columns == main.columns) and all(current.index == main.index):
        diff = (current - main) / main * 100
        result = pd.DataFrame(index=current.index, columns=current.columns)
        for idx, row in current.iterrows():
            for col in current.columns:
                x = row[col]
                d = diff.loc[idx, col]
                if d != 0:
                    result.loc[idx, col] = f"{x:_}({d:.2f}%)"
                else:
                    result.loc[idx, col] = f"{x:_}"
        print(result.to_markdown())
    else:
        print(f"print only current")
        print(current.to_markdown())
