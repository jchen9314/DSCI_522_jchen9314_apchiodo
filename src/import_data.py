import numpy as np
import pandas as pd

def main():
    wine_qual = pd.read_csv('../data/winequality-red.csv')
    print(wine_qual.head(5))
    return wine_qual.shape

if __name__ == "__main__":
    main()