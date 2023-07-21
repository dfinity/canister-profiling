import sys
import pandas as pd
import markdown
import re
import statistics
from scipy.stats import t

if len(sys.argv) < 3:
    print("Usage: python diff.py [current.md] [main.md]")
    sys.exit(1)

def extract_header_for_each_table(html_text):
    # Extract the tables from the HTML
    table_regex = r'<table>(.*?)</table>'
    tables = re.findall(table_regex, html_text, re.DOTALL)
    
    # Find the nearest header that comes before each table
    result = []
    for table in tables:
        # Find the index of the table in the HTML text
        table_index = html_text.find(table)
        
        # Find the nearest header by searching backwards
        header_regex = r'<h(\d)>(.*?)</h\1>'
        header_match = re.findall(header_regex, html_text[:table_index])[-1]
        if header_match is None:
            result.append("# Unknonw header")
            continue  # No header found before this table
        
        # Extract the header text and level and add the header and table to the result
        header_level = int(header_match[0])
        header_text = header_match[1]
        result.append('#' * header_level + ' ' + header_text)
    return result

def read_tables(file):
    try:
        with open(file, "r") as f:
            md = f.read()
            html = markdown.markdown(md, extensions=['tables'])
            headers = extract_header_for_each_table(html)
            tables = pd.read_html(html, thousands = '_', index_col = 0)
            if len(headers) != len(tables):
                print(f"Bad {file}", file=sys.stderr)
                sys.exit(1)
            return list(zip(headers, tables))
    except OSError as e:
        print(f"> **Warning**\n> Skip {file}. File not found.\n")
        sys.exit(0)

def stats(array, ignoreZeros=True):
    if ignoreZeros:
        array = [x for x in array if x != 0.]
    if len(array) == 0:
        return f"no change"
    elif len(array) == 1:
        return f"{array[0]}"
    mean = statistics.mean(array)
    std = statistics.stdev(array)
    conf_level = 0.9
    t_value = t.ppf(1 - (1 - conf_level) / 2, len(array) - 1)
    interval = t_value * std / len(array)**0.5
    l, r = mean - interval, mean + interval
    res = f"{mean:.2f}% [{l:.2f}%, {r:.2f}%]"
    return res

current = read_tables(sys.argv[1])
main = read_tables(sys.argv[2])

if len(current) != len(main):
    print(f"> **Warning**\n> Skip {sys.argv[1]}, due to the number of tables mismatches from main branch.\n")
    sys.exit(0)

flaky_benchmarks = ["## Heartbeat"]
binary_size = []
max_mem = []
cycles = []

for i, ((header, current), (header2, main)) in enumerate(zip(current, main)):
    if header == header2 and current.shape == main.shape and all(current.columns == main.columns) and all(current.index == main.index):
        result = pd.DataFrame(index=current.index, columns=current.columns)
        print(sys.argv[1], i, header, file=sys.stderr)
        print(f"\n{header}\n")
        if current.equals(main):
            print(f"> **Note**\n> Same as main branch, skipping.\n")
            continue
        for idx, row in current.iterrows():
            for col in current.columns:
                x = row[col]
                base = main.loc[idx, col]
                d = (x - base) / base * 100
                if d < 0:
                    result.loc[idx, col] = f"{x:_} ($\\textcolor{{green}}{{{d:.2f}\\\\%}}$)"
                elif d > 0:
                    result.loc[idx, col] = f"{x:_} ($\\textcolor{{red}}{{{d:.2f}\\\\%}}$)"
                else:
                    result.loc[idx, col] = f"{x:_}"
                if header in flaky_benchmarks:
                    continue
                if col.endswith("binary_size"):
                    binary_size.append(d)
                elif col.endswith("max mem"):
                    max_mem.append(d)
                else:
                    cycles.append(d)
        print(result.to_markdown())
        print(f"\n")
    else:
        print(f"> **Warning**\n> Skip table {i} {header} from {sys.argv[1]}, due to table shape mismatches from main branch.\n")

print(f"## Statistics\n\n")
print(f"* binary size: {stats(binary_size)}\n* max_mem: {stats(max_mem)}\n* cycles: {stats(cycles)}\n")
