import statistics
import pickle
from scipy.stats import t

data = {'binary_size': [], 'max_mem': [], 'cycles': []}
file = "stats.pk"

def stats(array, ignoreZeros=True):
    if ignoreZeros:
        array = [x for x in array if x != 0.]
    if len(array) == 0:
        return f"no change"
    elif len(array) == 1:
        return f"{array[0]:.2f}%"
    mean = statistics.mean(array)
    std = statistics.stdev(array)
    conf_level = 0.9
    t_value = t.ppf(1 - (1 - conf_level) / 2, len(array) - 1)
    interval = t_value * std / len(array)**0.5
    l, r = mean - interval, mean + interval
    res = f"{mean:.2f}% [{l:.2f}%, {r:.2f}%]"
    return res

def output_stats():
    for name, array in data.items():
        print(f"* {name}: {stats(array)}")

def save_stats():
    with open(file, 'ab') as fp:
        pickle.dump(data, fp)

def load_stats():
    with open(file, 'rb') as fr:
        try:
            while True:
                d = pickle.load(fr)
                for name, array in d.items():
                    data[name].extend(array)
        except EOFError:
            pass

